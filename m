Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 01:12:44 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4F8CffB011266
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 01:12:43 -0700
Received: from localhost (localhost [127.0.0.1])
	by lucidpixels.com (Postfix) with ESMTP id 1C06E50001A7
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 04:12:41 -0400 (EDT)
Date: Tue, 15 May 2007 04:12:40 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: xfs_db: segfault: error 4
Message-ID: <Pine.LNX.4.64.0705150411430.2471@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Kernel: 2.6.21.1

# xfs_db -V
xfs_db version 2.8.18

May 14 22:15:54 p34 kernel: [186121.414224] xfs_db[18999]: segfault at
00000000005b6ff8 rip 00002ac92ced40ce rsp 00007fff7e0a9a68 error 4

While running an xfs_db -c frag -f /dev/md3 (which runs nightly) this is 
the first time I have seen this problem.

Justin.
