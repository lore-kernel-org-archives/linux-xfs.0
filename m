Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 16 Jan 2007 08:54:07 -0800 (PST)
Received: from waldorf.loreland.org (ip186.digipost.co.nz [203.110.30.186] (may be forged))
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l0GGrwqw027653
	for <xfs@oss.sgi.com>; Tue, 16 Jan 2007 08:54:00 -0800
Received: from localhost (localhost [127.0.0.1])
	by waldorf.loreland.org (Postfix) with ESMTP id CB4E2428A0D
	for <xfs@oss.sgi.com>; Wed, 17 Jan 2007 05:30:47 +1300 (NZDT)
Received: from waldorf.loreland.org ([127.0.0.1])
	by localhost (waldorf.loreland.org [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id PdAKPmv33ATG for <xfs@oss.sgi.com>;
	Wed, 17 Jan 2007 05:30:42 +1300 (NZDT)
Received: from colo.loreland.org (localhost [127.0.0.1])
	by waldorf.loreland.org (Postfix) with ESMTP id 207DE41AD46
	for <xfs@oss.sgi.com>; Wed, 17 Jan 2007 05:30:42 +1300 (NZDT)
Message-ID: <32920.193.203.83.22.1168965042.squirrel@colo.loreland.org>
Date: Wed, 17 Jan 2007 05:30:42 +1300 (NZDT)
Subject: problem with latest xfsprogs progress code
From: "James Braid" <jamesb@loreland.org>
Reply-To: jamesb@loreland.org
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Running 2.8.18 xfs_repair on a largeish (65TB, ~70M inodes) filesystem on
an x86_64 machine gives the following "progress" output:

12:15:36: process known inodes and inode discovery - 1461632 of 0 inod
es done
12:15:36: Phase 3: elapsed time 14 minutes, 32 seconds - processed 100
571 inodes per minute
12:15:36: Phase 3: 0% done - estimated remaining time 3364 weeks, 3 da
ys, 7 hours, 30 minutes, 45 seconds

Is this a known bug?

Thanks, James
