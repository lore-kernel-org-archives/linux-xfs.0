Return-Path: <SRS0=w6e5=56=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFEC1C2BA2B
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 00:31:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B366C21655
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Apr 2020 00:31:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iS46H0cc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390457AbgDNAb2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Apr 2020 20:31:28 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:40000 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390456AbgDNAb1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 13 Apr 2020 20:31:27 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E0Dc5o186903;
        Tue, 14 Apr 2020 00:31:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=C9DyXwY0IvzHehu8kJ0b/KlUy9/IKvHFB6n+FXK9eoI=;
 b=iS46H0ccWezYz370H53i64fFT4M9x9Rqxzdsz245FMDZagjlGe53V+40vdSqwJuBoCsd
 n8XR5XFQDeP65+YDDSVporc6zonA2nFLzsXW6KUjjaXkJT9j5hx/LfbcwNaGMCAkVoaQ
 eKIaOlLrZfp4uzJ+2+QoC9/QULRdSxUX/7tK3t2N5B6XGrSQaxYRczyRtKzpeXd1xyRP
 4lTHHRxrxK2hQ1GNpmyG5O8/qVflwDgLMYfXfx7Z4O9l3ICWd92xWLi27gCD8j2nohe3
 rVHsBGIgKZz2tbP2WGUSJTDuMzL0re3mRBBpyebOzLWsGMefgMYqratzC8/m5xEmJz/I Fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 30b6hphfrv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 00:31:23 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03E0D53I009634;
        Tue, 14 Apr 2020 00:31:22 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 30cta8gej9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Apr 2020 00:31:22 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 03E0VMDW027544;
        Tue, 14 Apr 2020 00:31:22 GMT
Received: from localhost (/10.159.239.215)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Apr 2020 17:31:22 -0700
Date:   Mon, 13 Apr 2020 17:31:21 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: move inode flush to a workqueue
Message-ID: <20200414003121.GD6742@magnolia>
References: <158674021112.3253017.16592621806726469169.stgit@magnolia>
 <158674021749.3253017.16036198065081499968.stgit@magnolia>
 <20200413123109.GB57285@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200413123109.GB57285@bfoster>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=2
 spamscore=0 adultscore=0 mlxscore=0 phishscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9590 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0
 mlxlogscore=999 clxscore=1015 mlxscore=0 phishscore=0 suspectscore=2
 lowpriorityscore=0 bulkscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004140000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 13, 2020 at 08:31:09AM -0400, Brian Foster wrote:
> On Sun, Apr 12, 2020 at 06:10:17PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Move the inode dirty data flushing to a workqueue so that multiple
> > threads can take advantage of a single thread's flush work.  The
> > ratelimiting technique was not successful, because threads that skipped
> > the inode flush scan due to ratelimiting would ENOSPC early and
> > apparently now there are complaints about that.  So make everyone wait.
> > 
> > Fixes: bdd4ee4f8407 ("xfs: ratelimit inode flush on buffered write ENOSPC")
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Seems reasonable in general, but do we really want to to dump a longish
> running filesystem sync to the system workqueue? It looks like there are
> a lot of existing users so I can't really tell if there are major
> restrictions or not, but it seems risk of disruption is higher than
> necessary if we dump one or more full fs syncs to it..

Hmm, I guess I should look at the other flush_work user (the CIL) to see
if there's any potential for conflicts.  IIRC the system workqueue will
spawn more threads if someone blocks too long, but maybe we ought to
use system_long_wq for these kinds of things...

--D

> Brian
> 
> >  fs/xfs/xfs_mount.h |    6 +++++-
> >  fs/xfs/xfs_super.c |   40 ++++++++++++++++++++++------------------
> >  2 files changed, 27 insertions(+), 19 deletions(-)
> > 
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
> > index abf06bf9c3f3..dced03a4571d 100644
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
> > +	schedule_work(&mp->m_flush_inodes_work);
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
