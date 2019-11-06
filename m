Return-Path: <SRS0=KqY6=Y6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0B2C5DF63
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 16:03:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6DBCA20650
	for <linux-xfs@archiver.kernel.org>; Wed,  6 Nov 2019 16:03:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nt+Nfy5O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfKFQDw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 6 Nov 2019 11:03:52 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60976 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727028AbfKFQDw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 6 Nov 2019 11:03:52 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6G37hh076574;
        Wed, 6 Nov 2019 16:03:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=ESpk+ubONiAWIAit/WIiPvt1eR9pT3tlJuXga5lf96g=;
 b=nt+Nfy5O2UBsQKdTcVWXI8aeg8UEvsZGo62VSytmdiYwMg4A41yEVoijOFe+WpwTXivT
 r4yZKErfiATt/vNzbsYbPm1sFDGx0clJrIp2lygUFJ5CKB2RJqqrTrZQdg3RahjuKDoR
 nz4TqD1U6rlBW5GvPu5krqzKWEBqCiM16W58yBh+oxMbXxT8TY8VCxR0zB17PysXhmfU
 wUx+mZeQ5hH5FNyyBlJzm9z3EeEOC440czDmsUcPT3D0bA/VV3TA7nHrZmtAmvC1iUbF
 W9qiIRLid+XF1vPt3/85r6NSidhW5qhZwZ7KDRGL8lz1uG3CRykUI3nWy9vMHhwv1l+g WQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2w12erfknm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 16:03:44 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xA6FxSk8176028;
        Wed, 6 Nov 2019 16:01:43 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2w3vr329jg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 06 Nov 2019 16:01:43 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xA6G1gJT011468;
        Wed, 6 Nov 2019 16:01:42 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 06 Nov 2019 08:01:42 -0800
Date:   Wed, 6 Nov 2019 08:01:39 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs_io/lsattr: expose FS_XFLAG_HASATTR flag
Message-ID: <20191106160139.GK4153244@magnolia>
References: <20191106055855.31517-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191106055855.31517-1-amir73il@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1911060154
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9433 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1908290000
 definitions=main-1911060154
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
>  	{ 0, NULL, NULL }
>  };
>  #define CHATTR_XFLAG_LIST	"r"/*p*/"iasAdtPneEfSxC"

/me wonders if this should have /*X*/ commented out the same way we do
for "p".

Otherwise, the patch looks ok to me...

/me *also* wonders how many filesystems fail to implement this flag but
support xattrs.

Oh.  All of them.  Though I assume overlayfs is being patched... :)

--D

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
