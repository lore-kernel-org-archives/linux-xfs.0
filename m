Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 23:31:31 -0700 (PDT)
Received: from mail.clusterfs.com (mail.clusterfs.com [206.168.112.78])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4F6VPfB022437
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 23:31:27 -0700
Date: Tue, 15 May 2007 00:31:21 -0600
From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: [PATCH 0/5][TAKE2] fallocate system call
Message-ID: <20070515063120.GI5286@schatzie.adilger.int>
References: <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070514132926.GA30768@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514132926.GA30768@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On May 14, 2007  18:59 +0530, Amit K. Arora wrote:
>  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> 
> fd: The descriptor of the open file.
> 
> mode*: This specifies the behavior of the system call. Currently the
>   system call supports two modes - FA_ALLOCATE and FA_DEALLOCATE.
>   FA_ALLOCATE: Applications can use this mode to preallocate blocks to
>     a given file (specified by fd). This mode changes the file size if
>     the preallocation is done beyond the EOF. It also updates the
>     ctime/mtime in the inode of the corresponding file, marking a
>     successfull allocation.
>   FA_DEALLOCATE: This mode can be used by applications to deallocate the
>     previously preallocated blocks. This also may change the file size
>     and the ctime/mtime.
> * New modes might get added in future. One such new mode which is
>   already under discussion is FA_PREALLOCATE, which when used will
>   preallocate space but will not change the filesize and [cm]time.
>   Since the semantics of this new mode is not clear and agreed upon yet,
>   this patchset does not implement it currently.
> 
> offset: This is the offset in bytes, from where the preallocation should
>   start.
> 
> len: This is the number of bytes requested for preallocation (from
>   offset).

What is the return value?  I'd hope it is the number of bytes preallocated,
in case of interrupted preallocation for whatever reason (interrupt, out of
space, etc) like a regular write(2) call.  In this case the return type needs
to also be an loff_t to match @len.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.
