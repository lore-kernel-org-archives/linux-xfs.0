Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:60714 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751030AbeETShB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 20 May 2018 14:37:01 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id E26E24201B1F
        for <linux-xfs@vger.kernel.org>; Sun, 20 May 2018 18:37:00 +0000 (UTC)
Received: from localhost (hp-dl360g9-06.rhts.eng.pek2.redhat.com [10.73.4.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4FFDF63A49
        for <linux-xfs@vger.kernel.org>; Sun, 20 May 2018 18:37:00 +0000 (UTC)
Date: Mon, 21 May 2018 02:36:58 +0800
From: Zorro Lang <zlang@redhat.com>
Subject: [xfstests xfs/170]: filestreams test fail, multi-file data stream
 doesn't write into seperate AGs
Message-ID: <20180520183658.GH4893@hp-dl360g9-06.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

I hit a strange failure[3] when run xfs/170 on latest upstream kernel 4.17-rc5
and latest xfsprogs. The strange thing is this failure only can be reproduced
when rmapbt=1 and reflink=1. If either of them is 0, can't reproduce this
failure.

Another thing is I can't reproduce this failure on a device which sunit is not 0.

Is this bug? Or case issue? The xfs/170 expect Multi-file data streams should
always write into seperate AGs, can it still be sure 100% now?

Thanks,
Zorro

# mkfs.xfs -f -m rmapbt=1,reflink=1 -i sparse=1 /dev/mapper/fedora_ibm--x3650m4--10-xfstest
meta-data=/dev/mapper/fedora_ibm--x3650m4--10-xfstest isize=512    agcount=4, agsize=1310720 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1, reflink=1
data     =                       bsize=4096   blocks=5242880, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
log      =internal log           bsize=4096   blocks=3693, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

[1]
# cat local.config
export TEST_DEV=/dev/mapper/fedora_ibm--x3650m4--10-xfstest
export TEST_DIR=/mnt/test
export SCRATCH_DEV=/dev/mapper/fedora_ibm--x3650m4--10-xfscratch
export SCRATCH_MNT=/mnt/scratch
export MKFS_OPTIONS="-m rmapbt=1,reflink=1 -i sparse=1"

[2]
# cat /home/git/xfstests-dev/results//xfs/170.full 
stream 1 AGs: 0 0 0 0 0 4 5 5
stream 2 AGs: 1 1 1 1 1 5 5 5
duplicate AG 5 found
stream 3 AGs: 2 2 2 2 2 6 6 6
stream 4 AGs: 3 3 3 3 3 7 7 7
- failed, 1 streams with matching AGs

[3]
# cat /home/git/xfstests-dev/results//xfs/170.out.bad         
QA output created by 170
# testing 8 16 4 8 3 0 0 ....
# streaming
# sync AGs...
# checking stream AGs...
- failed, 1 streams with matching AGs
(see /home/git/xfstests-dev/results//xfs/170.full for details)
