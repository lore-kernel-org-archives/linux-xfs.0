Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB0EC76196
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Apr 2023 03:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbjDKDUo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 10 Apr 2023 23:20:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229624AbjDKDUl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 10 Apr 2023 23:20:41 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 831CE185
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:20:39 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 60-20020a17090a09c200b0023fcc8ce113so9494341pjo.4
        for <linux-xfs@vger.kernel.org>; Mon, 10 Apr 2023 20:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112; t=1681183239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uiv1toZKCXS/GvUNDQHTWjeyUeJtu4Vb7S6TnxlCUek=;
        b=4S37Uu/dQ/M/Ngi/65x7NG+hbwc0t7Hm2WtiXGqvij6d2NVzjtfzkCDBWJ+uWMQj1x
         vAc3C6Eh/HWy01HL4AubEUQyguIjmbuwpc4xQ5gNGsOkiudrOyFPr1pvbUxlh+sZ7PPA
         tAIT4ri4MuikuB9dbCAlsrtFSezh13eFqI8hFZrIxeCM5jUAJnJp8Lti4+j4HLlJ1dzs
         LiteN41uywxHjRLT70zFyQhhyqDYVmHe0d2L+JgVfLgBGOau832/+QBjNlXJM7MAeMJL
         KTzkHO7c4si9h4xzDXRO0rQhlJHtFe5r0A0bWJC3h3PV0AMsi7ubfLrjDMOvocud+h5q
         G0jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681183239;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uiv1toZKCXS/GvUNDQHTWjeyUeJtu4Vb7S6TnxlCUek=;
        b=xIFiTKl5kV7/shXOn/A/o3Lo5HP9SgNHkXqCtR+JYcpQrPwtRWGZ5/B3IqV9NrIEcE
         WBTCCvnkFdOAnIMmvScPCFYKajXM2ahvju4euyxj4oiq66XV3lFZIsUYrimTZNxHIUKz
         ONc5sC+0r6XdUgVQJHxOhiLDhJ3Fm8mGILrXEmr9pT8VuAJYlLjGlWHhLnM6pQHJIMNa
         J8rvtVYP48yWa8INpEhJuRHt+4qhg0xXvw8sUHAu6XzKTqiGin8WKy0rMUQyEHWPEtTK
         OtuOi49CpQr6mY3rSt2Qukkn4WdnDGyJzJcTKvKgsDNuYhDOY5rw8Xh+UJf7/4PNK8tl
         yLMg==
X-Gm-Message-State: AAQBX9fPYO3rieIknLaL1Pm3TQg263CDMERDut0CYj9ya/Oa68gUHzUH
        jQRO0MJ94//zz+tU/6RT3DD8AI+o8x9Wvs9YVCLosOv/
X-Google-Smtp-Source: AKy350ZC+3knXa/TuObu22n/fO3tFf3R6Cc+atPHxRv2NvE5LrSIDMxMxD3FYisURjxnDwgfETmKOw==
X-Received: by 2002:a17:90b:1c09:b0:246:dc4b:d52b with SMTP id oc9-20020a17090b1c0900b00246dc4bd52bmr1686279pjb.44.1681183238965;
        Mon, 10 Apr 2023 20:20:38 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-41-174.pa.nsw.optusnet.com.au. [49.180.41.174])
        by smtp.gmail.com with ESMTPSA id d16-20020a17090abf9000b002353082958csm9972466pjs.10.2023.04.10.20.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Apr 2023 20:20:38 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1pm4Yd-001wZB-6u; Tue, 11 Apr 2023 13:20:35 +1000
Date:   Tue, 11 Apr 2023 13:20:35 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: _{attr,data}_map_shared should take ILOCK_EXCL
 until iread_extents is completely done
