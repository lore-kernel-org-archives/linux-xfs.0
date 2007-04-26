Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Apr 2007 10:51:01 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3QHotfB000706
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 10:50:57 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l3QHoqfb002909
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 13:50:52 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l3QHoqGr478240
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 13:50:52 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l3QHoqvK017740
	for <xfs@oss.sgi.com>; Thu, 26 Apr 2007 13:50:52 -0400
Date: Thu, 26 Apr 2007 23:20:56 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 0/5] fallocate system call
Message-ID: <20070426175056.GA25321@amitarora.in.ibm.com>
References: <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070424121632.GA10136@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Based on the discussion, this new patchset uses following as the
interface for fallocate() system call:

 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)

It seems that only s390 architecture has a problem with such a layout of
arguments in fallocate(). Thus for s390, we plan to have a wrapper
(say, sys_s390_fallocate()) for the sys_fallocate(), which will get
called by glibc when an application issues a fallocate() system call
on s390. The s390 arch specific changes will be part of a separate
patch (PATCH 2/5). It will be great if some s390 expert can verify the
patch, since I have not been able to test it on s390 so far.

It was also noted that minor changes might be required to strace code
to take care of "different arguments on s390" issue.

Currently we have two modes FA_ALLOCATE and FA_DEALLOCATE, for
preallocation and deallocation of preallocated blocks respectively. More
modes can be added, when required.

ToDos:
=====
1>   Implementation on other architectures (other than i386, x86_64, 
ppc64 and s390(x)) 
2>   A generic file system operation to handle fallocate
(generic_fallocate), for filesystems that do _not_ have the fallocate
inode operation implemented.
3>   Changes to glibc,
	a) to support fallocate() system call
	b) so that posix_fallocate() and posix_fallocate64() call
	   fallocate() system call
4>   Changes to XFS to implement the fallocate inode operation


Following patches follow:

Patch 1/5 : fallocate() implementation in i86, x86_64 and powerpc
Patch 2/5 : fallocate() on s390
Patch 3/5 : ext4: Extent overlap bugfix
Patch 4/5 : ext4: fallocate support in ext4
Patch 5/5 : ext4: write support for preallocated blocks

--
Regards,
Amit Arora
