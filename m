Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Jun 2008 14:55:51 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5JLtm9k013101
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 14:55:49 -0700
Received: from realtouchweb.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8768BCFFF4A
	for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 14:56:46 -0700 (PDT)
Received: from realtouchweb.com (realtouchweb.com [161.58.239.72]) by cuda.sgi.com with ESMTP id 9lNIFwpWisD0bcMa for <xfs@oss.sgi.com>; Thu, 19 Jun 2008 14:56:46 -0700 (PDT)
Message-ID: <485AD667.1060402@qwest.net>
Date: Thu, 19 Jun 2008 15:57:59 -0600
From: Ash <ashovi@qwest.net>
MIME-Version: 1.0
Subject: xfs_repair taking a long time
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I am having the same problem as the person in this thread:


Which is xfs_repair has been running for 16 hours on a 1 TB raid array. 
It gave the same errors as this thread, saying that it could not use any 
of the super blocks it found. The last email in the thread says:

-----------------------------------------

xfs-repair did find candidate secondary superblocks - it discarded them
for some reason or another. If they were ok, all repair would have done
is copied them to block zero and then continued.

I'm suggesting that you manually do this step, and then see if repair
will run.

 >    Before wrapping this up, if you could just clarify a couple 
things.  If I
 >    look at the bytes at the beginning of each physical part of the LVM's,
 >    what am I looking for?  "XFSB"?

yes.

 >    If I do find that byte string, why
 >    couldn't xfs_repair find it when it did the scan and what do I do 
with it
 >    if I do find one?

As I said above, xfs-repair did find some, but rejected them for some
(unknown) reason. if you find one, copy it over block zero of the partition,
and see if repair will run. Like I said, though, you'll probably want to
back up th partition first, or at least run repair in no-modify mode.

--------------------------------------

The poster, Dave Chinner, says to manually copy the superblock to the 
right place, but not how to do it. I am familiar with dd, but would like 
to know the exact command or steps to take to replace the primary 
superblock manually with a secondary superblock.

Ashley

(I sent this earlier but I haven't seen it come over the list yet, so 
I'll send it again. Please forgive the duplicate.)
