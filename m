Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B8722AE65
	for <linux-xfs@vger.kernel.org>; Thu, 27 Aug 2026 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787841528; cv=none; b=PGO9891JgFPVhuAB1N67hockZcNjitQG8LKKweaSkdJKyOvot5BMS74cJyHrHEhhkKHkLwynAq/wTPmyLjXBYtJqvKXPbA1vMqjuHOEu8zqkIO0KgXRq9qd6xKzjt/wnNEmx5kx2iatK6BI4LJhA2qkLlh58pAFDF6H+5SjXPx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787841528; c=relaxed/simple;
	bh=aWuD/o3gU5Tiwh0VZNy3pao+CX5HiGQmGly9KFAX0LY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aMDhc2ZUiiAO8M4Ix06FwRCwIzEtDr6HqomFKcqEkv+kBmDg/ABomrDd0IYbmkOixidG6+PHLFAME5t0GENzcxHiCiKcie06sAwWUNREL+Y2tRYJC+jx/jKKWJuuPtIMBPZsrTnWzAECQkv+FJ7/zoBXgzMy8Kiy9fym8A7ypUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jfj72C8B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jfj72C8B"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 46E091F000E9;
	Thu, 27 Aug 2026 14:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787841525;
	bh=2MK6j0CbKefwIC9YZqmRHfondX9erYK+jHeVLmg1EF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jfj72C8BeoyjLlD2ObCOXU6QQRgWrYGSq7QmvrmiMz5mXZi676BQtNZc58dH3vzcS
	 0ifXqIB8GUrM5sreF3U7jxmY5plMrdePWt8Yjmq3ZSMsqSqxwPIP1EDlExMjYeuW0i
	 3r7Ihh09QX7IbPSm3M5LkQxtOS3XK8EtbwZS3BCUH7EEHtn8edng3iOynC2B4ZQMR3
	 0eiHTs5b3VzEAmw8emx73SykNA5VfH+5fpLtX3zomRC4YCtH0fRCQ5lXvIkrVjX3o4
	 sOpcRpnmhPPcNkQU5FSpq/ptR8HHaFcHJExZc5opfaO7Rca3lgFPbo1R6q3lZNihqb
	 dZ+EMEX3RSDqw==
Date: Thu, 27 Aug 2026 07:38:44 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] mkfs: Emit a clearer message if too-small log is due
 to AG geometry
Message-ID: <20260827143844.GC2114998@frogsfrogsfrogs>
References: <20260827034228.938740-1-sandeen@redhat.com>
 <a1864929-f3df-4c0a-ae47-019cda875c99@sandeen.net>
 <20260827050119.GA6072@frogsfrogsfrogs>
 <8d2e6c40-0d22-4eda-8f7f-be2678b53d2d@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d2e6c40-0d22-4eda-8f7f-be2678b53d2d@sandeen.net>

