Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C632D20EB
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 03:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728961531; cv=none; b=TGGuYxidH2wm82itTFez2jGlT3pQao2Ld0jSxGiRaekBS6IrEaZlDJ+jxyQL9zMDOTUshO8flGeB81jspF0pPq3cs1WmeunLNGme7tNG49fxK1fPCJbBl10Q9o65odyM1OHhdhTnqdFMG5KRXyyo+SOy58hgM8qaEG9Qve3+nR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728961531; c=relaxed/simple;
	bh=X2WUzt4WMnNQl2CgQEQE0+tECj4Mn5tpr4eTBRCwqL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEPwP9bM4fJzvdJEx7CFsW2T9Ci9H3cRU2CoMeRB66kDCIDN7ZTL0r/rzdtffTJb6nOoztzwqAHJid3MJCvp7e+rqqqE5YRWmtAU0JLZiJmLPxU3UqpzlgiS3L/lLKQChEryfUPXfCgzmwsDe7xxkoohtWm+P2lD63SIuYA403E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=NCk7AKjW; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="NCk7AKjW"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-7163489149eso3986613a12.1
        for <linux-xfs@vger.kernel.org>; Mon, 14 Oct 2024 20:05:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728961529; x=1729566329; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gHoPOt8QILO9hacoOhHDz1j7kF3yafnL5g/s+uYZvtE=;
        b=NCk7AKjWTJdlraSdeV5Lj70gIsEnhLa2x2ytSgD/LEXYQebbuljo0M/7bJIElHNMjL
         Eojpi+j+7IjcwKTzUHswubjrkex7LjW77PORxf/V9U5HbNrtWnS17FsL610139tkfuXS
         j3MLQBtPK7wZ7pfR4K+ayp+bhvOr/yqECbkVoV3gPbNR/oly1DiX+SUA6R5bz/GEIGAX
         CHH/+MZQyqbVb+yceJgzW4iUHw8UeGOjgreBZtTcH2e8E9t8WP9P3z3Lk84/6Tw7kc8W
         Ms18rFK0SJNUrI2xlyLn6KxnJfvhkiRwe4n3fmgIn9u8IipoqEGsMWNSt1CQ1iqlhx22
         AQPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728961529; x=1729566329;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHoPOt8QILO9hacoOhHDz1j7kF3yafnL5g/s+uYZvtE=;
        b=V5nZlcwpcVzAg1WuBjjDuW499GoMx5b5KLfB6f0R2YN2dr2A3m2GXICLJgL5iiSCAi
         AV910aDgmGUiEVtPfeVJz8xcW2+T3dnxF6UFbOkWuyfIqo/pDg+EjqVELlgT5A/BWqS5
         GQlX4ePv9QuTnUfkGuIpI+L0lJfs8+AqV97bc0SKeo9krq2zzTDUfcS4GJN7vhXlqMs8
         F/Y1nrmevQ/36z6ggM0mL+GrqssbeA3wTKkPwb4gHwi3jUA2XOReDiH+9zjgMQtgepao
         1OxcsnFy96zNiscAZuqcDPReGVvspi3JSWpMd2dwcVivCVD/ryqMh19VO0OuEKAWGX/o
         Yp0w==
X-Gm-Message-State: AOJu0YxkBD3bbbACOcKlu5T+0nHfjdNUmFLN/e7nzaK4HPlcnUyb1pqM
	igp4pURDvb7MlkxBX6uMl8KerL34Vvvnn/8Mjl+GX3n8D4SRXPD74cSQUIymxgE=
X-Google-Smtp-Source: AGHT+IHiOEhvnwPlqRq2JDA6/sfYpakSrBH1DuciMWSglGwblWQjU/cXP0Mi4/ZmPZM/Ihorcbjb4A==
X-Received: by 2002:a05:6a20:9f47:b0:1d4:fc75:8d48 with SMTP id adf61e73a8af0-1d8c9576f8emr15906613637.3.1728961528894;
        Mon, 14 Oct 2024 20:05:28 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e774a420dsm272765b3a.133.2024.10.14.20.05.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 20:05:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0XsE-000xWX-0j;
	Tue, 15 Oct 2024 14:05:26 +1100
Date: Tue, 15 Oct 2024 14:05:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 12/16] xfs: add a generic group pointer to the btree
 cursor
