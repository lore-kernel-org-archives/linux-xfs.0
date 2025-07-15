Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8814A1B7F4;
	Tue, 15 Jul 2025 09:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752572998; cv=none; b=OUSAd/FGCo3ptvaupAbNDtkF2mlJg7MTu422ehYKb6NQjRuP5QI6lTHC7J4k5BK6lZfHeKbrb1HFYtgQ52nKZi2LO2gaMFVcDconDhhRmGH7yCyYSphq7xzWar8OIJhklYSkTDKV9s9OvW+7sv5h2bOw26HXrtDmcrEgADU3SPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752572998; c=relaxed/simple;
	bh=vRVgCvsQ04ahIBDrKrozggdpXhjzZn5ayYqDp1soTJQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gudhT3VG/lRx3ByeZx8QH1N0/nj6X+UHSd23NJdLG6MLwS53jzeFCF3roGvsEdmMP1m6FzG/d4PiROmUaTSsm/l9H+UJ6JCIf0qv9aEltrJ70m/E8g3JUCdeABzOJesQVvplyqIIRgUL+DQ8aP8Iw9Bh4D5oWON+UOR1I2XZX2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MT6CFhjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MT6CFhjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5368C4CEE3;
	Tue, 15 Jul 2025 09:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752572998;
	bh=vRVgCvsQ04ahIBDrKrozggdpXhjzZn5ayYqDp1soTJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MT6CFhjUDX+hcPdl7BVvFdQ+jIOt4wIzvW9+gIiSNCKjzYelPPyNwixoWt3q2WisC
	 8OSCro36xiwR/coUpojtvu+ZZ+I/cpH0u8qKh9FQvcZ3Um07OfZAWxWZ7Xw0KoyDAB
	 U2Iy+VBnowuKuE/Yj0x1K7avgvhRrI7pwUqVFZPnUxPm3TMb0k1R+scWHbt/JC3gO0
	 loiGzvcV79GQIxQOAsT6iIS8Qm++Jf9b+seEGOl10s1j7j2mt9oslEQbbnhCl39UPo
	 a2hsHVM5yHkC5UMwMUCVJzR+tvLwlcCem7QPj33AJbVaB64sAAJis4Ppo2xkHSqYhY
	 80Bijcui5a9Iw==
Date: Tue, 15 Jul 2025 11:49:53 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: John Garry <john.g.garry@oracle.com>, 
	George Hu <integral@archlinux.org>, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: replace min & max with clamp() in
 xfs_max_open_zones()
Message-ID: <xpuse6544mmww24s7hqtgwcky2wyc5amykfdftfqeb2ghaqejy@6zj65eavbm6x>
References: <20250712145741.41433-1-integral@archlinux.org>
 <9ba1a836-c4c9-4e1a-903d-42c8b88b03c4@oracle.com>
 <ga3ch5pToaSs5VutqCDXTiZyaa4EZg1p-X4AOtoebVJBWEm2VpV_vy_jNeU6OIUzCdiSn38P2W_vgZVOWrHG3Q==@protonmail.internalid>
 <aHTjD6FxJYEu6C6R@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aHTjD6FxJYEu6C6R@infradead.org>

On Mon, Jul 14, 2025 at 03:59:27AM -0700, Christoph Hellwig wrote:
> On Mon, Jul 14, 2025 at 08:58:59AM +0100, John Garry wrote:
> > > @@ -1133,9 +1133,7 @@ xfs_max_open_zones(
> > >   	/*
> > >   	 * Cap the max open limit to 1/4 of available space
> > >   	 */
> >
> > Maybe you can keep this comment, but it was pretty much describing the code
> > and not explaining the rationale.
> 
> Let me send an incremental patch to explain the rational as long as I
> can still remember it :)

Sounds good, I'll wait and merge both together.

> 
> 
