Return-Path: <SRS0=6B5E=57=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C603C2BA19
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 15:38:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D05F20767
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Apr 2020 15:38:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fg6oU9UP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgDOPiT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Apr 2020 11:38:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:43634 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1414766AbgDOPiM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 15 Apr 2020 11:38:12 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03FFc4re129471;
        Wed, 15 Apr 2020 15:38:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aKsxLGoIX/gEA92FMh26o3dPTMSrTFggEWR+JIVabn0=;
 b=fg6oU9UP0rWk5KnJu3jpR4r9sbHtNMZ3G1RylDq4GetGPatcZaKVwMTLibjYH2nFBdgX
 0dODpN5IeHvzIVEqDdcWWdQvMiUSl9oJBiIZgwTt4eauHV7X+7lRE5uwQ3aYAuB1uzDM
 z3W+XIWKmwTJVS5Nju3tIjcfEpqniIELeWpGXF6Ys5RKtTqonp8iBlpmjUPRX8CfAjfI
 h1+WlRSzfg9GBUBtWDXqVI7ExLAKTWnGdpa7T0u6W2WlQdtTXYZRKieDZJOY+ypihU7c
 AkKb0r3EJUm9J+X1lCevQ75zoBRy6TO3Lro31fad7AVCMUilboZgElESNCL6uqygJovI tw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 30e0aa1pj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 15:38:07 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03FFbTKH153983;
        Wed, 15 Apr 2020 15:38:07 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30dn8wes9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Apr 2020 15:38:07 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03FFc5Gt014708;
        Wed, 15 Apr 2020 15:38:05 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 15 Apr 2020 08:38:05 -0700
Date:   Wed, 15 Apr 2020 08:38:04 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2] xfs: move inode flush to the sync workqueue
Message-ID: <20200415153804.GT6742@magnolia>
References: <20200415041529.GL6742@magnolia>
 <20200415110504.GA2140@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415110504.GA2140@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=2 malwarescore=0 spamscore=0 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150115
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9592 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 impostorscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 suspectscore=2 adultscore=0 spamscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150115
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Apr 15, 2020 at 07:05:04AM -0400, Brian Foster wrote:
> On Tue, Apr 14, 2020 at 09:15:29PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the inode dirty data flushing to a workqueue so that multiple
> > threads can take advantage of a single thread's flushing work.  The
> > ratelimiting technique used in bdd4ee4 was not successful, because
> > threads that skipped the inode flush scan due to ratelimiting would
> > ENOSPC early, which caused occasional (but noticeable) changes in
> > behavior and sporadic fstest regressions.
> > 
> > Therfore, make all the writer threads wait on a single inode flush,
> 
> Therefore
> 
> > which eliminates both the stampeding hoards of flushers and the small
> 
> 					hordes ? :)

Keybord malfulction, spel chekar offline...

Thanks for the review. :)

--D

