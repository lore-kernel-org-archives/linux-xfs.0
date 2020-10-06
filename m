Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DD2C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 22:10:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 60424208E4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 22:10:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ja9T2ZdF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726684AbgJFWKE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 18:10:04 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:51168 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgJFWKD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 18:10:03 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096M9x9a105273;
        Tue, 6 Oct 2020 22:09:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=YDFehqTFO7sGkQ+CadDUAQiDNlRbEI4Dl2vVdQdv6QQ=;
 b=Ja9T2ZdFE8WM3sxoGOCVkUqDZUQ3mRVYB/GooFB7gVM5Q04wB1X8KTJC0lI6v2syb0Zn
 zl4ew0HHmDKlVX+Tg9NHpcyR3zaktGegjAg1UAiz4Tgv2fKNp26l3uM5sJVY/Oi7u2Jt
 Dc9D1AlkfeT9UUUEELmhVXiQTNeXK+9jrYsTACFW6e5F7jpktYxEJ/0IjnfIk5DUvapc
 TC6IEC3lNwMpPSwyS454R3FtVXh3Yn7nzzLCxg1zmOTQJNIMG/7M/nonHUL2fhMBAnyO
 ZPLIFtYFt4NetKAfzrOFsFaiEUJHuYs97OXpA8EGkh5k1y1/BOgUuAS2zEu9/Zr6E4Vn Pw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 33ym34ktrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 22:09:59 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096M69DK128191;
        Tue, 6 Oct 2020 22:09:58 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 33y37xnjyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 22:09:58 +0000
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 096M9vo2002292;
        Tue, 6 Oct 2020 22:09:57 GMT
Received: from localhost (/10.159.134.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 15:09:57 -0700
Date:   Tue, 6 Oct 2020 15:09:56 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/2] xfsdump: remove obsolete code for handling
 mountpoint inodes
Message-ID: <20201006220956.GZ49547@magnolia>
References: <20201006220704.31157-1-ailiop@suse.com>
 <20201006220704.31157-2-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006220704.31157-2-ailiop@suse.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 spamscore=0
 mlxscore=0 malwarescore=0 suspectscore=1 adultscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 priorityscore=1501
 mlxscore=0 mlxlogscore=999 clxscore=1015 bulkscore=0 spamscore=0
 malwarescore=0 phishscore=0 suspectscore=1 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060145
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 12:07:03AM +0200, Anthony Iliopoulos wrote:
> The S_IFMNT file type was never supported in Linux, remove the last
> vestiges.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

Looks good to me,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  doc/xfsdump.html | 5 ++---
>  dump/content.c   | 3 ---
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/doc/xfsdump.html b/doc/xfsdump.html
> index d4d157fa62c5..9d06129a5e1d 100644
> --- a/doc/xfsdump.html
> +++ b/doc/xfsdump.html
> @@ -102,9 +102,8 @@ or stdout. The dump includes all the filesystem objects of:
>  <li>named pipes (S_FIFO)
>  <li>XENIX named pipes (S_IFNAM) 
>  </ul>
> -but not mount point types (S_IFMNT).
> -It also does not dump files from <i>/var/xfsdump</i> which
> -is where the xfsdump inventory is located.
> +It does not dump files from <i>/var/xfsdump</i> which is where the
> +xfsdump inventory is located.
>  Other data which is stored:
>  <ul>
>  <li> file attributes (stored in stat data) of owner, group, permissions,
> diff --git a/dump/content.c b/dump/content.c
> index 30232d422206..7637fe89609e 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -3913,9 +3913,6 @@ dump_file(void *arg1,
>  			contextp->cc_stat_lastino = statp->bs_ino;
>  		}
>  		return RV_OK;
> -	/* not yet implemented
> -	case S_IFMNT:
> -	 */
>  	}
>  
>  	if (rv == RV_OK
> -- 
> 2.28.0
> 
