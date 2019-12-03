Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9ADCC432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 15:53:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEB0B2070A
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 15:53:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="aFdo1JvB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfLCPxC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 10:53:02 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:51848 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726024AbfLCPxB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 10:53:01 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3Fi3an158418;
        Tue, 3 Dec 2019 15:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=TK4k4PE84ofpkkHuFn7V1y5iUUyg9zU00SZ0mBJ9iGU=;
 b=aFdo1JvB26LRaFCB0pQXkZh9v49GKyZ7Pvffr7NEGgAnadLKUBlu9bTRpsVXfQD8BjY2
 bmJzG+90amILnLORjgSAxUQxs44IJ9SlWAqxf2sK5JTcWAFxorjvf1/xqTS7d2EwXpjM
 SihEONX6cihCl+vKJ8pZxjXadLJ13rnMWJfY90zeS9aMRFaAzQSQbwSgDJuyic8vJ4Jp
 NjXboOnGPKdkWHNYBLVAEEfFXa+t2OYOu9vHE1zoniDUWyle9IzAp6c+Im3QkqhGWUn7
 Cixt9RKQOfuWIjGKQ+YKJB9dmUHV3F5e1Sar3bihJOsumbLJkVylea8NKLlH0cJKG/jS HQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2wkgcq8hu5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 15:52:58 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB3FhsrO180101;
        Tue, 3 Dec 2019 15:52:58 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2wn8k2tdrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 15:52:58 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB3FqvOL031056;
        Tue, 3 Dec 2019 15:52:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 07:52:56 -0800
Date:   Tue, 3 Dec 2019 07:52:56 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Brian Foster <bfoster@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix mount failure crash on invalid iclog memory
 access
Message-ID: <20191203155256.GI7335@magnolia>
References: <20191203140524.36043-1-bfoster@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191203140524.36043-1-bfoster@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9460 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030120
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 03, 2019 at 09:05:24AM -0500, Brian Foster wrote:
> syzbot (via KASAN) reports a use-after-free in the error path of
> xlog_alloc_log(). Specifically, the iclog freeing loop doesn't
> handle the case of a fully initialized ->l_iclog linked list.
> Instead, it assumes that the list is partially constructed and NULL
> terminated.
> 
> This bug manifested because there was no possible error scenario
> after iclog list setup when the original code was added.  Subsequent
> code and associated error conditions were added some time later,
> while the original error handling code was never updated. Fix up the
> error loop to terminate either on a NULL iclog or reaching the end
> of the list.
> 
> Reported-by: syzbot+c732f8644185de340492@syzkaller.appspotmail.com
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Ahh, a proper S-o-B!  Thank you,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_log.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 6a147c63a8a6..f6006d94a581 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1542,6 +1542,8 @@ xlog_alloc_log(
>  		prev_iclog = iclog->ic_next;
>  		kmem_free(iclog->ic_data);
>  		kmem_free(iclog);
> +		if (prev_iclog == log->l_iclog)
> +			break;
>  	}
>  out_free_log:
>  	kmem_free(log);
> -- 
> 2.20.1
> 
