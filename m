Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 04 May 2007 00:28:25 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l447SHfB017704
	for <xfs@oss.sgi.com>; Fri, 4 May 2007 00:28:19 -0700
Date: Fri, 4 May 2007 17:27:42 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Message-ID: <20070504072742.GK32602149@melbourne.sgi.com>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org> <20070504060731.GJ32602149@melbourne.sgi.com> <20070503232815.2f62a75e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070503232815.2f62a75e.akpm@linux-foundation.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Thu, May 03, 2007 at 11:28:15PM -0700, Andrew Morton wrote:
> On Fri, 4 May 2007 16:07:31 +1000 David Chinner <dgc@sgi.com> wrote:
> > On Thu, May 03, 2007 at 09:29:55PM -0700, Andrew Morton wrote:
> > > On Thu, 26 Apr 2007 23:33:32 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> > > 
> > > > This patch implements the fallocate() system call and adds support for
> > > > i386, x86_64 and powerpc.
> > > > 
> > > > ...
> > > > +{
> > > > +	struct file *file;
> > > > +	struct inode *inode;
> > > > +	long ret = -EINVAL;
> > > > +
> > > > +	if (len == 0 || offset < 0)
> > > > +		goto out;
> > > 
> > > The posix spec implies that negative `len' is permitted - presumably "allocate
> > > ahead of `offset'".  How peculiar.
> > 
> > I just checked the man page for posix_fallocate() and it says:
> > 
> >       EINVAL  offset or len was less than zero.
> > 
> > We should probably follow this lead.
> 
> Yes, I think so.  I'm suspecting that
> http://www.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html
> is just buggy.  Or I can't read.
> 
> I mean, if we're going to support negative `len' then is the byte at
> `offset' inside or outside the segment?  Head spins.

I don't think we should care. If we provide a syscall with the
semantics of "allocate from offset to offset+len" then glibc's
implementation can turn negative length into two separate
fallocate syscalls....

> > > > +	ret = -ENODEV;
> > > > +	if (!S_ISREG(inode->i_mode))
> > > > +		goto out_fput;
> > > 
> > > So we return ENODEV against an S_ISBLK fd, as per the posix spec.  That
> > > seems a bit silly of them.
> > 
> > Hmmmm - I thought that the intention of sys_fallocate() was to
> > be generic enough to eventually allow preallocation on directories.
> > If that is the case, then this check will prevent that....
> 
> The above opengroup page only permits S_ISREG.  Preallocating directories
> sounds quite useful to me, although it's something which would be pretty
> hard to emulate if the FS doesn't support it.  And there's a decent case to
> be made for emulating it - run-anywhere reasons.  Does glibc emulation support
> directories?  Quite unlikely.
> 
> But yes, sounds like a desirable thing.  Would XFS support it easily if the above
> check was relaxed?

No - right now empty blocks are pruned from the directory immediately so I
don't think we really have a concept of empty blocks in the btree structure.
dir2 is bloody complex, so adding preallocation is probably not going to
be simple to do.

It's not high on my list to add, either, because we can typically avoid the
worst case directory fragmentation by using larger directory block sizes
(e.g. 16k instead of the default 4k on a 4k block size fs).

IIRC directory preallocation has been talked about more for ext3/4....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
