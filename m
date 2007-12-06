Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Dec 2007 19:30:54 -0800 (PST)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB63UpAR031884
	for <xfs@oss.sgi.com>; Wed, 5 Dec 2007 19:30:51 -0800
Received: from mtv-amer002e--3.americas.sgi.com (unknown [192.26.64.114])
	by netops-testserver-3.corp.sgi.com (Postfix) with ESMTP id 2D004908A9
	for <xfs@oss.sgi.com>; Wed,  5 Dec 2007 19:11:02 -0800 (PST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Subject: RE: [Patch] xfs_lowbit64 broken on ia32
Date: Wed, 5 Dec 2007 18:22:04 -0800
Message-ID: <D59801BCA402F5418C040937230AF7E0755B28@mtv-amer002e--3.americas.sgi.com>
In-Reply-To: <20071206015553.GI115527101@sgi.com>
From: "Alex Elder" <aelder@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Lachlan Mcllroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

David Chinner wrote:
> On Wed, Dec 05, 2007 at 04:14:02AM -0800, Alex Elder wrote:
> > David Chinner wrote:
> > . . .
> > > > >Index: 2.6.x-xfs-new/fs/xfs/xfs_bit.h
> > > > 
> >===================================================================
> > > > >--- 2.6.x-xfs-new.orig/fs/xfs/xfs_bit.h	2007-11-02 
> > > > >13:44:45.000000000 +1100
> > > > >+++ 2.6.x-xfs-new/fs/xfs/xfs_bit.h	2007-12-03 
> > > 14:43:33.169851481 +1100
> > > > >@@ -68,8 +68,8 @@ static inline int xfs_lowbit32(__uint32_
> > > > > /* Get low bit set out of 64-bit argument, -1 if none set */
> > > > > static inline int xfs_lowbit64(__uint64_t v)
> > > > > {
> > > > >-	unsigned long	t = v;
> > > > >-	return (v) ? find_first_bit(&t, 64) : -1;
> > > > >+	unsigned long long	t = v;
> > > > Why create a local copy?  Why not just pass v into 
> find_first_bit()?
> > > 
> > > Because I thought that taking the address of a function parameter
> > > was a big no-no because the result is undefined (i.e. platform and
> > > compiler dependent)?
> > 
> > I've never heard of this, and it's incorrect--at least with respect
> > to standard C.  (But that's not to say in practice some compiler
> > does it wrong.)  Unless it's a real (details known) problem you
> > shouldn't try to work around it.
> 
> It caused me pain about 10 years ago with gcc 2.? and m68k platform,
> so I've just avoided doing it ever since.

I figured an experience like this was behind it.

> IMO, taking the address of a function parameter is also bad coding
> practice because it usually indicates a bug in the code. i.e. you
> should have passed a pointer to the function or you should be using
> a local variable rather than abusing the function parameter in strange
> ways.

I'm undecided.  I agree there's something aesthetically
wrong about it.  Technically I'm not so sure.  Maybe
a longjmp() can lead bad things happening when you do
this, I don't know.  Anyway, this is pretty picky.
The change was fine.

					-Alex
