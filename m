Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jul 2007 13:11:55 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6AKBpbm030758
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 13:11:52 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AJ89LF022910
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 15:08:09 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AKBpES544744
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 16:11:51 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AKBpPl028498
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 16:11:51 -0400
Date: Wed, 11 Jul 2007 01:42:00 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 0/7][TAKE6] fallocate system call
Message-ID: <20070710201200.GA10255@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: xfs@oss.sgi.com

This is the latest fallocate patchset and is rebased to 2.6.22.

Following are the changes from TAKE5:
1) Rebased to 2.6.22
2) Added compat wrapper for x86_64
3) Dropped s390 and ia64 patches, since the platform maintaners can
   add the support for fallocate once it is in mainline.
4) Added a change suggested by Andreas for better extent-to-group
   alignment in ext4 (Patch 6/6). Please refer following post:
5) Renamed mode flags and values from "FA_" to "FALLOC_"
6) Added manpage (updated version of the one initially submitted by
   David Chinner).


Todos:
-----
1> Implementation on other architectures (other than i386, x86_64,
   and ppc64). s390(x) and ia64 patches are ready and will be pushed
   by platform maintaners when the fallocate is in mainline.
2> A generic file system operation to handle fallocate
   (generic_fallocate), for filesystems that do _not_ have the fallocate
   inode operation implemented.
3> Changes to glibc,
   a) to support fallocate() system call
   b) to make posix_fallocate() and posix_fallocate64() call fallocate()
4> A testcase to test the system call. Will post it soon.


Following patches follow:
Patch 1/7 : manpage for fallocate
Patch 2/7 : fallocate() implementation in i386, x86_64 and powerpc
Patch 3/7 : support new modes in fallocate
Patch 4/7 : ext4: fallocate support in ext4
Patch 5/7 : ext4: write support for preallocated blocks
Patch 6/7 : ext4: support new modes in ext4
Patch 7/7 : ext4: change for better extent-to-group alignment


--
Regards,
Amit Arora
