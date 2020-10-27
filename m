Return-Path: <SRS0=u7A2=EC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1720C56201
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 17:42:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AF112054F
	for <linux-xfs@archiver.kernel.org>; Tue, 27 Oct 2020 17:42:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="p6PXk0Ot"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816702AbgJ0RmW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Oct 2020 13:42:22 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:39770 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1815693AbgJ0Rkd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Oct 2020 13:40:33 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RHdP68069627;
        Tue, 27 Oct 2020 17:40:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=ai3CIo5V3xkZE8hjaAdHK3L+FQzJDS9CG7y2U7aOX1o=;
 b=p6PXk0OtlkUTf1LM6UCOrurX2eJbVC5PR76aN2WYvyeVkUGTLiG9phekO+njV3YKFBpn
 Fftd/g1N6APANlp/R5pvA/CSPKcQzlmhe4FsVDvL7l0V1QEU/8GloiUqJzvsXwsCQvwu
 eDNfmPqq9VDjya1gI46r3h53Mmlhjl/ZrLCsFoOQTXFN+NBNGEYTH3Ky5LriK4WLNvPZ
 Mp8ke8h4Los0dR0b7bySMsnyR8XH3XKPXJA1zOFE+YkDMdATjDXSnPf885rmpaSyOQ3L
 glhEWGHkzv1gNCQxI3NyW2mh7YfveB2oR8GAq48brkmYIw35jJ4CQBmxICl77DRyBLD6 wg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 34c9saukj3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 27 Oct 2020 17:40:30 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09RHafpq035572;
        Tue, 27 Oct 2020 17:40:30 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 34cwump90m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Oct 2020 17:40:30 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09RHeT8Q023998;
        Tue, 27 Oct 2020 17:40:30 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 27 Oct 2020 10:40:29 -0700
Date:   Tue, 27 Oct 2020 10:40:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1.5/5] mkfs: clarify valid "inherit" option values
Message-ID: <20201027174026.GA1061252@magnolia>
References: <160375511371.879169.3659553317719857738.stgit@magnolia>
 <160375511989.879169.8816363379781873320.stgit@magnolia>
 <d59f5cbc-42b0-70f0-5471-210f87bf0fe3@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d59f5cbc-42b0-70f0-5471-210f87bf0fe3@sandeen.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=1
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010270105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9787 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=1
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010270105
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:24:29PM -0500, Eric Sandeen wrote:
> Clarify which values are valid for the various *inherit= mkfs
> options.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/man/man8/mkfs.xfs.8 b/man/man8/mkfs.xfs.8
> index 0a785874..a2be066b 100644
> --- a/man/man8/mkfs.xfs.8
> +++ b/man/man8/mkfs.xfs.8
> @@ -377,21 +377,21 @@ This option disables automatic geometry detection and creates the filesystem
>  without stripe geometry alignment even if the underlying storage device provides
>  this information.
>  .TP
> -.BI rtinherit= value
> -If set, all inodes created by
> +.BI rtinherit= [0|1]
> +If set to 1, all inodes created by
>  .B mkfs.xfs
>  will be created with the realtime flag set.
>  Directories will pass on this flag to newly created regular files and
>  directories.
>  .TP
> -.BI projinherit= value
> +.BI projinherit= projid
>  All inodes created by
>  .B mkfs.xfs
>  will be assigned this project quota id.
>  Directories will pass on the project id to newly created regular files and
>  directories.
>  .TP
> -.BI extszinherit= value
> +.BI extszinherit= extentsize

Hmm... if you're going to make this change to extszinherit, you might as
well do the same for cowextsize.

With that fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

>  All inodes created by
>  .B mkfs.xfs
>  will have this extent size hint applied.
> @@ -399,8 +399,8 @@ The value must be provided in units of filesystem blocks.
>  Directories will pass on this hint to newly created regular files and
>  directories.
>  .TP
> -.BI daxinherit= value
> -If set, all inodes created by
> +.BI daxinherit= [0|1]
> +If set to 1, all inodes created by
>  .B mkfs.xfs
>  will be created with the DAX flag set.
>  Directories will pass on this flag to newly created regular files and
> 
