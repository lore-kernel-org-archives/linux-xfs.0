Return-Path: <SRS0=NLen=BG=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03F8AC433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 15:46:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF77A2074F
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Jul 2020 15:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="wGt5pwyU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730791AbgG0PqP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jul 2020 11:46:15 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:44294 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729040AbgG0PqP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jul 2020 11:46:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RFbfDa009574
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 15:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=G/F5sNC/StFWupFif6yw1LpD76blfstBDup+ie0UKMk=;
 b=wGt5pwyUD65frYkdohVhn9oCmIJTr8OVq95knDZx4UYusBCw6SJ8kCGyoFEkbJlAQfWp
 4mQbd6sNBh3NgeHnsPZwkzRfPpjVs1qbBf/cG29Utrm08r8BWIilYn1+oSkmfof8B+rr
 ygY/7nJbSIST/USSl1S1DYPhma7azT8leCrc7QK1JiuPaFQ4FnnCzRYB7gQYHmrJ0UQI
 YMocnlzqagpFwvuxhQedMLKiqiOcL4Kue1XsXjzSs66wkq/Unml3UD/90y0+Vwezs70i
 oe/LbOhzy8nCBbK7fY9ZLobyk1KJNqRlSKzhq9pDD8lf72p7XNZoQtQvZqkNz0jjLvn7 Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 32hu1jabcc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 15:46:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 06RFcWxb159645
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 15:46:13 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 32hu5r5hbv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 15:46:13 +0000
Received: from abhmp0016.oracle.com (abhmp0016.oracle.com [141.146.116.22])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 06RFkC8r023269
        for <linux-xfs@vger.kernel.org>; Mon, 27 Jul 2020 15:46:12 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jul 2020 08:46:12 -0700
Date:   Mon, 27 Jul 2020 08:46:11 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Allison Collins <allison.henderson@oracle.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs: Fix compiler warning in
 xfs_attr_node_removename_setup
Message-ID: <20200727154611.GA3151642@magnolia>
References: <20200727022608.18535-1-allison.henderson@oracle.com>
 <20200727022608.18535-2-allison.henderson@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200727022608.18535-2-allison.henderson@oracle.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 bulkscore=0
 malwarescore=0 suspectscore=2 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270107
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9695 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 mlxlogscore=999
 malwarescore=0 impostorscore=0 priorityscore=1501 spamscore=0 phishscore=0
 suspectscore=2 bulkscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2007270107
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Jul 26, 2020 at 07:26:07PM -0700, Allison Collins wrote:
> Fix compiler warning for variable 'blk' set but not used in
> xfs_attr_node_removename_setup.  blk is used only in an ASSERT so only
> declare blk when DEBUG is set.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Allison Collins <allison.henderson@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_attr.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d4583a0..5168d32 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1174,7 +1174,9 @@ int xfs_attr_node_removename_setup(
>  	struct xfs_da_state	**state)
>  {
>  	int			error;
> +#ifdef DEBUG
>  	struct xfs_da_state_blk	*blk;
> +#endif

But now a non-DEBUG compilation will trip over the assignment to blk:

	blk = &(*state)->path.blk[(*state)->path.active - 1];

that comes just before the asserts, right?

	ASSERT((*state)->path.blk[(*state)->path.active - 1].bp != NULL);
	ASSERT((*state)->path.blk[(*state)->path.active - 1].magic ==
		XFS_ATTR_LEAF_MAGIC);

In the end you probably just want to encode the accessor logic in the
assert body so the whole thing just disappears entirely.

--D

>  
>  	error = xfs_attr_node_hasname(args, state);
>  	if (error != -EEXIST)
> -- 
> 2.7.4
> 
