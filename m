Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6041A18C05
	for <linux-xfs@vger.kernel.org>; Sun,  7 Apr 2024 22:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712529250; cv=none; b=k2BhiRpdaRz2CzP+j8e1FY1caghRZiaxqIEFdlg2avdAwN3tqUDTJ+fxQN1u0pUYvoT4lnrgkhGz4RpQTntNdylQ7sbJIgJgCVMFsOaMB66Jx7EkwpbQW/192eF8tZODEpEPw/NqcDpHaLvE79B5AbCpG2mvidVjPsy1v+t3QcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712529250; c=relaxed/simple;
	bh=xHph9YcnkY/Bioo1e1XB68YCDqE8lGqjOWc9hCcrfzk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qT0bj3QD8YPNivFOxnlC0foyTDOhhXzsphZkH0Y9PzSz2RISxKRM2/EVvi5JdWIWGWMUafzSkz0Sb31J+895aB2v5zwzlSSiN2PwPUphJQ4HWXwMI/vm16+9hlLtFRMn907YXcXbEmuNjfsZfO2oN3VQOITI/6ApsBoRJsrwPqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=0vnXcMUF; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="0vnXcMUF"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6eced6fd98aso3403290b3a.0
        for <linux-xfs@vger.kernel.org>; Sun, 07 Apr 2024 15:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1712529247; x=1713134047; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a9zQimG6tRa7Ozw/O66lazkUCG1nGIDicAgziceKaiA=;
        b=0vnXcMUFeb1J3buAF0aSUn0vBvZrM3wEwuk+IzFGt41v9TXnT/h/0hrSx3gKGtsgDd
         2Do2J4Uqya4KlvRrBLHO7Ci9qSThhF/064hwkNKqTWpC8j/wxiO8TMrjWl/pPM2LPj8R
         O3/6FWf/cyF3SbwUaaTYpr2VIMYo+4exwoFgOgYxizRIyLVoXZq0sqiwGEX6Zxf7nF1A
         wr7fLRN8t7eWU5QdRMSrnbFzdm8h7D2Rv7H7/HpSWekFyJYAHZJZOHinx2yfhBfm2goo
         bvF7zvvKwbg84kBwUV9FpLCJWII97KFbgny1fh2EnLamk7T6fKGtuKZOpnIDdlK2C+is
         5XJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712529247; x=1713134047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a9zQimG6tRa7Ozw/O66lazkUCG1nGIDicAgziceKaiA=;
        b=hNr3x2XRhBdPlBFSejUxBmCsBS+cqhj7WPj5hrJZeFyWWjleqs1lThD4L99Ue6Ocm+
         9NDZR0aIw46TltsF0EaelAJJbXEJtau/d75h1q/fwnHPZ9GtNzlD8A3RQWRM4LcalYBt
         DEIwLnk4ruJowyqAQ65DXMkgVQCLfBugc5NzrChnKTSg2pmMINHRwWuSdZFzOEZFScVr
         paNnWFOZGMZ85UTJJcbNwbyun7sFFoKevbx96Z/s7P+8Z/acEJ70byq4bp+vOLFzmugz
         +A4VLzOtIcnrID9XoNdmaLSG575p6Ung8+pgrC/V6ZahdZShbaOjx1fFaWpGoETREsKB
         h1DQ==
X-Gm-Message-State: AOJu0YzY1rUTB1cE4p7nHZawvHlpoXYQOK8o8Rbe/ftnfVqauH0ZRqkr
	YbppIV9cfLlbApsrMtABSBEL40VjHKkykXK9c6w40mytDhqKvE0D1aC2VRkhwJM=
X-Google-Smtp-Source: AGHT+IEcLyPESVsaTzIm167pOYSUTztt2N8EXZdB23MLfvL7kAbLJbYH1tB0nuEw89xpgOMzC8VC4g==
X-Received: by 2002:a05:6a00:23c3:b0:6ea:b69a:7c78 with SMTP id g3-20020a056a0023c300b006eab69a7c78mr10080801pfc.14.1712529247455;
        Sun, 07 Apr 2024 15:34:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-56-237.pa.nsw.optusnet.com.au. [49.181.56.237])
        by smtp.gmail.com with ESMTPSA id fb19-20020a056a002d9300b006ea8af2a613sm5088117pfb.208.2024.04.07.15.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 15:34:06 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rtb5Q-007hXl-0V;
	Mon, 08 Apr 2024 08:34:04 +1000
Date: Mon, 8 Apr 2024 08:34:04 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: fix an AGI lock acquisition ordering problem in
 xrep_dinode_findmode
Message-ID: <ZhMfXA/1YyRDe869@dread.disaster.area>
References: <171212150033.1535150.8307366470561747407.stgit@frogsfrogsfrogs>
 <171212151192.1535150.13198476701217286884.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171212151192.1535150.13198476701217286884.stgit@frogsfrogsfrogs>

