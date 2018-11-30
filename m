Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from smtp-out003.kontent.com ([81.88.40.217]:57829 "EHLO
        smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725817AbeLAFqp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 1 Dec 2018 00:46:45 -0500
Received: from rakete.bodenbinder.de (p5B29C1A9.dip0.t-ipconnect.de [91.41.193.169])
        (Authenticated sender: bodenbinder_de@smtp-out003.kontent.com)
        by smtp-out003.kontent.com (Postfix) with ESMTPA id 5F4A34000AA0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Nov 2018 19:36:33 +0100 (CET)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        by rakete.bodenbinder.de (Postfix) with ESMTP id 151324E14353
        for <linux-xfs@vger.kernel.org>; Fri, 30 Nov 2018 19:36:33 +0100 (CET)
From: Matthias Bodenbinder <matthias@bodenbinder.de>
Subject: inconsistent behaviour of xfs_db, xfs_repair and xfs_scrub
Message-ID: <d99f9b18-4fe6-a047-1484-2ff81683b597@bodenbinder.de>
Date: Fri, 30 Nov 2018 19:36:33 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: 8BIT
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Hi,

I am using xfs on Manjaro with kernel 4.19 and latest xfsprogs 4.19.0-1.

I checked my root filesystem with xfs_db for fragmentation and got metadata corruption messages:

5# xfs_db -c frag -r /dev/sde1
Metadata corruption detected at 0x558ed74133f3, xfs_inode block 0x7faac0/0x8000
Metadata corruption detected at 0x558ed74133f3, xfs_inode block 0x20cb300/0x8000
Metadata corruption detected at 0x558ed74133f3, xfs_inode block 0x2341340/0x8000
aktuell 976616, ideal 970547, Unterteilungsfaktor 0,62%
Note, this number is largely meaningless.
Files on this filesystem average 1,01 extents per file

But xfs_repiar is not mentioning anything and hence not repairing anything. Also, xfs_scrub is not complaining:

8# xfs_scrub -v /    
EXPERIMENTAL xfs_scrub program in use! Use at your own risk!
Phase 1: Find filesystem geometry.
/: using 8 threads to scrub.
Phase 2: Check internal metadata.
Phase 3: Scan all inodes.
Phase 5: Check directory tree.
Phase 7: Check summary counters.
41,6GiB data used;  1,3M inodes used.
41,5GiB data found; 1,3M inodes found.
1,3M inodes counted; 1,3M inodes checked.


How do I have to interpret these results? 
What can I do to get repair it?

I created an xfs dump just in case somebody wants to debug this.

Thank you for your help
Matthias
