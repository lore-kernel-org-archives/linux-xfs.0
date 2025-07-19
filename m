Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345D91C863B;
	Sat, 19 Jul 2025 06:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752905157; cv=none; b=C+/WPqM0G9BoJ5fHh91E49fBhxd0vJJdvUD8WZpqOwY284xmcnze6l0R/3Cy+k1wRabdDhyTYxkXiOlncWizoDUZP5M+DbsP2GAlcs4t14e/0EqjoEbgso+y4MqvyHw6pi4tMOYfKW2H/pJ+dQ1fHs1cSKmPB+sFap1Cvd3KioQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752905157; c=relaxed/simple;
	bh=mskhn0YVYQWGTgn2FiHZ7SCx/HAvVb9tT6yr5OGjQp8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UtPRG6QROEC7Ughoh2lY+oVTOlWIA2oQs73v1mUVm7sj8rFGfpZKPU8m/t9f4cpVIX+/rdFS9lIfn4S69477ALn5CWrSebLO2o9jGi738CnVzji5syML/A7fXndNKvUzJZBjLJGbrvfs717E3DnsWqWKDoQ+6Ce2oxfRVvEA5l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=saABQ3wA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="saABQ3wA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DBAC4CEE3;
	Sat, 19 Jul 2025 06:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752905156;
	bh=mskhn0YVYQWGTgn2FiHZ7SCx/HAvVb9tT6yr5OGjQp8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=saABQ3wA9M/K0Ti3OtcBYfu/h9qKVVU5+HMkeKvtVBTeQWjiRcWiAUUjOv8pXk/F2
	 O8Yex/gLKmIv2jVOIWVF7HgChipW5YhA/jFCkIP4+AragXpPnNAsqOfd2pBeqcrJIh
	 5COp8MCKWGmrDOKmiAI4M1bk60mFSLlXj8rB09MHT8n/U6yWaBszEOAFXnWm2X960t
	 R9lQ6RPbJs/lxwFdFhVaXJSRdObBrirSWsfFFEeoYKGpPIwq28sIYiVdGzsIg3RC/2
	 HTJuUYZjHrc2jBfzoNvrgzAxMJFAva66zcw/bwL/dZ1f96zUZ9UMFwySIHLzkaWhf3
	 Fbmmd6ZzYLAfA==
Date: Sat, 19 Jul 2025 08:05:52 +0200
From: Carlos Maiolino <cem@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: or10n-cli <muhammad.ahmed.27@hotmail.com>, linux-xfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] xfs: scrub: remove unnecessary braces and fix
Message-ID: <xco2agi4ggy4yy73bwfsfqc3qgtzsanrswfrndsb2kqz4yb6vq@6ysq36faziru>
References: <DB6PR07MB3142A5C5EAF928BA7F71CA47BB53A@DB6PR07MB3142.eurprd07.prod.outlook.com>
 <xOyvmjMbzYJc2swLFMVBnsx0cITFim-_7d2lhCNHmjNHlrr8hmMYN5l-d5udm7XRBhdUq76FU4trpZw2-H3IRQ==@protonmail.internalid>
 <20250719052916.GT2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250719052916.GT2672049@frogsfrogsfrogs>

On Fri, Jul 18, 2025 at 10:29:16PM -0700, Darrick J. Wong wrote:
> On Sat, Jul 19, 2025 at 10:22:09AM +0500, or10n-cli wrote:
> > From b8e455b79c84b4e1501ea554327672b6d391d35d Mon Sep 17 00:00:00 2001
> > From: or10n-cli <muhammad.ahmed.27@hotmail.com>
> 
> WTF is "orion-cli" ?

No clue, but those 'patches' are going to my spam-list from now on...

> 
> > Date: Sat, 19 Jul 2025 10:10:42 +0500
> > Subject: [PATCH] xfs: scrub: remove unnecessary braces and fix indentation
> > in
> >  findparent.c
> >
> > This patch removes unnecessary braces around simple if-else blocks and
> > fixes inconsistent indentation in fs/xfs/scrub/findparent.c to comply
> > with kernel coding style guidelines.
> >
> > All changes are verified using checkpatch.pl with no warnings or errors.
> >
> > Signed-off-by: Muhammad Ahmed <muhammad.ahmed.27@hotmail.com>
> > ---
> >  fs/xfs/scrub/findparent.c | 9 +++------
> >  1 file changed, 3 insertions(+), 6 deletions(-)
> >
> > diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
> > index 84487072b6dd..9a2f25c7c2e3 100644
> > --- a/fs/xfs/scrub/findparent.c
> > +++ b/fs/xfs/scrub/findparent.c
> > @@ -229,15 +229,12 @@ xrep_findparent_live_update(
> >          */
> >         if (p->ip->i_ino == sc->ip->i_ino &&
> >             xchk_iscan_want_live_update(&pscan->iscan, p->dp->i_ino)) {
> > -               if (p->delta > 0) {
> > +               if (p->delta > 0)
> >                         xrep_findparent_scan_found(pscan, p->dp->i_ino);
> > -               } else {
> > +               else
> >                         xrep_findparent_scan_found(pscan, NULLFSINO);
> > -               }
> >         }
> > -
> >         return NOTIFY_DONE;
> > -}
> 
> DID YOU EVEN COMPILE THIS???

I'll stop wasting time on patches from this sender.

And just for the *fun* of it... checkpatch.pl fails on this patch...


> 
> --D
> 
> >  /*
> >   * Set up a scan to find the parent of a directory.  The provided dirent
> > hook
> > @@ -386,7 +383,7 @@ xrep_findparent_confirm(
> >
> >         /* Reject garbage parent inode numbers and self-referential parents.
> > */
> >         if (*parent_ino == NULLFSINO)
> > -              return 0;
> > +               return 0;
> >         if (!xfs_verify_dir_ino(sc->mp, *parent_ino) ||
> >             *parent_ino == sc->ip->i_ino) {
> >                 *parent_ino = NULLFSINO;
> > --
> > 2.47.2
> >
> 
