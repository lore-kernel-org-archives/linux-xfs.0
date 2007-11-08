Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 08 Nov 2007 03:27:16 -0800 (PST)
Received: from waldorf.loreland.org (uk.loreland.org [89.16.172.112])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lA8BR7Ub026046
	for <xfs@oss.sgi.com>; Thu, 8 Nov 2007 03:27:12 -0800
Subject: =?UTF-8?Q?xfs=5Frepair=20=32=2E=39=2E=34=20threading/progress=20info=20mi?=
 =?UTF-8?Q?ssing=3F?=
MIME-Version: 1.0
Date: Thu, 8 Nov 2007 11:27:09 +0000
From: James Braid <jamesb@loreland.org>
Message-ID: <c7e221f6ec9555fa9789a67e7307f904@loreland.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com


I just upgraded to xfsprogs 2.9.4 and it seems the multi-threading and
progress information is no longer being reported?

2.8.18:
        - creating 8 worker thread(s)
Phase 1 - find and verify superblock...
        - reporting progress in intervals of 15 minutes
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...

2.9.4:
Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - zero log...
        - scan filesystem freespace and inode maps...
        - found root inode chunk

Have I just mis-compiled something? The progress information in particular
was REALLY useful on our bigger filesystems.
