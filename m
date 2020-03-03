Return-Path: <SRS0=TABv=4U=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C3BC3F2C6
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 20:19:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 391D320732
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Mar 2020 20:19:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o9YmGGmX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbgCCUTM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Mar 2020 15:19:12 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:33496 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728022AbgCCUTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Mar 2020 15:19:12 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023KI2xE074684
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 20:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=SVyzbgg8L/VKjzYIG8ODp++cYHkvTFlmSpzDPQy7lBw=;
 b=o9YmGGmXcXcHEdbNLQunSYuBrvBJCGvpzWR2eG5D9+7kOK4czFggSQEQqeBwiZI4hR2G
 U3qMgiahQdpAvKMxMmZiqsBeOAvhzgN4WdCFHK1ZpxN9/ZUAQVdiHTYoItl0qmCq6BzS
 Lp6EsWdStH5iWHIwzmUxr80jt6mUbJyaywROg3o5cyQo3u9fjjeRsYiJTiAL7d7XhG/Q
 G4YZIG4R3wNWtGYrhRaK4SJcd1cuDra0G6/bpcfV5WlF+LWli3e8KgJFOGvtTINwtYY0
 uwt3K+BJYuOO0wugFXGohjphQJLcpRJqM1FE/ojOMebqskW/qavQKfqmN4vr3qw3lPdN bw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2yffwqsq96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 20:19:10 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 023KGrQR060855
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 20:19:10 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2yg1rn47xu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 03 Mar 2020 20:19:10 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 023KJ9xF000387
        for <linux-xfs@vger.kernel.org>; Tue, 3 Mar 2020 20:19:10 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Mar 2020 12:19:09 -0800
Date:   Tue, 3 Mar 2020 12:19:08 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: fix buffer state when we reject a corrupt dir
 free block
Message-ID: <20200303201908.GF8045@magnolia>
References: <158294091582.1729975.287494493433729349.stgit@magnolia>
 <158294092192.1729975.12710230360219661807.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <158294092192.1729975.12710230360219661807.stgit@magnolia>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=727
 suspectscore=3 malwarescore=0 adultscore=0 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2001150001 definitions=main-2003030130
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9549 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 spamscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=767 mlxscore=0 suspectscore=3
 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2001150001
 definitions=main-2003030130
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Feb 28, 2020 at 05:48:41PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Fix two problems in the dir3 free block read routine when we want to
> reject a corrupt free block.  First, buffers should never have DONE set
> at the same time that b_error is EFSCORRUPTED.  Second, don't leak a
> pointer back to the caller.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  fs/xfs/libxfs/xfs_dir2_node.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> 
> diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
> index a0cc5e240306..f622ede7119e 100644
> --- a/fs/xfs/libxfs/xfs_dir2_node.c
> +++ b/fs/xfs/libxfs/xfs_dir2_node.c
> @@ -227,7 +227,9 @@ __xfs_dir3_free_read(
>  	fa = xfs_dir3_free_header_check(dp, fbno, *bpp);
>  	if (fa) {
>  		xfs_verifier_error(*bpp, -EFSCORRUPTED, fa);

Now that I've had time to think about this further, I conclude that this
call ought to be xfs_buf_corruption_error() since we created that
function to handle exactly this sort of thing...

> +		(*bpp)->b_flags &= ~XBF_DONE;

...and then we don't need this piece.

>  		xfs_trans_brelse(tp, *bpp);
> +		*bpp = NULL;

But we still need this because xfs_trans_brelse could have nuked *bpp
and we should never pass a (potentially stale and now reused) pointer up
to a caller, even if we are about to return an error code.

--D

>  		return -EFSCORRUPTED;
>  	}
>  
> 
