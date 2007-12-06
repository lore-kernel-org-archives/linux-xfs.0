Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 17:55:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lB61tplE020993
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 17:55:53 -0800
Date: Thu, 6 Dec 2007 12:55:53 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [Patch] xfs_lowbit64 broken on ia32
Message-ID: <20071206015553.GI115527101@sgi.com>
References: <20071205032128.GB115527101@sgi.com> <D59801BCA402F5418C040937230AF7E0755AF5@mtv-amer002e--3.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <D59801BCA402F5418C040937230AF7E0755AF5@mtv-amer002e--3.americas.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Alex Elder <aelder@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Lachlan Mcllroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Wed, Dec 05, 2007 at 04:14:02AM -0800, Alex Elder wrote:
> David Chinner wrote:
> . . .
> > > >Index: 2.6.x-xfs-new/fs/xfs/xfs_bit.h
> > > >===================================================================
> > > >--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bit.h	2007-11-02 
> > > >13:44:45.000000000 +1100
> > > >+++ 2.6.x-xfs-new/fs/xfs/xfs_bit.h	2007-12-03 
> > 14:43:33.169851481 +1100
> > > >@@ -68,8 +68,8 @@ static inline int xfs_lowbit32(__uint32_
> > > > /* Get low bit set out of 64-bit argument, -1 if none set */
> > > > static inline int xfs_lowbit64(__uint64_t v)
> > > > {
> > > >-	unsigned long	t = v;
> > > >-	return (v) ? find_first_bit(&t, 64) : -1;
> > > >+	unsigned long long	t = v;
> > > Why create a local copy?  Why not just pass v into find_first_bit()?
> > 
> > Because I thought that taking the address of a function parameter
> > was a big no-no because the result is undefined (i.e. platform and
> > compiler dependent)?
> 
> I've never heard of this, and it's incorrect--at least with respect
> to standard C.  (But that's not to say in practice some compiler
> does it wrong.)  Unless it's a real (details known) problem you
> shouldn't try to work around it.

It caused me pain about 10 years ago with gcc 2.? and m68k platform,
so I've just avoided doing it ever since.

IMO, taking the address of a function parameter is also bad coding
practice because it usually indicates a bug in the code. i.e. you
should have passed a pointer to the function or you should be using
a local variable rather than abusing the function parameter in strange
ways.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
