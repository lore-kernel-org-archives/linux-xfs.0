Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jul 2007 11:12:02 -0700 (PDT)
Received: from ext.agami.com (64.221.212.177.ptr.us.xo.net [64.221.212.177])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6HIBubm016493
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 11:11:57 -0700
Received: from agami.com (mail [192.168.168.5])
	by ext.agami.com (8.12.5/8.12.5) with ESMTP id l6HIBV8q007260
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 11:11:35 -0700
Received: from mx1.agami.com (mx1.agami.com [10.123.10.30])
	by agami.com (8.12.11/8.12.11) with ESMTP id l6HIBshX028687
	for <xfs@oss.sgi.com>; Tue, 17 Jul 2007 11:11:54 -0700
Message-ID: <469D0666.6040908@agami.com>
Date: Tue, 17 Jul 2007 11:11:50 -0700
From: Michael Nishimoto <miken@agami.com>
MIME-Version: 1.0
Subject: Allocating inodes from a single block
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi everyone,

Filesystem free space becomes fragmented over time.  It's possible
for total free space to be a decent size and still not have a chunk
large enough to allocate new inodes.

During testing, we managed to create a 111G filesystem which
could no longer create new inodes, but it had 6% free space.

Has anyone thought about how to solve this issue?

Ideally, a solution would still allocate multiple contiguous blocks
of inodes when space is available but would eventually work when
only single free blocks are available.  And it would be good if
any change remains backwards compatible with existing ondisk
formats.

thanks,

  Michael
