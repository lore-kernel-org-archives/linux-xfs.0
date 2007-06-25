Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 06:28:15 -0700 (PDT)
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5PDS6do000680
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 06:28:08 -0700
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5PDS5Vc011107
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 09:28:05 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5PDS3Hi208590
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 07:28:03 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5PDS2bZ021395
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 07:28:03 -0600
Date: Mon, 25 Jun 2007 18:58:10 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 0/6][TAKE5] fallocate system call
Message-ID: <20070625132810.GA1951@amitarora.in.ibm.com>
References: <20070510005926.GT85884050@sgi.com> <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614193347.GN5181@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

N O T E: 
-------
1) Only Patches 4/7 and 7/7 are NEW. Rest of them are _already_ part
   of ext4 patch queue git tree hosted by Ted.
2) The above new patches (4/7 and 7/7) are based on the dicussion
   between Andreas Dilger and David Chinner on the mode argument,
   when later posted a man page on fallocate.
3) All of these patches are based on 2.6.22-rc4 kernel and apply to
   2.6.22-rc5 too (with some successfull hunks, though  - since the
   ext4 patch queue git tree has some other patches as well before
   fallocate patches in the patch series).

Changelog:
---------
Changes from Take4 to Take5:
	1) New Patch 4/7 implements new flags and values for mode
	   argument of fallocate system call.
	2) New Patch 7/7 implements 2 (out of 4) modes in ext4.
	   Implementation of rest of the (two) modes is yet to be done.
	3) Updated the interface description below to mention new modes
	   being supported.
	4) Removed "extent overlap check" bugfix (patch 4/6 in TAKE4,
	   since it is now part of mainline.
	5) Corrected format of couple of multi-line comments, which got
	   missed in earlier take.

Changes from Take2 to Take3:
        1) Return type is now described in the interface description
           above.
        2) Patches rebased to 2.6.22-rc1 kernel.

** Each post will have an individual changelog for a particular patch.


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
The system call's layout is:

 asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len);

fd: The descriptor of the open file.

mode*: This specifies the behavior of the system call. Currently the
  system call supports four modes - FA_ALLOCATE, FA_DEALLOCATE, 
  FA_RESV_SPACE and FA_UNRESV_SPACE.
  FA_ALLOCATE: Applications can use this mode to preallocate blocks to
    a given file (specified by fd). This mode changes the file size if
    the preallocation is done beyond the EOF. It also updates the
    ctime in the inode of the corresponding file, marking a
    successfull allocation.
  FA_FA_RESV_SPACE: This mode is quite same as FA_ALLOCATE. The only
    difference being that the file size will not be changed.
  FA_DEALLOCATE: This mode can be used by applications to deallocate the
    previously preallocated blocks. This also may change the file size
    and the ctime/mtime. This is reverse of FA_ALLOCATE mode.
  FA_UNRESV_SPACE: This mode is quite same as FA_DEALLOCATE. The
    difference being that the file size is not changed and the data is
    also deleted.
* New modes might get added in future.

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
ia64, ppc64 and s390(x)).
2> A generic file system operation to handle fallocate
(generic_fallocate), for filesystems that do _not_ have the fallocate
inode operation implemented.
3> Changes to glibc,
   a) to support fallocate() system call
   b) to make posix_fallocate() and posix_fallocate64() call fallocate()


Following patches follow:
Patch 1/6 : fallocate() implementation on i386, x86_64 and powerpc
Patch 2/7 : fallocate() on s390(x)
Patch 3/7 : fallocate() on ia64
Patch 4/7 : support new modes in fallocate
Patch 5/7 : ext4: fallocate support in ext4
Patch 6/7 : ext4: write support for preallocated blocks
Patch 7/7 : ext4: support new modes
