Return-Path: <SRS0=4NJG=4W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DED9C3F2D1
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34FE2214D8
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Mar 2020 01:23:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WKOz0KDT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbgCEBXr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 20:23:47 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58522 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgCEBXr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 20:23:47 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0251Hpjj146074;
        Thu, 5 Mar 2020 01:23:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=xiuqJyxzhPnXULMHSJkFASYRMZGHxkhhdFOwj+9FCf8=;
 b=WKOz0KDT9TSx5yghIvq7EREUFWwNX5bZU0yFByZzxzWv3c4zljowwVV2mF1scmlFIRT2
 YeepvR1S0JHxjnSo7D1BBNPkdQx5pGWuHU3NtJNB/N/rXHouT7vafjUS+w9cmm7hEJkT
 tntFpbGYC8lFOhaBRpK2PFmpKv5S5jbJYW0bkPnCFHbZKtkS/hIh29+RgmsxYenFLEjY
 YpbVbXa+XqCaVIDnVKagBiEdLxfIqKHpbvE1xNZuih6dHZQ6/ODXDmbh6D0jZvs+9luG
 tTxVyfEDC7A26YrwiGSS9CrVxh9Om4zjKKSbt24UIzfCVK2wzJhydpM1HkMr+ZntPC14 hw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2yffcut4jn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 01:23:43 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0251IXNN010693;
        Thu, 5 Mar 2020 01:23:43 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2yg1p91dkv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Mar 2020 01:23:43 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0251Ngku029332;
        Thu, 5 Mar 2020 01:23:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 05 Mar 2020 01:23:42 +0000
Date:   Wed, 4 Mar 2020 17:23:41 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH 1/4] xfs: introduce fake roots for ag-rooted btrees
Message-ID: <20200305012341.GN8045@magnolia>
References: <158329250190.2423432.16958662769192587982.stgit@magnolia>
 <158329250827.2423432.18007812133503266256.stgit@magnolia>
 <20200305012054.GF10776@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305012054.GF10776@dread.disaster.area>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=958 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003050004
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9550 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003050004
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Mar 05, 2020 at 12:20:54PM +1100, Dave Chinner wrote:
> On Tue, Mar 03, 2020 at 07:28:28PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > Create an in-core fake root for AG-rooted btree types so that callers
> > can generate a whole new btree using the upcoming btree bulk load
> > function without making the new tree accessible from the rest of the
> > filesystem.  It is up to the individual btree type to provide a function
> > to create a staged cursor (presumably with the appropriate callouts to
> > update the fakeroot) and then commit the staged root back into the
> > filesystem.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> .....
> > @@ -188,6 +188,16 @@ union xfs_btree_cur_private {
> >  	} abt;
> >  };
> >  
> > +/* Private information for a AG-rooted btree. */
> > +struct xfs_btree_priv_ag {			/* needed for BNO, CNT, INO */
> > +	union {
> > +		struct xfs_buf		*agbp;	/* agf/agi buffer pointer */
> > +		struct xbtree_afakeroot	*afake;	/* fake ag header root */
> > +	};
> > +	xfs_agnumber_t			agno;	/* ag number */
> > +	union xfs_btree_cur_private	priv;
> > +};
> > +
> >  /*
> >   * Btree cursor structure.
> >   * This collects all information needed by the btree code in one place.
> > @@ -209,11 +219,7 @@ typedef struct xfs_btree_cur
> >  	xfs_btnum_t	bc_btnum;	/* identifies which btree type */
> >  	int		bc_statoff;	/* offset of btre stats array */
> >  	union {
> > -		struct {			/* needed for BNO, CNT, INO */
> > -			struct xfs_buf	*agbp;	/* agf/agi buffer pointer */
> > -			xfs_agnumber_t	agno;	/* ag number */
> > -			union xfs_btree_cur_private	priv;
> > -		} a;
> > +		struct xfs_btree_priv_ag a;
> >  		struct {			/* needed for BMAP */
> >  			struct xfs_inode *ip;	/* pointer to our inode */
> >  			int		allocated;	/* count of alloced */
> 
> I don't really like the mess this is turning into. I'll write a
> quick cleanup patch set for this union to make it much neater and
> the code much less verbose before we make the code even more
> unreadable. :/

Ok, thank you!

--D

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
