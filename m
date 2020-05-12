Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55638C2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 21:43:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3352220747
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 21:43:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728313AbgELVnj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 17:43:39 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:45267 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726268AbgELVnj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 17:43:39 -0400
Received: from dread.disaster.area (pa49-195-157-175.pa.nsw.optusnet.com.au [49.195.157.175])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 82121D59253;
        Wed, 13 May 2020 07:43:35 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jYcgY-0000Aw-6y; Wed, 13 May 2020 07:43:34 +1000
Date:   Wed, 13 May 2020 07:43:34 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: separate read-only variables in struct xfs_mount
Message-ID: <20200512214334.GU2040@dread.disaster.area>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-2-david@fromorbit.com>
 <20200512123027.GA37029@bfoster>
 <20200512160958.GF6714@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512160958.GF6714@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=X6os11be c=1 sm=1 tr=0
        a=ONQRW0k9raierNYdzxQi9Q==:117 a=ONQRW0k9raierNYdzxQi9Q==:17
        a=kj9zAlcOel0A:10 a=sTwFKg_x9MkA:10 a=20KFwNOVAAAA:8 a=7-415B0cAAAA:8
        a=sdXVU581OKU0INSPEhMA:9 a=pye_cauB-YKt0GKN:21 a=ZL-6aD14BXxr3rRo:21
        a=CjuIK1q_8ugA:10 a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 09:09:58AM -0700, Darrick J. Wong wrote:
> On Tue, May 12, 2020 at 08:30:27AM -0400, Brian Foster wrote:
> > On Tue, May 12, 2020 at 07:28:07PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > Seeing massive cpu usage from xfs_agino_range() on one machine;
> > > instruction level profiles look similar to another machine running
> > > the same workload, only one machien is consuming 10x as much CPU as
> > > the other and going much slower. The only real difference between
> > > the two machines is core count per socket. Both are running
> > > identical 16p/16GB virtual machine configurations
> > > 
> > ...
> > > 
> > > It's an improvement, hence indicating that separation and further
> > > optimisation of read-only global filesystem data is worthwhile, but
> > > it clearly isn't the underlying issue causing this specific
> > > performance degradation.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > 
> > Pretty neat improvement. Could you share your test script that generated
> > the above? I have a 80 CPU box I'd be interested to give this a whirl
> > on...
> > 
> > >  fs/xfs/xfs_mount.h | 50 +++++++++++++++++++++++++++-------------------
> > >  1 file changed, 29 insertions(+), 21 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > index aba5a15792792..712b3e2583316 100644
> > > --- a/fs/xfs/xfs_mount.h
> > > +++ b/fs/xfs/xfs_mount.h
> > > @@ -88,21 +88,12 @@ typedef struct xfs_mount {
> > >  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
> > >  	char			*m_rtname;	/* realtime device name */
> > >  	char			*m_logname;	/* external log device name */
> > > -	int			m_bsize;	/* fs logical block size */
> > >  	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
> > >  	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
> > >  	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
> > > -	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
> > > -	uint			m_allocsize_log;/* min write size log bytes */
> > > -	uint			m_allocsize_blocks; /* min write size blocks */
> > >  	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
> > >  	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
> > >  	struct xlog		*m_log;		/* log specific stuff */
> > > -	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
> > > -	int			m_logbufs;	/* number of log buffers */
> > > -	int			m_logbsize;	/* size of each log buffer */
> > > -	uint			m_rsumlevels;	/* rt summary levels */
> > > -	uint			m_rsumsize;	/* size of rt summary, bytes */
> > >  	/*
> > >  	 * Optional cache of rt summary level per bitmap block with the
> > >  	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
> > > @@ -117,9 +108,15 @@ typedef struct xfs_mount {
> > >  	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
> > >  	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
> > >  	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
> > > +
> > > +	/*
> > > +	 * Read-only variables that are pre-calculated at mount time.
> > > +	 */
> > 
> > The intent here is to align the entire section below, right? If so, the
> > connection with the cache line alignment is a bit tenuous. Could we
> > tweak and/or add a sentence to the comment to be more explicit? I.e.:
> > 
> > 	/*
> > 	 * Align the following pre-calculated fields to a cache line to
> > 	 * prevent cache line bouncing between frequently read and
> > 	 * frequently written fields.
> > 	 */
> 
> I kinda wish we laid out via comments each place we cross a 64b boundary
> on a 64-bit CPU, but I guess seeing as some of these structures can
> change size depending on config option and kernel version that's
> probably just asking for confusion and madness.

Yup, that's why we have tools like pahole. Stuff like lock debugging
or even different locking options change the size and layout of
structures like this, so you really have to look at pahole output to
determine what sits in the same cacheline for any given kernel
build.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
