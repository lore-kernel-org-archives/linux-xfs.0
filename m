Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:35874 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751268AbdGQHzQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jul 2017 03:55:16 -0400
Received: from localhost (localhost [IPv6:::1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by trent.utfs.org (Postfix) with ESMTPS id C033D5F960
        for <linux-xfs@vger.kernel.org>; Mon, 17 Jul 2017 09:47:16 +0200 (CEST)
Date: Mon, 17 Jul 2017 00:47:16 -0700 (PDT)
From: Christian Kujau <christian@nerdbynature.de>
Subject: Re: Metadata corruption detected at xfs_inode_buf_verify
In-Reply-To: <alpine.DEB.2.21.1.1707161018130.22141@trent.utfs.org>
Message-ID: <alpine.DEB.2.21.1.1707170035440.22141@trent.utfs.org>
References: <alpine.DEB.2.21.1.1707161018130.22141@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

On Sun, 16 Jul 2017, Christian Kujau wrote:
> so, the disk enclosure attached to my RaspberryPi[0] had "some" kind of 
> failure last night: one of the disks appears to have some kind of hardware 
> problem, the other is fine, but the XFS file system cannot be mounted. 
> Instead of using the RPI to try the repair, I attached the enclosure to an 
> Intel i7 machine (16 GB RAM) and attempted to mount:

After a late night chat on #xfs, it seems that the corruption may have 
happened due to a problem with the storage driver on this RPI and Dave
commented:

 | and I'm pretty sure that the USB mass storage interface/driver does not 
 | pass through cache flushes or support FUA operations.
 | which would explain why it appears that the inode cluster 
 | initialisation IO isn't on disk, and it wasn't replayed by log recovery
 | before inode updates were recovered....

(Put here so that it can be found in the archives, in case this happens to 
someone else)

So, that being said, the now corrupted XFS still cannot be repaired by 
xfs_repair (compiled from a git checkout two days ago). The full 
xfs_repair run can be found the in screenlog:

 http://nerdbynature.de/bits/4.12.0-rc7/screenlog_1.txt
 The xfs_logprint and xfs_metadump outputs can be provided at request.


Is this something xfs_repair should be able to fix or is the filesystem
just too mangled in this case?

Thanks,
Christian.
-- 
BOFH excuse #431:

Borg implants are failing
