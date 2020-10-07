Return-Path: <SRS0=AHt9=DO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F204C4363C
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 08:40:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B8E42080A
	for <linux-xfs@archiver.kernel.org>; Wed,  7 Oct 2020 08:40:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hnd4q1wf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbgJGIkl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 7 Oct 2020 04:40:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726041AbgJGIkk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Oct 2020 04:40:40 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3BCC061755
        for <linux-xfs@vger.kernel.org>; Wed,  7 Oct 2020 01:40:40 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 144so944162pfb.4
        for <linux-xfs@vger.kernel.org>; Wed, 07 Oct 2020 01:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8/0bmtW89RGCt3D8MMpPpww1FRFzeIZb6nBNYOb2b8w=;
        b=Hnd4q1wfgaMqfoS+O1953LQ5AXSTp9h/wmA/Cx50znao1oFX6N6Ef2gaLRVjzY0bDl
         w4wlaaDlnBDtpmalc4Dh3YRRnjBkTQtlc/x0CW6S/3YXIvfX6qFQz8e21nukkgmMJeEH
         VZWtDjQSa+I2rnnIOofL496k9J5UUwzhb4+PaeXl1joZOn5B1FMhXqubFbRMH/u9/ghz
         HiBzfGzp8AWJ/JU0jurmZYqZABw3te1oHtV2IHTmFkC2mWo0UqiAXgj0dN14qDZ7IFHH
         AbXB9IkGV3efK0xojj6VhV7sHBne9U/Tfhoc+o+gctdDdzUAXfnLCe+Zw9VDOhi1c6jq
         r7GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8/0bmtW89RGCt3D8MMpPpww1FRFzeIZb6nBNYOb2b8w=;
        b=pc3tpjlvs3GWiC7N11iAd2pFtTp2JPmeiFF3hgYRobHmsSSHZyweraFU3Infs4h5Tk
         34vLXcd/6iHNNBPusholn/RGA5FRqO82VHyYmTDtfHOA/cn5qwJVELX6l2cvPbegqqyL
         Z+6qBk2y8yspYaA4mEcnre7eQpVziX8PZvftE3eUoz1jXrCNLftzFWGntq3Gsx8MW9Kb
         OLP6iy2D9oMUfJmTQMDxrerz8IkuqpOXbuuMa0f/GHyNVGFWJBcbRh4BzKT1B9ztNvVl
         vHGLzd4ScbGRDYr44MZ5Qn0CdGxdTeVKfeX/LH9Ga8PPPxaF8mn3NfESehDbQAzWMrnJ
         PsaQ==
X-Gm-Message-State: AOAM532kPt4Vy9jBkoda08XDqrDT1jXrmPhktsSya32/hKOwzuYFJ4nr
        enCrcJwXTrhTip7veI7LssQ=
X-Google-Smtp-Source: ABdhPJyWbRfwLfBtE5sTa3+hpjio/Q5wGIWfOfx3fPxCYB0jIVE7wJYHuMK02YMKE2+ggFOVs8+4SQ==
X-Received: by 2002:a62:3001:0:b029:142:2501:39e3 with SMTP id w1-20020a6230010000b0290142250139e3mr1864513pfw.50.1602060040123;
        Wed, 07 Oct 2020 01:40:40 -0700 (PDT)
Received: from garuda.localnet ([171.61.78.55])
        by smtp.gmail.com with ESMTPSA id e6sm2031628pgg.83.2020.10.07.01.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2020 01:40:39 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs: fix deadlock and streamline xfs_getfsmap performance
Date:   Wed, 07 Oct 2020 14:10:36 +0530
Message-ID: <5181946.o3KTjg5V7k@garuda>
In-Reply-To: <160192209677.2569942.16673759463630442919.stgit@magnolia>
References: <160192208358.2569942.13189278742183856412.stgit@magnolia> <160192209677.2569942.16673759463630442919.stgit@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 5 October 2020 11:51:36 PM IST Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Refactor xfs_getfsmap to improve its performance: instead of indirectly
> calling a function that copies one record to userspace at a time, create
> a shadow buffer in the kernel and copy the whole array once at the end.
> On the author's computer, this reduces the runtime on his /home by ~20%.
> 
> This also eliminates a deadlock when running GETFSMAP against the
> realtime device.  The current code locks the rtbitmap to create
> fsmappings and copies them into userspace, having not released the
> rtbitmap lock.  If the userspace buffer is an mmap of a sparse file that
> itself resides on the realtime device, the write page fault will recurse
> into the fs for allocation, which will deadlock on the rtbitmap lock.
>

