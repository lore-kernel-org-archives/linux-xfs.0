Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DD0C3A5A8
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 16:37:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 527042087E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 16:37:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="n6YDAyBm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbfIDQhm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 12:37:42 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49494 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731478AbfIDQhm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 12:37:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x84GZFxV100529;
        Wed, 4 Sep 2019 16:37:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=vTvWRnGK/gGS/ocHwyPgRnVsyYEJ9Mxc5cvBvAbIbts=;
 b=n6YDAyBmqaV6dKTjMldiOFj8+6dcT8uu1SlUPbaxw7abDykSSNvwOuddiMN+Jqgn+Sfi
 Ub0qpHPsc4mVcyGK6uPl+cV/WNrTFfa/WhmtqxDkEIHeSPfsq7yxckl2BbbagoDSg2e/
 CF/23YkBPd8MVNWsiCdXsrykH/J4MZqf98f71hpNutJRj/rfAMVTfffXs5+yNHhYkfS9
 sff9ruEltK3QBhssYMyJ2ukzRmRL6v1e3Tl4aZ1AlDr765kN8t/JSraCnoFIWoVFbWYT
 uCO1TG3GbbSjdWXLD6EhMb8PvuAn/1BKBEGoEqKGzc2M19cqEf/5NtN/V9UojVu8dM5Q dw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2utgt9r1va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 16:37:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x84Gbc39004460;
        Wed, 4 Sep 2019 16:37:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2usu53aysf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 04 Sep 2019 16:37:38 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x84GbKH7012021;
        Wed, 4 Sep 2019 16:37:20 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 04 Sep 2019 09:37:20 -0700
Date:   Wed, 4 Sep 2019 09:37:19 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     sandeen@sandeen.net, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs_scrub: refactor queueing of subdir scan work item
Message-ID: <20190904163719.GC5354@magnolia>
References: <156685447255.2840069.707517725113377305.stgit@magnolia>
 <156685447885.2840069.3132139174368034407.stgit@magnolia>
 <20190904081252.GC1119@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904081252.GC1119@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1909040164
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9369 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1909040163
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 04, 2019 at 06:12:52PM +1000, Dave Chinner wrote:
> On Mon, Aug 26, 2019 at 02:21:18PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Replace the open-coded process of queueing a subdirectory for scanning
> > with a single helper function.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  scrub/vfs.c |   94 +++++++++++++++++++++++++++++++++--------------------------
> >  1 file changed, 52 insertions(+), 42 deletions(-)
> > 
> > 
> > diff --git a/scrub/vfs.c b/scrub/vfs.c
> > index 7b0b5bcd..ea2866d9 100644
> > --- a/scrub/vfs.c
> > +++ b/scrub/vfs.c
> > @@ -43,6 +43,49 @@ struct scan_fs_tree_dir {
> >  	bool			rootdir;
> >  };
> >  
> > +static void scan_fs_dir(struct workqueue *wq, xfs_agnumber_t agno, void *arg);
> > +
> > +/* Queue a directory for scanning. */
> > +static bool
> > +queue_subdir(
> > +	struct scrub_ctx	*ctx,
> > +	struct scan_fs_tree	*sft,
> > +	struct workqueue	*wq,
> > +	const char		*path,
> > +	bool			is_rootdir)
> > +{
> > +	struct scan_fs_tree_dir	*new_sftd;
> > +	int			error;
> > +
> > +	new_sftd = malloc(sizeof(struct scan_fs_tree_dir));
> > +	if (!new_sftd) {
> > +		str_errno(ctx, _("creating directory scan context"));
> > +		return false;
> > +	}
> > +
> > +	new_sftd->path = strdup(path);
> > +	if (!new_sftd->path) {
> > +		str_errno(ctx, _("creating directory scan path"));
> > +		free(new_sftd);
> > +		return false;
> > +	}
> > +
> > +	new_sftd->sft = sft;
> > +	new_sftd->rootdir = is_rootdir;
> > +
> > +	pthread_mutex_lock(&sft->lock);
> > +	sft->nr_dirs++;
> > +	pthread_mutex_unlock(&sft->lock);
> > +	error = workqueue_add(wq, scan_fs_dir, 0, new_sftd);
> > +	if (error) {
> > +		str_info(ctx, ctx->mntpoint,
> > +_("Could not queue subdirectory scan work."));
> > +		return false;
> 
> Need to drop sft->nr_dirs here, probably free the memory, too.

nr_dirs is (as you've observed) fixed in the next patch.

Yes, we need to free the memory.  Good catch.

> > @@ -177,41 +203,25 @@ scan_fs_tree(
> >  	pthread_mutex_init(&sft.lock, NULL);
> >  	pthread_cond_init(&sft.wakeup, NULL);
> >  
> > -	sftd = malloc(sizeof(struct scan_fs_tree_dir));
> > -	if (!sftd) {
> > -		str_errno(ctx, ctx->mntpoint);
> > -		return false;
> > -	}
> > -	sftd->path = strdup(ctx->mntpoint);
> > -	sftd->sft = &sft;
> > -	sftd->rootdir = true;
> > -
> >  	ret = workqueue_create(&wq, (struct xfs_mount *)ctx,
> >  			scrub_nproc_workqueue(ctx));
> >  	if (ret) {
> >  		str_info(ctx, ctx->mntpoint, _("Could not create workqueue."));
> > -		goto out_free;
> > +		return false;
> >  	}
> > -	ret = workqueue_add(&wq, scan_fs_dir, 0, sftd);
> > -	if (ret) {
> > -		str_info(ctx, ctx->mntpoint,
> > -_("Could not queue directory scan work."));
> > +
> > +	sft.moveon = queue_subdir(ctx, &sft, &wq, ctx->mntpoint, true);
> > +	if (!sft.moveon)
> >  		goto out_wq;
> > -	}
> 
> sft is a stack varable that is stuffed into the structure passed to
> work run on the workqueue. Is that safe to do here?
> 
> >  	pthread_mutex_lock(&sft.lock);
> >  	pthread_cond_wait(&sft.wakeup, &sft.lock);
> 
> maybe it is because of this, but it's not immediately obvious what
> condition actually triggers and that all the work is done...

A worker thread signals the condition variable when nr_dirs hits zero.
There should only be one worker left when this happens (assuming the
accounting is correct) and the worker doesn't do anything with sft after
it unlocks it, so this should be safe.

Will add comment to that effect.

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
