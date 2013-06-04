Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C3BB129DF8
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 14:24:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 53A78AC007
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 12:24:02 -0700 (PDT)
Received: from cobra.newdream.net (cobra.newdream.net [66.33.216.30]) by
	cuda.sgi.com with ESMTP id Yo0zPERIvcwjwoFX for
	<xfs@oss.sgi.com>; Tue, 04 Jun 2013 12:24:01 -0700 (PDT)
Received: from cobra.newdream.net (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id CA6F08004B
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 12:24:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by cobra.newdream.net (Postfix) with ESMTP id 9C8278004B
	for <xfs@oss.sgi.com>; Tue,  4 Jun 2013 12:24:00 -0700 (PDT)
Date: Tue, 4 Jun 2013 12:24:00 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
Subject: garbage block(s) after powercycle/reboot + sparse writes
Message-ID: <alpine.DEB.2.00.1306041210070.15156@cobra.newdream.net>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I'm observing an interesting data corruption pattern:

- write a bunch of files
- power cycle the box
- remount
- immediately (within 1-2 seconds) write create a file and
 - write to a lower offset, say offset 430423 len 527614
 - write to a higher offset, say offset 1360810 len 269613
 (there is other random io going to other files too)

- about 5 seconds later, read the whole file and verify content

And what I see:

- the first region is correct, and intact
- the bytes that follow, up until the block boundary, are 0
- the next few blocks are *not* zero! (i've observed 1 and 6 4k blocks)
- then lots of zeros, up until the second region, which appears intact.

I'm pretty reliably hitting this, and have reproduced it twice now and 
found the above consistent pattern (but different filenames, different 
offsets).  What I haven't yet confirmed is whether the file was written at 
all prior to the powercycle, since that tends to blow away the last 
bit of the ceph logs, too.  I'm adding some additional checks to see 
whether the file is in fact new when the first extent is written.

The other possibly interesting thing is the offsets.  The garbage regions 
I saw were

 0xea000 - 0xf0000
 0xff000 - 0x100000

Does this failure pattern look familiar to anyone? I'm pretty sure it is 
new in 3.9, which we switched over to right around the time when this 
started happening.  I'm confirming that as well, but just wanted to see if 
this is ringing any bells...

Thanks!
sage

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
