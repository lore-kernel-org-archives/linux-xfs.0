Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 04 Sep 2008 16:13:02 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m84NCubt028760
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2008 16:12:58 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3AFAA404295
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2008 16:14:21 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id 9E0fDc3bI6DGCEQg for <xfs@oss.sgi.com>; Thu, 04 Sep 2008 16:14:21 -0700 (PDT)
Date: Fri, 5 Sep 2008 09:14:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_growfs fix backport for 2.6.16.y
Message-ID: <20080904231418.GB5991@disturbed>
References: <20080825153931.GD7575@coraid.com> <20080826020101.GU5706@disturbed> <20080903182701.GA29192@coraid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903182701.GA29192@coraid.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Ed Cashin <ecashin@coraid.com>
Cc: xfs@oss.sgi.com, Adrian Bunk <bunk@kernel.org>

On Wed, Sep 03, 2008 at 02:27:02PM -0400, Ed Cashin wrote:
> On Tue, Aug 26, 2008 at 12:01:01PM +1000, Dave Chinner wrote:
> > On Mon, Aug 25, 2008 at 11:39:31AM -0400, Ed Cashin wrote:
> ...
> > > I backported your fix,
> > > 
> > >     commit 20f4ebf2bf2f57c1a9abb3655391336cc90314b3
> ...
> > > ... to the 2.6.16.y git tree, and the result is included below.  When
> > > I apply this backported fix to 2.6.16.62, I can grow an online XFS by
> > > 10 terabytes without any trouble.
> 
> ...
> > I suggest you make sure it passes test 078 in the xfsqa suite (part
> > of the xfs-cmds tree) as that tests all the nasty growfs corner
> > cases. You'll need to test it on 32 bit and 64 bit machines....
> > 
> > If it passes that then I don't see any problems - SGI backported
> > this for sles10 which is based on 2.6.16 a long time ago.
> 
> On a 64-bit system running 2.6.16.62 with this patch, test 078 does
> not succeed because of one difference in the output file, the line in
> the diff below.  Instead of a new size of 4194304001 blocks, the new
> size is 4194304000 blocks.

Ah, yes. That. I think Barry can try to explain that one because:

http://oss.sgi.com/cgi-bin/cvsweb.cgi/xfs-cmds/xfstests/078.out.diff?r1=1.3;r2=1.4

The test golden output was changed instead of someone understanding
why the fixes to growfs changed the size that the filesystem was
grown to. ISTR being opposed to changing the golden output because
it was the wrong thing to do and would break QA on older kernels,
not to mention that it indicated some possible off-by-one bug in
a change that had been made at some point...

Other than that, the backport should be fine given it passed all the
other parts of the test....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
