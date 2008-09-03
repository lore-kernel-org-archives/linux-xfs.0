Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Sep 2008 11:24:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m83IOHBP023169
	for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 11:24:17 -0700
Received: from coraid.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3F6A53FBF27
	for <xfs@oss.sgi.com>; Wed,  3 Sep 2008 11:25:43 -0700 (PDT)
Received: from coraid.com (baron.coraid.com [12.51.113.4]) by cuda.sgi.com with ESMTP id lyrMtzBAgGjVmb8X for <xfs@oss.sgi.com>; Wed, 03 Sep 2008 11:25:43 -0700 (PDT)
Date: Wed, 3 Sep 2008 14:27:02 -0400
From: Ed Cashin <ecashin@coraid.com>
Subject: Re: xfs_growfs fix backport for 2.6.16.y
Message-ID: <20080903182701.GA29192@coraid.com>
References: <20080825153931.GD7575@coraid.com> <20080826020101.GU5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080826020101.GU5706@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com, Adrian Bunk <bunk@kernel.org>

On Tue, Aug 26, 2008 at 12:01:01PM +1000, Dave Chinner wrote:
> On Mon, Aug 25, 2008 at 11:39:31AM -0400, Ed Cashin wrote:
...
> > I backported your fix,
> > 
> >     commit 20f4ebf2bf2f57c1a9abb3655391336cc90314b3
...
> > ... to the 2.6.16.y git tree, and the result is included below.  When
> > I apply this backported fix to 2.6.16.62, I can grow an online XFS by
> > 10 terabytes without any trouble.

...
> I suggest you make sure it passes test 078 in the xfsqa suite (part
> of the xfs-cmds tree) as that tests all the nasty growfs corner
> cases. You'll need to test it on 32 bit and 64 bit machines....
> 
> If it passes that then I don't see any problems - SGI backported
> this for sles10 which is based on 2.6.16 a long time ago.

On a 64-bit system running 2.6.16.62 with this patch, test 078 does
not succeed because of one difference in the output file, the line in
the diff below.  Instead of a new size of 4194304001 blocks, the new
size is 4194304000 blocks.

Maybe this looks familiar to you and suggests that I missed
something.  If so, please let me know.

ellijay:/mnt/makki/ecashin/opt-amd64/xfstests# diff -U15 078.out 078.out.bad
--- 078.out     2008-03-05 00:25:08.000000000 -0500
+++ 078.out.bad 2008-08-29 16:41:34.537888000 -0400
@@ -194,18 +194,18 @@
 
 === GROWFS (from 1t to 16000g, 4096 blocksize)
 
 *** mkfs loop file (size=1t)
 meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
 data     = bsize=XXX blocks=XXX, imaxpct=PCT
          = sunit=XXX swidth=XXX, unwritten=X
 naming   =VERN bsize=XXX
 log      =LDEV bsize=XXX blocks=XXX
 realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 *** extend loop file
 wrote 4096/4096 bytes at offset 17179869184000
 *** mount loop filesystem
 *** grow loop filesystem
 xfs_growfs --BlockSize=4096 --Blocks=268435456
-data blocks changed from 268435456 to 4194304001
+data blocks changed from 268435456 to 4194304000
 *** unmount
 *** all done
ellijay:/mnt/makki/ecashin/opt-amd64/xfstests# 

-- 
  Ed Cashin <ecashin@coraid.com>
