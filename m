Return-Path: <SRS0=8d1d=7V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 285F6C433DF
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 16:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00CF32053B
	for <linux-xfs@archiver.kernel.org>; Mon,  8 Jun 2020 16:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L9s1mvsy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730671AbgFHQw3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Jun 2020 12:52:29 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:36438 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730637AbgFHQw3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Jun 2020 12:52:29 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058GmDMD125525;
        Mon, 8 Jun 2020 16:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Bup3deLzU7yk6lbfn+DbxnC0k2n/Kla9wcOhQ9gUTeU=;
 b=L9s1mvsygjqIvti0Onv4nbAh0s9gM0xBTXD7xDzbtQTLh+xABBZA1rfsmHD5389UjKLZ
 9iAVJ5LFLsnzVymAVkfj3frRru3czaaF27NZYVOe60jliSI0F9lz11rdkWND8sJbFhJc
 fzhEi4UGQY1uECY7/xEe8SZI/Y6GRDkJwgbVjnrhBJmB1q2gwR29iHSFFS7bAEb/LHjW
 7rGlJOGMA2ATcKWUeBCs4zp+Ji9+I/+ofLjP678PsTr+U7nomLFYs0zDv0DT3NsvSajD
 s0M61yiDQuaADFqmNU2AVTABbCXhkmFqrCx9pcagD354eAEol8+GWTToVOk+1VyXCTlG fw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31g2jqyxx4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 08 Jun 2020 16:52:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 058GmJSf182758;
        Mon, 8 Jun 2020 16:52:20 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 31gn23ask3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 08 Jun 2020 16:52:20 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 058GqJOH025438;
        Mon, 8 Jun 2020 16:52:19 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 08 Jun 2020 09:52:18 -0700
Date:   Mon, 8 Jun 2020 09:52:17 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 5/7] xfs: Use 2^27 as the maximum number of directory
 extents
Message-ID: <20200608165217.GE1334206@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com>
 <20200606082745.15174-6-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200606082745.15174-6-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=5 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2006080119
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9646 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 cotscore=-2147483648 priorityscore=1501 spamscore=0 suspectscore=5
 lowpriorityscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 phishscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006080119
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 06, 2020 at 01:57:43PM +0530, Chandan Babu R wrote:
> The maximum number of extents that can be used by a directory can be
> calculated as shown below. (FS block size is assumed to be 512 bytes
> since the smallest allowed block size can create a BMBT of maximum
> possible height).
> 
> Maximum number of extents in data space =
> XFS_DIR2_SPACE_SIZE / 2^9 = 32GiB / 2^9 = 2^26.
> 
> Maximum number (theoretically) of extents in leaf space =
> 32GiB / 2^9 = 2^26.

Hm.  The leaf hash entries are 8 bytes long, whereas I think directory
entries occupy at least 16 bytes.  Is there a situation where the number
of dir leaf/dabtree blocks can actually hit the 32G section size limit?

> Maximum number of entries in a free space index block
> = (512 - (sizeof struct xfs_dir3_free_hdr)) / (sizeof struct
>                                                xfs_dir2_data_off_t)
> = (512 - 64) / 2 = 224
> 
> Maximum number of extents in free space index =
> (Maximum number of extents in data segment) / 224 =
> 2^26 / 224 = ~2^18
> 
> Maximum number of extents in a directory =
> Maximum number of extents in data space +
> Maximum number of extents in leaf space +
> Maximum number of extents in free space index =
> 2^26 + 2^26 + 2^18 = ~2^27

I calculated the exact expression here, and got:

2^26 + 2^26 + (2^26/224) = 134,517,321

This requires 28 bits of space, doesn't it?

Granted I bet the leaf section won't come within 300,000 nextents of the
2^26 you've assumed for it, so I suspect that in real world scenarios,
27 bits is enough.  But if you're anticipating a totally full leaf
section under extreme fragmentation, then MAXDIREXTNUM ought to be able
to handle that.

(Assuming I did any of that math correctly. ;))

--D

> 
> This commit defines the macro MAXDIREXTNUM to have the value 2^27 and
> this in turn is used in calculating the maximum height of a directory
> BMBT.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  fs/xfs/libxfs/xfs_bmap.c  | 2 +-
>  fs/xfs/libxfs/xfs_types.h | 1 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> index 8b0029b3cecf..f75b70ae7b1f 100644
> --- a/fs/xfs/libxfs/xfs_bmap.c
> +++ b/fs/xfs/libxfs/xfs_bmap.c
> @@ -81,7 +81,7 @@ xfs_bmap_compute_maxlevels(
>  	if (whichfork == XFS_DATA_FORK) {
>  		sz = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
>  		if (dir_bmbt)
> -			maxleafents = MAXEXTNUM;
> +			maxleafents = MAXDIREXTNUM;
>  		else
>  			maxleafents = MAXEXTNUM;
>  	} else {
> diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> index 397d94775440..0a3041ad5bec 100644
> --- a/fs/xfs/libxfs/xfs_types.h
> +++ b/fs/xfs/libxfs/xfs_types.h
> @@ -60,6 +60,7 @@ typedef void *		xfs_failaddr_t;
>   */
>  #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
>  #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> +#define	MAXDIREXTNUM	((xfs_extnum_t)0x7ffffff)	/* 27 bits */
>  #define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
>  
>  /*
> -- 
> 2.20.1
> 
