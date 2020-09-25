Return-Path: <SRS0=2WGG=DC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15D16C4727E
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 18:59:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0AD521D7A
	for <linux-xfs@archiver.kernel.org>; Fri, 25 Sep 2020 18:59:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gVwC37EK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbgIYS7X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 25 Sep 2020 14:59:23 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:37750 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgIYS7W (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 25 Sep 2020 14:59:22 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PInd9X018462;
        Fri, 25 Sep 2020 18:59:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mo9HJm/mUTnCimry8x9e5LUo8LS0JPBJ8wwL7pkkYEE=;
 b=gVwC37EK8F2LjZgQl0qrorF6OUHco/87Kwab1otuCGP09sBDvwMo1vuNPiEvlzm55RIT
 +CptkhadudLZqc35x2W+NeXpdVyP8UENn5cNVwShDiUAOU3w4bTo4M8YrkJjMhKvz0Bw
 rZ85k+vz2++pfsKc6z7HliItA83I3D1N2y6+kxqvGXr0CAcgvDs5nkeHkVNKFWePRZLI
 SbPXLDdqczJqdnloQSoUMWItX+izTalJ9DEgIBQRHWkMS5aRpkFEYqnS9Ib4Ni1Ho469
 n0GT+4Qit0ygf+astgMU2DpcDyZI7qBGUSoLgMVLCQAzNQh25b78A3wfVnXglDg2nL8U VA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 33q5rgwmuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 25 Sep 2020 18:59:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08PIkSet050021;
        Fri, 25 Sep 2020 18:59:19 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 33r28yqv2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 25 Sep 2020 18:59:19 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08PIxIAt010758;
        Fri, 25 Sep 2020 18:59:18 GMT
Received: from localhost (/10.159.232.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 25 Sep 2020 11:59:18 -0700
Date:   Fri, 25 Sep 2020 11:59:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 2/3] xfs: expose the log push threshold
Message-ID: <20200925185917.GM7964@magnolia>
References: <160083917978.1401135.9502772939838940679.stgit@magnolia>
 <160083919333.1401135.1467785318303966214.stgit@magnolia>
 <20200925111511.GA2646051@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200925111511.GA2646051@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 suspectscore=5 adultscore=0 bulkscore=0 malwarescore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250131
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9755 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 clxscore=1015 suspectscore=5 phishscore=0 malwarescore=0
 priorityscore=1501 mlxlogscore=999 adultscore=0 bulkscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009250131
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 25, 2020 at 07:15:11AM -0400, Brian Foster wrote:
> On Tue, Sep 22, 2020 at 10:33:13PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Separate the computation of the log push threshold and the push logic in
> > xlog_grant_push_ail.  This enables higher level code to determine (for
> > example) that it is holding on to a logged intent item and the log is so
> > busy that it is more than 75% full.  In that case, it would be desirable
> > to move the log item towards the head to release the tail, which we will
> > cover in the next patch.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_log.c |   41 +++++++++++++++++++++++++++++++----------
> >  fs/xfs/xfs_log.h |    2 ++
> >  2 files changed, 33 insertions(+), 10 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> > index ad0c69ee8947..62c9e0aaa7df 100644
> > --- a/fs/xfs/xfs_log.c
> > +++ b/fs/xfs/xfs_log.c
> > @@ -1475,14 +1475,15 @@ xlog_commit_record(
> >  }
> >  
> >  /*
> > - * Push on the buffer cache code if we ever use more than 75% of the on-disk
> > - * log space.  This code pushes on the lsn which would supposedly free up
> > - * the 25% which we want to leave free.  We may need to adopt a policy which
> > - * pushes on an lsn which is further along in the log once we reach the high
> > - * water mark.  In this manner, we would be creating a low water mark.
> > + * Compute the LSN push target needed to push on the buffer cache code if we
> > + * ever use more than 75% of the on-disk log space.  This code pushes on the
> > + * lsn which would supposedly free up the 25% which we want to leave free.  We
> > + * may need to adopt a policy which pushes on an lsn which is further along in
> > + * the log once we reach the high water mark.  In this manner, we would be
> > + * creating a low water mark.
> >   */
> 
> Probably no need to duplicate so much of the original comment between
> the two functions. I'd just put something like "calculate the AIL push
> target based on the provided log reservation requirement ..." or
> otherwise just remove it. That aside, LGTM:

Hmm, how about this for xlog_grant_push_threshold:

/*
 * Compute the LSN that we'd need to push the log tail towards in order
 * to have (a) enough on-disk log space to log the number of bytes
 * specified, (b) at least 25% of the log space free, and (c) at least
 * 256 blocks free.  If the log free space already meets all three
 * thresholds, this function returns NULLCOMMITLSN.
 */

and then this for xlog_grant_push_ail:

/*
 * Push the tail of the log if we need to do so to maintain the free log
 * space thresholds set out by xlog_grant_push_threshold.  We may need
 * to adopt a policy which pushes on an lsn which is further along in
 * the log once we reach the high water mark.  In this manner, we would
 * be creating a low water mark.
 */

> Reviewed-by: Brian Foster <bfoster@redhat.com>

Thanks for the review!

--D

> > -STATIC void
> > -xlog_grant_push_ail(
> > +xfs_lsn_t
> > +xlog_grant_push_threshold(
> >  	struct xlog	*log,
> >  	int		need_bytes)
> >  {
> > @@ -1508,7 +1509,7 @@ xlog_grant_push_ail(
> >  	free_threshold = max(free_threshold, (log->l_logBBsize >> 2));
> >  	free_threshold = max(free_threshold, 256);
> >  	if (free_blocks >= free_threshold)
> > -		return;
> > +		return NULLCOMMITLSN;
> >  
> >  	xlog_crack_atomic_lsn(&log->l_tail_lsn, &threshold_cycle,
> >  						&threshold_block);
> > @@ -1528,13 +1529,33 @@ xlog_grant_push_ail(
> >  	if (XFS_LSN_CMP(threshold_lsn, last_sync_lsn) > 0)
> >  		threshold_lsn = last_sync_lsn;
> >  
> > +	return threshold_lsn;
> > +}
> > +
> > +/*
> > + * Push on the buffer cache code if we ever use more than 75% of the on-disk
> > + * log space.  This code pushes on the lsn which would supposedly free up
> > + * the 25% which we want to leave free.  We may need to adopt a policy which
> > + * pushes on an lsn which is further along in the log once we reach the high
> > + * water mark.  In this manner, we would be creating a low water mark.
> > + */
> > +STATIC void
> > +xlog_grant_push_ail(
> > +	struct xlog	*log,
> > +	int		need_bytes)
> > +{
> > +	xfs_lsn_t	threshold_lsn;
> > +
> > +	threshold_lsn = xlog_grant_push_threshold(log, need_bytes);
> > +	if (threshold_lsn == NULLCOMMITLSN || XLOG_FORCED_SHUTDOWN(log))
> > +		return;
> > +
> >  	/*
> >  	 * Get the transaction layer to kick the dirty buffers out to
> >  	 * disk asynchronously. No point in trying to do this if
> >  	 * the filesystem is shutting down.
> >  	 */
> > -	if (!XLOG_FORCED_SHUTDOWN(log))
> > -		xfs_ail_push(log->l_ailp, threshold_lsn);
> > +	xfs_ail_push(log->l_ailp, threshold_lsn);
> >  }
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_log.h b/fs/xfs/xfs_log.h
> > index 1412d6993f1e..58c3fcbec94a 100644
> > --- a/fs/xfs/xfs_log.h
> > +++ b/fs/xfs/xfs_log.h
> > @@ -141,4 +141,6 @@ void	xfs_log_quiesce(struct xfs_mount *mp);
> >  bool	xfs_log_check_lsn(struct xfs_mount *, xfs_lsn_t);
> >  bool	xfs_log_in_recovery(struct xfs_mount *);
> >  
> > +xfs_lsn_t xlog_grant_push_threshold(struct xlog *log, int need_bytes);
> > +
> >  #endif	/* __XFS_LOG_H__ */
> > 
> 
