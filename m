Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1612C4167D
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 22:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232790AbjKFWUq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 17:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbjKFWUp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 17:20:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14849D57
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 14:20:43 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8EB1C433C7;
        Mon,  6 Nov 2023 22:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699309242;
        bh=cQia/vqy1nlP7AcsvILRt45FKAlRqUIhrEj+o8lxriA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DcyZAVBZxwim/EOh9YaQFBF4K1XmeZ1NA0oTVg+NX6UIVJn2lVLXZ4L9Lc+mQcoSp
         GXiby1DUA6M2TKQbJvAcNd/37tghnbH0yV0ZW2eh95YfFonO2ew0m2xbIUJ2NRLG2t
         usWx7u8ic9HcFtANNmxhbW0kvMC7PdPmsvyKLIpehJtKvKgvponUiErBcp5PenHYWe
         TL0hgBvuuStx5rth7396wuOsN2W2cLhWj/nwPCXlATffeS5o83TCTxabVvz2KArB+l
         yBpf1JQFJNppYXI6VnCTyKAy6X+/PSzMdugfZzToI5Z8Y/igIKDnNmlQHcqUhuSVNJ
         uL0ZkG/3yYiaQ==
Date:   Mon, 6 Nov 2023 14:20:42 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     Zorro Lang <zlang@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <20231106222042.GE1758611@frogsfrogsfrogs>
References: <20231029041122.bx2k7wwm7otebjd5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUiECgUWZ/8HKi3k@dread.disaster.area>
 <20231106192627.ilvijcbpmp3l3wcz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUlNroz8l5h1s1oF@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZUlNroz8l5h1s1oF@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

n Tue, Nov 07, 2023 at 07:33:50AM +1100, Dave Chinner wrote:
> On Tue, Nov 07, 2023 at 03:26:27AM +0800, Zorro Lang wrote:
> > On Mon, Nov 06, 2023 at 05:13:30PM +1100, Dave Chinner wrote:
> > > On Sun, Oct 29, 2023 at 12:11:22PM +0800, Zorro Lang wrote:
> > > > Hi xfs list,
> > > > 
> > > > Recently I always hit xfs corruption by running fstests generic/047 [1], and
> > > > it show more failures in dmesg[2], e.g:
> > > 
> > > OK, g/047 is an fsync test.
> > > 
> > > > 
> > > >   XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
> > > 
> > > Ok, a directory block index translated to a hole in the file
> > > mapping. That's bad...
> ....
> > > > _check_xfs_filesystem: filesystem on /dev/loop1 is inconsistent (r)
> > > > *** xfs_repair -n output ***
> > > > Phase 1 - find and verify superblock...
> > > > Phase 2 - using internal log
> > > >         - zero log...
> > > >         - scan filesystem freespace and inode maps...
> > > >         - found root inode chunk
> > > > Phase 3 - for each AG...
> > > >         - scan (but don't clear) agi unlinked lists...
> > > >         - process known inodes and perform inode discovery...
> > > >         - agno = 0
> > > > bad nblocks 9 for inode 128, would reset to 0
> > > > no . entry for directory 128
> > > > no .. entry for root directory 128
> > > > problem with directory contents in inode 128
> > > > would clear root inode 128
> > > > bad nblocks 8 for inode 131, would reset to 0
> > > > bad nblocks 8 for inode 132, would reset to 0
> > > > bad nblocks 8 for inode 133, would reset to 0
> > > > ...
> > > > bad nblocks 8 for inode 62438, would reset to 0
> > > > bad nblocks 8 for inode 62439, would reset to 0
> > > > bad nblocks 8 for inode 62440, would reset to 0
> > > > bad nblocks 8 for inode 62441, would reset to 0
> > > 
> > > Yet all the files - including the data files that were fsync'd - are
> > > all bad.
> > > 
> > > Aparently the journal has been recovered, but lots of metadata
> > > updates that should have been in the journal are missing after
> > > recovery has completed? That doesn't make a whole lot of sense -
> > > when did these tests start failing? Can you run a bisect?
> > 
> > Hi Dave,
> > 
> > Thanks for your reply :) I tried to do a kernel bisect long time, but
> > find nothing ... Then suddently, I found it's failed from a xfsprogs
> > change [1].
> > 
> > Although that's not the root cause of this bug (on s390x), it just
> > enabled "nrext64" by default, which I never tested on s390x before.
> > For now, we know this's an issue about this feature, and only on
> > s390x for now.
> 
> That's not good. Can you please determine if this is a zero-day bug
> with the nrext64 feature? I think it was merged in 5.19, so if you
> could try to reproduce it on a 5.18 and 5.19 kernels first, that
> would be handy.
> 
> Also, from your s390 kernel build, can you get the pahole output
> for the struct xfs_dinode both for a good kernel and a bad kernel?

And could you get the pahole output of xfs_log_dinode as well?  I'm
assuming that these problems only come up after *log recovery* and that
generic/476 is fine.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
