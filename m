Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 May 2007 05:40:30 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4FCeNfB031295
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 05:40:25 -0700
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l4FCeN0N009204
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 08:40:23 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l4FCeNkl492006
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 08:40:23 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l4FCeM5B024328
	for <xfs@oss.sgi.com>; Tue, 15 May 2007 08:40:23 -0400
Date: Tue, 15 May 2007 18:10:20 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/5][TAKE2] fallocate system call
Message-ID: <20070515124020.GA12964@amitarora.in.ibm.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070514132926.GA30768@amitarora.in.ibm.com> <20070515063120.GI5286@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070515063120.GI5286@schatzie.adilger.int>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Tue, May 15, 2007 at 12:31:21AM -0600, Andreas Dilger wrote:
> On May 14, 2007  18:59 +0530, Amit K. Arora wrote:
> >  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)
> > 
> > fd: The descriptor of the open file.
> > 
> > mode*: This specifies the behavior of the system call. Currently the
> >   system call supports two modes - FA_ALLOCATE and FA_DEALLOCATE.
> >   FA_ALLOCATE: Applications can use this mode to preallocate blocks to
> >     a given file (specified by fd). This mode changes the file size if
> >     the preallocation is done beyond the EOF. It also updates the
> >     ctime/mtime in the inode of the corresponding file, marking a
> >     successfull allocation.
> >   FA_DEALLOCATE: This mode can be used by applications to deallocate the
> >     previously preallocated blocks. This also may change the file size
> >     and the ctime/mtime.
> > * New modes might get added in future. One such new mode which is
> >   already under discussion is FA_PREALLOCATE, which when used will
> >   preallocate space but will not change the filesize and [cm]time.
> >   Since the semantics of this new mode is not clear and agreed upon yet,
> >   this patchset does not implement it currently.
> > 
> > offset: This is the offset in bytes, from where the preallocation should
> >   start.
> > 
> > len: This is the number of bytes requested for preallocation (from
> >   offset).
> 
> What is the return value?  I'd hope it is the number of bytes preallocated,
> in case of interrupted preallocation for whatever reason (interrupt, out of
> space, etc) like a regular write(2) call.  In this case the return type needs
> to also be an loff_t to match @len.

The return value in current implementation has been kept as "long" where
zero is returned for success and an error on failure. This is done to
keep it inline with posix_fallocate behavior.

This point was brought up sometime back by Badari. At that time it was
decided to keep it the way posix_fallocate is designed. Here are the
posts related to this:

Still if you feel that we should be returning number of bytes
preallocated, we can again ask for opinion here.

Thanks!
--
Regards,
Amit Arora