The changes look good to me,

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Fixes: 4c934c7dd60c ("xfs: report realtime space information via the rtbitmap")
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/xfs_fsmap.c |   45 +++++++++-------
>  fs/xfs/xfs_fsmap.h |    6 --
>  fs/xfs/xfs_ioctl.c |  146 +++++++++++++++++++++++++++++++++++-----------------
>  3 files changed, 125 insertions(+), 72 deletions(-)
> 
> 
> diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
> index aa36e7daf82c..9ce5e7d5bf8f 100644
> --- a/fs/xfs/xfs_fsmap.c
> +++ b/fs/xfs/xfs_fsmap.c
> @@ -26,7 +26,7 @@
>  #include "xfs_rtalloc.h"
>  
>  /* Convert an xfs_fsmap to an fsmap. */
> -void
> +static void
>  xfs_fsmap_from_internal(
>  	struct fsmap		*dest,
>  	struct xfs_fsmap	*src)
> @@ -155,8 +155,7 @@ xfs_fsmap_owner_from_rmap(
>  /* getfsmap query state */
>  struct xfs_getfsmap_info {
>  	struct xfs_fsmap_head	*head;
> -	xfs_fsmap_format_t	formatter;	/* formatting fn */
> -	void			*format_arg;	/* format buffer */
> +	struct fsmap		*fsmap_recs;	/* mapping records */
>  	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
>  	xfs_daddr_t		next_daddr;	/* next daddr we expect */
>  	u64			missing_owner;	/* owner of holes */
> @@ -224,6 +223,20 @@ xfs_getfsmap_is_shared(
>  	return 0;
>  }
>  
> +static inline void
> +xfs_getfsmap_format(
> +	struct xfs_mount		*mp,
> +	struct xfs_fsmap		*xfm,
> +	struct xfs_getfsmap_info	*info)
> +{
> +	struct fsmap			*rec;
> +
> +	trace_xfs_getfsmap_mapping(mp, xfm);
> +
> +	rec = &info->fsmap_recs[info->head->fmh_entries++];
> +	xfs_fsmap_from_internal(rec, xfm);
> +}
> +
>  /*
>   * Format a reverse mapping for getfsmap, having translated rm_startblock
>   * into the appropriate daddr units.
> @@ -288,10 +301,7 @@ xfs_getfsmap_helper(
>  		fmr.fmr_offset = 0;
>  		fmr.fmr_length = rec_daddr - info->next_daddr;
>  		fmr.fmr_flags = FMR_OF_SPECIAL_OWNER;
> -		error = info->formatter(&fmr, info->format_arg);
> -		if (error)
> -			return error;
> -		info->head->fmh_entries++;
> +		xfs_getfsmap_format(mp, &fmr, info);
>  	}
>  
>  	if (info->last)
> @@ -323,11 +333,8 @@ xfs_getfsmap_helper(
>  		if (shared)
>  			fmr.fmr_flags |= FMR_OF_SHARED;
>  	}
> -	error = info->formatter(&fmr, info->format_arg);
> -	if (error)
> -		return error;
> -	info->head->fmh_entries++;
>  
> +	xfs_getfsmap_format(mp, &fmr, info);
>  out:
>  	rec_daddr += XFS_FSB_TO_BB(mp, rec->rm_blockcount);
>  	if (info->next_daddr < rec_daddr)
> @@ -795,11 +802,11 @@ xfs_getfsmap_check_keys(
>  #endif /* CONFIG_XFS_RT */
>  
>  /*
> - * Get filesystem's extents as described in head, and format for
> - * output.  Calls formatter to fill the user's buffer until all
> - * extents are mapped, until the passed-in head->fmh_count slots have
> - * been filled, or until the formatter short-circuits the loop, if it
> - * is tracking filled-in extents on its own.
> + * Get filesystem's extents as described in head, and format for output. Fills
> + * in the supplied records array until there are no more reverse mappings to
> + * return or head.fmh_entries == head.fmh_count.  In the second case, this
> + * function returns -ECANCELED to indicate that more records would have been
> + * returned.
>   *
>   * Key to Confusion
>   * ----------------
> @@ -819,8 +826,7 @@ int
>  xfs_getfsmap(
>  	struct xfs_mount		*mp,
>  	struct xfs_fsmap_head		*head,
> -	xfs_fsmap_format_t		formatter,
> -	void				*arg)
> +	struct fsmap			*fsmap_recs)
>  {
>  	struct xfs_trans		*tp = NULL;
>  	struct xfs_fsmap		dkeys[2];	/* per-dev keys */
> @@ -895,8 +901,7 @@ xfs_getfsmap(
>  
>  	info.next_daddr = head->fmh_keys[0].fmr_physical +
>  			  head->fmh_keys[0].fmr_length;
> -	info.formatter = formatter;
> -	info.format_arg = arg;
> +	info.fsmap_recs = fsmap_recs;
>  	info.head = head;
>  
>  	/*
> diff --git a/fs/xfs/xfs_fsmap.h b/fs/xfs/xfs_fsmap.h
> index c6c57739b862..a0775788e7b1 100644
> --- a/fs/xfs/xfs_fsmap.h
> +++ b/fs/xfs/xfs_fsmap.h
> @@ -27,13 +27,9 @@ struct xfs_fsmap_head {
>  	struct xfs_fsmap fmh_keys[2];	/* low and high keys */
>  };
>  
> -void xfs_fsmap_from_internal(struct fsmap *dest, struct xfs_fsmap *src);
>  void xfs_fsmap_to_internal(struct xfs_fsmap *dest, struct fsmap *src);
>  
> -/* fsmap to userspace formatter - copy to user & advance pointer */
> -typedef int (*xfs_fsmap_format_t)(struct xfs_fsmap *, void *);
> -
>  int xfs_getfsmap(struct xfs_mount *mp, struct xfs_fsmap_head *head,
> -		xfs_fsmap_format_t formatter, void *arg);
> +		struct fsmap *out_recs);
>  
>  #endif /* __XFS_FSMAP_H__ */
> diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> index bca7659fb5c6..3fbd98f61ea5 100644
> --- a/fs/xfs/xfs_ioctl.c
> +++ b/fs/xfs/xfs_ioctl.c
> @@ -1716,39 +1716,17 @@ xfs_ioc_getbmap(
>  	return error;
>  }
>  
> -struct getfsmap_info {
> -	struct xfs_mount	*mp;
> -	struct fsmap_head __user *data;
> -	unsigned int		idx;
> -	__u32			last_flags;
> -};
> -
> -STATIC int
> -xfs_getfsmap_format(struct xfs_fsmap *xfm, void *priv)
> -{
> -	struct getfsmap_info	*info = priv;
> -	struct fsmap		fm;
> -
> -	trace_xfs_getfsmap_mapping(info->mp, xfm);
> -
> -	info->last_flags = xfm->fmr_flags;
> -	xfs_fsmap_from_internal(&fm, xfm);
> -	if (copy_to_user(&info->data->fmh_recs[info->idx++], &fm,
> -			sizeof(struct fsmap)))
> -		return -EFAULT;
> -
> -	return 0;
> -}
> -
>  STATIC int
>  xfs_ioc_getfsmap(
>  	struct xfs_inode	*ip,
>  	struct fsmap_head	__user *arg)
>  {
> -	struct getfsmap_info	info = { NULL };
>  	struct xfs_fsmap_head	xhead = {0};
>  	struct fsmap_head	head;
> -	bool			aborted = false;
> +	struct fsmap		*recs;
> +	unsigned int		count;
> +	__u32			last_flags = 0;
> +	bool			done = false;
>  	int			error;
>  
>  	if (copy_from_user(&head, arg, sizeof(struct fsmap_head)))
> @@ -1760,38 +1738,112 @@ xfs_ioc_getfsmap(
>  		       sizeof(head.fmh_keys[1].fmr_reserved)))
>  		return -EINVAL;
>  
> +	/*
> +	 * Use an internal memory buffer so that we don't have to copy fsmap
> +	 * data to userspace while holding locks.  Start by trying to allocate
> +	 * up to 128k for the buffer, but fall back to a single page if needed.
> +	 */
> +	count = min_t(unsigned int, head.fmh_count,
> +			131072 / sizeof(struct fsmap));
> +	recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
> +	if (!recs) {
> +		count = min_t(unsigned int, head.fmh_count,
> +				PAGE_SIZE / sizeof(struct fsmap));
> +		recs = kvzalloc(count * sizeof(struct fsmap), GFP_KERNEL);
> +		if (!recs)
> +			return -ENOMEM;
> +	}
> +
>  	xhead.fmh_iflags = head.fmh_iflags;
> -	xhead.fmh_count = head.fmh_count;
>  	xfs_fsmap_to_internal(&xhead.fmh_keys[0], &head.fmh_keys[0]);
>  	xfs_fsmap_to_internal(&xhead.fmh_keys[1], &head.fmh_keys[1]);
>  
>  	trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
>  	trace_xfs_getfsmap_high_key(ip->i_mount, &xhead.fmh_keys[1]);
>  
> -	info.mp = ip->i_mount;
> -	info.data = arg;
> -	error = xfs_getfsmap(ip->i_mount, &xhead, xfs_getfsmap_format, &info);
> -	if (error == -ECANCELED) {
> -		error = 0;
> -		aborted = true;
> -	} else if (error)
> -		return error;
> -
> -	/* If we didn't abort, set the "last" flag in the last fmx */
> -	if (!aborted && info.idx) {
> -		info.last_flags |= FMR_OF_LAST;
> -		if (copy_to_user(&info.data->fmh_recs[info.idx - 1].fmr_flags,
> -				&info.last_flags, sizeof(info.last_flags)))
> -			return -EFAULT;
> +	head.fmh_entries = 0;
> +	do {
> +		struct fsmap __user	*user_recs;
> +		struct fsmap		*last_rec;
> +
> +		user_recs = &arg->fmh_recs[head.fmh_entries];
> +		xhead.fmh_entries = 0;
> +		xhead.fmh_count = min_t(unsigned int, count,
> +					head.fmh_count - head.fmh_entries);
> +
> +		/* Run query, record how many entries we got. */
> +		error = xfs_getfsmap(ip->i_mount, &xhead, recs);
> +		switch (error) {
> +		case 0:
> +			/*
> +			 * There are no more records in the result set.  Copy
> +			 * whatever we got to userspace and break out.
> +			 */
> +			done = true;
> +			break;
> +		case -ECANCELED:
> +			/*
> +			 * The internal memory buffer is full.  Copy whatever
> +			 * records we got to userspace and go again if we have
> +			 * not yet filled the userspace buffer.
> +			 */
> +			error = 0;
> +			break;
> +		default:
> +			goto out_free;
> +		}
> +		head.fmh_entries += xhead.fmh_entries;
> +		head.fmh_oflags = xhead.fmh_oflags;
> +
> +		/*
> +		 * If the caller wanted a record count or there aren't any
> +		 * new records to return, we're done.
> +		 */
> +		if (head.fmh_count == 0 || xhead.fmh_entries == 0)
> +			break;
> +
> +		/* Copy all the records we got out to userspace. */
> +		if (copy_to_user(user_recs, recs,
> +				 xhead.fmh_entries * sizeof(struct fsmap))) {
> +			error = -EFAULT;
> +			goto out_free;
> +		}
> +
> +		/* Remember the last record flags we copied to userspace. */
> +		last_rec = &recs[xhead.fmh_entries - 1];
> +		last_flags = last_rec->fmr_flags;
> +
> +		/* Set up the low key for the next iteration. */
> +		xfs_fsmap_to_internal(&xhead.fmh_keys[0], last_rec);
> +		trace_xfs_getfsmap_low_key(ip->i_mount, &xhead.fmh_keys[0]);
> +	} while (!done && head.fmh_entries < head.fmh_count);
> +
> +	/*
> +	 * If there are no more records in the query result set and we're not
> +	 * in counting mode, mark the last record returned with the LAST flag.
> +	 */
> +	if (done && head.fmh_count > 0 && head.fmh_entries > 0) {
> +		struct fsmap __user	*user_rec;
> +
> +		last_flags |= FMR_OF_LAST;
> +		user_rec = &arg->fmh_recs[head.fmh_entries - 1];
> +
> +		if (copy_to_user(&user_rec->fmr_flags, &last_flags,
> +					sizeof(last_flags))) {
> +			error = -EFAULT;
> +			goto out_free;
> +		}
>  	}
>  
>  	/* copy back header */
> -	head.fmh_entries = xhead.fmh_entries;
> -	head.fmh_oflags = xhead.fmh_oflags;
> -	if (copy_to_user(arg, &head, sizeof(struct fsmap_head)))
> -		return -EFAULT;
> +	if (copy_to_user(arg, &head, sizeof(struct fsmap_head))) {
> +		error = -EFAULT;
> +		goto out_free;
> +	}
>  
> -	return 0;
> +out_free:
> +	kmem_free(recs);
> +	return error;
>  }
>  
>  STATIC int
> 
> 


-- 
chandan



