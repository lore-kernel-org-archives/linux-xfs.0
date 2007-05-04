Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 03 May 2007 23:28:37 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [65.172.181.25])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l446STfB031053
	for <xfs@oss.sgi.com>; Thu, 3 May 2007 23:28:30 -0700
Date: Thu, 3 May 2007 23:28:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and
 powerpc
Message-Id: <20070503232815.2f62a75e.akpm@linux-foundation.org>
In-Reply-To: <20070504060731.GJ32602149@melbourne.sgi.com>
References: <20070329101010.7a2b8783.akpm@linux-foundation.org>
	<20070330071417.GI355@devserv.devel.redhat.com>
	<20070417125514.GA7574@amitarora.in.ibm.com>
	<20070418130600.GW5967@schatzie.adilger.int>
	<20070420135146.GA21352@amitarora.in.ibm.com>
	<20070420145918.GY355@devserv.devel.redhat.com>
	<20070424121632.GA10136@amitarora.in.ibm.com>
	<20070426175056.GA25321@amitarora.in.ibm.com>
	<20070426180332.GA7209@amitarora.in.ibm.com>
	<20070503212955.b1b6443c.akpm@linux-foundation.org>
	<20070504060731.GJ32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com

On Fri, 4 May 2007 16:07:31 +1000 David Chinner <dgc@sgi.com> wrote:

> On Thu, May 03, 2007 at 09:29:55PM -0700, Andrew Morton wrote:
> > On Thu, 26 Apr 2007 23:33:32 +0530 "Amit K. Arora" <aarora@linux.vnet.ibm.com> wrote:
> > 
> > > This patch implements the fallocate() system call and adds support for
> > > i386, x86_64 and powerpc.
> > > 
> > > ...
> > > +{
> > > +	struct file *file;
> > > +	struct inode *inode;
> > > +	long ret = -EINVAL;
> > > +
> > > +	if (len == 0 || offset < 0)
> > > +		goto out;
> > 
> > The posix spec implies that negative `len' is permitted - presumably "allocate
> > ahead of `offset'".  How peculiar.
> 
> I just checked the man page for posix_fallocate() and it says:
> 
>       EINVAL  offset or len was less than zero.
> 
> We should probably follow this lead.

Yes, I think so.  I'm suspecting that
http://www.opengroup.org/onlinepubs/009695399/functions/posix_fallocate.html
is just buggy.  Or I can't read.

I mean, if we're going to support negative `len' then is the byte at
`offset' inside or outside the segment?  Head spins.

However it would be neat if someone could test $OTHER_OS and, perhaps more
importantly, the present glibc emulation (which I assume your manpage is
referring to, so this would be a manpage test ;)).

> > > +
> > > +	ret = -ENODEV;
> > > +	if (!S_ISREG(inode->i_mode))
> > > +		goto out_fput;
> > 
> > So we return ENODEV against an S_ISBLK fd, as per the posix spec.  That
> > seems a bit silly of them.
> 
> Hmmmm - I thought that the intention of sys_fallocate() was to
> be generic enough to eventually allow preallocation on directories.
> If that is the case, then this check will prevent that....

The above opengroup page only permits S_ISREG.  Preallocating directories
sounds quite useful to me, although it's something which would be pretty
hard to emulate if the FS doesn't support it.  And there's a decent case to
be made for emulating it - run-anywhere reasons.  Does glibc emulation support
directories?  Quite unlikely.

But yes, sounds like a desirable thing.  Would XFS support it easily if the above
check was relaxed?
