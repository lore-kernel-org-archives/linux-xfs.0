Return-Path: <SRS0=ldVD=CD=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552B6C433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 20:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2714D2074D
	for <linux-xfs@archiver.kernel.org>; Tue, 25 Aug 2020 20:27:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="uir48NtQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbgHYU07 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Aug 2020 16:26:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54404 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYU06 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Aug 2020 16:26:58 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PKNjhS186080;
        Tue, 25 Aug 2020 20:26:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=d5xliLnhJ+y98A9kRGvzIOVrxrgbEfWbSTLEtQ6dS30=;
 b=uir48NtQajrFkOmapxnjlGI5SuDVsLQgvni/Uz7ulKhpiOXjnyvG8nHBHYdW5u0O7Dfz
 8XAykX/7JQR/n6OCLFLhCqrt+xk4fjD+6GlvyWxItp0B4rF8ypUbbYjoULhRqqa0g6jt
 iVPzDarS3eokRhJ+Ay49fL4BsQm6kdj5oIZC8PY9iHSxl3tNzymSm7kYPeII1Z4PCMzr
 zZy6SK6uG7CX9kJN3I71jmUbCbRh5N2/4cOUcdaRADh5yjh5Zk4NsU7U707TSjLM4VvA
 t7yugj8N/k1Qk8c4fYhCyFxBTGsgAznYJAoOuQwEu7AphGKPxtVBWyypt0CCKkk/rJJA Yw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 333dbrvrxb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 25 Aug 2020 20:26:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07PKQcbN082826;
        Tue, 25 Aug 2020 20:26:52 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 333rty95dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 20:26:51 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07PKQn4j017562;
        Tue, 25 Aug 2020 20:26:50 GMT
Received: from localhost (/10.159.234.29)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 25 Aug 2020 13:26:49 -0700
Date:   Tue, 25 Aug 2020 13:26:48 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: fix boundary test in xfs_attr_shortform_verify
Message-ID: <20200825202648.GD6096@magnolia>
References: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63722af5-2d8d-2455-17ee-988defd3126f@redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9724 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0
 phishscore=0 spamscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9724 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 spamscore=0 mlxscore=0 lowpriorityscore=0 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008250154
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 25, 2020 at 03:25:29PM -0500, Eric Sandeen wrote:
> The boundary test for the fixed-offset parts of xfs_attr_sf_entry
> in xfs_attr_shortform_verify is off by one.  endp is the address
> just past the end of the valid data; to check the last byte of
> a structure at offset of size "size" we must subtract one.
> (i.e. for an object at offset 10, size 4, last byte is 13 not 14).
> 
> This can be shown by:
> 
> # touch file
> # setfattr -n root.a file
> 
> and subsequent verifications will fail when it's reread from disk.
> 
> This only matters for a last attribute which has a single-byte name
> and no value, otherwise the combination of namelen & valuelen will
> push endp out and this test won't fail.
> 
> Fixes: 1e1bbd8e7ee06 ("xfs: create structure verifier function for shortform xattrs")
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

NGGHGHGHG array[1]s that are actually array[0]...

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
> index 8623c815164a..a0cf22f0c904 100644
> --- a/fs/xfs/libxfs/xfs_attr_leaf.c
> +++ b/fs/xfs/libxfs/xfs_attr_leaf.c
> @@ -1037,7 +1037,7 @@ xfs_attr_shortform_verify(
>  		 * Check the fixed-offset parts of the structure are
>  		 * within the data buffer.
>  		 */
> -		if (((char *)sfep + sizeof(*sfep)) >= endp)
> +		if (((char *)sfep + sizeof(*sfep)-1) >= endp)
>  			return __this_address;
>  
>  		/* Don't allow names with known bad length. */
> 
