Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 04:28:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5ABSKZv013347
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 04:28:20 -0700
Received: from mail.brightcove.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 43BC9C69123
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 04:29:14 -0700 (PDT)
Received: from mail.brightcove.com (mail.brightcove.com [38.113.27.188]) by cuda.sgi.com with ESMTP id 0eJF0xAb65aWKsV0 for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 04:29:14 -0700 (PDT)
From: Lance Reed <lreed@brightcove.com>
Date: Tue, 10 Jun 2008 07:28:21 -0400
Subject: Probems with xfs_repair on large filesystem and 32bit OS.
Message-ID: <6A32BC807C106440B7E23208F280DDAF01D3F6C8A8@bcmail1.VIDMARK.LOCAL>
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

So I am having trouble fixing a corrupted <16 TB file system on a 32bit Linux system:


The problem is that xfs_repair dies due to xfs_repair: libxfs_initbuf can't memalign 4096 bytes: Cannot allocate memory:

I found the below post, but the links are dead.

I tried upping the system RAM to 12 GB, but the problem still exists, which I assume is the per process limit of 1-4 GB.


So I am looking for advice on how to fix a large 32bit filesystem.  I see options about running on a 64bit host.
Can I do this with a newer version of xfs and kernel?
We have many hosts that run 64bit Linux (2.6.18-8.1.15.el5  x86_64) and updated xfs progs.
Is it possible to mount the existing LVM volumes on a new 64bit host with a newer OS and xfs progs and not risk losing data.
Os details for old and possible new host below:

Thanks in advance for any possible ideas.
Really, THANKS!
Lance

Basic Os details: (Problem host used to mount XFS filesystem).
CentOS release 4.4 (Final)
2.6.9-42.ELsmp  i686 i686 i386 GNU/Linux

XFS info:

xfsprogs-2.8.11-1.c4
xfsdump-2.2.42-1.c4
kernel-module-xfs-2.6.9-42.ELsmp-0.1-3

Possible new host.:

CentOS release 5 (Final)
2.6.18-8.1.15.el5  x86_64
xfsprogs-2.9.4-1.el5.centos
xfsdump-2.2.46-1.el5.centos
kmod-xfs-0.4-1.2.6.18_8.1.15.el5


Previous posts on list:




#> I had 2GB RAM and a 300GB swap partition and was monitoring

#> memory consumption with "top": it never went over 3BG before

#> failing.

#

#The default 3GiB address space limit per process on a 32 bit

#system is rather well documented, for a summary:

#

#  http://WWW.sabi.co.UK/Notes/#060821c

#

#Let's mention this classic entry again:

#

#  http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00045.html

#

#   <> > Your filesystem (8TiB) may simply bee too large for your

#    > > system to be able to repair. Try mounting it on a 64bit

#    > > system with more RAM in it and repairing it from there.

#

#    Now that linux supports larger than 2TiB filesystems on 32

#    bit systems, this is true for Linux as well.>

#

#A previous entry in the same thread might help too:

#

#  http://OSS.SGI.com/archives/linux-xfs/2005-08/msg00037.html

#

#   <> I try xfs_check and xfs_ncheck (and more progs) with

#    > +200GB swap, but no different! less than 1 second and get

#    > out of memory.

#

#    Swap won't help if you're running an ia32 (32bit) kernel -

#    you have a per-process memory limit of 1-4GiB (depending on

#    kernel and config). The amount of physical memory and swap

#    does not change this limitation.>

#

#Trying hard to avoid looking at what <has been discussed many

#times previously> is a great time saving strategy! :-)
#












[[HTML alternate version deleted]]
