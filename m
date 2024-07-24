Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B79F15EFC6
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jul 2024 17:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721841816; cv=none; b=KK694EbPXOSDdUj1BxOVMumDnZBHgZD4HfbjUaZcnjbx8gq83OlCi4XJxecGN1jhaXQsZKklmL/QJT3Ne73N/tK4N5VtyC7Aq7ZbdLMwIbZHTb/LgX7dkPOylC/+zLjrvs6ZAK83BsLvnnt6V0w22dxI2wUCg2a5jVTlAyZHKVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721841816; c=relaxed/simple;
	bh=jCzwhYhj1BjsQoH2+DIZOoq0JQeSEgVZx0zMa/TAJmM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFnXjJwsMCZVuVUKmrl6PPeck4eW/DP8gfQIucFq+w8HF7pdM2FWWasTPz7w+FKk/EfKHq/skgBFoeguKjakwzxIHy3cMMX1ksZx+qmYbZzOv5mroMlyosazPxwl4AzL6tf0hF499TxsIF5uabAbyPLEnsSK98yBeTenggagfQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=er5A6XDu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="er5A6XDu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA28AC32781;
	Wed, 24 Jul 2024 17:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721841816;
	bh=jCzwhYhj1BjsQoH2+DIZOoq0JQeSEgVZx0zMa/TAJmM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=er5A6XDuvu6W8sp/xCHc6inuvuO7j4oWIm2p7Q5+dv++5yrCHXhjDt1+HvKlc1wc4
	 fNNbEoSu/2QrU4qr900hbdoAg6RHRIhalisJy07CSNg8buKUN1mZRPNr6Db8NJW1sO
	 wF6obMqKx9+5hjfDq0oMkEAZIcFRIgTyDf4cXniZd0mOc/D4hzQYpANq1DbFTYr2Zy
	 XgRbahWHhYmlSmCIuyOHPmgWyKy3e9I54rLvu6MI957q+wwF2eAGJfy6UXBf+xNcN8
	 5OQGmOEkLY//MFhII5bOOo8lAl7XMN+2rGpO5vKRXL5SopfV6I97kvzFwKvdFUrXa9
	 QYmUjawnEeWpQ==
Date: Wed, 24 Jul 2024 10:23:34 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] [RFC] xfs: filesystem expansion design documentation
Message-ID: <20240724172334.GY612460@frogsfrogsfrogs>
References: <20240721230100.4159699-1-david@fromorbit.com>
 <20240723235801.GU612460@frogsfrogsfrogs>
 <ZqBO177pPLbovguo@dread.disaster.area>
 <f7bbde19-80b8-4118-b8ab-654df9784e13@sandeen.net>
 <73173356-6914-42d4-8020-ea2f32661393@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73173356-6914-42d4-8020-ea2f32661393@sandeen.net>

On Wed, Jul 24, 2024 at 10:44:47AM -0500, Eric Sandeen wrote:
> On 7/24/24 10:41 AM, Eric Sandeen wrote:
> > On 7/23/24 7:46 PM, Dave Chinner wrote:
> >>> What about the log?  If sb_agblocks increases, that can cause
> >>> transaction reservations to increase, which also increases the minimum
> >>> log size.
> >> Not caring, because the current default minimum of 64MB is big enough for
> >> any physical filesystem size. Further, 64MB is big enough for decent
> >> metadata performance even on large filesystem, so we really don't
> >> need to touch the journal here.

<shrug> I think our support staff might disagree about that for the
large machines they have to support, but log expansion doesn't need to
be implemented in the initial proposal or programming effort.

> > Seems fair, but just to stir the pot, "growing the log" offline, when
> > you've just added potentially gigabytes of free space to an AG, should
> > be trivial, right?

Possibly -- if there's free space after the end and the log is clean.
Maybe mkfs should try to allocate the log at the /end/ of the AG to
make this easier?

> Ugh I'm sorry, read to the end before responding, Eric.
> 
> (I had assumed that an expand operation would require a clean log, but I
> suppose it doesn't have to.)

...why not require a clean filesystem?  Most of these 10000x XFS
expansions are gold master cloud images coming from a vendor, which
implies that we could hold them to slightly higher cleanliness levels.

--D

> -Eric
> 
> 
