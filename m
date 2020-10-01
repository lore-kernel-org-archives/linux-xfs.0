Return-Path: <SRS0=mWNF=DI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A989C4727E
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:55:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E5A31221EF
	for <linux-xfs@archiver.kernel.org>; Thu,  1 Oct 2020 17:55:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IikzpF0D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732968AbgJARzK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 1 Oct 2020 13:55:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:47568 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732795AbgJARzJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 1 Oct 2020 13:55:09 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091HdMW1074508;
        Thu, 1 Oct 2020 17:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=uy0bALq2XnrV8CefdQ42QR+EwFdk7hMaRunfz5OBmJA=;
 b=IikzpF0DrzcF2yzOIlcUKy7xouGbK63a4b2rDVw5mRsd8hHV30pMNynDM0CVu5GQltxW
 GYP3gt2cd91Vpw0VNNQvw+uYxiTr9LHUx/VY13ifsioE5EDeVQIsZ9Ec9e67FJY7JHN/
 3/xD3RymPCGBa5F+5K3YP1cS3qKVH2gvEnfwvxwpY7x/gNQcFtFzmE3hpH1ovQEsRps9
 H42LfO25ps9JmtGozGcRP+P3xP4H6COnz9WZs+1a7237kqKKDlxxKqtGKzYw8XFlhutc
 DnO2Yu3KtUvsLm8G64T84cQxF1czOLtg9RHz3heMh2oOS/CqfhrBiI33R9zWOIOxuScq sQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9nfcty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 01 Oct 2020 17:55:02 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 091Hexpp031746;
        Thu, 1 Oct 2020 17:53:01 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 33uv2h7y7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 01 Oct 2020 17:53:01 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 091Hqxt2032342;
        Thu, 1 Oct 2020 17:52:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 01 Oct 2020 10:52:58 -0700
Date:   Thu, 1 Oct 2020 10:52:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@lst.de
Subject: Re: [PATCH 5/5] xfs: xfs_defer_capture should absorb remaining
 transaction reservation
Message-ID: <20201001175257.GS49547@magnolia>
References: <160140139198.830233.3093053332257853111.stgit@magnolia>
 <160140142459.830233.7194402837807253154.stgit@magnolia>
 <20201001173256.GG112884@bfoster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001173256.GG112884@bfoster>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 adultscore=0
 suspectscore=1 malwarescore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9761 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=1
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010010148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 01, 2020 at 01:32:56PM -0400, Brian Foster wrote:
> On Tue, Sep 29, 2020 at 10:43:44AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > When xfs_defer_capture extracts the deferred ops and transaction state
> > from a transaction, it should record the transaction reservation type
> > from the old transaction so that when we continue the dfops chain, we
> > still use the same reservation parameters.
> > 
> > Doing this means that the log item recovery functions get to determine
> > the transaction reservation instead of abusing tr_itruncate in yet
> > another part of xfs.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> 
> Much nicer, and FWIW this is pretty much the approach I was wondering
> about wrt to the block reservation in the previous patch..
> 
> >  fs/xfs/libxfs/xfs_defer.c |    9 +++++++++
> >  fs/xfs/libxfs/xfs_defer.h |    1 +
> >  fs/xfs/xfs_log_recover.c  |    4 ++--
> >  3 files changed, 12 insertions(+), 2 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/libxfs/xfs_defer.c b/fs/xfs/libxfs/xfs_defer.c
> > index 0cceebb390c4..4caaf5527403 100644
> > --- a/fs/xfs/libxfs/xfs_defer.c
> > +++ b/fs/xfs/libxfs/xfs_defer.c
> > @@ -579,6 +579,15 @@ xfs_defer_ops_capture(
> >  	dfc->dfc_blkres = tp->t_blk_res - tp->t_blk_res_used;
> >  	tp->t_blk_res = tp->t_blk_res_used;
> >  
> > +	/*
> > +	 * Preserve the transaction reservation type.  The logcount is
> > +	 * hardwired to 1 to so that we can make forward progress in recovery
> > +	 * no matter how full the log might be, at a cost of more regrants.
> > +	 */
> > +	dfc->dfc_tres.tr_logres = tp->t_log_res;
> > +	dfc->dfc_tres.tr_logcount = 1;
> > +	dfc->dfc_tres.tr_logflags = XFS_TRANS_PERM_LOG_RES;
> 
> Any real need to allocate these last two fields in every captured chain
> when they're basically hardcoded? If not, it might be a bit more
> efficient to put an xfs_trans_res on the stack in
> xlog_finish_defer_ops() and just save the logres value here.

Ok, will do.

--D

> 
> Brian
> 
> > +
> >  	return dfc;
> >  }
> >  
> > diff --git a/fs/xfs/libxfs/xfs_defer.h b/fs/xfs/libxfs/xfs_defer.h
> > index b1c7b761afd5..c447c79bbe74 100644
> > --- a/fs/xfs/libxfs/xfs_defer.h
> > +++ b/fs/xfs/libxfs/xfs_defer.h
> > @@ -76,6 +76,7 @@ struct xfs_defer_capture {
> >  	struct list_head	dfc_dfops;
> >  	unsigned int		dfc_tpflags;
> >  	unsigned int		dfc_blkres;
> > +	struct xfs_trans_res	dfc_tres;
> >  };
> >  
> >  /*
> > diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> > index b06c9881a13d..46e750279634 100644
> > --- a/fs/xfs/xfs_log_recover.c
> > +++ b/fs/xfs/xfs_log_recover.c
> > @@ -2442,8 +2442,8 @@ xlog_finish_defer_ops(
> >  	int			error = 0;
> >  
> >  	list_for_each_entry_safe(dfc, next, capture_list, dfc_list) {
> > -		error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0,
> > -				0, XFS_TRANS_RESERVE, &tp);
> > +		error = xfs_trans_alloc(mp, &dfc->dfc_tres, 0, 0,
> > +				XFS_TRANS_RESERVE, &tp);
> >  		if (error)
> >  			return error;
> >  
> > 
> 
