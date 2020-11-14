Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DABC55ABD
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 287EA2224D
	for <linux-xfs@archiver.kernel.org>; Sat, 14 Nov 2020 00:10:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RjGvUPzP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726064AbgKNAKg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 13 Nov 2020 19:10:36 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:35760 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726020AbgKNAKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Nov 2020 19:10:36 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE03vvS022929;
        Sat, 14 Nov 2020 00:10:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=b+cxr6qd5FWMN/9844mJuV/IA607U68H2F1hXt4xqvE=;
 b=RjGvUPzPFHmt+G3tcpcM5NXlFqzvQBzdPTqfV7yUykEC7cTFcI8xhIh8+WTfJZebFjvX
 2bIz1BIFPyB51qxU8/NrxxZYlM/HjhujlqM7nZ87ie3SPfU3g8B34rEdITSqD4UXU4hO
 4b9rInhAPe+hDIVtig9bwP2/q1IcB1vNkJeydvOjdcbxNrnb8SnWSNXBevMWsd67I/lc
 BbNC84x9jvvOhksumerXxcARXHhcrRzAqz3Pd/aoZvpleYlrCsH9zFm5iEAmSPjTbcWP
 mzTRE+mkDgqrV8k5GPOIhp7JJ5Le8dgLQ0HcAwoECI79PO1sesmphJwlYEme4lu6Xr89 rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 34p72f2wyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 14 Nov 2020 00:10:34 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 0AE0542l063844;
        Sat, 14 Nov 2020 00:10:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 34p5g5q5y8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 14 Nov 2020 00:10:33 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0AE0AWJN030085;
        Sat, 14 Nov 2020 00:10:32 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 13 Nov 2020 16:10:31 -0800
Date:   Fri, 13 Nov 2020 16:10:30 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Chandan Babu R <chandanrlinux@gmail.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 01/11] common/xfs: Add a helper to get an inode fork's
 extent count
Message-ID: <20201114001030.GB9695@magnolia>
References: <20201113112704.28798-1-chandanrlinux@gmail.com>
 <20201113112704.28798-2-chandanrlinux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113112704.28798-2-chandanrlinux@gmail.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 malwarescore=0
 adultscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130155
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9804 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 suspectscore=1 lowpriorityscore=0 adultscore=0 phishscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2011130155
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Nov 13, 2020 at 04:56:53PM +0530, Chandan Babu R wrote:
> This commit adds the helper _scratch_get_iext_count() which returns an
> inode fork's extent count.
> 
> Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> ---
>  common/xfs | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/common/xfs b/common/xfs
> index 79dab058..45cd329c 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -883,6 +883,28 @@ _scratch_get_bmx_prefix() {
>  	return 1
>  }
>  
> +_scratch_get_iext_count()
> +{
> +	ino=$1
> +	whichfork=$2
> +
> +	case $whichfork in
> +		"attr")
> +			field=core.naextents
> +			;;
> +		"data")
> +			field=core.nextents
> +			;;
> +		*)
> +			return 1
> +	esac
> +
> +	nextents=$(_scratch_xfs_db  -c "inode $ino" -c "print $field")
> +	nextents=${nextents##${field} = }

This helper looks fine, but looking at the callers spread over the next
10 patches, I notice that you unmount to call this helper and
immediately remount the fs.

I wonder, is there a specific reason for grabbing the extent count that
way?  You can extract the same info online with `xfs_io -c 'stat' /moo',
right?

--D

> +
> +	echo $nextents
> +}
> +
>  #
>  # Ensures that we don't pass any mount options incompatible with XFS v4
>  #
> -- 
> 2.28.0
> 
