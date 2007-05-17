Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 May 2007 07:11:21 -0700 (PDT)
Received: from e6.ny.us.ibm.com (e6.ny.us.ibm.com [32.97.182.146])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4HEBDfB030335
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 07:11:16 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4HECCtU030437
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 10:12:12 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4HEBCuY524960
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 10:11:12 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4HEBAS6007475
	for <xfs@oss.sgi.com>; Thu, 17 May 2007 10:11:11 -0400
Date: Thu, 17 May 2007 19:41:15 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 0/6][TAKE4] fallocate system call
Message-ID: <20070517141115.GA24260@amitarora.in.ibm.com>
References: <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426175056.GA25321@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

Description:
-----------
fallocate() is a new system call being proposed here which will allow
applications to preallocate space to any file(s) in a file system.
Each file system implementation that wants to use this feature will need
to support an inode operation called fallocate.

Applications can use this feature to avoid fragmentation to certain
level and thus get faster access speed. With preallocation, applications
also get a guarantee of space for particular file(s) - even if later the
the system becomes full.

Currently, glibc provides an interface called posix_fallocate() which
can be used for similar cause. Though this has the advantage of working
on all file systems, but it is quite slow (since it writes zeroes to
each block that has to be preallocated). Without a doubt, file systems
can do this more efficiently within the kernel, by implementing
the proposed fallocate() system call. It is expected that
posix_fallocate() will be modified to call this new system call first
and incase the kernel/filesystem does not implement it, it should fall
back to the current implementation of writing zeroes to the new blocks.

Interface:
---------
The proposed system call's layout is:

 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)

fd: The descriptor of the open file.

mode*: This specifies the behavior of the system call. Currently the
  system call supports two modes - FA_ALLOCATE and FA_DEALLOCATE.
  FA_ALLOCATE: Applications can use this mode to preallocate blocks to
    a given file (specified by fd). This mode changes the file size if
    the preallocation is done beyond the EOF. It also updates the
    ctime in the inode of the corresponding file, marking a
    successfull allocation.
  FA_DEALLOCATE: This mode can be used by applications to deallocate the
    previously preallocated blocks. This also may change the file size
    and the ctime/mtime.
* New modes might get added in future. One such new mode which is
  already under discussion is FA_PREALLOCATE, which when used will
  preallocate space but will not change the filesize and [cm]time.
  Since the semantics of this new mode is not clear and agreed upon yet,
  this patchset does not implement it currently.

offset: This is the offset in bytes, from where the preallocation should
  start.

len: This is the number of bytes requested for preallocation (from
  offset).
 
RETURN VALUE: The system call returns 0 on success and an error on
failure. This is done to keep the semantics same as of
posix_fallocate(). 
    
sys_fallocate() on s390:
-----------------------
There is a problem with s390 ABI to implement sys_fallocate() with the
proposed order of arguments. Martin Schwidefsky has suggested a patch to
solve this problem which makes use of a wrapper in the kernel. This will
require special handling of this system call on s390 in glibc as well.
But, this seems to be the best solution so far.

Known Problem:
-------------
mmapped writes into uninitialized extents is a known problem with the
current ext4 patches. Like XFS, ext4 may need to implement
->page_mkwrite() to solve this. See:

Since there is a talk of ->fault() replacing ->page_mkwrite() and also
with a generic block_page_mkwrite() implementation already posted, we
can implement this later some time. See:

ToDos:
-----
1> Implementation on other architectures (other than i386, x86_64,
ppc64 and s390(x)). David Chinner has already posted a patch for ia64.
2> A generic file system operation to handle fallocate
(generic_fallocate), for filesystems that do _not_ have the fallocate
inode operation implemented.
3> Changes to glibc,
   a) to support fallocate() system call
   b) to make posix_fallocate() and posix_fallocate64() call fallocate()


Changelog:
---------
Changes from Take2 to Take3:
	1) Return type is now described in the interface description
	   above.
	2) Patches rebased to 2.6.22-rc1 kernel.

** Each post will have an individual changelog for a particular patch.


Following patches follow:
Patch 1/6 : fallocate() implementation on i86, x86_64 and powerpc
Patch 2/6 : fallocate() on s390
Patch 3/6 : fallocate() on ia64
Patch 4/6 : ext4: Extent overlap bugfix
Patch 5/6 : ext4: fallocate support in ext4
Patch 6/6 : ext4: write support for preallocated blocks

--
Regards,
Amit Arora
