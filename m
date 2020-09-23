Return-Path: <SRS0=WPjR=DA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61B22C4727E
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 15:22:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F9462311E
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Sep 2020 15:22:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Bq+Kt9yV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgIWPWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Sep 2020 11:22:15 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:52378 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726156AbgIWPWP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Sep 2020 11:22:15 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NF9YBl045538;
        Wed, 23 Sep 2020 15:22:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MXtcF3791Qw1VCXrTO6dgvWjxaDevmtB2HplVFV7sL4=;
 b=Bq+Kt9yVobZU/nSYVTekXH9WA+kzE1+zXhfsQleBRM78mdXIq+ro9tsnFjFvxx4Slois
 gS8KNBpHvTX75gWW5qotFFfEAUm8m3r+/NYMGKnpnfGFIEPAXGNdyp2Lcltve0s7xdGo
 ZtuLXYZDIktK3ji1lJDlp+Hh/G2Tzp5LVXLeJeBlc79WUsayJ9UZQ4386IGxMqCtYEP8
 2kP9OJZ3R/HRGQVKJAlNdZzdvdhA2+uCGvVF7CGjsZPArH3d3IEXtM66UCxiHHXDGzBQ
 w2wIRp76JULWrjCsojcNNST+/NhpUtA7LDzxMCdvxUPdVUkgBGCc0/XYJtsiPpwNAP4j Fw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 33qcpu0227-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 23 Sep 2020 15:22:11 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08NF5QIZ118421;
        Wed, 23 Sep 2020 15:22:10 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33nux1ac4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Sep 2020 15:22:10 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 08NFM7WU017549;
        Wed, 23 Sep 2020 15:22:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 23 Sep 2020 08:22:07 -0700
Date:   Wed, 23 Sep 2020 08:22:06 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 1/3] xfs: clean up bmap intent item recovery checking
Message-ID: <20200923152206.GL7955@magnolia>
References: <160031336397.3624582.9639363323333392474.stgit@magnolia>
 <160031337029.3624582.3821482653073391016.stgit@magnolia>
 <20200923071614.GA29203@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200923071614.GA29203@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=999 phishscore=0 suspectscore=1 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9753 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxlogscore=999
 adultscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0 priorityscore=1501
 phishscore=0 spamscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009230123
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Sep 23, 2020 at 08:16:14AM +0100, Christoph Hellwig wrote:
> On Wed, Sep 16, 2020 at 08:29:30PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The bmap intent item checking code in xfs_bui_item_recover is spread all
> > over the function.  We should check the recovered log item at the top
> > before we allocate any resources or do anything else, so do that.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_bmap_item.c |   57 ++++++++++++++++--------------------------------
> >  1 file changed, 19 insertions(+), 38 deletions(-)
> > 
> > 
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 0a0904a7650a..877afe76d76a 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -437,17 +437,13 @@ xfs_bui_item_recover(
> >  	xfs_fsblock_t			inode_fsb;
> >  	xfs_filblks_t			count;
> >  	xfs_exntst_t			state;
> > -	enum xfs_bmap_intent_type	type;
> > -	bool				op_ok;
> >  	unsigned int			bui_type;
> >  	int				whichfork;
> >  	int				error = 0;
> >  
> >  	/* Only one mapping operation per BUI... */
> > -	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS) {
> > -		xfs_bui_release(buip);
> > -		return -EFSCORRUPTED;
> > -	}
> > +	if (buip->bui_format.bui_nextents != XFS_BUI_MAX_FAST_EXTENTS)
> > +		goto garbage;
> 
> We don't really need the xfs_bui_release any more, and can stick to
> plain "return -EFSCORRUPTED" instead of the goto, but I suspect the
> previous patch has taken care of that and you've rebased already?

Yep.

--D

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
