Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50B6BC4727E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:33:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E814C20872
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:33:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OruqmQX5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732883AbgJARdf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 13:33:35 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:45472 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732096AbgJARdf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 13:33:35 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091HU0ZU097193;
        Thu, 1 Oct 2020 17:33:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5vfJO/fuJ5UKtq/Ulufyz0Cu2NNJgAayaPc68tZ7S40=;
 b=OruqmQX5xHpIPhiciGr57xpQl93YjUMoWuabrJipjchDcSHR0kUc0A1tfVbqA5ZuU6oR
 6Yefi2c6qnUJT9ionD1cNhXLQMDQ0oXFyeEnVeoQT49h1ZonXpkdzH+aqDG5BySL4F0p
 urDLGVo1dZ8OH//ZkrKoczHi2Bi7blbunNVb20MlPbMdx3gOLu0YM2T/0qBND532rI/o
 ktObHZiMncz2oX9W+hxB0ByLUcWp0xevLMhiR4uN+r4GYs/fH9TiLlMEBhuvtlzlY3wa
 uD5mKhRgHgJNpp7p2wZfGI7lUaPm9te3qjwCeyCgM229ZcP8HOaNZyEmdbicgJ4c5/Q8 lw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33swkm7b6t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 17:33:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091HOvaN057599;
        Thu, 1 Oct 2020 17:33:31 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 33tfdw64x2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 17:33:30 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 091HXTID031939;
        Thu, 1 Oct 2020 17:33:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 10:33:29 -0700
Date:   Thu, 1 Oct 2020 10:33:27 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 4/4] xfs: only relog deferred intent items if free space
 in the log gets low
Message-ID: <20201001173327.GH49559@magnolia>
References: <160140144925.831337.14031530940286104610.stgit@magnolia>
 <160140147498.831337.5344692693382121188.stgit@magnolia>
 <20201001160256.GB112884@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001160256.GB112884@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 spamscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010010146
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010146
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 12:02:56PM -0400, Brian Foster wrote:
> On Tue, Sep 29, 2020 at 10:44:35AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Now that we have the ability to ask the log how far the tail needs to be
> > pushed to maintain its free space targets, augment the decision to relog
> > an intent item so that we only do it if the log has hit the 75% full
> > threshold.  There's no point in relogging an intent into the same
> > checkpoint, and there's no need to relog if there's plenty of free space
> > in the log.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/libxfs/xfs_defer.c |   16 ++++++++++++++++
> >  1 file changed, 16 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 554777d1069c..2ba02f2e59a1 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -356,7 +356,10 @@ xfs_defer_relog(
> >  	struct xfs_trans		**tpp,
> >  	struct list_head		*dfops)
> >  {
> > +	struct xlog			*log = (*tpp)->t_mountp->m_log;
> >  	struct xfs_defer_pending	*dfp;
> > +	xfs_lsn_t			threshold_lsn = NULLCOMMITLSN;
> > +
> >  
> >  	ASSERT((*tpp)->t_flags & XFS_TRANS_PERM_LOG_RES);
> >  
> > @@ -372,6 +375,19 @@ xfs_defer_relog(
> >  		    xfs_log_item_in_current_chkpt(dfp->dfp_intent))
> >  			continue;
> >  
> > +		/*
> > +		 * Figure out where we need the tail to be in order to maintain
> > +		 * the minimum required free space in the log.  Only sample
> > +		 * the log threshold once per call.
> > +		 */
> > +		if (threshold_lsn == NULLCOMMITLSN) {
> > +			threshold_lsn = xlog_grant_push_threshold(log, 0);
> > +			if (threshold_lsn == NULLCOMMITLSN)
> > +				break;
> > +		}
> 
> FWIW, this looks slightly different from the referenced repo again. :P
> It might be good practice to create a -v# branch for patches sent to the
> list and to keep that one stable for the associated review cycle.

I did, as we talked about on irc.  For anyone following along at home:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git/tag/?h=defer-ops-stalls-5.10_2020-09-29

> That aside, I'm not quite clear where we stand with this patch. My
> preference was to keep it unless there was some fundamental correctness
> issue that I'm not aware of. I think your and Dave's preference was to
> drop it. So either way, for posterity:

As the author who keeps spraying this patch onto the list, I'm still of
a mind to include it. :)  Since we don't really need to relog the
intents unless we need to move the log forward.

That said, even my attempts to force worst case scenarios (make a few
hundred of the big-extent-partially-shared files, truncate them all at
the same time while repeatedly fsyncing (or freezing the fs) still shows
that the relog counts are a tiny percentage of the total transactions
run.  I guess I'll try a higher AG count fs next...

--D

> 
> Reviewed-by: Brian Foster <bfoster@redhat.com>
> 
> > +		if (XFS_LSN_CMP(dfp->dfp_intent->li_lsn, threshold_lsn) >= 0)
> > +			continue;
> > +
> >  		trace_xfs_defer_relog_intent((*tpp)->t_mountp, dfp);
> >  		XFS_STATS_INC((*tpp)->t_mountp, defer_relog);
> >  		dfp->dfp_intent = xfs_trans_item_relog(dfp->dfp_intent, *tpp);
> > 
> 
