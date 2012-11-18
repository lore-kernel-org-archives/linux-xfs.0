Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qAI40Dhw096962 for <xfs@oss.sgi.com>; Sat, 17 Nov 2012 22:00:13 -0600
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88]) by
	cuda.sgi.com with ESMTP id zQwCpMCislj1t2lJ for
	<xfs@oss.sgi.com>; Sat, 17 Nov 2012 20:02:20 -0800 (PST)
Date: Sun, 18 Nov 2012 12:02:17 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [xfs:for-next 68/70] fs/xfs/xfs_ialloc_btree.c:186:1: sparse:
	symbol 'xfs_inobt_verify' was not declared. Should it be static?
Message-ID: <20121118040217.GA26302@localhost>
References: <50a5e062.XN/BRFaWJHYKYG4f%fengguang.wu@intel.com>
	<20121117233057.GR14281@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20121117233057.GR14281@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ben Myers <bpm@sgi.com>, xfs@oss.sgi.com, Dave Chinner <dchinner@redhat.com>

Hi Dave,

On Sun, Nov 18, 2012 at 10:30:57AM +1100, Dave Chinner wrote:
> On Fri, Nov 16, 2012 at 02:42:42PM +0800, kbuild test robot wrote:
> > tree:   git://oss.sgi.com/xfs/xfs for-next
> > head:   1813dd64057490e7a0678a885c4fe6d02f78bdc1
> > commit: 612cfbfe174a89d565363fff7f3961a2dda5fb71 [68/70] xfs: add pre-write metadata buffer verifier callbacks
> > 
> > 
> > sparse warnings:
> > 
> > + fs/xfs/xfs_ialloc_btree.c:186:1: sparse: symbol 'xfs_inobt_verify' was not declared. Should it be static?
> > fs/xfs/xfs_ialloc_btree.c:227:1: sparse: symbol 'xfs_inobt_read_verify' was not declared. Should it be static?
> 
> Hi Fengguang,
> 
> For a short while these probably should be static, but they will be
> externally visible soon - there are subsequent patches that will hit
> 3.9 require this to be available externally, so I'm not sure it's
> worth fixing this right now, only to change it back again shortly.

OK.

> > Please consider folding the attached diff :-)
> 
> No, because it changes more than just what the above sparse error
> reports.....

OK.

> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index b38a10e..6a714b5 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -52,10 +52,10 @@
> >   */
> >  
> >  #ifdef DEBUG
> > -xfs_buftarg_t *xfs_dqerror_target;
> > -int xfs_do_dqerror;
> > -int xfs_dqreq_num;
> > -int xfs_dqerror_mod = 33;
> > +static xfs_buftarg_t *xfs_dqerror_target;
> > +static int xfs_do_dqerror;
> > +static int xfs_dqreq_num;
> > +static int xfs_dqerror_mod = 33;
> >  #endif
> 
> These are debug build only, and intended to be globally visible so
> they can be changed with a debugger. And sparse didn't warn about
> them, because you didn't do a debug build, so the script shouldn't
> be changing them.(*)
> 
> Cheers,
> 
> Dave.
> 
> (*) Please don't do debug XFS builds with this automated checker. We
> pretty much turn all static functions to global "noinline" functions
> for debug builds, and sparse will throw hundreds of useless warnings.

Dave, thanks for the explanations. And sorry for the noises!  
I'll disable the "Should it be static" checks against the xfs tree.

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
