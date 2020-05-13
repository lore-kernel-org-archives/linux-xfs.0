Return-Path: <SRS0=Dhh5=63=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D89BC433DF
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 17:18:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD6AC205ED
	for <linux-xfs@archiver.kernel.org>; Wed, 13 May 2020 17:18:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kZSef8/X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389855AbgEMRSD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 May 2020 13:18:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:40780 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732731AbgEMRSD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 May 2020 13:18:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DHDAJ6046966;
        Wed, 13 May 2020 17:18:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SnU/v5nI4abjtlbs4dyCj9/83belEwfEgdxOba5C5AQ=;
 b=kZSef8/XX3wTk0NDmP/To+XRhYmnjEQWU35rwjP0qwSOHx4lI8qhJwJ280AEK6yR2sNF
 fb5RnwveVA9k1mxynlpVRIA3Vxh83G6jmMgEWoM3DPlPbA4SAAZJyOquf0JGwLPTlSaW
 gzVoBAS5bMKqMEYSAjZkJp2uEgYiANE6dl+wR3Z1qONbDUgCttjs7LQrTuBy17ZWIGix
 mcJgHqomgy9qnLlt1XhcOXRwdsqSy6+dRYIZityXCplGZgiu12vc0PW+5EomjUI3zgnB
 LZIUs86sNPj4506BBabSMVT7JQWVxQJapp54pcl5LWUcZsTlgz2jra/3jEifMxARH0CJ hA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 3100xwdhj6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 13 May 2020 17:18:01 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04DHDvxZ124234;
        Wed, 13 May 2020 17:18:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 3100yaxddf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 May 2020 17:18:00 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04DHI0kR019677;
        Wed, 13 May 2020 17:18:00 GMT
