Return-Path: <SRS0=2mLC=C3=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB7AC43464
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 01:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E417206B5
	for <linux-xfs@archiver.kernel.org>; Fri, 18 Sep 2020 01:49:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QAZi0qkN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726040AbgIRBtB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Sep 2020 21:49:01 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:59658 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgIRBtB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Sep 2020 21:49:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I1mthF122892;
        Fri, 18 Sep 2020 01:48:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=IvdLtyS6CDyiKxDsqMSc7D0FfOAh7hwnwCCi1dGtXyk=;
 b=QAZi0qkNBCHdhlg4cUJEwsGHftUR2gCzMJIo/7xN8WCQNXQSIVhM2W+hjiwZXnn/qzFk
 79owcE8FVuGO8B3K/0daccUqN2lFJNk766Bud7x9MpEp2SJi3BZsBqMOwNIHgaUOSL3y
 JmvdrOR0tHNlOluoKDUoDbZGNnwd4JTA9KXkvgMAD1DKD3YPI3p4ifaL1MlHDkPyADzk
 W6AihvH1oVloZApBogRlwyFruKO+9G/98eIet4302TvydfXkAOPUklAnoKfIK4WLNLgn
 AixfBy1j/+XRdM1X5R+TvEc1AuaCd80fZDcTg3GbODv8qjUpRLnMpBELdsdEmb95QCdx AQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 33gp9mmfkc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 18 Sep 2020 01:48:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08I1jvaO075810;
        Fri, 18 Sep 2020 01:48:49 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 33hm35wft0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Sep 2020 01:48:49 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08I1mmdv009445;
        Fri, 18 Sep 2020 01:48:48 GMT
Received: from localhost (/10.159.238.153)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 18 Sep 2020 01:48:47 +0000
Date:   Thu, 17 Sep 2020 18:48:46 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Subject: Re: [PATCH 3/2] xfs: free the intent item when allocating recovery
 transaction fails
Message-ID: <20200918014846.GT7955@magnolia>
References: <160031332353.3624373.16349101558356065522.stgit@magnolia>
 <20200917070135.GV7955@magnolia>
 <20200917090645.GB13366@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200917090645.GB13366@infradead.org>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 mlxscore=0 phishscore=0 adultscore=0 suspectscore=5
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180015
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9747 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 phishscore=0
 spamscore=0 priorityscore=1501 suspectscore=5 impostorscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009180016
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Sep 17, 2020 at 10:06:45AM +0100, Christoph Hellwig wrote:
> On Thu, Sep 17, 2020 at 12:01:35AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <darrick.wong@oracle.com>
> > 
> > The recovery functions of all four log intent items fail to free the
> > intent item if the transaction allocation fails.  Fix this.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  fs/xfs/xfs_bmap_item.c     |    5 ++++-
> >  fs/xfs/xfs_extfree_item.c  |    5 ++++-
> >  fs/xfs/xfs_refcount_item.c |    5 ++++-
> >  fs/xfs/xfs_rmap_item.c     |    5 ++++-
> >  4 files changed, 16 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
> > index 2b1cf3ed8172..85d18cd708ba 100644
> > --- a/fs/xfs/xfs_bmap_item.c
> > +++ b/fs/xfs/xfs_bmap_item.c
> > @@ -484,8 +484,11 @@ xfs_bui_item_recover(
> >  
> >  	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
> >  			XFS_EXTENTADD_SPACE_RES(mp, XFS_DATA_FORK), 0, 0, &tp);
> > -	if (error)
> > +	if (error) {
> > +		xfs_bui_release(buip);
> >  		return error;
> > +	}
> 
> This should probably use a common label instead of duplicating the
> release three times.
> 
> That beind said I don't think we need either the existing or newly
> added calls.  At the end of log recovery we always call
> xlog_recover_cancel_intents, which will release all intents remaining
> in the AIL.

You know, that's right, recovery will clean up all the intents for us if
we fail.  Ok, new patch. :)

--D
