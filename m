Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 23 Mar 2008 13:41:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m2NKfYlU005596
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 13:41:35 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B70C125F1D6
	for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 13:42:07 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id s7nDfDn5u38qAK9U for <xfs@oss.sgi.com>; Sun, 23 Mar 2008 13:42:07 -0700 (PDT)
Message-ID: <47E6C09E.5030601@sandeen.net>
Date: Sun, 23 Mar 2008 15:42:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Poor VMWare disk performance on XFS partition
References: <876423.51989.qm@web52006.mail.re2.yahoo.com>
In-Reply-To: <876423.51989.qm@web52006.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Hendrik ." <chasake@yahoo.com>
Cc: xfs@oss.sgi.com

Hendrik . wrote:
> I've been converting some of my drives from EXT3 to
> XFS a while ago. Now I notice poor disk performance
> when using XFS as underlying filesystem for a VMware
> virtual drive. I did some experiments and it really
> seems to be the XFS filesystem 'trashing' the speed of
> a VMware Windows XP guest.
> 
> The first thing that I noticed is that when I shut
> down the virtual machine it takes a very long time
> after the machine seems to be shut down until the
> VMware window becomes responsive again. In the mean
> time there is heavy disk I/O. I found out that VMware
> seems to write some kind of memory map on the host
> hard disk which get heavily fragmented. 

What does xfs_bmap and/or filefrag say, is this file indeed very
fragmented?  And is it less so on ext3?  If the file is persistent then
preallocating it would probably help.

> The removal of
> this file is probably very I/O intensive which causes
> the delay. This is very annoying but not really a
> problem as it only happens when a virtual machine is
> shut down.
> 
> But there seems to be another problem when running the
> guest operating system itself. I made two exact copies
> of a Windows XP virtual machine on two hard disks of
> the same type, size and brand. The first hard disk had
> a XFS partition to host the virtual machine, the
> seconds harddisk was formatted as EXT3. The XFS
> partition has no fragmentation at all thus all files
> only consisted of 1 extent. The EXT3 files were a bit
> fragmented but this was only marginal (some larger
> disk image files consisted of 17 extents where 16 was
> optimal, reported by 'filefrag').

I've honestly never used vmware. How many disk image files per guest?
You said 2 copies of an XP VM, one on xfs and one on ext3, but then said
"EXT3 files" so I'm not sure what the big picture looks like here.

If a single guest uses multiple files, can you run xfs_bmap -v on them,
it may be that xfs is spreading them out between the AGs, thereby
putting them into different regions of the disk.

> Then I ran the virtual machines one by one and started
> a defragmentation program to cause a lot of I/O on the
> guest operating system. Defragmentation of the XP host
> running from the EXT3 partition took only 2m36 but the
> exact same guest on the XFS partition took 10m5 to
> complete. On the EXT3 partition hardly any noise was
> heard from the drive heads as if the host operating
> system was caching and delaying the I/O operations. On
> the XFS host however a lot of noise was heard as if
> the harddisk was trashing heavily.

Maybe try using seekwatcher to trace/graph IO of the vmware processes to
see what's going on?

-Eric
