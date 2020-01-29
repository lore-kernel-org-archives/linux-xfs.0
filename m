Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8D66C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 16:01:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A20720716
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 16:01:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="UVC6vhX8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbgA2QB3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 11:01:29 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:44060 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbgA2QB3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 11:01:29 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00TFsPPf005723;
        Wed, 29 Jan 2020 16:01:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=qO5UZXwsad9AddenRihy417XTrlP5C1fFZXuC+yx0f4=;
 b=UVC6vhX8gm0E9Sk/NdYzIfM6b93dbsZMJDQAk6KybJLxprx6hJ3AyY3jzX3y1kUQ7nyP
 jUbkoBAIrJ9Mair2UFABJfxI6VuEPbQAONNkLPBvmxLsIJtwmZbzxFYcgWAFfmFhs3Zd
 IuyTtiZiTfQzTPEKQTfP6C1SU4ZmRXwnkK6YlCwLdcQlKWSxWJ3bSyrOhJNiVRiNMNJq
 0gej8JFQMy1yP76EBXvpCWJM3qlKfUNXow/iPjnPt9pc5ByVOtaA9L8adU/Xg+sdGt6t
 aQmuDT9RZHw3D97FGPh3zSkpF5E+Em0htq9nIp061f2ZbJbTBPaVosSheoR8SE3/I1w1 FQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2xreare9b0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 16:01:25 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00TFsO6j131487;
        Wed, 29 Jan 2020 16:01:24 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2xuc2wwfqs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Jan 2020 16:01:24 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00TG1MtP018917;
        Wed, 29 Jan 2020 16:01:23 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 29 Jan 2020 08:01:22 -0800
Date:   Wed, 29 Jan 2020 08:01:21 -0800
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eric Sandeen <sandeen@sandeen.net>
Cc:     linux-xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH V2] xfsprogs: do not redeclare globals provided by
 libraries
Message-ID: <20200129160121.GS3447196@magnolia>
References: <0892b951-ac99-9f84-9c65-421798daa547@sandeen.net>
 <a2b9920e-8f65-31d8-8809-a862213117df@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2b9920e-8f65-31d8-8809-a862213117df@sandeen.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001290132
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9514 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001290132
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 29, 2020 at 09:16:58AM -0600, Eric Sandeen wrote:
> In each of these cases, db, logprint, and mdrestore are redeclaring
> as a global variable something which was already provided by a
> library they link with. 
> 
> gcc now defaults to -fno-common and trips over these global variables
> which are declared in utilities as well as in libxfs and libxlog, and
> it causes the build to fail.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com> 
> ---
> 
> V2: unmangle whitespace, I'm a n00b.

BOFH FTW

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
> index 7754a2a..5809af9 100644
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

With the trailing whitespace after the comment fixed,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Though given your earlier comment on IRC, maybe we should investigate
why -fno-common would be useful (since Fedora turned it on??) or if it
should be in the regular build to catch multiply defined global vars?

--D

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
> 
