Return-Path: <SRS0=OQuR=ZA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 750E5C5DF60
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:50:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 478202178F
	for <linux-xfs@archiver.kernel.org>; Fri,  8 Nov 2019 06:50:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lft5o5Is"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729880AbfKHGuY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 Nov 2019 01:50:24 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:50640 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHGuY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Nov 2019 01:50:24 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA86iTAd041803;
        Fri, 8 Nov 2019 06:50:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=P9f7VDB9DS9Jmt5ICm+MvNl3iBvUkLQoQzo6oPaV134=;
 b=lft5o5IssK1bA6RGilbhDZndpKcPybUdwtAhKH2i4FPzpsIgwTq/KbAACpcRwAcWN7sP
 WOX4qWEZCpNErjBnczb+rV5bA3Q79IvG9y33DR1IMUbD2UFGNZoJqQzsr2kg2MtI/w7i
 I2RIt5P+aWtIVa0tlb0nhZ+Uz+QAQd0s4hROtm4Ne8fAY4LzEV4e5GXLpVdcsa3Mc8vF
 rG/6jO2cbsUQmT9zizfcw+qR+DZEkk4KUOqEc4+g6wng+iS3VEHst1o9rrJk8cgf/pby
 fnTYhnoGWoquXAHRlHWY7PW63TdxUXQGLytFoooUK3ZsEPUiDOCKdRv8S/OEX2UY4SsF Sw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 2w41w139t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 06:50:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA86mLCV151914;
        Fri, 8 Nov 2019 06:50:20 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2w41wgyt2a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 08 Nov 2019 06:50:20 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id xA86oJH1008946;
        Fri, 8 Nov 2019 06:50:19 GMT
Received: from localhost (/10.159.155.116)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 07 Nov 2019 22:50:19 -0800
Date:   Thu, 7 Nov 2019 22:50:17 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_io/lsattr: expose FS_XFLAG_HASATTR flag
Message-ID: <20191108065017.GN6219@magnolia>
References: <20191106055855.31517-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106055855.31517-1-amir73il@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1910280000 definitions=main-1911080066
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9434 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1910280000
 definitions=main-1911080066
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Nov 06, 2019 at 07:58:55AM +0200, Amir Goldstein wrote:
> For efficient check if file has xattrs.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  io/attr.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/io/attr.c b/io/attr.c
> index b713d017..ba88ef16 100644
> --- a/io/attr.c
> +++ b/io/attr.c
> @@ -37,6 +37,7 @@ static struct xflags {
>  	{ FS_XFLAG_FILESTREAM,		"S", "filestream"	},
>  	{ FS_XFLAG_DAX,			"x", "dax"		},
>  	{ FS_XFLAG_COWEXTSIZE,		"C", "cowextsize"	},
> +	{ FS_XFLAG_HASATTR,		"X", "has-xattr"	},

This causes an xfs/207 regression on the extra letter in the output; can
you please fix that?

--D

>  	{ 0, NULL, NULL }
>  };
>  #define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfSxC"
> @@ -65,6 +66,7 @@ lsattr_help(void)
>  " S -- enable filestreams allocator for this directory\n"
>  " x -- Use direct access (DAX) for data in this file\n"
>  " C -- for files with shared blocks, observe the inode CoW extent size value\n"
> +" X -- file has extended attributes (cannot be changed using chattr)\n"
>  "\n"
>  " Options:\n"
>  " -R -- recursively descend (useful when current file is a directory)\n"
> -- 
> 2.17.1
> 
