Return-Path: <SRS0=UJS8=3R=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ADFFC33CB7
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 03:29:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CE152467B
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jan 2020 03:29:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="qQHzX/a7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgA1D3a (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Jan 2020 22:29:30 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:41778 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbgA1D3a (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Jan 2020 22:29:30 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3TOxs176013;
        Tue, 28 Jan 2020 03:29:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=AG0hu6LwstxOVikkBTavr0vrtwhoV9s7Dk3kOvWl9RA=;
 b=qQHzX/a7vtCdoMFRhMMb49HIGU+wWaHKSJDgfj+MxoHsnwPmYQ7chpy4p8oOjJWIG+Gk
 r7fdeHMp0OADnSgw2NHFRyav5zsVpS/54CAO8H9u4wZ7pq+jLFVQpHaGke46622g6zrt
 S75+2s8nC/3QwWLYnR4u+HLFggC6XmewSSGu8T1lwd/+TtneDeg5YbIiqWglzGOYNRaF
 oxeHNFnHjbsSGlsEGwMWCIHlj14jzKL29DHb9rSvHmqS6xTKYK2mvmC35HRrf8XqLjqe
 am0n1QRtBBqX/GIyy4gTLSNWidVAbiR2X4O+mrUgVcWdU6kjS9nrvLukExceWO1hFPmX JQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2xrear38uj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 03:29:27 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00S3TOq7038413;
        Tue, 28 Jan 2020 03:29:26 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2xry6x6use-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Jan 2020 03:29:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 00S3T8R5006800;
        Tue, 28 Jan 2020 03:29:08 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Jan 2020 19:29:08 -0800
Date:   Mon, 27 Jan 2020 19:29:07 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfsprogs: do not redeclare globals provided by libraries
Message-ID: <20200128032907.GM3447196@magnolia>
References: <0892b951-ac99-9f84-9c65-421798daa547@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0892b951-ac99-9f84-9c65-421798daa547@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001280026
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9513 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001280026
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jan 27, 2020 at 04:56:02PM -0600, Eric Sandeen wrote:
> From: Eric Sandeen <sandeen@redhat.com>
> 
> In each of these cases, db, logprint, and mdrestore are redeclaring
> as a global variable something which was already provided by a
> library they link with.

Er... which library?

Also, uh...maybe we shouldn't be exporting globals across libraries?

(He says having not looked for how many there are lurki... ye gods)

--D

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/db/init.c b/db/init.c
> index 455220a..0ac3736 100644
> --- a/db/init.c
> +++ b/db/init.c
> @@ -27,7 +27,6 @@ static int		force;
>  static struct xfs_mount	xmount;
>  struct xfs_mount	*mp;
>  static struct xlog	xlog;
> -libxfs_init_t		x;
>  xfs_agnumber_t		cur_agno = NULLAGNUMBER;
> 
>  static void
> diff --git a/logprint/logprint.c b/logprint/logprint.c
> index 7754a2a..511a32a 100644
> --- a/logprint/logprint.c
> +++ b/logprint/logprint.c
> @@ -24,7 +24,6 @@ int	print_buffer;
>  int	print_overwrite;
>  int     print_no_data;
>  int     print_no_print;
> -int     print_exit = 1; /* -e is now default. specify -c to override */
>  static int	print_operation = OP_PRINT;
> 
>  static void
> @@ -132,6 +131,7 @@ main(int argc, char **argv)
>  	bindtextdomain(PACKAGE, LOCALEDIR);
>  	textdomain(PACKAGE);
>  	memset(&mount, 0, sizeof(mount));
> +	print_exit = 1; /* -e is now default. specify -c to override */
> 
>  	progname = basename(argv[0]);
>  	while ((c = getopt(argc, argv, "bC:cdefl:iqnors:tDVv")) != EOF) {
> @@ -152,7 +152,7 @@ main(int argc, char **argv)
>  			case 'e':
>  			    /* -e is now default
>  			     */
> -				print_exit++;
> +				print_exit = 1;
>  				break;
>  			case 'C':
>  				print_operation = OP_COPY;
> diff --git a/mdrestore/xfs_mdrestore.c b/mdrestore/xfs_mdrestore.c
> index 3375e08..1cd399d 100644
> --- a/mdrestore/xfs_mdrestore.c
> +++ b/mdrestore/xfs_mdrestore.c
> @@ -7,7 +7,6 @@
>  #include "libxfs.h"
>  #include "xfs_metadump.h"
> 
> -char 		*progname;
>  static int	show_progress = 0;
>  static int	show_info = 0;
>  static int	progress_since_warning = 0;
> 
