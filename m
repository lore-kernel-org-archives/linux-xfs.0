Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Sep 2006 07:25:48 -0700 (PDT)
Received: from garda.mci.edu (intern.mci4me.at [193.171.232.20])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k8IEPbZd006725
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 07:25:38 -0700
Received: from localhost (localhost.localdomain [127.0.0.1])
	by garda.mci.edu (Postfix) with ESMTP id 7C4501046D1
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 15:32:30 +0200 (CEST)
Received: from garda.mci.edu ([127.0.0.1])
	by localhost (rekim [127.0.0.1]) (amavisd-new, port 10024) with ESMTP
	id 26513-07 for <xfs@oss.sgi.com>;
	Mon, 18 Sep 2006 13:32:21 +0000 (UTC)
Received: from crados (pc61vw.mci.edu [193.171.235.61])
	by garda.mci.edu (Postfix) with ESMTP id A91FB10465A
	for <xfs@oss.sgi.com>; Mon, 18 Sep 2006 15:32:21 +0200 (CEST)
From: christian gattermair <christian.gattermair@mci.edu>
Subject: xfs_check - out of memory | xfs_repair - superblock error reading
Date: Mon, 18 Sep 2006 15:19:18 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200609181519.18448.christian.gattermair@mci.edu>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

hi!

after a reboot of our box (debian sarge, 3ware controller, raid 5 - 3tb xfs) 
we can not mount it any more.

from syslog:

Sep 18 12:51:36 localhost kernel: SGI XFS with ACLs, security attributes, 
realtime, large block numbers, no debug enabled
Sep 18 12:51:36 localhost kernel: SGI XFS Quota Management subsystem
Sep 18 12:51:53 localhost kernel: attempt to access beyond end of device
Sep 18 12:51:53 localhost kernel: sdb1: rw=0, want=6445069056, 
limit=2150101796
Sep 18 12:51:53 localhost kernel: I/O error in filesystem ("sdb1") meta-data 
dev sdb1 block 0x18027f2ff       ("xfs_read_buf") error 5 buf count 512
Sep 18 12:51:53 localhost kernel: XFS: size check 2 failed

xfs_check fails with:

xfs_check /dev/sdb1
XFS: totally zeroed log
xfs_check: out of memory

there is a lot of space (i tryed more swap)

Mem:          1011       1006          5          0        750        111
-/+ buffers/cache:        144        867
Swap:        57812          0      57812

does xfs_check only looks at the mem or also an swap??? is there any hint to 
use the swap?

second question:

xfs_repair works but can not find any superblock. any hints?

xfs_repair /dev/sdb1
Phase 1 - find and verify superblock...
error reading superblock 11 -- seek to offset 1134332153856 failed
couldn't verify primary superblock - bad magic number !!!

attempting to find secondary superblock...
...
...
..............found candidate secondary superblock...
error reading superblock 11 -- seek to offset 1134332153856 failed
unable to verify superblock, continuing...


the whole system runs one year without any errors. only today one shutdown for 
chaning the usv ....

thanks for any hint!

with friendly greetings,

christian gattermair
