Return-Path: <SRS0=guuR=DN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600F6C4363D
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 22:09:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DBAD6208E4
	for <linux-xfs@archiver.kernel.org>; Tue,  6 Oct 2020 22:09:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pXcdIT40"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgJFWJv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 18:09:51 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46468 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726137AbgJFWJv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Oct 2020 18:09:51 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096M09Yw037863;
        Tue, 6 Oct 2020 22:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=pe2AQaW+mZfdCpVlOCVOMd9lVAnwGDVFvlVZ8z4anOc=;
 b=pXcdIT40Dnk9EAVJgkcGGvW416JnIwHSrU4SATFBOiillhQSLXwbLColUaMGVkubgyxe
 rCaw9TK8cr3ODwROrX5rI7/U/mtfRV71cdImLzNK49KZ3GLz1Jof2YLJgvESYTs+Lk8P
 OFzHCVKdcKDiIC1WlRNliaVspPGLyn44HNe9Kh2yy3EQDegrTxSoTB/F0x6oZFs17AyO
 /vKWspex23iDthIi+/EqMTVfMLIoegIrThMHMm0B+y0OU9h19h6KZu2v1pSt+ckUZiu4
 kuiDJ8QJa7MfChGvouw2fecnlSHsjMBPDQwYfMotUK4hHHFRc7NzabIXMPdopoepo7NT fw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 33xetaxw4u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 06 Oct 2020 22:09:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 096M5907020701;
        Tue, 6 Oct 2020 22:09:45 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 33yyjg9q1h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Oct 2020 22:09:45 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 096M9i7s002244;
        Tue, 6 Oct 2020 22:09:44 GMT
Received: from localhost (/10.159.134.8)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 06 Oct 2020 15:09:43 -0700
Date:   Tue, 6 Oct 2020 15:09:43 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Anthony Iliopoulos <ailiop@suse.com>
Cc:     Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfsdump: remove obsolete code for handling xenix
 named pipes
Message-ID: <20201006220943.GY49547@magnolia>
References: <20201006220704.31157-1-ailiop@suse.com>
 <20201006220704.31157-3-ailiop@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201006220704.31157-3-ailiop@suse.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 adultscore=0 bulkscore=0
 phishscore=0 mlxlogscore=999 mlxscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060145
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9766 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1011 priorityscore=1501 adultscore=0 mlxlogscore=999 phishscore=0
 impostorscore=0 malwarescore=0 suspectscore=1 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2010060144
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 07, 2020 at 12:07:04AM +0200, Anthony Iliopoulos wrote:
> We can safely drop support for XENIX named pipes (S_IFNAM) at this
> point, since this was never implemented in Linux.
> 
> Signed-off-by: Anthony Iliopoulos <ailiop@suse.com>

<giggle> :)

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
>  doc/files.obj     | 2 +-
>  doc/xfsdump.html  | 1 -
>  dump/content.c    | 3 ---
>  dump/inomap.c     | 3 ---
>  restore/content.c | 8 --------
>  5 files changed, 1 insertion(+), 16 deletions(-)
> 
> diff --git a/doc/files.obj b/doc/files.obj
> index 4f4653ac56fc..098620e356da 100644
> --- a/doc/files.obj
> +++ b/doc/files.obj
> @@ -295,7 +295,7 @@ minilines(486,15,0,0,0,0,0,[
>  mini_line(486,12,3,0,0,0,[
>  str_block(0,486,12,3,0,-4,0,0,0,[
>  str_seg('black','Courier',0,80640,486,12,3,0,-4,0,0,0,0,0,
> -	"Other File (S_IFCHAR|S_IFBLK|S_IFIFO|S_IFNAM|S_IFSOCK)")])
> +	"Other File (S_IFCHAR|S_IFBLK|S_IFIFO|S_IFSOCK)")])
>  ])
>  ])]).
>  text('black',48,244,2,0,1,54,30,379,12,3,0,0,0,0,2,54,30,0,0,"",0,0,0,0,256,'',[
> diff --git a/doc/xfsdump.html b/doc/xfsdump.html
> index 9d06129a5e1d..958bc8055bef 100644
> --- a/doc/xfsdump.html
> +++ b/doc/xfsdump.html
> @@ -100,7 +100,6 @@ or stdout. The dump includes all the filesystem objects of:
>  <li>character special files (S_IFCHR)
>  <li>block special files (S_IFBLK)
>  <li>named pipes (S_FIFO)
> -<li>XENIX named pipes (S_IFNAM) 
>  </ul>
>  It does not dump files from <i>/var/xfsdump</i> which is where the
>  xfsdump inventory is located.
> diff --git a/dump/content.c b/dump/content.c
> index 7637fe89609e..75b79220daf6 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -3883,9 +3883,6 @@ dump_file(void *arg1,
>  	case S_IFCHR:
>  	case S_IFBLK:
>  	case S_IFIFO:
> -#ifdef S_IFNAM
> -	case S_IFNAM:
> -#endif
>  	case S_IFLNK:
>  	case S_IFSOCK:
>  		/* only need a filehdr_t; no data
> diff --git a/dump/inomap.c b/dump/inomap.c
> index 85f76df606a9..85d61c353cf0 100644
> --- a/dump/inomap.c
> +++ b/dump/inomap.c
> @@ -1723,9 +1723,6 @@ estimate_dump_space(struct xfs_bstat *statp)
>  	case S_IFIFO:
>  	case S_IFCHR:
>  	case S_IFDIR:
> -#ifdef S_IFNAM
> -	case S_IFNAM:
> -#endif
>  	case S_IFBLK:
>  	case S_IFSOCK:
>  	case S_IFLNK:
> diff --git a/restore/content.c b/restore/content.c
> index 6b22965bd894..97f821322960 100644
> --- a/restore/content.c
> +++ b/restore/content.c
> @@ -7313,9 +7313,6 @@ restore_file_cb(void *cp, bool_t linkpr, char *path1, char *path2)
>  		case S_IFBLK:
>  		case S_IFCHR:
>  		case S_IFIFO:
> -#ifdef S_IFNAM
> -		case S_IFNAM:
> -#endif
>  		case S_IFSOCK:
>  			ok = restore_spec(fhdrp, rvp, path1);
>  			return ok;
> @@ -7797,11 +7794,6 @@ restore_spec(filehdr_t *fhdrp, rv_t *rvp, char *path)
>  	case S_IFIFO:
>  		printstr = _("named pipe");
>  		break;
> -#ifdef S_IFNAM
> -	case S_IFNAM:
> -		printstr = _("XENIX named pipe");
> -		break;
> -#endif
>  	case S_IFSOCK:
>  		printstr = _("UNIX domain socket");
>  		break;
> -- 
> 2.28.0
> 
