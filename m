Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F2B44212E;
	Wed,  8 Jul 2026 12:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783514529; cv=none; b=jXIsqdSszSES0LrQnoyzY59RtOmnDjabUkAt2EThatnDH163I1KJ6MG4u7na/qE4tRfnX/5j3frNq0wR4QpAnTfrh3+dnzpNfhONxS7ar4d3o2IMKWA67iD4OJohlV7DOi8ippgpM+GWqjbb+awNQb3/YGJLDTgqtkMcvSqJfW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783514529; c=relaxed/simple;
	bh=dQ68wts3uchrkq9WowYvJUsez36hgDLOsKXQlmT9O48=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ex4zf4ZdaW6Q0UR0jWAcvfsUX658A+Tz57QZyKo/osvo3K3sk5d94pffdM4cugrCd+X9QMqehngfYMQQ+JTSad37wq58rUpKpljHqAZPKvt3PscdZVUdCGYncJ52PwRIaKOBCS/RWVPDWSEfvXWN3XvW+g24nJH1OGxdUB6DBaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PIFydq3r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PIFydq3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4351F000E9;
	Wed,  8 Jul 2026 12:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783514528;
	bh=DmamhOZUaT2JdHI23bO4TE8nEgFLlKRK2SdEw2ZIBi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PIFydq3rsoWEnTJROsSE5FKDr4TAKIt89de5mkPRVjFn8ijZPyo5txPm26yGqOpDm
	 YZu5FUbujbHuDb46N1hQY+8tuvEcYdMVC1hODHqIy3sJKis6rvlkE2us8jUm4ae3jX
	 Yqx00+IWQAXYT2y5bFmdtXX2s3JObURPRkTQScZC7q9AQ0wLJNT8ES9G6QQncRzOXg
	 wQklLlzs+JIC1xUdc8Pr5Y82+ZQuqNPK//E8/lg63euSwN8tDyhwBjVE88sT1MtMMH
	 QpzUg7mzxNU2BGtEhgVy11RYRZuNiDiV7fXAUHpiCsdj4tarJL2qGyayg0JEtTMz0g
	 TKFWkvROXu8OQ==
Date: Wed, 8 Jul 2026 14:42:04 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Mark Brown <broonie@kernel.org>
Cc: David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: Missing signoff in the xfs tree
Message-ID: <ak5FjjZbMALlQJSm@andromeda.toxiclabs.cc>
References: <ak4uhSXlLF3Gr576@sirena.org.uk>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak4uhSXlLF3Gr576@sirena.org.uk>

On Wed, Jul 08, 2026 at 12:03:33PM +0100, Mark Brown wrote:
> Commit
> 
>   92d2d133c6cb3 ("xfs: fail recovery on a committed log item with no regions")
> 
> is missing a Signed-off-by from its committer


woops, I'll fix it
