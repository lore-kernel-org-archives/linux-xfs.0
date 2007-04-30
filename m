Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 30 Apr 2007 05:31:13 -0700 (PDT)
Received: from mailsecure1.itc.griffith.edu.au (mailsecure1-out.itc.griffith.edu.au [132.234.242.61])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3UCV9fB027347
	for <xfs@oss.sgi.com>; Mon, 30 Apr 2007 05:31:10 -0700
Received: from mailsecure1.itc.griffith.edu.au (unknown [127.0.0.1])
	by mailsecure1.itc.griffith.edu.au (Symantec Mail Security) with ESMTP id C7D4218F
	for <xfs@oss.sgi.com>; Mon, 30 Apr 2007 22:01:43 +1000 (EST)
Received: from nox-1.itc.griffith.edu.au (sc2bigip02-242.nms.griffith.edu.au [132.234.242.254])
	by mailsecure1.itc.griffith.edu.au (Symantec Mail Security) with ESMTP id 9269F3018B
	for <xfs@oss.sgi.com>; Mon, 30 Apr 2007 22:01:43 +1000 (EST)
Received: from [132.234.242.254] (helo=studentemail.griffith.edu.au)
	by nox-1.itc.griffith.edu.au with esmtp (Exim 4.63)
	(envelope-from <s.so@griffith.edu.au>)
	id 1HiUZb-000053-Hs
	for xfs@oss.sgi.com; Mon, 30 Apr 2007 22:01:43 +1000
Received: from [132.234.200.137] by studentemail.griffith.edu.au
 (Sun Java System Messaging Server 6.2-6.01 (built Apr  3 2006))
 with ESMTPA id <0JHB00G9182VYL70@studentemail.griffith.edu.au> for
 xfs@oss.sgi.com; Mon, 30 Apr 2007 22:01:43 +1000 (EST)
Date: Mon, 30 Apr 2007 22:01:40 +1000
From: Stephen So <s.so@griffith.edu.au>
Subject: Slow performance when extracting tarballs
Message-id: <4635DAA4.4070402@griffith.edu.au>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7BIT
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi everyone,

Just a question about XFS when extracting bzipped tarballs containing
lots of little files (e.g. the linux kernel source).  I've noticed on my
new laptop (Intel Core 2 Duo @ 2.16 GHz), which has FC6 i386, which has
XFS partitions that when I extract these types of tarballs, my system
becomes rather non responsive, my mp3 player starts skipping etc.  After
looking at top during the extraction process, bzip2 uses about 80-90% of
CPU initially and extraction seems quite fast but after a few seconds,
it drops to 30-40%, the system becomes non responsive, and extraction is
much slower. 

I created a new partition of ext3 and reiserfs, did the same tarball
extraction, and on both filesystems, bzip2 uses at least 90%, extraction
is fast the whole way through, and the system is quite responsive.

I created my XFS partition using the following command (I made a larger
log file size since I heard that improve delete performance a bit):

mkfs.xfs  -l size=64m /dev/sda10

Then to mount this partition, I have these switches in my /etc/fstab file

noatime, nodiratime, logbufs=8

I'm using kernel 2.6.20 that came from the FC6 updates repositories.  So
is there something wrong with my XFS setup?  Is my log file too small? 
Or is this "normal" behaviour of XFS (i.e. that it excels best when
working with very large files but not lots of little files)?

Many thanks and best regards,

Steve.

-- 
______________________________________________________
Dr Stephen So, PhD, MIEEE
Griffith School of Engineering & 
  Institute for Integrated and Intelligent Systems
Science, Environment, Engineering and Technology Group
Griffith University, Gold Coast Campus
PMB 50, Gold Coast Mail Centre
Gold Coast, QLD, 9726, Australia

E-mail:       s.so@griffith.edu.au
Phone (Fax):  +61 7 5552 8663 (8065)
Homepage:     http://maxwell.me.gu.edu.au/sso
______________________________________________________
