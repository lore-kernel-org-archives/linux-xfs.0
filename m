Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC903B5312
	for <linux-xfs@vger.kernel.org>; Mon, 16 Mar 2026 16:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773678740; cv=none; b=BBNoREucLZIbVIighT1moZwlxugbS4HtKE2v09LSeIlV1RXvYw6QsXW/Uowsiq57htFjDXyA++08a/Mpc1Ezoppzc67a1XOWxJtW/IxDF+GW6F5d7m06aCWDvgSZe4LUHmTHdcmhwxC/e+qRRhe+W5WKrP0MHMltKBvpb1inqmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773678740; c=relaxed/simple;
	bh=i1pWGAkfagBrbbYaz9b00scq+TT9JIXkB1YLTy1avEY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g6yPxuQRiLlwmtQcRUP+O5uSvOi7RXKvYt7VMrbUteF8n0dyiVwP6DLCw3BzKLHgLXNe9pZGNPx0bRurvC74uXkBGX0OBgFLEF+q0t3/rDEV7TS0x1ZKqelvAI5xUZKf3wJa6fVaNAPP8ngT/OvzKvYm0TUjn27EBBl7jcUbDB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m7GU0te4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m7GU0te4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06A7C19421;
	Mon, 16 Mar 2026 16:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773678739;
	bh=i1pWGAkfagBrbbYaz9b00scq+TT9JIXkB1YLTy1avEY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m7GU0te4N7oXzyMc0/9Dh50G/WINjwCg9tX2cODx8Vq3lwH3scPTmsy6jhKyp2aGi
	 QMPUC4xvnAHdOCxMMzIe7HlwnVe4diao3JJCmnQwXYVib52G5KqhJcfLFLpmebRrMD
	 OQhX5O0IVTVbSjY+VUJKiC8HF782RxQPa5U46FSgNR079hkAXBP11wPeLxCJeMXU0f
	 aOE78qoqfk0jCI3MhnhX9nbWcMgQBAUYTUJvxx6ipwcJxyRBZjWIEcpXTOsnm874QK
	 CUCfmt4QEo3n+2KsMqnBU1UEwev60LDqGOeyBD7TUabniJcbeYNbswYC9zsjUP2vW7
	 s57866qiPcwtg==
Date: Mon, 16 Mar 2026 09:32:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 26/28] mkfs: enable online repair if all backrefs are
 enabled
Message-ID: <20260316163219.GY1770774@frogsfrogsfrogs>
References: <177311401331.1183235.13382695982141268952.stgit@frogsfrogsfrogs>
 <177311401930.1183235.5546361742527693533.stgit@frogsfrogsfrogs>
 <abguES2dZ4Bcky5K@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abguES2dZ4Bcky5K@infradead.org>

On Mon, Mar 16, 2026 at 09:21:37AM -0700, Christoph Hellwig wrote:
> It looks like this makes xfs/805 unhappy, as it does not expect
> autofsck to be set by default.

Yeah.  I've a patch to remove the "no autofsck option at all" test
because you can't really change the default without breaking old
xfsprogs, and a bunch of sed to fake the output seems pretty silly.

--D

> >  1 file changed, 9 insertions(+)
> > 
> > 
> > diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> > index 527a662f3ac858..f859626afdda36 100644
> > --- a/mkfs/xfs_mkfs.c
> > +++ b/mkfs/xfs_mkfs.c
> > @@ -6296,6 +6296,15 @@ main(
> >  	if (mp->m_sb.sb_agcount > 1)
> >  		rewrite_secondary_superblocks(mp);
> >  
> > +	/*
> > +	 * If the filesystem has full backreferences and the user didn't
> > +	 * express an autofsck preference, enable online repair because they
> > +	 * might as well get some useful functionality from the extra metadata.
> > +	 */
> > +	if (cli.autofsck == FSPROP_AUTOFSCK_UNSET &&
> > +	    cli.sb_feat.rmapbt && cli.sb_feat.parent_pointers)
> > +		cli.autofsck = FSPROP_AUTOFSCK_REPAIR;
> > +
> >  	if (cli.autofsck != FSPROP_AUTOFSCK_UNSET)
> >  		set_autofsck(mp, &cli);
> >  
> > 
> > 
> ---end quoted text---
> 
