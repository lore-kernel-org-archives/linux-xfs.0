Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 29 Apr 2007 17:47:38 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3U0lVfB022362
	for <xfs@oss.sgi.com>; Sun, 29 Apr 2007 17:47:34 -0700
Date: Mon, 30 Apr 2007 10:47:02 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 0/5] fallocate system call
Message-ID: <20070430004702.GM32602149@melbourne.sgi.com>
References: <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070426175056.GA25321@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, Apr 26, 2007 at 11:20:56PM +0530, Amit K. Arora wrote:
> Based on the discussion, this new patchset uses following as the
> interface for fallocate() system call:
> 
>  asmlinkage long sys_fallocate(int fd, int mode, loff_t offset, loff_t len)

Ok, so now for the hard questions - what are the semantics of
FA_ALLOCATE and FA_DEALLOCATE?

For FA_ALLOCATE, it's supposed to change the file size if we
allocate past EOF, right? What's the return value supposed to
be? Zero for success, error otherwise? Does this update a/m/ctime
at all? How persistent is this preallocation? Should it be
there "forever" or for the lifetime of the currently open fd
that it was preallocated on?

For FA_DEALLOCATE, does it change the filesize at all? Or does
it just punch a hole in the file? If it does change file size,
what happens when you punch out preallocation beyond EOF?
What's the return value supposed to be?

> Currently we have two modes FA_ALLOCATE and FA_DEALLOCATE, for
> preallocation and deallocation of preallocated blocks respectively. More
> modes can be added, when required.

FWIW, we definitely need a FA_PREALLOCATE mode (FA_ALLOCATE but does
not change file size) so we can preallocate beyond EOF for apps which
use O_APPEND (i.e. changing file size would cause problems for them).

> ToDos:
> =====
> 1>   Implementation on other architectures (other than i386, x86_64, 
> ppc64 and s390(x)) 

I'll have ia64 soon.

> 2>   A generic file system operation to handle fallocate
> (generic_fallocate), for filesystems that do _not_ have the fallocate
> inode operation implemented.
> 3>   Changes to glibc,
> 	a) to support fallocate() system call
> 	b) so that posix_fallocate() and posix_fallocate64() call
> 	   fallocate() system call
> 4>   Changes to XFS to implement the fallocate inode operation

And that's what I'm doing now, hence all the questions ;)

BTW, do you have a test program for this, or will I need to write
one myself?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
