Return-Path: <SRS0=FA12=W2=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2EA0C3A59B
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 21:36:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A011F23439
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Aug 2019 21:36:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XFvcToxF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfH3VgH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Aug 2019 17:36:07 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:53578 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728079AbfH3VgG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Aug 2019 17:36:06 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7ULYFuF074977;
        Fri, 30 Aug 2019 21:36:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : subject : to :
 cc : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=JbbwYEUEAAYDUEFbiHhIDxvmoN1Iw7+wFW+2dLsLGNo=;
 b=XFvcToxFVhCKxzBaVbidjSNUFmFhl7ZqK05zQDq2AhXqgvXxuI1S3PGQzkuDaGL9laL0
 iNHWmVYm9/5vTKFRUAMS4YXLSUud5MexZ2XuJlRVqqQfC7NJd2fRt+KXb2t6h7o1mNcV
 Y65dMcIoAdLSTJh5Nnt/ZgXhp/aNsHA5scYtqTBdUMZBGwzPULo/KsKJF/5qpdgfElFH
 56Atc+AkhmcfDGufmNcmpKm1JrrcANiBhFQGWLVvbSHzE0qJ5rB+xzTgSIecyEwUhqJG
 ZlJz3b5khe7yXjjCRVysMWfgs0BqXO3hsyq+2qSGF02RLZy2rpbuDXRIQZlj/2PYgy8z kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 2uqbsgg0et-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 21:36:04 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7ULWa9D016049;
        Fri, 30 Aug 2019 21:36:03 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2upkrgvsc9-19
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Aug 2019 21:36:03 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7UL3Hq6017116;
        Fri, 30 Aug 2019 21:03:17 GMT
Received: from [192.168.1.9] (/67.1.183.122)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 30 Aug 2019 14:03:16 -0700
From:   Allison Collins <allison.henderson@oracle.com>
Subject: Re: [PATCH 1/9] libxfs: revert FSGEOMETRY v5 -> v4 hack
To:     "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
References: <156713882070.386621.8501281965010809034.stgit@magnolia>
 <156713882716.386621.4791011879331220967.stgit@magnolia>
Message-ID: <6b411536-eefe-80f1-1acb-3635ae34b530@oracle.com>
Date:   Fri, 30 Aug 2019 14:03:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <156713882716.386621.4791011879331220967.stgit@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908300206
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9365 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908300206
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 8/29/19 9:20 PM, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Revert the #define redirection of XFS_IOC_FSGEOMETRY to the old V4
> ioctl.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>   libxfs/xfs_fs.h |    4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
> 
> 
> diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
> index 67fceffc..31ac6323 100644
> --- a/libxfs/xfs_fs.h
> +++ b/libxfs/xfs_fs.h
> @@ -822,9 +822,7 @@ struct xfs_scrub_metadata {
>   #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
>   #define XFS_IOC_FSGEOMETRY_V4	     _IOR ('X', 124, struct xfs_fsop_geom_v4)
>   #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, uint32_t)
> -/* For compatibility, for now */
> -/* #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom_v5) */
> -#define XFS_IOC_FSGEOMETRY XFS_IOC_FSGEOMETRY_V4
> +#define XFS_IOC_FSGEOMETRY	     _IOR ('X', 126, struct xfs_fsop_geom)
>   #define XFS_IOC_BULKSTAT	     _IOR ('X', 127, struct xfs_bulkstat_req)
>   #define XFS_IOC_INUMBERS	     _IOR ('X', 128, struct xfs_inumbers_req)
>   
> 
Ok, looks fine to me

Reviewed-by: Allison Collins <allison.henderson@oracle.com>
