Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 26 Sep 2007 08:06:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l8QF6Y7G032641
	for <linux-xfs@oss.sgi.com>; Wed, 26 Sep 2007 08:06:36 -0700
Message-ID: <46FA7579.9090403@sandeen.net>
Date: Wed, 26 Sep 2007 10:06:33 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS DMAPI support for RHEL4
References: <cce360c30709260650o728bc046ic90fc0e0c726bd78@mail.gmail.com> <cce360c30709260651k17c80518k555f174af3fafb54@mail.gmail.com>
In-Reply-To: <cce360c30709260651k17c80518k555f174af3fafb54@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Manoj Kumar Pradhan <manojkp80@gmail.com>
Cc: linux-xfs@oss.sgi.com

Manoj Kumar Pradhan wrote:
> Hi,
> 
> I am running RHEL with kernel 2.6.9-42ELsmp x86_64. I got the xfs module
> from http://sandeen.net/rhel4_xfs/ and did a rpmbuild as instructed there, I
> got the xfs.ko and the module-xfs rpm for the running kernel too but modinfo
> shows me that the xfs module hence created is not dmapi enabled.

Right, the dmapi module isn't included in that.  As far as I can recall,
the necessary bits to support DMAPI are not present in the RHEL4 kernel,
so this is probably not going to work.  Perhaps the sgi guys can chime
in if I'm off base.

-Eric

> [root@asher RPMS]# modinfo xfs
> filename:       /lib/modules/2.6.9-42.ELsmp/kernel/fs/xfs/xfs.ko
> license:        GPL
> description:    SGI XFS with ACLs, security attributes, realtime, large
> block/inode numbers, no debug enabled
> author:         Silicon Graphics, Inc.
> depends:
> vermagic:       2.6.9-42.ELsmp SMP gcc-3.4
> 
> When I run a simple app which tries to init dmapi for XFS it fails with
> ENOSYS.
> Did I miss anything here? How do I enable DMAPI on this XFS module?
> 
> Thanks,
> Manoj
> 
> 
> [[HTML alternate version deleted]]
> 
> 
