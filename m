Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F656C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:09:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4C6F23407
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 15:09:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qwrdYc1m"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727820AbfH3PJD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 11:09:03 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:47432 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727603AbfH3PJD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 11:09:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UF46p2132887;
        Fri, 30 Aug 2019 15:08:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=bsHIQWVt/pkVv8O6cvYb/zQa8sOxhgmPKZRusUK2vtY=;
 b=qwrdYc1mylA0AOXufEW44ISJqjsSuJTsqbYiAAOWb3ouD0uqaCSquh+AiMFyrhnQU6he
 mkZsilVVUGz/3FFkH4sMzg7ZL6akwzDlYfWI8MNo+dxQZU+8Sk9Ar1rg7NujzgIL4DVW
 55uLY6sHYv47KaJzZQ8rU3ixKwEFzufq5rzobPzF+80Rm1Kg59O+Q02Mru8ApgDefsmb
 rymmxf1ZC76BUluBclGTsVOrHzlV6dAZVh53m5KrQEq9lqO3NH8jNAeIKWRxhppBW10C
 WVydDA8rLkETkkIyJcP7KQ0b3KMIDOc6oco422Yljn+Ob/0GTijzZQ9BOwdKd1/Mweia 7w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 2uq5tx8501-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:08:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7UF8f9g074725;
        Fri, 30 Aug 2019 15:08:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2upxabdj9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 15:08:58 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UF8v7W030039;
        Fri, 30 Aug 2019 15:08:57 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 08:08:57 -0700
Date:   Fri, 30 Aug 2019 08:08:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: remove the unused XFS_ALLOC_USERDATA flag
Message-ID: <20190830150856.GC5354@magnolia>
References: <20190830102411.519-1-hch@lst.de>
 <20190830102411.519-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830102411.519-4-hch@lst.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300153
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Aug 30, 2019 at 12:24:11PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  fs/xfs/libxfs/xfs_alloc.h | 7 +++----
>  fs/xfs/libxfs/xfs_bmap.c  | 8 ++------
>  2 files changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
> index d6ed5d2c07c2..58fa85cec325 100644
> --- a/fs/xfs/libxfs/xfs_alloc.h
> +++ b/fs/xfs/libxfs/xfs_alloc.h
> @@ -81,10 +81,9 @@ typedef struct xfs_alloc_arg {
>  /*
>   * Defines for datatype
>   */
> -#define XFS_ALLOC_USERDATA		(1 << 0)/* allocation is for user data*/
> -#define XFS_ALLOC_INITIAL_USER_DATA	(1 << 1)/* special case start of file */
> -#define XFS_ALLOC_USERDATA_ZERO		(1 << 2)/* zero extent on allocation */
> -#define XFS_ALLOC_NOBUSY		(1 << 3)/* Busy extents not allowed */
> +#define XFS_ALLOC_INITIAL_USER_DATA	(1 << 0)/* special case start of file */
> +#define XFS_ALLOC_USERDATA_ZERO		(1 << 1)/* zero extent on allocation */
> +#define XFS_ALLOC_NOBUSY		(1 << 2)/* Busy extents not allowed */
>  
>  static inline bool
>  xfs_alloc_is_userdata(int datatype)
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 80b25e21e708..054b4ce30033 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -4042,12 +4042,8 @@ xfs_bmapi_allocate(
>  	 */
>  	if (!(bma->flags & XFS_BMAPI_METADATA)) {
>  		bma->datatype = XFS_ALLOC_NOBUSY;
> -		if (whichfork == XFS_DATA_FORK) {
> -			if (bma->offset == 0)
> -				bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
> -			else
> -				bma->datatype |= XFS_ALLOC_USERDATA;
> -		}
> +		if (whichfork == XFS_DATA_FORK && bma->offset == 0)
> +			bma->datatype |= XFS_ALLOC_INITIAL_USER_DATA;
>  		if (bma->flags & XFS_BMAPI_ZERO)
>  			bma->datatype |= XFS_ALLOC_USERDATA_ZERO;
>  	}
> -- 
> 2.20.1
> 