> 
> > window in which a write could fail with ENOSPC because it lost the
> > ratelimit race after even another thread freed space.
> > 
> > Fixes: bdd4ee4f8407 ("xfs: ratelimit inode flush on buffered write ENOSPC")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > v2: run it on the sync workqueue
> > ---
> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> >  fs/xfs/xfs_mount.h |    6 +++++-
> >  fs/xfs/xfs_super.c |   40 ++++++++++++++++++++++------------------
> >  2 files changed, 27 insertions(+), 19 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > index 50c43422fa17..b2e4598fdf7d 100644
> > --- a/fs/xfs/xfs_mount.h
> > +++ b/fs/xfs/xfs_mount.h
> > @@ -167,8 +167,12 @@ typedef struct xfs_mount {
> >  	struct xfs_kobj		m_error_meta_kobj;
> >  	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
> >  	struct xstats		m_stats;	/* per-fs stats */
> > -	struct ratelimit_state	m_flush_inodes_ratelimit;
> >  
> > +	/*
> > +	 * Workqueue item so that we can coalesce multiple inode flush attempts
> > +	 * into a single flush.
> > +	 */
> > +	struct work_struct	m_flush_inodes_work;
> >  	struct workqueue_struct *m_buf_workqueue;
> >  	struct workqueue_struct	*m_unwritten_workqueue;
> >  	struct workqueue_struct	*m_cil_workqueue;
> > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > index abf06bf9c3f3..424bb9a2d532 100644
> > --- a/fs/xfs/xfs_super.c
> > +++ b/fs/xfs/xfs_super.c
> > @@ -516,6 +516,20 @@ xfs_destroy_mount_workqueues(
> >  	destroy_workqueue(mp->m_buf_workqueue);
> >  }
> >  
> > +static void
> > +xfs_flush_inodes_worker(
> > +	struct work_struct	*work)
> > +{
> > +	struct xfs_mount	*mp = container_of(work, struct xfs_mount,
> > +						   m_flush_inodes_work);
> > +	struct super_block	*sb = mp->m_super;
> > +
> > +	if (down_read_trylock(&sb->s_umount)) {
> > +		sync_inodes_sb(sb);
> > +		up_read(&sb->s_umount);
> > +	}
> > +}
> > +
> >  /*
> >   * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
> >   * or a page lock. We use sync_inodes_sb() here to ensure we block while waiting
> > @@ -526,15 +540,15 @@ void
> >  xfs_flush_inodes(
> >  	struct xfs_mount	*mp)
> >  {
> > -	struct super_block	*sb = mp->m_super;
> > -
> > -	if (!__ratelimit(&mp->m_flush_inodes_ratelimit))
> > +	/*
> > +	 * If flush_work() returns true then that means we waited for a flush
> > +	 * which was already in progress.  Don't bother running another scan.
> > +	 */
> > +	if (flush_work(&mp->m_flush_inodes_work))
> >  		return;
> >  
> > -	if (down_read_trylock(&sb->s_umount)) {
> > -		sync_inodes_sb(sb);
> > -		up_read(&sb->s_umount);
> > -	}
> > +	queue_work(mp->m_sync_workqueue, &mp->m_flush_inodes_work);
> > +	flush_work(&mp->m_flush_inodes_work);
> >  }
> >  
> >  /* Catch misguided souls that try to use this interface on XFS */
> > @@ -1369,17 +1383,6 @@ xfs_fc_fill_super(
> >  	if (error)
> >  		goto out_free_names;
> >  
> > -	/*
> > -	 * Cap the number of invocations of xfs_flush_inodes to 16 for every
> > -	 * quarter of a second.  The magic numbers here were determined by
> > -	 * observation neither to cause stalls in writeback when there are a
> > -	 * lot of IO threads and the fs is near ENOSPC, nor cause any fstest
> > -	 * regressions.  YMMV.
> > -	 */
> > -	ratelimit_state_init(&mp->m_flush_inodes_ratelimit, HZ / 4, 16);
> > -	ratelimit_set_flags(&mp->m_flush_inodes_ratelimit,
> > -			RATELIMIT_MSG_ON_RELEASE);
> > -
> >  	error = xfs_init_mount_workqueues(mp);
> >  	if (error)
> >  		goto out_close_devices;
> > @@ -1752,6 +1755,7 @@ static int xfs_init_fs_context(
> >  	spin_lock_init(&mp->m_perag_lock);
> >  	mutex_init(&mp->m_growlock);
> >  	atomic_set(&mp->m_active_trans, 0);
> > +	INIT_WORK(&mp->m_flush_inodes_work, xfs_flush_inodes_worker);
> >  	INIT_DELAYED_WORK(&mp->m_reclaim_work, xfs_reclaim_worker);
> >  	INIT_DELAYED_WORK(&mp->m_eofblocks_work, xfs_eofblocks_worker);
> >  	INIT_DELAYED_WORK(&mp->m_cowblocks_work, xfs_cowblocks_worker);
> > 
> 
