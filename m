Return-Path: <SRS0=J8xT=CE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06305C433E1
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 16:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D44662078B
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Aug 2020 16:47:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KBNag+kk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbgHZQrj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Aug 2020 12:47:39 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43740 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727022AbgHZQqa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Aug 2020 12:46:30 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QGi3eU059574;
        Wed, 26 Aug 2020 16:46:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=aAvfBsQ9KCRgZvtXYc75A/WtIZ2/cddFz4H7Ret+f7M=;
 b=KBNag+kks0TXLWtTeVVAzaYgkgEpnLooWZj0erLiJxpjh95+R5QAI5o4ZFEASmxMq5Em
 jdB90MKXh+X2aRi3Wc7awM5Fbv8AgIsTLEODDPKfkhit+QkV4s2XZoY4/dDVC7MEV1WI
 qCZeq5zmZ/rXea2axZG2WVsIbCcgG+/X4NcCFjfpH/pYPyP3RMBZ2zH1WlwoRF4vpeXf
 AH3QOarhMNYC+SQTIdAGhFJ5Mve1GVnmFx78isxr3hrAlK66XBydSLgTruqgjCo+VeQI
 qiwSVOQzz4Oq9DdshKaTwFZC5TJsw2vqooWln8H0ZeFDjT2OHWwsbotOz4yu3pPxoznV Fw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 333dbs1m3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 26 Aug 2020 16:46:22 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07QGepIO097609;
        Wed, 26 Aug 2020 16:44:22 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 333r9mcm19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Aug 2020 16:44:22 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 07QGiLBm000746;
        Wed, 26 Aug 2020 16:44:21 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 26 Aug 2020 09:44:20 -0700
Date:   Wed, 26 Aug 2020 09:44:20 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH V2] xfs: fix boundary test in xfs_attr_shortform_verify
Message-ID: <20200826164420.GP6096@magnolia>
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
 <689c4eda-dd80-c1bd-843f-1b485bfddc5a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <689c4eda-dd80-c1bd-843f-1b485bfddc5a@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 spamscore=0 mlxlogscore=999 phishscore=0 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008260123
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9725 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008260124
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 26, 2020 at 11:19:54AM -0500, Eric Sandeen wrote:
> The boundary test for the fixed-offset parts of xfs_attr_sf_entry in
> xfs_attr_shortform_verify is off by one, because the variable array
> at the end is defined as nameval[1] not nameval[].
> Hence we need to subtract 1 from the calculation.
> 
> This can be shown by:
> 
> # touch file
> # setfattr -n root.a file
> 
> and verifications will fail when it's written to disk.
> 
> This only matters for a last attribute which has a single-byte name
> and no value, otherwise the combination of namelen & valuelen will
> push endp further out and this test won't fail.
> 
> Fixes: 1e1bbd8e7ee06 ("xfs: create structure verifier function for shortform xattrs")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok.

From whom should I be expecting a test case?

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> V2: Add whitespace and comments, tweak commit log.
> 
> Note: as Darrick points out, this should be made consistent w/ the dir2 arrays
> by making the nameval variable size array [] not [1], and then we can lose all
> the -1 magic sprinkled around.  At that time we should probably also make the
> macros into proper functions, as was done for dir2.
> 
> For now, this is just the least invasive fixup for the problem at hand.
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8623c815164a..383b08f2ac61 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1036,8 +1036,10 @@ xfs_attr_shortform_verify(
>  		 * struct xfs_attr_sf_entry has a variable length.
>  		 * Check the fixed-offset parts of the structure are
>  		 * within the data buffer.
> +		 * xfs_attr_sf_entry is defined with a 1-byte variable
> +		 * array at the end, so we must subtract that off.
>  		 */
> -		if (((char *)sfep + sizeof(*sfep)) >= endp)
> +		if (((char *)sfep + sizeof(*sfep) - 1) >= endp)
>  			return __this_address;
>  
>  		/* Don't allow names with known bad length. */
> 
