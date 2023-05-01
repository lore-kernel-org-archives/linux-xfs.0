Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F089DC77B73
	for <linux-xfs@archiver.kernel.org>; Mon,  1 May 2023 23:05:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231741AbjEAXFt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 May 2023 19:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjEAXFt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 May 2023 19:05:49 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFF72D63
        for <linux-xfs@vger.kernel.org>; Mon,  1 May 2023 16:05:47 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-64115e652eeso30462417b3a.0
        for <linux-xfs@vger.kernel.org>; Mon, 01 May 2023 16:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1682982347; x=1685574347;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kzUgwE1HaZ7BmlY1VEzFG8LzRCyMZljl73soTqQ4/TE=;
        b=1Rd5VodTEMxhbv3SnFBvXEopNFLd80QInA9ZXpllLezHJr3aWksUNL6St3fV+5Pnn3
         7Pi6y97ymxlbYbrSED4VFExX9jqewVT+4Ku89Ef/brbWbKkbiUGU+sI3s0aQTOGpZCCh
         lQ42PSVk+7Tg3frXrXMUzuZbQc4sKW6O1CqPrQCqLC1/l/qoxjRRYcHrUcjblcmHPQVX
         ccz6rdOT8uZsTynqhFiFk4Er6aVGP2FJjOf+ZLwKa86mAiwTNBXlgxDx4i4VbPFHN2KK
         uxWFZNJ0xOIrbZgFG5Td5uge78xYQ1Ma6yoaWz0zG5H5Y+19UHQgJkFJnsXFM4q0aIrB
         /DNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682982347; x=1685574347;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kzUgwE1HaZ7BmlY1VEzFG8LzRCyMZljl73soTqQ4/TE=;
        b=OLTgn4pAeeYQ3tId5Ctv1yjP+hf3eA8y9apv1D/jfYyv5PnseQQj1jYo54Qtzco0WR
         O6vO5b9H1bnvlftsh7+Ig022f6MomBKhfRLfBvl1z/L2pk9reqFx1r8CSEtMS8eFIgca
         /hob3Ka841klDwI7CITsxBG1tr1GYZKFdufMmd2f4x9/HxaIK7b2q5H9/pazVeLdM3vE
         V4ZNjlGytAN3r5otxNu6bKhpUdh5H4c2c060amx5dl4ogMWtp9v8CtWuqB2cqrJ5WRRu
         RiFgk+7BtWR7r2S15epFAQQVWrBmQPPWLEZmakuOTArlkv7rYNhQna9hUBH4ycCHV+JP
         uX9Q==
X-Gm-Message-State: AC+VfDxuqb76ycx8/D+ir/7YWEMzNlKsId3IsRylSsDwTCQFCe+4i1Ki
        S0DweCWcs5+8CP4fXuj745CTKq8vZgHjc4fZfmE=
X-Google-Smtp-Source: ACHHUZ4ISFcozKDZkrzOYCiGRaiE9n6IFQjz0RXDsHBgBGssvPpKYjr2YLB5yR3yA3wbkEz4SOcn9g==
X-Received: by 2002:a05:6a20:3c93:b0:f8:73b4:32c2 with SMTP id b19-20020a056a203c9300b000f873b432c2mr18790651pzj.7.1682982346833;
        Mon, 01 May 2023 16:05:46 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-88-204.pa.nsw.optusnet.com.au. [49.181.88.204])
        by smtp.gmail.com with ESMTPSA id n11-20020a056a00212b00b0063f167b41bdsm18875319pfj.38.2023.05.01.16.05.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 May 2023 16:05:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ptcaU-00AEYT-BS; Tue, 02 May 2023 09:05:42 +1000
Date:   Tue, 2 May 2023 09:05:42 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/4] xfs: set bnobt/cntbt numrecs correctly when
 formatting new AGs
Message-ID: <20230501230542.GX3223426@dread.disaster.area>
References: <168296561299.290030.5324305660599413777.stgit@frogsfrogsfrogs>
 <168296562443.290030.11898351600272300988.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168296562443.290030.11898351600272300988.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, May 01, 2023 at 11:27:04AM -0700, Darrick J. Wong wrote:
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
>  fs/xfs/libxfs/xfs_ag.c |   19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)

Looks fine.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
-- 
Dave Chinner
david@fromorbit.com
