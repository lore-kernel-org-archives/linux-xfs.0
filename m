Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 09:33:07 -0800 (PST)
Received: from service.eng.exegy.net (68-191-203-42.static.stls.mo.charter.com [68.191.203.42])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l08HX1qw028138
	for <linux-xfs@oss.sgi.com>; Mon, 8 Jan 2007 09:33:03 -0800
Message-ID: <45A27BC7.2020709@exegy.com>
Date: Mon, 08 Jan 2007 11:13:43 -0600
From: "Mr. Berkley Shands" <bshands@exegy.com>
MIME-Version: 1.0
Subject: XFS and 2.6.18 -> 2.6.20-rc3
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Dave Lloyd <dlloyd@exegy.com>, linux-xfs@oss.sgi.com

My testbench is a 4 core Opteron (dual 275's) into
two LSI8408E SAS controllers, into 16 Seagate 7200.10 320GB satas.
Redhat ES4.4 (Centos 4.4). A slightly newer parted is needed
than the contemporary of Moses that is shipped with the O/S.

I have a standard burn in script that takes the 4 4-drive raid0's
and puts a GPT label on them, aligns the partitions to stripe
boundary's. It then proceeds to write 8GB files concurrently
onto all 4 raid drives.

Under 2.6.18.1 the write speeds start at 265MB/Sec and decrease
mostly monotonically down to ~160MB/Sec, indicating that
the files start on the outside (fastest tracks) and work in.
All 4 raids are within 7-8MB/Sec of each other (usually they
are identical in speed).

By the time of 2.6.20-rc3, the same testbench shows
a 10% across the board decrease in throughput for writes.
Reads are unaffected.
But now the allocation order for virgin file systems are random,
usually starting at the slow 140MB/Sec, then bouncing up to 220MB/Sec,
then around and around. No two raids get the same write speeds at the 
same time.

Dave Lloyd (our in-house Idea Guy) looked at the allocation groups...
Non-sequential, random...

What data would you like to see?

The run logs from 2.6.18.1 and 2.6.20-rc3?
Want the scripts?
The xfs-debug dumps of a few files?

Berkley

-- 

//E. F. Berkley Shands, MSc//

**Exegy Inc.**

3668 S. Geyer Road, Suite 300

St. Louis, MO  63127

Direct:  (314) 450-5348

Cell:  (314) 303-2546

Office:  (314) 450-5353

Fax:  (314) 450-5354

 

This e-mail and any documents accompanying it may contain legally 
privileged and/or confidential information belonging to Exegy, Inc.  
Such information may be protected from disclosure by law.  The 
information is intended for use by only the addressee.  If you are not 
the intended recipient, you are hereby notified that any disclosure or 
use of the information is strictly prohibited.  If you have received 
this e-mail in error, please immediately contact the sender by e-mail or 
phone regarding instructions for return or destruction and do not use or 
disclose the content to others.

 



[[HTML alternate version deleted]]