On Thu, Aug 27, 2026 at 08:19:52AM -0500, Eric Sandeen wrote:
> On 8/27/26 12:01 AM, Darrick J. Wong wrote:
> > On Wed, Aug 26, 2026 at 10:49:38PM -0500, Eric Sandeen wrote:
> >> There is a constraint in mkfs.xfs that logs must not be smaller than
> >> 64MiB. We can arrive at a too-small log without specifying its size,
> >> though, if we specify so many AGs (or such small AGs) that a single
> >> AG cannot hold the minimum-sized log. This leads to confusing output:
> >>
> >> $ truncate --size=500m testfile
> >> $ mkfs.xfs -dagcount=10 testfile
> >> Log size must be at least 64MiB.
> >> Usage: mkfs.xfs
> >> ...
> >>
> >> because the user did not specify the log size at all! If this error
> >> occurs due to the AG geometry specification, make that clear with a
> >> better error message.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>  mkfs/xfs_mkfs.c | 19 ++++++++++++++++++-
> >>  1 file changed, 18 insertions(+), 1 deletion(-)
> >>
> >> V2: Ugh as soon as I sent this I realized I forgot to restrict this to internal
> >> logs. An external log may be too small all on its own, unrelated to AG size.
> >>
> >> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
> >> index a4864c37..4f11c9de 100644
> >> --- a/mkfs/xfs_mkfs.c
> >> +++ b/mkfs/xfs_mkfs.c
> >> @@ -3456,8 +3456,25 @@ validate_supported(
> >>  	 */
> >>  	if (mp->m_sb.sb_logblocks <
> >>  			XFS_MIN_REALISTIC_LOG_BLOCKS(mp->m_sb.sb_blocklog)) {
> >> -		fprintf(stderr,
> >> +		/*
> >> +		 * An internal log must fit within a single allocation group.
> >> +		 * If the user specified the AG geometry but didn't ask for a
> >> +		 * specific log size, the undersized log is due to allocation
> >> +		 * groups that are too small, not a log size the user chose.
> >> +		 */
> >> +		if (cli->loginternal &&
> >> +		    !cli_opt_set(&lopts, L_SIZE) &&
> >> +		    (cli_opt_set(&dopts, D_AGCOUNT) ||
> >> +		     cli_opt_set(&dopts, D_AGSIZE))) {
> >> +			fprintf(stderr,
> >> + _("Allocation group size (%lld MiB) is too small to hold the minimum 64MiB log.\n"
> >> +   "Specify fewer or larger allocation groups, or use a larger data device.\n"),
> > 
> > I like this!  With a couple of comments:
> > 
> > Can the warning message be more targeted to the option?  e.g.
> > 
> > 	if (loginternal && !set(L_SIZE)) {
> > 		if (set(D_AGCOUNT))
> > 			fprintf("Specify fewer AGs or a larger data device...");
> > 		else
> > 			fprintf("Specify larger allocation groups...");
> > 	}
> 
> And if the user specified both size and count? I'm not really convinced
> that we need to go that far, I guess. All the logic in that block is
> kind of eye-bleeding already IMHO.

Eh, ok.  I forgot that maybe the user did both, so they get both
messages. :)

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D


> > Also, what do you think about not hardcoding 64MiB?
> > 
> > printf("Log size must be at least %uMiB\n",
> > 		XFS_MIN_REALISTIC_LOG_BLOCKS(20));
> 
> That give blocks, not MiB I think, right? 
> > (separate change obviously)
> 
> Yeah I noticed that but was just following djwong's lead from the existing
> printf. ;) 

Yeah but djwong is laaaaazy.

> #define XFS_MIN_REALISTIC_LOG_BLOCKS(blog)      (MEGABLOCKS(64, (blog)))
> 
> Maybe we'd need:
> 
> #define XFS_MIN_REALISTIC_LOG_MB	64
> 
> and then
> 
> #define XFS_MIN_REALISTIC_LOG_BLOCKS(blog)      (MEGABLOCKS(XFS_MIN_REALISTIC_LOG_MB, (blog)))
> 
> and then
> 
> printf("Log size must be at least %uMiB\n", XFS_MIN_REALISTIC_LOG_MB);
> 
> or something?

MEGABLOCKS(xx, 20) gets you megabytes:

#define MEGABLOCKS(count, blog)      ((uint64_t)(count) << (20 - (blog)))

so XFS_MIN_REALISTIC_LOG_BLOCKS(20) gets you the min realistic log size
in megabytes.

#define XFS_MIN_REALISTIC_LOG_MB \
	(XFS_MIN_REALISTIC_LOG_BLOCKS(20))

Your way also works. :)

--D

> -Eric
> 
> > --D
> > 
> >> +				(long long)XFS_FSB_TO_B(mp,
> >> +					mp->m_sb.sb_agblocks) >> 20);
> >> +		} else {
> >> +			fprintf(stderr,
> >>   _("Log size must be at least 64MiB.\n"));
> >> +		}
> >>  		usage();
> >>  	}
> >>  
> >> -- 
> >> 2.55.0
> >>
> >>
> > 
> 
