Return-Path: <SRS0=k9vQ=62=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B43EC2D0F8
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 22:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC64620747
	for <linux-xfs@archiver.kernel.org>; Tue, 12 May 2020 22:59:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HR3N2c3N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgELW7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 May 2020 18:59:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:44700 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725938AbgELW7X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 May 2020 18:59:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CMvQtP163732;
        Tue, 12 May 2020 22:59:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=bgE/ldxHg4fGamD8iLXsvgdZpieejGa83KP6r5hQZn8=;
 b=HR3N2c3N7P7Cr4mLQjZzzsrfjK94ICHxBHOoS4+q9ETJ562BoYspXgGFwRQ9oMaYS2hx
 w3WB+4OnDlAO+Qa4UNgS3vVZO+KUfH+nWKiXEUlkISS8ZHQ3Gp3/BURA4AMx/NU8cI7B
 3fKx0+A5bozE8FuN8tjvv7VKBJe9b3UkqIpMENexV81+OuMRmY6oTvsJteGyTYFkjgM0
 V00aAygRX8EFy+Gh1uaxxmJHVvO8aSfWUqV8FFa3E2J5XvaRO3OelfxFUy5vj8GAE70b
 y1OFL2GbAbk218rkG+DoTDZAwDyGdqs+6DkiySRhoQTSXg9+9t3948T9rmj1PeqRS5vr +Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 3100xw956x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 12 May 2020 22:59:20 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04CMrxG1165404;
        Tue, 12 May 2020 22:59:19 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 3100yd89yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 May 2020 22:59:19 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 04CMxJWW016170;
        Tue, 12 May 2020 22:59:19 GMT
Received: from localhost (/10.159.139.160)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 12 May 2020 15:59:18 -0700
Date:   Tue, 12 May 2020 15:59:18 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: convert m_active_trans counter to per-cpu
Message-ID: <20200512225918.GA1984748@magnolia>
References: <20200512025949.1807131-1-david@fromorbit.com>
 <20200512025949.1807131-3-david@fromorbit.com>
 <20200512160352.GE6714@magnolia>
 <20200512213919.GT2040@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512213919.GT2040@dread.disaster.area>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 suspectscore=1 adultscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005120171
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9619 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005120171
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 13, 2020 at 07:39:19AM +1000, Dave Chinner wrote:
> On Tue, May 12, 2020 at 09:03:52AM -0700, Darrick J. Wong wrote:
> > On Tue, May 12, 2020 at 12:59:49PM +1000, Dave Chinner wrote:
> > > From: Dave Chinner <dchinner@redhat.com>
> > > 
> > > It's a global atomic counter, and we are hitting it at a rate of
> > > half a million transactions a second, so it's bouncing the counter
> > > cacheline all over the place on large machines. Convert it to a
> > > per-cpu counter.
> > > 
> > > And .... oh wow, that was unexpected!
> > > 
> > > Concurrent create, 50 million inodes, identical 16p/16GB virtual
> > > machines on different physical hosts. Machine A has twice the CPU
> > > cores per socket of machine B:
> > > 
> > > 		unpatched	patched
> > > machine A:	3m45s		2m27s
> > > machine B:	4m13s		4m14s
> > > 
> > > Create rates:
> > > 		unpatched	patched
> > > machine A:	246k+/-15k	384k+/-10k
> > > machine B:	225k+/-13k	223k+/-11k
> > > 
> > > Concurrent rm of same 50 million inodes:
> > > 
> > > 		unpatched	patched
> > > machine A:	8m30s		3m09s
> > > machine B:	4m02s		4m51s
> > > 
> > > The transaction rate on the fast machine went from about 250k/sec to
> > > over 600k/sec, which indicates just how much of a bottleneck this
> > > atomic counter was.
> > > 
> > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > ---
> > >  fs/xfs/xfs_mount.h |  2 +-
> > >  fs/xfs/xfs_super.c | 12 +++++++++---
> > >  fs/xfs/xfs_trans.c |  6 +++---
> > >  3 files changed, 13 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > index 712b3e2583316..af3d8b71e9591 100644
> > > --- a/fs/xfs/xfs_mount.h
> > > +++ b/fs/xfs/xfs_mount.h
> > > @@ -84,6 +84,7 @@ typedef struct xfs_mount {
> > >  	 * extents or anything related to the rt device.
> > >  	 */
> > >  	struct percpu_counter	m_delalloc_blks;
> > > +	struct percpu_counter	m_active_trans;	/* in progress xact counter */
> > >  
> > >  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
> > >  	char			*m_rtname;	/* realtime device name */
> > > @@ -164,7 +165,6 @@ typedef struct xfs_mount {
> > >  	uint64_t		m_resblks;	/* total reserved blocks */
> > >  	uint64_t		m_resblks_avail;/* available reserved blocks */
> > >  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> > > -	atomic_t		m_active_trans;	/* number trans frozen */
> > >  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
> > >  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
> > >  	struct delayed_work	m_eofblocks_work; /* background eof blocks
> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index e80bd2c4c279e..bc4853525ce18 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -883,7 +883,7 @@ xfs_quiesce_attr(
> > >  	int	error = 0;
> > >  
> > >  	/* wait for all modifications to complete */
> > > -	while (atomic_read(&mp->m_active_trans) > 0)
> > > +	while (percpu_counter_sum(&mp->m_active_trans) > 0)
> > >  		delay(100);
> > 
> > Hmm.  AFAICT, this counter stops us from quiescing the log while
> > transactions are still running.  We only quiesce the log for unmount,
> > remount-ro, and fs freeze.  Given that we now start_sb_write for
> > xfs_getfsmap and the background freeing threads, I wonder, do we still
> > need this at all?
> 
> Perhaps not - I didn't look that far. It's basically only needed to
> protect against XFS_TRANS_NO_WRITECOUNT transactions, which is
> really just xfs_sync_sb() these days. This can come from several
> places, but the only one outside of mount/freeze/unmount is the log
> worker.  Perhaps the log worker can be cancelled before calling
> xfs_quiesce_attr() rather than after?

What if we skip bumping m_active_trans for NO_WRITECOUNT transactions?
There aren't that many of them, and it'd probably better for memory
consumption on 1000-core systems. ;)

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
