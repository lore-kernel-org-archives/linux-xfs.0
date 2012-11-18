Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAINplfK195328 for <xfs@oss.sgi.com>; Sun, 18 Nov 2012 17:51:47 -0600
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	oVLgMUCojQyLXwgO for <xfs@oss.sgi.com>;
	Sun, 18 Nov 2012 15:53:54 -0800 (PST)
Date: Mon, 19 Nov 2012 10:53:11 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [xfs:for-next 68/70] fs/xfs/xfs_ialloc_btree.c:186:1: sparse:
	symbol 'xfs_inobt_verify' was not declared. Should it be static?
Message-ID: <20121118235311.GU14281@dastard>
References: <50a5e062.XN/BRFaWJHYKYG4f%fengguang.wu@intel.com>
	<20121117233057.GR14281@dastard> <20121118040217.GA26302@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121118040217.GA26302@localhost>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

On Sun, Nov 18, 2012 at 12:02:17PM +0800, Fengguang Wu wrote:
> On Sun, Nov 18, 2012 at 10:30:57AM +1100, Dave Chinner wrote:
> > On Fri, Nov 16, 2012 at 02:42:42PM +0800, kbuild test robot wrote:
> > > tree:   git://oss.sgi.com/xfs/xfs for-next
> > > head:   1813dd64057490e7a0678a885c4fe6d02f78bdc1
> > > commit: 612cfbfe174a89d565363fff7f3961a2dda5fb71 [68/70] xfs: add pre-write metadata buffer verifier callbacks
> > > 
> > > 
> > > sparse warnings:
> > > 
> > > + fs/xfs/xfs_ialloc_btree.c:186:1: sparse: symbol 'xfs_inobt_verify' was not declared. Should it be static?
> > > fs/xfs/xfs_ialloc_btree.c:227:1: sparse: symbol 'xfs_inobt_read_verify' was not declared. Should it be static?
....
> > 
> > These are debug build only, and intended to be globally visible so
> > they can be changed with a debugger. And sparse didn't warn about
> > them, because you didn't do a debug build, so the script shouldn't
> > be changing them.(*)
> > 
> > Cheers,
> > 
> > Dave.
> > 
> > (*) Please don't do debug XFS builds with this automated checker. We
> > pretty much turn all static functions to global "noinline" functions
> > for debug builds, and sparse will throw hundreds of useless warnings.
> 
> Dave, thanks for the explanations. And sorry for the noises!  
> I'll disable the "Should it be static" checks against the xfs tree.

I didn't say that - I'm suggesting that you should be more selective
about what the bot throws out as a fix. i.e. only fix the newly
discovered problem rather than everything that is found....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
