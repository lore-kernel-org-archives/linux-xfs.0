Return-Path: <SRS0=rYOu=EB=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AABCC4363A
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D92AD2087C
	for <linux-xfs@archiver.kernel.org>; Mon, 26 Oct 2020 23:10:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="eRxpfE5Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395476AbgJZXKt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 26 Oct 2020 19:10:49 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:49326 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395475AbgJZXKt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 26 Oct 2020 19:10:49 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QN9wt5132677;
        Mon, 26 Oct 2020 23:10:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3GlEtv4Ogzi8Oob79FduKSA6tCKY1Ec47Mj324WiPwU=;
 b=eRxpfE5QQrqlJtFA6hrdNOQy5iJL+rIBFRWvWSnWamGEFA3qJZkeMZROwr8DX5PNJzTp
 0KE86MwjvE+nlPxn4MV6jq3FVZ9Q0c1LUMaQXf6gDZI95VCDVKHf36xXJP02dju3wWOJ
 Lm+rlL8j80gS8GZnA0wCCK7FVcAqiHfk4y/ESb11bqPhz0zfGzYjh17lWri0JAZlZ8ol
 mzcLlMhQ28xQgjNwxJrh6YqIAnbxOX/GDSo6c2FQKAXrXQsWASxZvjAgMwetGWlKlhTn
 NM0mQxo4YAbDTklayjGBWxpUS8iKzCEqDZD+1v2w6ZQNzUAeC4SRRe8Qe9T+XnHpMfWr oQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 34cc7kq6y6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 26 Oct 2020 23:10:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09QNAGIk193642;
        Mon, 26 Oct 2020 23:10:41 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 34cx1q1ucg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 26 Oct 2020 23:10:40 +0000
Received: from abhmp0004.oracle.com (abhmp0004.oracle.com [141.146.116.10])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09QNAdv7027222;
        Mon, 26 Oct 2020 23:10:39 GMT
Received: from localhost (/10.159.145.170)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Oct 2020 16:10:39 -0700
Date:   Mon, 26 Oct 2020 16:10:38 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, hch@infradead.org
Subject: Re: [PATCH V7 08/14] xfs: Check for extent overflow when remapping
 an extent
Message-ID: <20201026231038.GA853509@magnolia>
References: <20201019064048.6591-1-chandanrlinux@gmail.com>
 <20201019064048.6591-9-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019064048.6591-9-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=1 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010260151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9786 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 adultscore=0
 malwarescore=0 spamscore=0 clxscore=1015 mlxscore=0 suspectscore=1
 priorityscore=1501 impostorscore=0 bulkscore=0 phishscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010260151
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 19, 2020 at 12:10:42PM +0530, Chandan Babu R wrote:
> Remapping an extent involves unmapping the existing extent and mapping
> in the new extent. When unmapping, an extent containing the entire unmap
> range can be split into two extents,
> i.e. | Old extent | hole | Old extent |
> Hence extent count increases by 1.
> 
> Mapping in the new extent into the destination file can increase the
> extent count by 1.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>

Looks fine,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/xfs_reflink.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
> index 4f0198f636ad..856fe755a5e9 100644
> --- a/fs/xfs/xfs_reflink.c
> +++ b/fs/xfs/xfs_reflink.c
> @@ -1006,6 +1006,7 @@ xfs_reflink_remap_extent(
>  	unsigned int		resblks;
>  	bool			smap_real;
>  	bool			dmap_written = xfs_bmap_is_written_extent(dmap);
> +	int			iext_delta = 0;
>  	int			nimaps;
>  	int			error;
>  
> @@ -1099,6 +1100,16 @@ xfs_reflink_remap_extent(
>  			goto out_cancel;
>  	}
>  
> +	if (smap_real)
> +		++iext_delta;
> +
> +	if (dmap_written)
> +		++iext_delta;
> +
> +	error = xfs_iext_count_may_overflow(ip, XFS_DATA_FORK, iext_delta);
> +	if (error)
> +		goto out_cancel;
> +
>  	if (smap_real) {
>  		/*
>  		 * If the extent we're unmapping is backed by storage (written
> -- 
> 2.28.0
> 
