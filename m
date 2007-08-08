Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Aug 2007 18:39:06 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l781d1bm011025
	for <xfs@oss.sgi.com>; Tue, 7 Aug 2007 18:39:02 -0700
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id 7D7F61807DEFF
	for <xfs@oss.sgi.com>; Tue,  7 Aug 2007 20:39:05 -0500 (CDT)
Message-ID: <46B91EBA.10407@sandeen.net>
Date: Tue, 07 Aug 2007 20:39:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: qa 166 failure on f8 kernel
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-oss <xfs@oss.sgi.com>

Posting this just in case it rings any bells, though I plan to
investigate...

[root@inode xfstests]# ./check  166
FSTYP         -- xfs (non-debug)
PLATFORM      -- Linux/x86_64 inode 2.6.23-0.71.rc2.fc8
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb6
MOUNT_OPTIONS -- /dev/sdb6 /mnt/sdb6

166      - output mismatch (see 166.out.bad)
2,6c2,7
< 0: [0..31]: XX..YY AG (AA..BB) 32
< 1: [32..127]: XX..YY AG (AA..BB) 96 10000
< 2: [128..159]: XX..YY AG (AA..BB) 32
< 3: [160..223]: XX..YY AG (AA..BB) 64 10000
< 4: [224..255]: XX..YY AG (AA..BB) 32
---
> /mnt/sdb6/test_file:  XX..YY AG (AA..BB)
> 0: [0..7]: XX..YY AG (AA..BB) 8
> 1: [8..127]: XX..YY AG (AA..BB) 120 10000
> 2: [128..135]: XX..YY AG (AA..BB) 8
> 3: [136..247]: XX..YY AG (AA..BB) 112 10000
> 4: [248..255]: XX..YY AG (AA..BB) 8
Failures: 166
Failed 1 of 1 tests
[root@inode xfstests]# uname -a
Linux inode.lab.msp.redhat.com 2.6.23-0.71.rc2.fc8 #1 SMP Sat Aug 4
01:21:06 EDT 2007 x86_64 x86_64 x86_64 GNU/Linux

-Eric
