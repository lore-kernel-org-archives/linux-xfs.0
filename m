Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from trent.utfs.org ([94.185.90.103]:56302 "EHLO trent.utfs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751371AbdGQSoo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 17 Jul 2017 14:44:44 -0400
Date: Mon, 17 Jul 2017 11:44:42 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
Subject: Re: Metadata corruption detected at xfs_inode_buf_verify
In-Reply-To: <20170717174851.GB57771@bfoster.bfoster>
Message-ID: <alpine.DEB.2.21.1.1707171133280.22141@trent.utfs.org>
References: <alpine.DEB.2.21.1.1707161018130.22141@trent.utfs.org> <alpine.DEB.2.21.1.1707170035440.22141@trent.utfs.org> <20170717174851.GB57771@bfoster.bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, 17 Jul 2017, Brian Foster wrote:
> Hard to say for sure. I do wonder whether this is related to any of the
> issues that Emmanuel ran into in his recent post[1]. Care to post the
> metadump somewhere where it can be downloaded? Note that it usually can
> be compressed to save upload/download time.

OK, so I tried again and this time with the stock version of xfsprogs from 
Debian/stretch (v4.9.0) and it was able to repair the file system:

  http://nerdbynature.de/bits/4.12.0-rc7/screenlog_seagate.txt

When I moved the disk enclosure from my aarch64 RPI system (running 
current Arch Linux) to my x86-64 Debian/stretch box, I used the self 
compiled git checkout of xfsprogs, because the Debian version is always 
somewhat behind, of course.

> [1] http://www.spinics.net/lists/linux-xfs/msg08176.html

Well, in my case it succeeded to move some data to lost+found, as the file 
system did have enough space free.


In other news, the other disk I suspected as "bad" before isn't bad at 
all, turns out that one of the controller ports in this disk enclosure 
("ElitePro Dual USB") may be have a problem, but on the working port both 
disks can be read from start to finish and xfs_repair v4.9.0 was able to 
repair both file systems now :-)

Thanks for your input,
Christian.

PS: I'll send you the link to the metadump off-list, because:
 | xfs_metadump: Filesystem log is dirty; image will contain unobfuscated metadata in log.
-- 
BOFH excuse #29:

It works the way the Wang did, what's the problem