On Tue, Apr 02, 2024 at 10:18:31PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While reviewing the next patch which fixes an ABBA deadlock between the
> AGI and a directory ILOCK, someone asked a question about why we're
> holding the AGI in the first place.  The reason for that is to quiesce
> the inode structures for that AG while we do a repair.
> 
> I then realized that the xrep_dinode_findmode invokes xchk_iscan_iter,
> which walks the inobts (and hence the AGIs) to find all the inodes.
> This itself is also an ABBA vector, since the damaged inode could be in
> AG 5, which we hold while we scan AG 0 for directories.  5 -> 0 is not
> allowed.
> 
> To address this, modify the iscan to allow trylock of the AGI buffer
> using the flags argument to xfs_ialloc_read_agi that the previous patch
> added.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/scrub/inode_repair.c |    1 +
>  fs/xfs/scrub/iscan.c        |   36 +++++++++++++++++++++++++++++++++++-
>  fs/xfs/scrub/iscan.h        |   15 +++++++++++++++
>  fs/xfs/scrub/trace.h        |   10 ++++++++--
>  4 files changed, 59 insertions(+), 3 deletions(-)
> 
> 
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> index eab380e95ef40..35da0193c919e 100644
> --- a/fs/xfs/scrub/inode_repair.c
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -356,6 +356,7 @@ xrep_dinode_find_mode(
>  	 * so there's a real possibility that _iscan_iter can return EBUSY.
>  	 */
>  	xchk_iscan_start(sc, 5000, 100, &ri->ftype_iscan);
> +	xchk_iscan_set_agi_trylock(&ri->ftype_iscan);
>  	ri->ftype_iscan.skip_ino = sc->sm->sm_ino;
>  	ri->alleged_ftype = XFS_DIR3_FT_UNKNOWN;
>  	while ((error = xchk_iscan_iter(&ri->ftype_iscan, &dp)) == 1) {
> diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
> index 66ba0fbd059e0..736ce7c9de6a8 100644
> --- a/fs/xfs/scrub/iscan.c
> +++ b/fs/xfs/scrub/iscan.c
> @@ -243,6 +243,40 @@ xchk_iscan_finish(
>  	mutex_unlock(&iscan->lock);
>  }
>  
> +/*
> + * Grab the AGI to advance the inode scan.  Returns 0 if *agi_bpp is now set,
> + * -ECANCELED if the live scan aborted, -EBUSY if the AGI could not be grabbed,
> + * or the usual negative errno.
> + */
> +STATIC int
> +xchk_iscan_read_agi(
> +	struct xchk_iscan	*iscan,
> +	struct xfs_perag	*pag,
> +	struct xfs_buf		**agi_bpp)
> +{
> +	struct xfs_scrub	*sc = iscan->sc;
> +	unsigned long		relax;
> +	int			ret;
> +
> +	if (!xchk_iscan_agi_trylock(iscan))
> +		return xfs_ialloc_read_agi(pag, sc->tp, 0, agi_bpp);
> +
> +	relax = msecs_to_jiffies(iscan->iget_retry_delay);
> +	do {
> +		ret = xfs_ialloc_read_agi(pag, sc->tp, XFS_IALLOC_FLAG_TRYLOCK,
> +				agi_bpp);

Why is this using xfs_ialloc_read_agi() and not xfs_read_agi()?
How do we get here without the perag AGI state not already
initialised?

i.e. if you just use xfs_read_agi(), all the code that has to plumb
flags into xfs_ialloc_read_agi() goes away and this change because a
lot less intrusive....

> +		if (ret != -EAGAIN)
> +			return ret;
> +		if (!iscan->iget_timeout ||
> +		    time_is_before_jiffies(iscan->__iget_deadline))
> +			return -EBUSY;
> +
> +		trace_xchk_iscan_agi_retry_wait(iscan);
> +	} while (!schedule_timeout_killable(relax) &&
> +		 !xchk_iscan_aborted(iscan));
> +	return -ECANCELED;
> +}
> +
>  /*
>   * Advance ino to the next inode that the inobt thinks is allocated, being
>   * careful to jump to the next AG if we've reached the right end of this AG's
> @@ -281,7 +315,7 @@ xchk_iscan_advance(
>  		if (!pag)
>  			return -ECANCELED;
>  
> -		ret = xfs_ialloc_read_agi(pag, sc->tp, 0, &agi_bp);
> +		ret = xchk_iscan_read_agi(iscan, pag, &agi_bp);
>  		if (ret)
>  			goto out_pag;
>  
> diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
> index 71f657552dfac..c9da8f7721f66 100644
> --- a/fs/xfs/scrub/iscan.h
> +++ b/fs/xfs/scrub/iscan.h
> @@ -59,6 +59,9 @@ struct xchk_iscan {
>  /* Set if the scan has been aborted due to some event in the fs. */
>  #define XCHK_ISCAN_OPSTATE_ABORTED	(1)
>  
> +/* Use trylock to acquire the AGI */
> +#define XCHK_ISCAN_OPSTATE_TRYLOCK_AGI	(2)
> +
>  static inline bool
>  xchk_iscan_aborted(const struct xchk_iscan *iscan)
>  {
> @@ -71,6 +74,18 @@ xchk_iscan_abort(struct xchk_iscan *iscan)
>  	set_bit(XCHK_ISCAN_OPSTATE_ABORTED, &iscan->__opstate);
>  }
>  
> +static inline bool
> +xchk_iscan_agi_trylock(const struct xchk_iscan *iscan)
> +{
> +	return test_bit(XCHK_ISCAN_OPSTATE_TRYLOCK_AGI, &iscan->__opstate);
> +}

Function does not actually do any locking, but the name implies it
is actually doing a trylock operation. Perhaps
xchk_iscan_agi_needs_trylock()?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
