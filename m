Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Oct 2006 05:22:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9CCM8aG032218
	for <xfs@oss.sgi.com>; Thu, 12 Oct 2006 05:22:10 -0700
Message-ID: <452E32FF.8010109@ah.jp.nec.com>
Date: Thu, 12 Oct 2006 21:20:15 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
MIME-Version: 1.0
Subject: Re: [patch] Fix xfs_iunpin() sets I_DIRTY_SYNC after clear_inode().
References: <45237CCE.4010007@ah.jp.nec.com> <20061006032617.GC11034@melbourne.sgi.com> <20061011064357.GN19345@melbourne.sgi.com>
In-Reply-To: <20061011064357.GN19345@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

Hi David,

I tried those patches, but they caused degradation.
These are results of "vmstat 10" while my test program was running.

- Before applying those patches:
procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 7  0      0 2768240  37632 210512    0    0     7 43367  268  676  1 49 50  0  0
 9  0      0 2716352  37632 210672    0    0     0 362864 2154 47915  1 51 48  0  0
 9  0      0 2663136  37664 210048    0    0     0 361745 2154 48258  1 50 49  0  0
10  0      0 2610688  37664 211184    0    0     0 360908 2152 48068  1 51 49  0  0
 9  0      0 2557904  37680 210512    0    0     0 360254 2154 49036  1 51 48  0  0
10  0      0 2504832  37696 210304    0    0     0 362525 2153 48460  1 50 49  0  0


- After applying those patches:
procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
 0  0      0 15584608  21776 153072    0    0    69   403  256  394  1  3 95  1  0
 0  0      0 15586032  21824 153024    0    0     1  2319 2161 2944  0  2 98  0  0
 1  0      0 15585920  21824 153104    0    0     0  2342 2161 2951  0  2 98  0  0
 0  0      0 15585696  21824 152976    0    0     0  2364 2160 2978  0  2 98  0  0
 1  0      0 15585360  21824 153168    0    0     0  2380 2161 3027  0  2 98  0  0
 0  0      0 15585248  21824 152976    0    0     0  2348 2161 2983  0  2 98  0  0


Block I/O performance degradation was very serious.
Now, I am trying to ease the degradation.
Do you have any idea for resolving the degradation?

By the way, I found some mistakes in your patch.
Please correct them.

> > Index: 2.6.x-xfs-new/fs/xfs/xfs_iget.c
> > ===================================================================
> > --- 2.6.x-xfs-new.orig/fs/xfs/xfs_iget.c        2006-09-14 11:18:52.000000000 
> > +1000
> > +++ 2.6.x-xfs-new/fs/xfs/xfs_iget.c     2006-09-14 12:01:04.648209950 +1000
> > @@ -625,7 +617,7 @@ xfs_iput_new(xfs_inode_t    *ip,
> >         vn_trace_entry(vp, "xfs_iput_new", (inst_t *)__return_address);
> >  
> >         if ((ip->i_d.di_mode == 0)) {
> > -               ASSERT(!(ip->i_flags & XFS_IRECLAIMABLE));
> > +               ASSERT(!xfs_iflags_test(ip, XFS_IRECLAIMABLE)) {

+               ASSERT(!xfs_iflags_test(ip, XFS_IRECLAIMABLE));


> > Index: 2.6.x-xfs-new/fs/xfs/xfs_inode.h
> > ===================================================================
> > --- 2.6.x-xfs-new.orig/fs/xfs/xfs_inode.h       2006-09-14 11:18:52.000000000 
> > +1000
> > +++ 2.6.x-xfs-new/fs/xfs/xfs_inode.h    2006-09-14 12:32:16.395321563 +1000
> > @@ -305,6 +305,47 @@ typedef struct xfs_inode {
> >  #endif
> >  } xfs_inode_t;
> >  
> > +
> > +/*
> > + * i_flags helper functions
> > + */
> > +static inline void
> > +__xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
> > +{
> > +       ip->i_flags |= flags;
> > +}
> > +
> > +static inline void
> > +xfs_iflags_set(xfs_inode_t *ip, unsigned short flags)
> > +{
> > +       spin_lock(&ip->i_flags_lock);
> > +       __xfs_iflag_set(ip, flags);

+       __xfs_iflags_set(ip, flags);


David Chinner wrote:
> On Fri, Oct 06, 2006 at 01:26:17PM +1000, David Chinner wrote:
>> I think this is a much better way of fixing the problem, but it needs
>> a little tweaking. Also, it indicates that we can probably revert
>> some of the previous changes made in attempting to fix this bug.
>> I'll put together a new patch with this fix and as much of the
>> other fixes removed as possible and run some tests on it here.
>> It'l be a day or two before I have a tested patch ready....
> 
> I've run the attached patch through xfsqa but have not stress tested
> it yet.
> 
> Takenori - can you give this a run through your tests to see if
> it passes. I expect any races to trigger the BUG_ON statements
> in xfs_iunpin().
> 
> This patch sits on top of iflags locking cleanup I posted here:
> 
> http://oss.sgi.com/archives/xfs/2006-10/msg00014.html
> 
> Cheers,
> 
> Dave.

Best Regards,
--
Takenori Nagano, NEC
t-nagano@ah.jp.nec.com