Message-ID: <Zw3b9lD12fK0Y6Pn@dread.disaster.area>
References: <172860641207.4176300.780787546464458623.stgit@frogsfrogsfrogs>
 <172860641471.4176300.17811783731579673565.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <172860641471.4176300.17811783731579673565.stgit@frogsfrogsfrogs>

On Thu, Oct 10, 2024 at 05:47:20PM -0700, Darrick J. Wong wrote:
> From: Christoph Hellwig <hch@lst.de>
> 
> Replace the pag pointers in the type specific union with a generic
> xfs_group pointer.  This prepares for adding realtime group support.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_alloc.c          |    8 ++++----
>  fs/xfs/libxfs/xfs_alloc_btree.c    |   28 ++++++++++++++--------------
>  fs/xfs/libxfs/xfs_btree.c          |   35 ++++++++++++-----------------------
>  fs/xfs/libxfs/xfs_btree.h          |    3 +--
>  fs/xfs/libxfs/xfs_btree_mem.c      |    6 ++----
>  fs/xfs/libxfs/xfs_ialloc.c         |   12 +++++++-----
>  fs/xfs/libxfs/xfs_ialloc_btree.c   |   15 ++++++++-------
>  fs/xfs/libxfs/xfs_refcount.c       |   17 +++++++++--------
>  fs/xfs/libxfs/xfs_refcount_btree.c |   10 +++++-----
>  fs/xfs/libxfs/xfs_rmap.c           |    8 +++-----
>  fs/xfs/libxfs/xfs_rmap_btree.c     |   19 ++++++++++---------
>  fs/xfs/scrub/alloc.c               |    2 +-
>  fs/xfs/scrub/bmap.c                |    3 ++-
>  fs/xfs/scrub/bmap_repair.c         |    4 ++--
>  fs/xfs/scrub/cow_repair.c          |    9 ++++++---
>  fs/xfs/scrub/health.c              |    2 +-
>  fs/xfs/scrub/ialloc.c              |   14 +++++++-------
>  fs/xfs/scrub/refcount.c            |    3 ++-
>  fs/xfs/scrub/rmap.c                |    2 +-
>  fs/xfs/scrub/rmap_repair.c         |    2 +-
>  fs/xfs/xfs_fsmap.c                 |    6 ++++--
>  fs/xfs/xfs_health.c                |   23 ++++++-----------------
>  fs/xfs/xfs_trace.h                 |   28 ++++++++++++++--------------
>  23 files changed, 122 insertions(+), 137 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 820ffa6ea6bd75..db25c8ad104206 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -275,7 +275,7 @@ xfs_alloc_complain_bad_rec(
>  
>  	xfs_warn(mp,
>  		"%sbt record corruption in AG %d detected at %pS!",
> -		cur->bc_ops->name, pag_agno(cur->bc_ag.pag), fa);
> +		cur->bc_ops->name, cur->bc_group->xg_index, fa);
                                   ^^^^^^^^^^^^^^^^^^^^^^^

Reading through this patch, I keep wanting to this to read as "group
number" as a replacement for AG number. i.e. pag_agno(pag) ->
group_num(grp) as the nice, short helper function.

We're kinda used to this with terminology with agno, agbno, fsbno,
ino, agino, etc all refering to the "number" associated with an
object type.  Hence it seems kinda natural to refer to these as
group numbers rather than an index into something....

Just an observation, up to you whether you think it's worthwhile or
not.

> diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
> index 843174a5903658..22a65d09e647a3 100644
> --- a/fs/xfs/libxfs/xfs_alloc_btree.c
> +++ b/fs/xfs/libxfs/xfs_alloc_btree.c
> @@ -28,7 +28,7 @@ xfs_bnobt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_bnobt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ag.agbp,
> -			cur->bc_ag.pag);
> +			to_perag(cur->bc_group));
>  }
>  
>  STATIC struct xfs_btree_cur *
> @@ -36,29 +36,29 @@ xfs_cntbt_dup_cursor(
>  	struct xfs_btree_cur	*cur)
>  {
>  	return xfs_cntbt_init_cursor(cur->bc_mp, cur->bc_tp, cur->bc_ag.agbp,
> -			cur->bc_ag.pag);
> +			to_perag(cur->bc_group));
>  }

Huh. Less than ideal code will be generated for these (group on old
cursor -> perag -> back to group in new cursor) code, but converting
every single bit of the btree cursor code over to groups doesn't
need to be done here...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
