Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Mar 2008 07:50:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2NEnYi7007666
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 07:49:35 -0700
Received: from web52006.mail.re2.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 0C899125E5BA
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 07:50:07 -0700 (PDT)
Received: from web52006.mail.re2.yahoo.com (web52006.mail.re2.yahoo.com [206.190.49.253]) by cuda.sgi.com with SMTP id FoSIoUbcE0tdBfwY for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 07:50:07 -0700 (PDT)
Date: Sun, 23 Mar 2008 07:50:06 -0700 (PDT)
From: "Hendrik ." <chasake@yahoo.com>
Subject: Poor VMWare disk performance on XFS partition
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <876423.51989.qm@web52006.mail.re2.yahoo.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I've been converting some of my drives from EXT3 to
XFS a while ago. Now I notice poor disk performance
when using XFS as underlying filesystem for a VMware
virtual drive. I did some experiments and it really
seems to be the XFS filesystem 'trashing' the speed of
a VMware Windows XP guest.

The first thing that I noticed is that when I shut
down the virtual machine it takes a very long time
after the machine seems to be shut down until the
VMware window becomes responsive again. In the mean
time there is heavy disk I/O. I found out that VMware
seems to write some kind of memory map on the host
hard disk which get heavily fragmented. The removal of
this file is probably very I/O intensive which causes
the delay. This is very annoying but not really a
problem as it only happens when a virtual machine is
shut down.

But there seems to be another problem when running the
guest operating system itself. I made two exact copies
of a Windows XP virtual machine on two hard disks of
the same type, size and brand. The first hard disk had
a XFS partition to host the virtual machine, the
seconds harddisk was formatted as EXT3. The XFS
partition has no fragmentation at all thus all files
only consisted of 1 extent. The EXT3 files were a bit
fragmented but this was only marginal (some larger
disk image files consisted of 17 extents where 16 was
optimal, reported by 'filefrag').

Then I ran the virtual machines one by one and started
a defragmentation program to cause a lot of I/O on the
guest operating system. Defragmentation of the XP host
running from the EXT3 partition took only 2m36 but the
exact same guest on the XFS partition took 10m5 to
complete. On the EXT3 partition hardly any noise was
heard from the drive heads as if the host operating
system was caching and delaying the I/O operations. On
the XFS host however a lot of noise was heard as if
the harddisk was trashing heavily.

The machine I ran the tests on had the following
specifications:
- Dual core AMD Athlon64 5200+
- 2 GB memory
- 2x 80 GB Samsung IDE harddisk
- Ubuntu Gutsy Gibbon (7.10) 64-bit
- Standard stock Ubuntu kernel
- VMware workstation 6.0.2 build-59824

The guest was a bare Windows XP SP-2 installation,
running O&O defrag 10.

Can anyone give me some information what might be
causing this massive slowdown? 

Regards,
Hendrik van den Boogaard


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
