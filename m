Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 090B3C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 15 Nov 2022 00:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232149AbiKOAXU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 19:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiKOAXT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 19:23:19 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F84615A3D
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 16:23:17 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id p21so11645975plr.7
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 16:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eYFJpx9kuyCY3eSY9nnA/YIoIy4aZu4JLftw8XfV/Ig=;
        b=US0siIuC0q858cjIwpdtd9H3TSJijBV7XVZlPjQkNIuiSkKuBJcoROq6exZXvCa87u
         GU9kkKxn+2x9Q+9hnH17YGYJ0rNMMrpmNVCxUfN8W4tBYLV0ycIgcF5VRfGyMdnk6u5P
         WkB9wamhLO3zu0vJDqv5HSc5ojSXfNITQ0XzHaG8z9Nn4NDmRd16Winj+fblJNu7KFgU
         RCjXUa/Qxqg2mGUVI3elEz/P7kg1QFIzDADNOA5tiURXegxHRTxElWDsSnUmhal6U7O1
         TT6c8fd7jcipA4ZIV4H1ypaInrbKiUFoVHRlUnss5OcDxdotf5BcMJlaayFV9Vhzos+H
         iMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eYFJpx9kuyCY3eSY9nnA/YIoIy4aZu4JLftw8XfV/Ig=;
        b=pLysavx8b7RFtXsf2m3OCnrSWFAWCL2chHKxqezXtWKheRl+ldSo/79r1x1lhTKKKA
         I6pjj+3usw0/csgBAaMnxJQbjE5QF81v3V2reflx/Fcp7tbBGBD09t9Vc/6V5zUCnnIE
         REdbQQlntEzr9gluxmPekCkDQ0VGQnZpSj2uCN1OWoEy/Q9fqBDFFI9BWCqwAeFgOJI3
         xWM/iOdJJjDQ3T0AIezBsdyTEHIMDhI6PTzxIpGAsJppi8VZ44r12Db8ar2hO5kg58Tb
         DHVYGjQE3WWVrZWu6c9J5gwbp6HIF4hoRKin7Q7CAN4WYBlcFXdVSh/7584+CZR5n6Bc
         vLRw==
X-Gm-Message-State: ANoB5pmaPFpFrm6AGXz+7kp91vPAKfhif0+cH5srG/fWb0dy7G9uKLd/
        HTKBurh4IvATsR0iCmsJ1xdkBw==
X-Google-Smtp-Source: AA0mqf4tpPJq/UwJa5NosZlZaUJBUpgxVNL32PGGq3ssI38RIRrFanDf/mV8OJn/9KtW0PkvncddHw==
X-Received: by 2002:a17:902:e413:b0:186:9cf4:e53b with SMTP id m19-20020a170902e41300b001869cf4e53bmr1621185ple.50.1668471797191;
        Mon, 14 Nov 2022 16:23:17 -0800 (PST)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id m2-20020a170902db0200b0016c50179b1esm8326782plx.152.2022.11.14.16.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 16:23:16 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1oujjN-00EIxF-OQ; Tue, 15 Nov 2022 11:23:13 +1100
Date:   Tue, 15 Nov 2022 11:23:13 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Long Li <leo.lilong@huawei.com>
Cc:     djwong@kernel.org, houtao1@huawei.com, yi.zhang@huawei.com,
        guoxuenan@huawei.com, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix incorrect i_nlink caused by inode racing
Message-ID: <20221115002313.GS3600936@dread.disaster.area>
References: <20221107143648.GA2013250@ceph-admin>
 <20221111205250.GO3600936@dread.disaster.area>
 <20221114133417.GA1723222@ceph-admin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114133417.GA1723222@ceph-admin>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 14, 2022 at 09:34:17PM +0800, Long Li wrote:
> On Sat, Nov 12, 2022 at 07:52:50AM +1100, Dave Chinner wrote:
> > On Mon, Nov 07, 2022 at 10:36:48PM +0800, Long Li wrote:
> > > The following error occurred during the fsstress test:
> > > 
> > > XFS: Assertion failed: VFS_I(ip)->i_nlink >= 2, file: fs/xfs/xfs_inode.c, line: 2925
> > > 
> > > The problem was that inode race condition causes incorrect i_nlink to be
> > > written to disk, and then it is read into memory. Consider the following
> > > call graph, inodes that are marked as both XFS_IFLUSHING and
> > > XFS_IRECLAIMABLE, i_nlink will be reset to 1 and then restored to original
> > > value in xfs_reinit_inode(). Therefore, the i_nlink of directory on disk
> > > may be set to 1.
> > > 
> > >   xfsaild
> > >       xfs_inode_item_push
> > >           xfs_iflush_cluster
> > >               xfs_iflush
> > >                   xfs_inode_to_disk
> > > 
> > >   xfs_iget
> > >       xfs_iget_cache_hit
> > >           xfs_iget_recycle
> > >               xfs_reinit_inode
> > >   	          inode_init_always
> > > 
> > > So skip inodes that being flushed and markded as XFS_IRECLAIMABLE, prevent
> > > concurrent read and write to inodes.
> > 
> > urk.
> > 
> > xfs_reinit_inode() needs to hold the ILOCK_EXCL as it is changing
> > internal inode state and can race with other RCU protected inode
> > lookups. Have a look at what xfs_iflush_cluster() does - it
> > grabs the ILOCK_SHARED while under rcu + ip->i_flags_lock, and so
> > xfs_iflush/xfs_inode_to_disk() are protected from racing inode
> > updates (during transactions) by that lock.
> > 
> > Hence it looks to me that I_FLUSHING isn't the problem here - it's
> > that we have a transient modified inode state in xfs_reinit_inode()
> > that is externally visisble...
> 
> Before xfs_reinit_inode(), XFS_IRECLAIM will be set in ip->i_flags, this 
> looks like can prevent race with other RCU protected inode lookups.  

That only protects against new lookups - it does not protect against the
IRECLAIM flag being set *after* the lookup in xfs_iflush_cluster()
whilst the inode is being flushed to the cluster buffer. That's why
xfs_iflush_cluster() does:

	rcu_read_lock()
	lookup inode
	spinlock(ip->i_flags_lock);
	check IRECLAIM|IFLUSHING
>>>>>>	xfs_ilock_nowait(ip, XFS_ILOCK_SHARED)     <<<<<<<<
	set IFLUSHING
	spin_unlock(ip->i_flags_lock)
	rcu_read_unlock()

At this point, the only lock that is held is XFS_ILOCK_SHARED, and
it's the only lock that protects the inode state outside the lookup
scope against concurrent changes.

Essentially, xfs_reinit_inode() needs to add a:

	xfs_ilock_nowait(ip, XFS_ILOCK_EXCL)

before it set IRECLAIM - if it fails to get the ILOCK_EXCL, then we
need to skip the inode, drop out of RCU scope, delay and retry the
lookup.

> Can it be considered that don't modifying the information about the on-disk
> values in the VFS inode in xfs_reinit_inode()? if so lock can be avoided.

We have to reinit the VFS inode because it has gone through
->destroy_inode and so the state has been trashed. We have to bring
it back as an I_NEW inode, which requires reinitialising everything.
THe issue is that we store inode state information (like nlink) in
the VFS inode instead of the XFS inode portion of the structure (to
minimise memory footprint), and that means xfs_reinit_inode() has a
transient state where the VFS inode is not correct. We can avoid
that simply by holding the XFS_ILOCK_EXCL, guaranteeing nothing in
XFS should be trying to read/modify the internal metadata state
while we are reinitialising the VFS inode portion of the
structure...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
