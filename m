Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96878C77B73
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Apr 2023 02:11:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbjD1CLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 22:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbjD1CLa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Apr 2023 22:11:30 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86311FFD
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:11:29 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b7b54642cso6559778b3a.0
        for <linux-xfs@vger.kernel.org>; Thu, 27 Apr 2023 19:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682647889; x=1685239889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Bfa2/UjM0FDMPneuE9VDvjd8CwyBcY3GoZvkEdSJo/Y=;
        b=Pyib2hNlYarBL7Z+xfKFWj27wJ+HREyAPH4rYnktb89Pxo83GR+ybwHZ4SU8qYExSQ
         HVb2BpEF8ncPlZ3MraL4JwevicdT3rGRjd2oWAS6MvLZJaBsbaF19P8BHJvzqQeX3FEp
         68RNbKVSq43cQUIhNvBzKu3nnHWCoZnVoG8LbuhmmlF5e5huTWfI9rCmCfupdxEZ5yPE
         AJUC7U20ug7FkMJ78h8FV1t0K+f/wGwl5jfo+K8Djndep4H2OYEd3ErGMnLxc86DooZT
         7ESDxlTIPX6jY33HF3tvNuj+Bbe8LgS5igVUVsZ9VEgq9LYwGfrNlVOHCkEWzq9PFacS
         KbwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682647889; x=1685239889;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bfa2/UjM0FDMPneuE9VDvjd8CwyBcY3GoZvkEdSJo/Y=;
        b=B9uPi8WtbOLottXqu0rbJv4MlGQQW+wF7NF9Z8yc+wAc96rKEMlIQBmyxvUYcYzbgm
         LMIeH2/d6vkx3qZRA/bq9goK6JYamMAKXSmonwxciajM2wcKS6G8u04d4dIwplzjMFuy
         S23l/W8bBOvrym7R5T05mbuIXF/5pUY2qIXdogfuy2u64Y8qM498w7WIhzhoZOzp4mQl
         153YtlWZ8W6y83L3pt/G+lhufn1jzXY1JfhH0jvSHXVaUlznRkeBTmVw8aFYzrd1jHUi
         c7Vg0wst+X8NY1kKhFAL6yZ2mZTg8sm2vIcc7m3SK/86eXq3oWXlxFhzZKeJGRgu/YsW
         CfiQ==
X-Gm-Message-State: AC+VfDyVeNGzy7xLRYx5zgkJJVT5cWq7Pr1m4HI5CkTJfs+qGmgM8/Lj
        C4nDuwR5Pnymy2viUGqsGkrvXA==
X-Google-Smtp-Source: ACHHUZ6V8fIHIu3xvrZTBLinyiiVs+ej5b2DFXhbgO4+2xetD9WsRKjZXj2Ksm6FYShdz3P2iE2njw==
X-Received: by 2002:a05:6a20:7f90:b0:ee:786b:d6f8 with SMTP id d16-20020a056a207f9000b000ee786bd6f8mr4729414pzj.57.1682647889129;
        Thu, 27 Apr 2023 19:11:29 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id n13-20020a17090ac68d00b0023f8e3702c3sm13868633pjt.30.2023.04.27.19.11.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 19:11:28 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1psDa1-008hve-72; Fri, 28 Apr 2023 12:11:25 +1000
Date:   Fri, 28 Apr 2023 12:11:25 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: set bnobt/cntbt numrecs correctly when
 formatting new AGs
Message-ID: <20230428021125.GO3223426@dread.disaster.area>
References: <168263573426.1717721.15565213947185049577.stgit@frogsfrogsfrogs>
 <168263574554.1717721.6730628291355995988.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168263574554.1717721.6730628291355995988.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 27, 2023 at 03:49:05PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Through generic/300, I discovered that mkfs.xfs creates corrupt
> filesystems when given these parameters:
> 
> # mkfs.xfs -d size=512M /dev/sda -f -d su=128k,sw=4 --unsupported
> Filesystems formatted with --unsupported are not supported!!
> meta-data=/dev/sda               isize=512    agcount=8, agsize=16352 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=1        finobt=1, sparse=1, rmapbt=1
>          =                       reflink=1    bigtime=1 inobtcount=1 nrext64=1
> data     =                       bsize=4096   blocks=130816, imaxpct=25
>          =                       sunit=32     swidth=128 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=8192, version=2
>          =                       sectsz=512   sunit=32 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
>          =                       rgcount=0    rgsize=0 blks
> Discarding blocks...Done.
> # xfs_repair -n /dev/sda
> Phase 1 - find and verify superblock...
>         - reporting progress in intervals of 15 minutes
> Phase 2 - using internal log
>         - zero log...
>         - 16:30:50: zeroing log - 16320 of 16320 blocks done
>         - scan filesystem freespace and inode maps...
> agf_freeblks 25, counted 0 in ag 4
> sb_fdblocks 8823, counted 8798
> 
> The root cause of this problem is the numrecs handling in
> xfs_freesp_init_recs, which is used to initialize a new AG.  Prior to
> calling the function, we set up the new bnobt block with numrecs == 1
> and rely on _freesp_init_recs to format that new record.  If the last
> record created has a blockcount of zero, then it sets numrecs = 0.
> 
> That last bit isn't correct if the AG contains the log, the start of the
> log is not immediately after the initial blocks due to stripe alignment,
> and the end of the log is perfectly aligned with the end of the AG.  For
> this case, we actually formatted a single bnobt record to handle the
> free space before the start of the (stripe aligned) log, and incremented
> arec to try to format a second record.  That second record turned out to
> be unnecessary, so what we really want is to leave numrecs at 1.
> 
> The numrecs handling itself is overly complicated because a different
> function sets numrecs == 1.  Change the bnobt creation code to start
> with numrecs set to zero and only increment it after successfully
> formatting a free space extent into the btree block.
> 
> Fixes: f327a00745ff ("xfs: account for log space when formatting new AGs")
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/xfs/libxfs/xfs_ag.c |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 1b078bbbf225..4481ce8ead9d 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -499,6 +499,7 @@ xfs_freesp_init_recs(
>  			 */
>  			arec->ar_blockcount = cpu_to_be32(start -
>  						mp->m_ag_prealloc_blocks);
> +			be16_add_cpu(&block->bb_numrecs, 1);
>  			nrec = arec + 1;
>  
>  			/*
> @@ -509,7 +510,6 @@ xfs_freesp_init_recs(
>  					be32_to_cpu(arec->ar_startblock) +
>  					be32_to_cpu(arec->ar_blockcount));
>  			arec = nrec;
> -			be16_add_cpu(&block->bb_numrecs, 1);
>  		}
>  		/*
>  		 * Change record start to after the internal log
> @@ -525,8 +525,8 @@ xfs_freesp_init_recs(
>  	 */
>  	arec->ar_blockcount = cpu_to_be32(id->agsize -
>  					  be32_to_cpu(arec->ar_startblock));
> -	if (!arec->ar_blockcount)
> -		block->bb_numrecs = 0;
> +	if (arec->ar_blockcount)
> +		be16_add_cpu(&block->bb_numrecs, 1);

Ok, but I think the comment above this about resetting the count
back to zero needs to be updated as we aren't resetting anything
back to zero anymore.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
