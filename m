Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 12:25:08 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5JJP1bl027509
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 12:25:01 -0700
Received: from graphics.sendsations.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1718ECFF398
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 12:25:59 -0700 (PDT)
Received: from graphics.sendsations.com (graphics.sendsations.com [70.97.166.26]) by cuda.sgi.com with ESMTP id kX7OGJGkIMY1jsDv for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 12:25:59 -0700 (PDT)
Received: from [127.0.0.1] ([10.0.0.229])
	by graphics.sendsations.com (8.13.7/8.13.4) with ESMTP id m5JJPvHR011233
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 13:25:58 -0600
Message-ID: <485AB312.4040608@gmail.com>
Date: Thu, 19 Jun 2008 13:27:14 -0600
From: Ashley Oviatt <ashovi@gmail.com>
MIME-Version: 1.0
Subject: xfs_repair
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I am having the same problem as the person in this thread (Which problem 
is xfs_repair has been running for 16 hours on a 1 TB raid array):

http://www.linux.sgi.com/archives/xfs/2007-03/msg00061.html

It gave the same errors as this thread, saying that it could not use any 
of the super blocks it found. The last email in the thread says:

-----------------------------------------

xfs-repair did find candidate secondary superblocks - it discarded them
for some reason or another. If they were ok, all repair would have done
is copied them to block zero and then continued.

I'm suggesting that you manually do this step, and then see if repair
will run.

>/    Before wrapping this up, if you could just clarify a couple things.  If I/
>/    look at the bytes at the beginning of each physical part of the LVM's,/
>/    what am I looking for?  "XFSB"?/

yes.

>/    If I do find that byte string, why/
>/    couldn't xfs_repair find it when it did the scan and what do I do with it/
>/    if I do find one?/

As I said above, xfs-repair did find some, but rejected them for some
(unknown) reason. if you find one, copy it over block zero of the partition,
and see if repair will run. Like I said, though, you'll probably want to
back up th partition first, or at least run repair in no-modify mode.

--------------------------------------

The poster, Dave Chinner, says to manually copy the superblock to the 
right place, but not how to do it. I am familiar with dd, but would like 
to know the exact command or steps to take to replace the primary 
superblock manually with a secondary superblock.

I am using slackware linux 10 with an intel raid card.

Ashley


[[HTML alternate version deleted]]
