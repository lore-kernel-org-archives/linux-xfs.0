Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C6FC4363A
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 18:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CD7020760
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 18:39:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="IZR3DAgr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S371106AbgJ0Sjz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 14:39:55 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:58424 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S371105AbgJ0Sjz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 14:39:55 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIYpeZ079533;
        Tue, 27 Oct 2020 18:39:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=B94A4AZM+GYhRYxqokZzLEhGISPlnf6OXoHb45ak6ZA=;
 b=IZR3DAgrDg4sCfSMEQmXGdYwmKVan7qx5p/f069OfFxKxwGPNROLhfA9zznraOXcjRJX
 yayYf6eYQvhoTYQsxfDRBZbHAApQ66Xmw1azywEEKyLwd5jXFgqpS3obabVQ+MoYKUmD
 yyNnZuM82sIGCQ7IfMX+vlDOmVEFFX4OPgtFAF3mPZSyRjZNAITL25bQiqAWrskmANfM
 cLo0VsZou0y71HvzCbCZjMit0JJySd2RncWx5FrKI0BItcVytgyMx4mh6AEvTiepyR/2
 NGufR5KBynmwcFilAfnXmueG3+bYXS6c4jKV03CdXLHrDFArd03KmckIqMbE96u3U3+S 7Q== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 34dgm41brk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 18:39:52 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RIUROx005025;
        Tue, 27 Oct 2020 18:37:51 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 34cwumqv4a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 18:37:51 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 09RIbnbR013694;
        Tue, 27 Oct 2020 18:37:50 GMT
Received: from localhost (/10.159.243.144)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 11:37:48 -0700
Date:   Tue, 27 Oct 2020 11:37:47 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1.5/5 V2] mkfs: clarify valid "inherit" option values
Message-ID: <20201027183747.GA1061260@magnolia>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375511989.879169.8816363379781873320.stgit@magnolia>
 <d59f5cbc-42b0-70f0-5471-210f87bf0fe3@sandeen.net>
 <04d65a53-00f9-527d-2b4c-c66b1799d2d4@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04d65a53-00f9-527d-2b4c-c66b1799d2d4@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270109
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=1 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270109
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:50:43PM -0500, Eric Sandeen wrote:
> Clarify which values are valid for the various *inherit= mkfs
> options.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> V2: Keep the same "=value" as elsewhere in the manpage but still clarify
> what those values should be and what they do.
> 
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 0a785874..10ceea30 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -378,31 +378,38 @@ without stripe geometry alignment even if the underlying storage device provides
>  this information.
>  .TP
>  .BI rtinherit= value
> -If set, all inodes created by
> +If
> +.I value
> +is set to 1, all inodes created by
>  .B mkfs.xfs
> -will be created with the realtime flag set.
> +will be created with the realtime flag set.  Default is 0.

Nit: Start new sentences on a new line.

>  Directories will pass on this flag to newly created regular files and
>  directories.
>  .TP
>  .BI projinherit= value
>  All inodes created by
>  .B mkfs.xfs
> -will be assigned this project quota id.
> +will be assigned the project quota id provided in 

Nit: Blank space at end of line.

> +.I value.
>  Directories will pass on the project id to newly created regular files and
>  directories.
>  .TP
>  .BI extszinherit= value
>  All inodes created by
>  .B mkfs.xfs
> -will have this extent size hint applied.
> +will have this
> +.I value
> +extent size hint applied.
>  The value must be provided in units of filesystem blocks.
>  Directories will pass on this hint to newly created regular files and
>  directories.
>  .TP
>  .BI daxinherit= value
> -If set, all inodes created by
> +If
> +.I value
> +is set to 1, all inodes created by
>  .B mkfs.xfs
> -will be created with the DAX flag set.
> +will be created with the DAX flag set.  Default is 0.

The first nit again...

With /that/ fixed...
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  Directories will pass on this flag to newly created regular files and
>  directories.
>  By default,
> 
