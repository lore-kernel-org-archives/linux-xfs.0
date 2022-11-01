Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AA9BC4332F
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Nov 2022 23:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiKAXkc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 19:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbiKAXkb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 19:40:31 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FC0B1D0C3
        for <linux-xfs@vger.kernel.org>; Tue,  1 Nov 2022 16:40:27 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p3so15003048pld.10
        for <linux-xfs@vger.kernel.org>; Tue, 01 Nov 2022 16:40:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GtKgZnMWnFV8ARtobSyeL40TV48xDhDVUkrse8zSNho=;
        b=4I5TkjATpqUuNsbyAbPQFS4mOGohLHgEazX2mYy8yac5IDq3+/muKpZCKemheBmvUU
         qBDN7udHxzvSyd1YLQws0vYrxYTwmi7OvcdgS2I+XQjhz9+3wSIHrp8S2sQZuXraghTU
         sFNP1zyaYVMQ4jRlATQnh/bwAGXkmte32LS7kL/JkDiwyXVzFfDaC8AwUUoT8LAsIlxt
         sQiJlwgTLPAs8FNUmFG7Z3EjQsAkhPuojFXtTef5W0w1P61AH4hk76nwjX6gGjS6guaJ
         qaSrmfSKpFJ9Re9SL79AXPihV6oJZJ1EjPVI4zTy2SVT4zAgFeFrGyCO35vOCkRW4wrW
         saJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GtKgZnMWnFV8ARtobSyeL40TV48xDhDVUkrse8zSNho=;
        b=WK+ll6PJChDw7eQ89mMf8LUfKzNirXjchX/SHENExm46cqFfl5I3scmSdSliF5Ddd6
         MCdSiVO0f6Imnnr4qtSl9BGpImOjCigFzlfe6hwKyiM4kzhL+FeI0uo/WS0txU6fiudm
         HazTqlGOM5icdFkZWBVNOllCVYA1w6pwmTIXNNPuWfI2fKn9kQu8AKi/BQa/8TWL3hN7
         ungPOmcXShKBo6fLGiIyXt4Yau+qp9SJAw1icbu+ei8qPVV8WonQgGgUw6LRUnzIwn65
         1fymnE9HDF22sovhhjmmuZhNDuyhwil0oXN9Zi6VX+O3ecG0VSA+6zx60ZF/UsGPr26H
         zw1w==
X-Gm-Message-State: ACrzQf3d1Mb3bSh+6Vf5h8vqGtN2nB+SmfYeU6GTjBjG1fPFlia0itgd
        xF8GxoOZHH+VMh4mwXJJSUVcDQ==
X-Google-Smtp-Source: AMsMyM7N69Qps0nRdNHq9+WcnHEWmGCSdRTDHzhaYcqpSKhdR10SPD9WbO7jZySUv2FtNendRqBP2w==
X-Received: by 2002:a17:90a:5a46:b0:213:cf6e:5f67 with SMTP id m6-20020a17090a5a4600b00213cf6e5f67mr15782796pji.93.1667346026779;
        Tue, 01 Nov 2022 16:40:26 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id m6-20020a170902db0600b0017c19d7c89bsm6887263plx.269.2022.11.01.16.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 16:40:26 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oq0rm-009ASM-KB; Wed, 02 Nov 2022 10:40:22 +1100
Date:   Wed, 2 Nov 2022 10:40:22 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: fix rmap key comparison functions
Message-ID: <20221101234022.GO3600936@dread.disaster.area>
References: <166473481246.1084112.5533985608121370791.stgit@magnolia>
 <166473481263.1084112.1077820948503334734.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166473481263.1084112.1077820948503334734.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Oct 02, 2022 at 11:20:12AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Keys for extent interval records in the reverse mapping btree are
> supposed to be computed as follows:
> 
> (physical block, owner, fork, is_btree, offset)
> 
> This provides users the ability to look up a reverse mapping from a file
> block mapping record -- start with the physical block; then if there are
> multiple records for the same block, move on to the owner; then the
> inode fork type; and so on to the file offset.
> 
> However, the key comparison functions incorrectly remove the fork/bmbt
> information that's encoded in the on-disk offset.  This means that
> lookup comparisons are only done with:
> 
> (physical block, owner, offset)
> 
> This means that queries can return incorrect results.  On consistent
> filesystems this isn't an issue because bmbt blocks and blocks mapped to
> an attr fork cannot be shared, but this prevents us from detecting
> incorrect fork and bmbt flag bits in the rmap btree.
> 
> A previous version of this patch forgot to keep the (un)written state
> flag masked during the comparison and caused a major regression in
> 5.9.x since unwritten extent conversion can update an rmap record
> without requiring key updates.
> 
> Note that blocks cannot go directly from data fork to attr fork without
> being deallocated and reallocated, nor can they be added to or removed
> from a bmbt without a free/alloc cycle, so this should not cause any
> regressions.
> 
> Found by fuzzing keys[1].attrfork = ones on xfs/371.
> 
> Fixes: 4b8ed67794fe ("xfs: add rmap btree operations")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_rmap_btree.c |   25 +++++++++++++++++--------
>  1 file changed, 17 insertions(+), 8 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
> index 7f83f62e51e0..e2e1f68cedf5 100644
> --- a/fs/xfs/libxfs/xfs_rmap_btree.c
> +++ b/fs/xfs/libxfs/xfs_rmap_btree.c
> @@ -219,6 +219,15 @@ xfs_rmapbt_init_ptr_from_cur(
>  	ptr->s = agf->agf_roots[cur->bc_btnum];
>  }
>  
> +/*
> + * Fork and bmbt are significant parts of the rmap record key, but written
> + * status is merely a record attribute.
> + */
> +static inline uint64_t offset_keymask(uint64_t offset)
> +{
> +	return offset & ~XFS_RMAP_OFF_UNWRITTEN;
> +}

Ok. but doesn't that mean xfs_rmapbt_init_key_from_rec() and
xfs_rmapbt_init_high_key_from_rec() should be masking out the
XFS_RMAP_OFF_UNWRITTEN bit as well?

-Dave.

-- 
Dave Chinner
david@fromorbit.com
