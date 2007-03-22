Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 22 Mar 2007 09:41:34 -0700 (PDT)
Received: from service.eng.exegy.net (68-191-203-42.static.stls.mo.charter.com [68.191.203.42])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l2MGfO6p004798
	for <linux-xfs@oss.sgi.com>; Thu, 22 Mar 2007 09:41:26 -0700
Message-ID: <4602A836.2010004@exegy.com>
Date: Thu, 22 Mar 2007 11:00:54 -0500
From: "Mr. Berkley Shands" <bshands@exegy.com>
MIME-Version: 1.0
Subject: 2.6.20, XFS, mptsas and LSI-8888ELP write lockup
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: linux-xfs@oss.sgi.com, linux-scsi@vger.kernel.org, Dave Lloyd <dlloyd@exegy.com>

I have a uniwide 3346, 20GB 8-core Opteron (2.2GHz)
With one LSI-8888ELP PCI-e SAS controller.
Each of the two external mini-sas 4-lane connectors goes to
an Xtore XJ-SAxx-316J-2 (16 drive 3U with dual SAS ports).
Running both Centos 4.4 or RedHat-5 Server with kernel 2.6.20.

The raids are all 4 drive raid0, 128KB stripes, using Seagate 7200.10
320GB drives (all firmware AAJ or later) Sata-II drives.
XFS filesystem, properly aligned, mkfs'ed etc.

If I write to all 4 VDs on one Xtore at a time, I get ~550MB/Sec
combined write rate. If I try writing to 7 of the 8 VDs at one time,
I get just under 800MB/Sec. Any 7 of 8 VDs.
But If I try to write to ALL 8 at once, the system crawls to a stop,
and I get Micro-Bytes per second.

xfs_datad/<N> process runs every few seconds, then pdflush runs
two or three at a time every few seconds. But iostat reports 0 writes.
every 10 seconds or so (iostat 5) reports a burst of write activity,
and then 10 seconds of nothing.

If I use  the Adaptec 4805 (two of them), I get about
the same write rate, but it does not hang (AACRAID driver).
same type of file systems, same external enclosures.

I had a "echo 10 > /proc/sys/vm/dirty_ratio" fix in to correct slow
writes (vs 2.6.18), but altering this value changed nothing. It still
runs oh-so-slow.

What to look at next? 2.6.21-rc4 ?

berkley

-- 

//E. F. Berkley Shands, MSc//

**Exegy Inc.**

3668 S. Geyer Road, Suite 300

St. Louis, MO  63127

Direct:  (314) 450-5348

Cell:  (314) 303-2546

Office:  (314) 450-5353

Fax:  (314) 450-5354

 

The Usual Disclaimer follows...
This e-mail and any documents accompanying it may contain legally privileged and/or confidential information belonging to Exegy, Inc. Such information may be protected from disclosure by law. The information is intended for use by only the addressee. If you are not the intended recipient, you are hereby notified that any disclosure or use of the information is strictly prohibited. If you have received this e-mail in error, please immediately contact the sender by e-mail or phone regarding instructions for return or destruction and do not use or disclose the content to others.


[[HTML alternate version deleted]]