Received: from localhost (/10.159.244.214)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 13 May 2020 10:17:59 -0700
Date:   Wed, 13 May 2020 10:17:59 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: convert m_active_trans counter to per-cpu
Message-ID: <20200513171759.GZ6714@magnolia>
References: <20200512025949.1807131-1-david@fromorbit.com>
 <20200512025949.1807131-3-david@fromorbit.com>
 <20200512160352.GE6714@magnolia>
 <20200512213919.GT2040@dread.disaster.area>
 <20200512225918.GA1984748@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200512225918.GA1984748@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 phishscore=0
 adultscore=0 suspectscore=1 mlxscore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005130150
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9620 signatures=668687
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 lowpriorityscore=0
 suspectscore=1 mlxlogscore=999 clxscore=1015 cotscore=-2147483648
 mlxscore=0 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005130150
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, May 12, 2020 at 03:59:18PM -0700, Darrick J. Wong wrote:
> On Wed, May 13, 2020 at 07:39:19AM +1000, Dave Chinner wrote:
> > On Tue, May 12, 2020 at 09:03:52AM -0700, Darrick J. Wong wrote:
> > > On Tue, May 12, 2020 at 12:59:49PM +1000, Dave Chinner wrote:
> > > > From: Dave Chinner <dchinner@redhat.com>
> > > > 
> > > > It's a global atomic counter, and we are hitting it at a rate of
> > > > half a million transactions a second, so it's bouncing the counter
> > > > cacheline all over the place on large machines. Convert it to a
> > > > per-cpu counter.
> > > > 
> > > > And .... oh wow, that was unexpected!
> > > > 
> > > > Concurrent create, 50 million inodes, identical 16p/16GB virtual
> > > > machines on different physical hosts. Machine A has twice the CPU
> > > > cores per socket of machine B:
> > > > 
> > > > 		unpatched	patched
> > > > machine A:	3m45s		2m27s
> > > > machine B:	4m13s		4m14s
> > > > 
> > > > Create rates:
> > > > 		unpatched	patched
> > > > machine A:	246k+/-15k	384k+/-10k
> > > > machine B:	225k+/-13k	223k+/-11k
> > > > 
> > > > Concurrent rm of same 50 million inodes:
> > > > 
> > > > 		unpatched	patched
> > > > machine A:	8m30s		3m09s
> > > > machine B:	4m02s		4m51s
> > > > 
> > > > The transaction rate on the fast machine went from about 250k/sec to
> > > > over 600k/sec, which indicates just how much of a bottleneck this
> > > > atomic counter was.
> > > > 
> > > > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> > > > ---
> > > >  fs/xfs/xfs_mount.h |  2 +-
> > > >  fs/xfs/xfs_super.c | 12 +++++++++---
> > > >  fs/xfs/xfs_trans.c |  6 +++---
> > > >  3 files changed, 13 insertions(+), 7 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> > > > index 712b3e2583316..af3d8b71e9591 100644
> > > > --- a/fs/xfs/xfs_mount.h
> > > > +++ b/fs/xfs/xfs_mount.h
> > > > @@ -84,6 +84,7 @@ typedef struct xfs_mount {
> > > >  	 * extents or anything related to the rt device.
> > > >  	 */
> > > >  	struct percpu_counter	m_delalloc_blks;
> > > > +	struct percpu_counter	m_active_trans;	/* in progress xact counter */
> > > >  
> > > >  	struct xfs_buf		*m_sb_bp;	/* buffer for superblock */
> > > >  	char			*m_rtname;	/* realtime device name */
> > > > @@ -164,7 +165,6 @@ typedef struct xfs_mount {
> > > >  	uint64_t		m_resblks;	/* total reserved blocks */
> > > >  	uint64_t		m_resblks_avail;/* available reserved blocks */
> > > >  	uint64_t		m_resblks_save;	/* reserved blks @ remount,ro */
> > > > -	atomic_t		m_active_trans;	/* number trans frozen */
> > > >  	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
> > > >  	struct delayed_work	m_reclaim_work;	/* background inode reclaim */
> > > >  	struct delayed_work	m_eofblocks_work; /* background eof blocks
> > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > index e80bd2c4c279e..bc4853525ce18 100644
> > > > --- a/fs/xfs/xfs_super.c
> > > > +++ b/fs/xfs/xfs_super.c
> > > > @@ -883,7 +883,7 @@ xfs_quiesce_attr(
> > > >  	int	error = 0;
> > > >  
> > > >  	/* wait for all modifications to complete */
> > > > -	while (atomic_read(&mp->m_active_trans) > 0)
> > > > +	while (percpu_counter_sum(&mp->m_active_trans) > 0)
> > > >  		delay(100);
> > > 
> > > Hmm.  AFAICT, this counter stops us from quiescing the log while
> > > transactions are still running.  We only quiesce the log for unmount,
> > > remount-ro, and fs freeze.  Given that we now start_sb_write for
> > > xfs_getfsmap and the background freeing threads, I wonder, do we still
> > > need this at all?
> > 
> > Perhaps not - I didn't look that far. It's basically only needed to
> > protect against XFS_TRANS_NO_WRITECOUNT transactions, which is
> > really just xfs_sync_sb() these days. This can come from several
> > places, but the only one outside of mount/freeze/unmount is the log
> > worker.  Perhaps the log worker can be cancelled before calling
> > xfs_quiesce_attr() rather than after?
> 
> What if we skip bumping m_active_trans for NO_WRITECOUNT transactions?
> There aren't that many of them, and it'd probably better for memory
> consumption on 1000-core systems. ;)

I think the log worker is the only piece remaining that uses
NO_WRITECOUNT transactions without fsfreeze protection, and AFAICT we
should be able to cancel it at the beginning of xfs_quiesce_attr since
the function forces the log out and pushes the AIL manually.  That seems
like it should enable us to remove m_active_trans...

--D

> --D
> 
> > Cheers,
> > 
> > Dave.
> > -- 
> > Dave Chinner
> > david@fromorbit.com
