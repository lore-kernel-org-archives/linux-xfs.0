Return-Path: <SRS0=Podu=5I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFAF4C3F2CD
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 15:38:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EEE820637
	for <linux-xfs@archiver.kernel.org>; Mon, 23 Mar 2020 15:38:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GBtJG5U0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgCWPip (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 11:38:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58572 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgCWPio (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 11:38:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02NF9Gg2117920;
        Mon, 23 Mar 2020 15:38:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ake1KhpAPmsn5p7jqVXe/DTEcbRtVp39Y2OhCygO4kc=;
 b=GBtJG5U0/XqUq1pNp6B0Z+wHwwYyk7EJqwWDTO7Rxe2o+nvcP7bGf+pf/l8TJ4N5D3Qv
 LXrAttGzogKrFYPdtjfShUGYNfKhwpk/scNaJOYAYFzrJ7q+oa9fq3kHesGwOCNfMgXR
 zYQZjjbjt0WRWNwIlKK7xlz/fJe+YPPOriGMNj+Mrmi63S1O5hQ3KUecG8Z18HCPpAhy
 FuBM2EMsASRZciClFUtoDUxzcZVTW7/sMSl9fm5NgA3e4og0Moyk3e7Cs0cZgJh26SPT
 O3Yo1olr9Nju7zzwt/oufMKgcTNJ1CK2lrLsWLiqY/Db4unWhhujnIMHy4KVkhZEcVt4 VQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2ywavkyas2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 15:38:28 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02NFbYZM027488;
        Mon, 23 Mar 2020 15:38:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2yxw6jsku2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 15:38:28 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 02NFcRvC027472;
        Mon, 23 Mar 2020 15:38:27 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Mar 2020 08:38:27 -0700
Date:   Mon, 23 Mar 2020 08:38:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] iomap: Do not use GFP_NORETRY to allocate BIOs
Message-ID: <20200323153825.GC29339@magnolia>
References: <20200323131244.29435-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323131244.29435-1-willy@infradead.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003230087
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9569 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 bulkscore=0 clxscore=1015 impostorscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003230086
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Mar 23, 2020 at 06:12:44AM -0700, Matthew Wilcox wrote:
> From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> 
> If we use GFP_NORETRY, we have to be able to handle failures, and it's
> tricky to handle failure here.  Other implementations of ->readpages
> do not attempt to handle BIO allocation failures, so this is no worse.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

This fixes the regression I saw, though I see what looks like a new
patch forming further down in this thread, so please let me know if
you'd prefer I take this change, the other one, or both.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/iomap/buffered-io.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 417115bfaf6b..2336642d7390 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -307,8 +307,6 @@ iomap_readpage_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
>  		if (ctx->bio)
>  			submit_bio(ctx->bio);
>  
> -		if (ctx->is_readahead) /* same as readahead_gfp_mask */
> -			gfp |= __GFP_NORETRY | __GFP_NOWARN;
>  		ctx->bio = bio_alloc(gfp, min(BIO_MAX_PAGES, nr_vecs));
>  		ctx->bio->bi_opf = REQ_OP_READ;
>  		if (ctx->is_readahead)
> -- 
> 2.25.1
> 
