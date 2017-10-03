Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:33531 "EHLO
        mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752137AbdJCNTU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Oct 2017 09:19:20 -0400
From: Martin Steigerwald <martin@lichtvoll.de>
Subject: Something like ZFS Channel Programs for BTRFS & probably XFS or even VFS?
Date: Tue, 03 Oct 2017 15:19:18 +0200
Message-ID: <1799362.XC3pUdehxN@merkaba>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-btrfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org

[repost. I didn´t notice autocompletion gave me wrong address for fsdevel, 
blacklisted now]

Hello.

What do you think of

http://open-zfs.org/wiki/Projects/ZFS_Channel_Programs

?

There are quite some BTRFS maintenance programs like the deduplication stuff. 
Also regular scrubs… and in certain circumstances probably balances can make 
sense.

In addition to this XFS got scrub functionality as well.

Now putting the foundation for such a functionality in the kernel I think 
would only be reasonable if it cannot be done purely within user space, so I 
wonder about the safety from other concurrent ZFS modification and atomicity 
that are mentioned on the wiki page. The second set of slides, those the 
OpenZFS Developer Commit 2014, which are linked to on the wiki page explain 
this more. (I didn´t look the first ones, as I am no fan of slideshare.net and 
prefer a simple PDF to download and view locally anytime, not for privacy 
reasons alone, but also to avoid a using a crappy webpage over a wonderfully 
functional PDF viewer fat client like Okular)

Also I wonder about putting a lua interpreter into the kernel, but it seems at 
least NetBSD developers added one to their kernel with version 7.0¹.

I also ask this cause I wondered about a kind of fsmaintd or volmaintd for 
quite a while, and thought… it would be nice to do this in a generic way, as 
BTRFS is not the only filesystem which supports maintenance operations. However 
if it can all just nicely be done in userspace, I am all for it.

[1] http://www.netbsd.org/releases/formal-7/NetBSD-7.0.html
(tons of presentation PDFs on their site as well)

Thanks,
-- 
Martin

