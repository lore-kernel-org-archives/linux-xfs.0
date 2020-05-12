Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D7ECA90AF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 16:10:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 675D52075E
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 16:10:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VSW65sY0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgELQKH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 12:10:07 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52600 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELQKH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 12:10:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CG8LYc011651;
        Tue, 12 May 2020 16:10:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=vN1/7u/HA/qqxGjcUz3SwaKfCHP7W39EukO59hP/b/E=;
 b=VSW65sY0XhoEE6PjComAZIYyNO2sOwR79TphiFE3Mlt7lbsFOGtGlfNXq7n46EY+Q/5n
 UzRNsP/ni4csmBAwH986nCQfTE9WTeXttcrIvJ5byMhev8V3NsGgB0DD9bxu6Kt2Sa7O
 Swd44znIUHcq8TyyzALGt7+y8s9+XhaYCzEKIhwrW2KG5tMR4oiCFJ3in0dokpabItsY
 luX517++ed9mMk7wfe9O0vRIi7tBG60wVyuwdYdAWjcl7j9D2s3nU4qcbl+RUDKABOoJ
 o8j0IghAnTtJrPglwu+2LlQxEDaJD+iNyUyxbmStZRycDYZi3zGf9/1CYDfBs0jNMWzp +g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 30x3gmm0sx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 16:10:01 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CG7xXS100506;
        Tue, 12 May 2020 16:10:00 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 30ydsqs5bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 16:10:00 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04CG9xY2025332;
        Tue, 12 May 2020 16:10:00 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 09:09:59 -0700
