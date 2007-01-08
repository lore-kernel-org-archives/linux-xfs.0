Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 08 Jan 2007 05:08:53 -0800 (PST)
Received: from web31704.mail.mud.yahoo.com (web31704.mail.mud.yahoo.com [68.142.201.184])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l08D8iqw003127
	for <linux-xfs@oss.sgi.com>; Mon, 8 Jan 2007 05:08:46 -0800
Date: Mon, 8 Jan 2007 04:41:07 -0800 (PST)
From: Heilige Gheist <hgheist@yahoo.com>
Subject: kmem_alloc deadlock in SLES9 SP3
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <674311.78396.qm@web31704.mail.mud.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-xfs@oss.sgi.com

I'm getting occassional system freezes preceded by spurious
kmem_deadlock messages.
The system is running SLES9 SP3, xfs with large (~1GB) fragmented
files, using real-time section.
The message is 
Jan  8 06:27:55 ce-9 kernel: XFS: possible memory allocation deadlock
in kmem_alloc (mode:0x2d0)

ce-9:~ # uname -a
Linux ce-9 2.6.5-7.276-bigsmp #2 SMP Tue Sep 19 05:27:23 IDT 2006 i686
i686 i386 GNU/Linux

The similar bug report http://oss.sgi.com/bugzilla/show_bug.cgi?id=410
recommends upgrading to 2.6.17 to make use of new incore extent
management code.
Is there a version of commercial Linux (RHEL/SLES) that incorporates
this fix? SLES10 is based on 2.6.16 kernel.

--alan

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
