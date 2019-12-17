Return-Path: <SRS0=4VMi=2H=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C9DEC43603
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 21:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AC982072D
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Dec 2019 21:51:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rdphKxjR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbfLQVvv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Dec 2019 16:51:51 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:46442 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfLQVvv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Dec 2019 16:51:51 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHLjrSn074387;
        Tue, 17 Dec 2019 21:51:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=WpqUjpkSsbvjLlJ56HCP9aAdithyr7RKD4X4F6UkX+k=;
 b=rdphKxjRifG17xc823PtiD05FGoI/PsC4KgSh95f8C5EyXD58fAy19v2f4hTPCvAZF02
 aLIxw82XqSzyTd4MxYHawwyVmArBFq+s/cOOAM9h+B5HIUHtbkeTLgVLcIqrdpx5U4Nk
 Juw/7VMI/BLe+Ex6Th3Lz2uApsGms2CN8tYjV8UwCMCCsQ/eLge8U3xxXq6+vTzH2X+i
 jYjG7ygYCmKKrhEteGj/DY5p2Lhz2y5QJCfzbKl8WvaPI1NWwZklmiOTob8GAC+HwWJM
 6J5Ha1hd8vbwPKXFCZW1WkDUjH02kchyy8HMyPq604o1TLMgEzn0ZbFnPD8Nt36TliE2 oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wvq5uhp3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 21:51:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xBHLiI5K049401;
        Tue, 17 Dec 2019 21:51:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 2wxm5nxenb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Dec 2019 21:51:45 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xBHLpiw1018762;
        Tue, 17 Dec 2019 21:51:45 GMT
Received: from localhost (/10.159.137.228)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 17 Dec 2019 13:51:44 -0800
Date:   Tue, 17 Dec 2019 13:51:43 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: use bitops interface for buf log item AIL flag check
Message-ID: <20191217215143.GD12765@magnolia>
References: <20191217184203.56997-1-bfoster@redhat.com>
 <b6375ec4-f2e4-0e87-376c-ff25ee83a563@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6375ec4-f2e4-0e87-376c-ff25ee83a563@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=719
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912170173
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9474 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=781 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912170173
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 17, 2019 at 02:01:26PM -0600, Eric Sandeen wrote:
> On 12/17/19 12:42 PM, Brian Foster wrote:
> > The xfs_log_item flags were converted to atomic bitops as of commit
> > 22525c17ed ("xfs: log item flags are racy"). The assert check for
> > AIL presence in xfs_buf_item_relse() still uses the old value based
> > check. This likely went unnoticed as XFS_LI_IN_AIL evaluates to 0
> > and causes the assert to unconditionally pass. Fix up the check.
> > 
> > Signed-off-by: Brian Foster <bfoster@redhat.com>
> 
> Whoops.
> 
> Fixes: 22525c17ed ("xfs: log item flags are racy")
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 

Looks ok to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> > ---
> >  fs/xfs/xfs_buf_item.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
> > index 3458a1264a3f..3984779e5911 100644
> > --- a/fs/xfs/xfs_buf_item.c
> > +++ b/fs/xfs/xfs_buf_item.c
> > @@ -956,7 +956,7 @@ xfs_buf_item_relse(
> >  	struct xfs_buf_log_item	*bip = bp->b_log_item;
> >  
> >  	trace_xfs_buf_item_relse(bp, _RET_IP_);
> > -	ASSERT(!(bip->bli_item.li_flags & XFS_LI_IN_AIL));
> > +	ASSERT(!test_bit(XFS_LI_IN_AIL, &bip->bli_item.li_flags));
> >  
> >  	bp->b_log_item = NULL;
> >  	if (list_empty(&bp->b_li_list))
> > 