Date:   Tue, 12 May 2020 09:09:58 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] xfs: separate read-only variables in struct xfs_mount
Message-ID: <20200512160958.GF6714@magnolia>
References: <20200512092811.1846252-1-david@fromorbit.com>
 <20200512092811.1846252-2-david@fromorbit.com>
 <20200512123027.GA37029@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512123027.GA37029@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=5 mlxscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2005120122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 clxscore=1015 spamscore=0 lowpriorityscore=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 suspectscore=5
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2005120122
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 08:30:27AM -0400, Brian Foster wrote:
> On Tue, May 12, 2020 at 07:28:07PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Seeing massive cpu usage from xfs_agino_range() on one machine;
> > instruction level profiles look similar to another machine running
> > the same workload, only one machien is consuming 10x as much CPU as
> > the other and going much slower. The only real difference between
> > the two machines is core count per socket. Both are running
> > identical 16p/16GB virtual machine configurations
> > 
> ...
> > 
> > It's an improvement, hence indicating that separation and further
> > optimisation of read-only global filesystem data is worthwhile, but
> > it clearly isn't the underlying issue causing this specific
> > performance degradation.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > ---
> 
> Pretty neat improvement. Could you share your test script that generated
> the above? I have a 80 CPU box I'd be interested to give this a whirl
> on...
> 
> >  fs/xfs/xfs_mount.h | 50 +++++++++++++++++++++++++++-------------------
> >  1 file changed, 29 insertions(+), 21 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index aba5a15792792..712b3e2583316 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -88,21 +88,12 @@ typedef struct xfs_mount {
> >  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
> >  	char			*m_rtname;	/* realtime device name */
> >  	char			*m_logname;	/* external log device name */
> > -	int			m_bsize;	/* fs logical block size */
> >  	xfs_agnumber_t		m_agfrotor;	/* last ag where space found */
> >  	xfs_agnumber_t		m_agirotor;	/* last ag dir inode alloced */
> >  	spinlock_t		m_agirotor_lock;/* .. and lock protecting it */
> > -	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
> > -	uint			m_allocsize_log;/* min write size log bytes */
> > -	uint			m_allocsize_blocks; /* min write size blocks */
> >  	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
> >  	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
> >  	struct xlog		*m_log;		/* log specific stuff */
> > -	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
> > -	int			m_logbufs;	/* number of log buffers */
> > -	int			m_logbsize;	/* size of each log buffer */
> > -	uint			m_rsumlevels;	/* rt summary levels */
> > -	uint			m_rsumsize;	/* size of rt summary, bytes */
> >  	/*
> >  	 * Optional cache of rt summary level per bitmap block with the
> >  	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
> > @@ -117,9 +108,15 @@ typedef struct xfs_mount {
> >  	xfs_buftarg_t		*m_ddev_targp;	/* saves taking the address */
> >  	xfs_buftarg_t		*m_logdev_targp;/* ptr to log device */
> >  	xfs_buftarg_t		*m_rtdev_targp;	/* ptr to rt device */
> > +
> > +	/*
> > +	 * Read-only variables that are pre-calculated at mount time.
> > +	 */
> 
> The intent here is to align the entire section below, right? If so, the
> connection with the cache line alignment is a bit tenuous. Could we
> tweak and/or add a sentence to the comment to be more explicit? I.e.:
> 
> 	/*
> 	 * Align the following pre-calculated fields to a cache line to
> 	 * prevent cache line bouncing between frequently read and
> 	 * frequently written fields.
> 	 */

I kinda wish we laid out via comments each place we cross a 64b boundary
on a 64-bit CPU, but I guess seeing as some of these structures can
change size depending on config option and kernel version that's
probably just asking for confusion and madness.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D


> > +	int ____cacheline_aligned m_bsize;	/* fs logical block size */
> >  	uint8_t			m_blkbit_log;	/* blocklog + NBBY */
> >  	uint8_t			m_blkbb_log;	/* blocklog - BBSHIFT */
> >  	uint8_t			m_agno_log;	/* log #ag's */
> > +	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
> >  	uint			m_blockmask;	/* sb_blocksize-1 */
> >  	uint			m_blockwsize;	/* sb_blocksize in words */
> >  	uint			m_blockwmask;	/* blockwsize-1 */
> > @@ -138,20 +135,35 @@ typedef struct xfs_mount {
> >  	xfs_extlen_t		m_ag_prealloc_blocks; /* reserved ag blocks */
> >  	uint			m_alloc_set_aside; /* space we can't use */
> >  	uint			m_ag_max_usable; /* max space per AG */
> > -	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
> > -	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> > -	struct mutex		m_growlock;	/* growfs mutex */
> > +	int			m_dalign;	/* stripe unit */
> > +	int			m_swidth;	/* stripe width */
> > +	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
> > +	uint			m_allocsize_log;/* min write size log bytes */
> > +	uint			m_allocsize_blocks; /* min write size blocks */
> > +	int			m_logbufs;	/* number of log buffers */
> > +	int			m_logbsize;	/* size of each log buffer */
> > +	uint			m_rsumlevels;	/* rt summary levels */
> > +	uint			m_rsumsize;	/* size of rt summary, bytes */
> >  	int			m_fixedfsid[2];	/* unchanged for life of FS */
> > -	uint64_t		m_flags;	/* global mount flags */
> > -	bool			m_finobt_nores; /* no per-AG finobt resv. */
> >  	uint			m_qflags;	/* quota status flags */
> > +	uint64_t		m_flags;	/* global mount flags */
> > +	int64_t			m_low_space[XFS_LOWSP_MAX];
> > +	struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
> >  	struct xfs_trans_resv	m_resv;		/* precomputed res values */
> > +						/* low free space thresholds */
> > +	bool			m_always_cow;
> > +	bool			m_fail_unmount;
> > +	bool			m_finobt_nores; /* no per-AG finobt resv. */
> > +	/*
> > +	 * End of pre-calculated read-only variables
> > +	 */
> 
> m_always_cow and m_fail_unmount are mutable via sysfs knobs so
> technically not read-only. I'm assuming that has no practical impact on
> the performance optimization, but it might be worth leaving them where
> they are to avoid confusion.
> 
> With those nits fixed:
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +
> > +	struct radix_tree_root	m_perag_tree;	/* per-ag accounting info */
> > +	spinlock_t		m_perag_lock;	/* lock for m_perag_tree */
> > +	struct mutex		m_growlock;	/* growfs mutex */
> >  	uint64_t		m_resblks;	/* total reserved blocks */
> >  	uint64_t		m_resblks_avail;/* available reserved blocks */
> >  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> > -	int			m_dalign;	/* stripe unit */
> > -	int			m_swidth;	/* stripe width */
> > -	uint8_t			m_sectbb_log;	/* sectlog - BBSHIFT */
> >  	atomic_t		m_active_trans;	/* number trans frozen */
> >  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
> >  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
> > @@ -160,8 +172,6 @@ typedef struct xfs_mount {
> >  	struct delayed_work	m_cowblocks_work; /* background cow blocks
> >  						     trimming */
> >  	bool			m_update_sb;	/* sb needs update in mount */
> > -	int64_t			m_low_space[XFS_LOWSP_MAX];
> > -						/* low free space thresholds */
> >  	struct xfs_kobj		m_kobj;
> >  	struct xfs_kobj		m_error_kobj;
> >  	struct xfs_kobj		m_error_meta_kobj;
> > @@ -191,8 +201,6 @@ typedef struct xfs_mount {
> >  	 */
> >  	uint32_t		m_generation;
> >  
> > -	bool			m_always_cow;
> > -	bool			m_fail_unmount;
> >  #ifdef DEBUG
> >  	/*
> >  	 * Frequency with which errors are injected.  Replaces xfs_etest; the
> > -- 
> > 2.26.1.301.g55bc3eb7cb9
> > 
> 
