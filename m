Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n0H7Q1eu029995 for <xfs@oss.sgi.com>; Sat, 17 Jan 2009 01:26:01 -0600
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C88F68F57E
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 23:25:56 -0800 (PST)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net
	[203.16.214.57]) by cuda.sgi.com with ESMTP id PgZthd7nbspEVo4s
	for <xfs@oss.sgi.com>; Fri, 16 Jan 2009 23:25:56 -0800 (PST)
Date: Sat, 17 Jan 2009 18:25:53 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs regression in linux_2.6.28, "XFS_WANT_CORRUPTED_GOTO at
	line 3327 of file fs/xfs/xfs_btree.c"
Message-ID: <20090117072553.GJ8071@disturbed>
References: <200901150402.39801.edvx1@systemanalysen.net>
	<20090115221438.GF8071@disturbed>
	<200901161008.02387.edvx1@systemanalysen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200901161008.02387.edvx1@systemanalysen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Roland Eggner <edvx1@systemanalysen.net>
Cc: SGI Project XFS mailing list <xfs@oss.sgi.com>

On Fri, Jan 16, 2009 at 10:08:01AM +0100, Roland Eggner wrote:
> On Thursday Jan 15th 2009 at 23:14:38 Dave Chinner wrote:
> > On Thu, Jan 15, 2009 at 04:02:39AM +0100, Roland Eggner wrote:
> > > Latest (so far) working linux_2.6.27.9
> > > linux_2.6.28 seems to introduce a xfs regression:
> > 
> > You mean 2.6.29, don't you (i.e. a current TOT development kernel,
> > not a stable kernel)?
> I meant exactly what I have written:  linux_2.6.28

The kernel number does not appear to change until -rc1 is released.
Hence 2.6.28-gitX is actually the first unsatable snapshots of the
2.6.29 tree.

> > We have received a few reports of that since 2.6.29-git2 after the
> > big XFS merge occurred. Can you confirm that you are running a very
> > recent unstable kernel and not a stable 2.6.28 kernel?
> all 2.6.28 builds which I have tried so far are broken,
> today tried linux_2.6.29-rc1 and got the same "XFS_WANT_CORRUPTED_GOTO .."
> note:  SAME failure with
> linux_2.6.28
> linux_2.6.28-git7
> linux_2.6.28-git9
> linux_2.6.29-rc1

These would all appear to be 2.6.29 trees you are testing. I'm
pretty certain of this because in the vanilla stable 2.6.28 tree
fs/xfs/xfs_btree.c only has 914 lines in it and it has no
WANT_CORRUPTED_GOTO() macros in it either. See here if you don't
beleive me:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=fs/xfs/xfs_btree.c;h=cc593a84c34572211cc2ff44997457838bbe4f5d;hb=4a6908a3a050aacc9c3a2f36b276b46c0629ad91

Linus pulled the XFS tree between -git1 and -git2, which is
why the file now has ~3700 lines in it and the bug you are
hitting....

> Should I compile with CONFIG_XFS_DEBUG?

A reproducable test case based on an xfs_metadump image of the
filesystem would be much more helpful to us at this point.

> If you know a 2.6.28 or 2.6.29 kernel with REALLY stable xfs:
> please point me :-)

I don't think you really have tried the stable 2.6.28
release at all. I think you will find the problem does
not exist on 2.6.28.

> > BTW, I note your kernel is tainted (like a couple of other
> > reports of this problem). Can you tell us what module you are
> > running that taints the kernel so we can correlate that with
> > other reports of the problem?
> kernels vanilla from kernel.org
> + NVIDIA-Linux-x86-96.43.09 graphics driver

Ok, that's different to other taints we've seen, so probably
not related.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
