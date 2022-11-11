Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48BCAC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Nov 2022 20:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234250AbiKKUw6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Nov 2022 15:52:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233220AbiKKUwz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Nov 2022 15:52:55 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763A58546E
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 12:52:54 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id i3so5823721pfc.11
        for <linux-xfs@vger.kernel.org>; Fri, 11 Nov 2022 12:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UkyEVG/RyW6vDupFCAQzcFg2FflfqHknNFxaJtgz67w=;
        b=Yd59e9EioIXpyf+8YfP7XRSK3GyjACyjg1sQ4M0uSux1sBaWcyFMk/THKf8HLagG0L
         DtYnknwJ4mEArbiJYqV4t8BrIX6BrtSwunXwJhtz7X00TWDdrLOcpxmg5rnSnv7PTSzn
         HXnLG7lxzM6XEY+riGUmRA+aysic4nrRKVz3pS10V/OguBdn31Mou4hPbftPUSHAW5ei
         TRoVXNfUPY7TUKOOGRHBLbv4nVT5C5p9Nfi3e4sMl6f3UxIIQESI49s3FFd8Yr4xdER1
         flxC2IHymuPTZk5G0/QXmBAnRgOOvpszmjuJek5W5F5YHuZSeX3zOt/NHs5YvIIU62Gj
         H84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UkyEVG/RyW6vDupFCAQzcFg2FflfqHknNFxaJtgz67w=;
        b=ytBzeD0Zw7n0eAOk0CKDCoJ0FTtBPL2wiwjLBSqEUliHwLkCPb17jsoTlPqQxbR6pJ
         esm2rHxazTU6IABjJorszjc4TJUAjhhviROiq0+OwMhjGFpzBvHGxEAc9btUAC+CqyAr
         oghvF7t7yKd36vz7cgVrV4NFFk8PyBY8J8PN2+hjF/X33s6gGTWgyw6P4aA4NGDznWkq
         hbGVioda8lVrc/9wbwWhi4CLH2ibUqyPVhwMuvlySspBDOcbUTISIkyX8CJIk4RI9HQm
         4j4Xd1FQVsD6iqzSuZuDOoL/8DlZ56eeePS7QIAOwlTiuYvJiezJymleeSaHD5iJdfaT
         iQ0A==
X-Gm-Message-State: ANoB5pk2DVzZQAIbGXtslm1Nn8cT0yAHpyQ8ON+SVzdPlhz5ckRaigrQ
        z++4vCgMkTrQPYYvrJ+SJ5bjFfqgpvoFFw==
X-Google-Smtp-Source: AA0mqf4eQz3FrHuebxD6Z93l4bU664ZgbeWFnU+torpI9O58AtCi1cU1TJK5ttxeakUcVeLBqkyjQw==
X-Received: by 2002:a65:5908:0:b0:470:1a0c:3930 with SMTP id f8-20020a655908000000b004701a0c3930mr3143311pgu.559.1668199973973;
        Fri, 11 Nov 2022 12:52:53 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id e11-20020a170902784b00b00186ffe62502sm2105605pln.254.2022.11.11.12.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Nov 2022 12:52:53 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1otb18-00D4FO-Kd; Sat, 12 Nov 2022 07:52:50 +1100
Date:   Sat, 12 Nov 2022 07:52:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Long Li <leo.lilong@huawei.com>
Cc:     djwong@kernel.org, houtao1@huawei.com, yi.zhang@huawei.com,
        guoxuenan@huawei.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix incorrect i_nlink caused by inode racing
Message-ID: <20221111205250.GO3600936@dread.disaster.area>
References: <20221107143648.GA2013250@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107143648.GA2013250@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 07, 2022 at 10:36:48PM +0800, Long Li wrote:
> The following error occurred during the fsstress test:
> 
> XFS: Assertion failed: VFS_I(ip)->i_nlink >= 2, file: fs/xfs/xfs_inode.c, line: 2925
> 
> The problem was that inode race condition causes incorrect i_nlink to be
> written to disk, and then it is read into memory. Consider the following
> call graph, inodes that are marked as both XFS_IFLUSHING and
> XFS_IRECLAIMABLE, i_nlink will be reset to 1 and then restored to original
> value in xfs_reinit_inode(). Therefore, the i_nlink of directory on disk
> may be set to 1.
> 
>   xfsaild
>       xfs_inode_item_push
>           xfs_iflush_cluster
>               xfs_iflush
>                   xfs_inode_to_disk
> 
>   xfs_iget
>       xfs_iget_cache_hit
>           xfs_iget_recycle
>               xfs_reinit_inode
>   	          inode_init_always
> 
> So skip inodes that being flushed and markded as XFS_IRECLAIMABLE, prevent
> concurrent read and write to inodes.

urk.

xfs_reinit_inode() needs to hold the ILOCK_EXCL as it is changing
internal inode state and can race with other RCU protected inode
lookups. Have a look at what xfs_iflush_cluster() does - it
grabs the ILOCK_SHARED while under rcu + ip->i_flags_lock, and so
xfs_iflush/xfs_inode_to_disk() are protected from racing inode
updates (during transactions) by that lock.

Hence it looks to me that I_FLUSHING isn't the problem here - it's
that we have a transient modified inode state in xfs_reinit_inode()
that is externally visisble...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