Message-ID: <20230411032035.GZ3223426@dread.disaster.area>
References: <20230411010638.GF360889@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230411010638.GF360889@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 10, 2023 at 06:06:38PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> While fuzzing the data fork extent count on a btree-format directory
> with xfs/375, I observed the following (excerpted) splat:
> 
> XFS: Assertion failed: xfs_isilocked(ip, XFS_ILOCK_EXCL), file: fs/xfs/libxfs/xfs_bmap.c, line: 1208
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 43192 at fs/xfs/xfs_message.c:104 assfail+0x46/0x4a [xfs]
> Call Trace:
>  <TASK>
>  xfs_iread_extents+0x1af/0x210 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_dir_walk+0xb8/0x190 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent_count_parent_dentries+0x41/0x80 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent_validate+0x199/0x2e0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xchk_parent+0xdf/0x130 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_scrub_metadata+0x2b8/0x730 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_scrubv_metadata+0x38b/0x4d0 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_ioc_scrubv_metadata+0x111/0x160 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  xfs_file_ioctl+0x367/0xf50 [xfs 09f66509ece4938760fac7de64732a0cbd3e39cd]
>  __x64_sys_ioctl+0x82/0xa0
>  do_syscall_64+0x2b/0x80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> 
> The cause of this is a race condition in xfs_ilock_data_map_shared,
> which performs an unlocked access to the data fork to guess which lock
> mode it needs:
> 
> Thread 0                          Thread 1
> 
> xfs_need_iread_extents
> <observe no iext tree>
> xfs_ilock(..., ILOCK_EXCL)
> xfs_iread_extents
> <observe no iext tree>
> <check ILOCK_EXCL>
> <load bmbt extents into iext>
> <notice iext size doesn't
>  match nextents>
>                                   xfs_need_iread_extents
>                                   <observe iext tree>
>                                   xfs_ilock(..., ILOCK_SHARED)
> <tear down iext tree>
> xfs_iunlock(..., ILOCK_EXCL)
>                                   xfs_iread_extents
>                                   <observe no iext tree>
>                                   <check ILOCK_EXCL>
>                                   *BOOM*
> 
> Fix this race by adding a flag to the xfs_ifork structure to indicate
> that we have not yet read in the extent records and changing the
> predicate to look at the flag state, not if_height.  The memory barrier
> ensures that the flag will not be set until the very end of the
> function.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_bmap.c       |    2 ++
>  fs/xfs/libxfs/xfs_inode_fork.c |    2 ++
>  fs/xfs/libxfs/xfs_inode_fork.h |    3 ++-
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 34de6e6898c4..5f96e7ce7b4a 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -1171,6 +1171,8 @@ xfs_iread_extents(
>  		goto out;
>  	}
>  	ASSERT(ir.loaded == xfs_iext_count(ifp));
> +	smp_mb();
> +	ifp->if_needextents = 0;

Hmmm - if this is to ensure that everything above is completed
before the clearing of this flag is visible everywhere else, then we
should be able to use load_acquire/store_release semantics? i.e. the
above is

	smp_store_release(ifp->if_needextents, 0);

and we use

	smp_load_acquire(ifp->if_needextents)

when we need to read the value to ensure that all the changes made
before the relevant stores are also visible?

>  	return 0;
>  out:
>  	xfs_iext_destroy(ifp);
> diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> index 6b21760184d9..eadae924dc42 100644
> --- a/fs/xfs/libxfs/xfs_inode_fork.c
> +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> @@ -174,6 +174,8 @@ xfs_iformat_btree(
>  	int			level;
>  
>  	ifp = xfs_ifork_ptr(ip, whichfork);
> +	ifp->if_needextents = 1;

Hmmm - what's the guarantee that the reader will see ifp->if_format
set correctly if they if_needextents = 1?

Wouldn't it be better to set this at the same time we set the
ifp->if_format value? We clear it unconditionally above in
xfs_iread_extents(), so why not set it unconditionally there, too,
before we start. i.e.

	/*
	 * Set the format before we set needsextents with release
	 * semantics. This ensures that we can use acquire semantics
	 * on needextents in xfs_need_iread_extents() and be
	 * guaranteed to see a valid format value after that load.
	 */
	ifp->if_format = dip->di_format;
	smp_store_release(ifp->if_needextents, 1);

That then means xfs_need_iread_extents() is guaranteed to see a
valid ifp->if_format if ifp->if_needextents is set if we do:

/* returns true if the fork has extents but they are not read in yet. */
static inline bool xfs_need_iread_extents(struct xfs_ifork *ifp)
{

	/* see xfs_iread_extents() for needextents semantics */
	return smp_load_acquire(ifp->if_needextents) &&
			ifp->if_format == XFS_DINODE_FMT_BTREE;
}

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
