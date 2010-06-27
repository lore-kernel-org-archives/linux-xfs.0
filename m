Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5R18IHh215663 for <xfs@oss.sgi.com>; Sat, 26 Jun 2010 20:08:19 -0500
Received: from Ishtar.sc.tlinx.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C93321555A0A
	for <xfs@oss.sgi.com>; Sat, 26 Jun 2010 18:11:00 -0700 (PDT)
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id AnEEQGjVIQxCAxHh for
	<xfs@oss.sgi.com>; Sat, 26 Jun 2010 18:11:00 -0700 (PDT)
Received: from [192.168.3.12] (Athenae [192.168.3.12])
	by Ishtar.sc.tlinx.org (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5R1AtIB027369 for <xfs@oss.sgi.com>; Sat, 26 Jun 2010 18:10:57 -0700
Message-ID: <4C26A51F.8020909@tlinx.org>
Date: Sat, 26 Jun 2010 18:10:55 -0700
From: "Linda A. Walsh" <xfs@tlinx.org>
MIME-Version: 1.0
Subject: WARNING xfsdump [still] Cannot allocate memory for list of
	[root|non-root] attributes for nondir ino xxyz
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>


FWIW -- that bug I mentioned a few weeks back that I thought was gone in 
the latest CVS
of xfsdump -- isn't.

It seems less frequent (maybe external attributes have been getting slow 
weeded out as
they fail -- if it is random).

What's 'unique' about this dump -- I just copied from one partition to 
another, to resize the first,
and this is on the copy back.

I.e. Stuff that xfs-restore just wrote has problems being read.

First problem was about 30 minutes into the 'copy'

Then about 2 more in the next half hour -- so not real often.

This is with kernel 2.6.34.

xfstools were downloaded a few weeks ago, so fairly recent.

xfsdump: WARNING: could not get list of non-root attributes for nondir 
ino 2428439: Cannot allocate memory (12)
in @  108 MB/s, out @  0.0 kB/s,  116 GB total, buffer   6% fullxfsdump: 
status at 02:25:06: 918808/2250704 files dumped, 54.3% data dumped, 1800 
seconds elapsed
in @ 14.0 MB/s, out @ 14.0 MB/s,  123 GB total, buffer   0% fullxfsdump: 
status at 02:30:06: 975579/2250704 files dumped, 57.6% data dumped, 2100 
seconds elapsed
in @  0.0 kB/s, out @  0.0 kB/s,  135 GB total, buffer  14% fullxfsdump: 
status at 02:35:07: 1062278/2250704 files dumped, 63.2% data dumped, 
2401 seconds elapsed
in @  226 MB/s, out @  157 MB/s,  152 GB total, buffer  91% fullxfsdump: 
status at 02:40:06: 1191037/2250704 files dumped, 71.5% data dumped, 
2700 seconds elapsed
in @  0.0 kB/s, out @  0.0 kB/s,  169 GB total, buffer   0% fullxfsdump: 
status at 02:45:06: 1321397/2250704 files dumped, 79.2% data dumped, 
3000 seconds elapsed
in @  0.0 kB/s, out @  120 MB/s,  176 GB total, buffer  30% full

xfsdump: WARNING: could not get list of secure attributes for nondir ino 
3929093: Cannot allocate memory (12)
in @  0.0 kB/s, out @  118 MB/s,  177 GB total, buffer   7% full

xfsdump: WARNING: could not get list of non-root attributes for nondir 
ino 3929095: Cannot allocate memory (12)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
