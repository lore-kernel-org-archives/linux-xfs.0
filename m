Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8E55C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 531BC22247
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:41:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="GhPvTily"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728185AbgJOFlD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 01:41:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:52042 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727397AbgJOFlD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 01:41:03 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5dp31178659;
        Thu, 15 Oct 2020 05:41:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=iiQpPg3APeJedwtZZq+Dq/sZox9OTAGQavCn7HMIFcw=;
 b=GhPvTilypBBVewCm98sjNBNAffzFaOJpHWqyARLN/Tsw7JckQ+keHN2ZlQQl+dVWpgf4
 Iowq6m9FwPajWBGq6iKL55d/xI2wtnflYrsy4GqjBZ+c1+9jB0gszF0sQ5LqAoYpC+xx
 gxDOGoZnUf0ZZxLS5iZaMVk7A0OKfGl9/8/1XZD3w37h6BU5sjLmSNmtTD4MirGFpNqI
 NfS0jpDWcoGuCVaqYCqTLclhpKmGZ/XpvjsMcFr2OO9Y4Fnd9h7MF4B+3VEqXB1otfn3
 S4Ng7Neh6cp58GX6wMSGN67L65L9Cw7UD13OsHU16hF453WJgoNXgB2DSQr16vPZX+fh 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 343vaeh6a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 05:41:00 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5ZI0V031008;
        Thu, 15 Oct 2020 05:40:59 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3020.oracle.com with ESMTP id 343pv1bd19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 05:40:59 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09F5ewYZ002863;
        Thu, 15 Oct 2020 05:40:58 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Oct 2020 22:40:57 -0700
Date:   Wed, 14 Oct 2020 22:40:55 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/5] build: add support for libinih for mkfs
Message-ID: <20201015054055.GR9832@magnolia>
References: <20201015032925.1574739-1-david@fromorbit.com>
 <20201015032925.1574739-2-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015032925.1574739-2-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=2 phishscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150039
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 clxscore=1015
 impostorscore=0 phishscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 mlxscore=0 suspectscore=2 spamscore=0 adultscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010150040
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 02:29:21PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Need to make sure the library is present so we can build mkfs with
> config file support.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  configure.ac         |  3 +++
>  doc/INSTALL          |  5 +++++
>  include/builddefs.in |  1 +
>  m4/package_inih.m4   | 20 ++++++++++++++++++++
>  4 files changed, 29 insertions(+)
>  create mode 100644 m4/package_inih.m4
> 
> diff --git a/configure.ac b/configure.ac
> index 4674673ed67c..dc57bbd7cd8c 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -145,6 +145,9 @@ AC_PACKAGE_UTILITIES(xfsprogs)
>  AC_MULTILIB($enable_lib64)
>  AC_RT($enable_librt)
>  
> +AC_PACKAGE_NEED_INI_H
> +AC_PACKAGE_NEED_LIBINIH
> +
>  AC_PACKAGE_NEED_UUID_H
>  AC_PACKAGE_NEED_UUIDCOMPARE
>  
> diff --git a/doc/INSTALL b/doc/INSTALL
> index d4395eefa834..2b04f9cfe108 100644
> --- a/doc/INSTALL
> +++ b/doc/INSTALL
> @@ -28,6 +28,11 @@ Linux Instructions
>     (on an RPM based system) or the uuid-dev package (on a Debian system)
>     as some of the commands make use of the UUID library provided by these.
>  
> +   If your distro does not provide a libinih package, you can download and build
> +   it from source from the upstream repository found at:
> +
> +	https://github.com/benhoyt/inih

Someone's gonna have fun packaging this for RHEL. ;)

Oh look, a Debian package.  Assuming the legal-minded are ok with us
mixing BSD and GPL2 code,

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> +
>     To build the package and install it manually, use the following steps:
>  
>  	# make
> diff --git a/include/builddefs.in b/include/builddefs.in
> index 30b2727a8db4..e8f447f92baf 100644
> --- a/include/builddefs.in
> +++ b/include/builddefs.in
> @@ -27,6 +27,7 @@ LIBTERMCAP = @libtermcap@
>  LIBEDITLINE = @libeditline@
>  LIBBLKID = @libblkid@
>  LIBDEVMAPPER = @libdevmapper@
> +LIBINIH = @libinih@
>  LIBXFS = $(TOPDIR)/libxfs/libxfs.la
>  LIBFROG = $(TOPDIR)/libfrog/libfrog.la
>  LIBXCMD = $(TOPDIR)/libxcmd/libxcmd.la
> diff --git a/m4/package_inih.m4 b/m4/package_inih.m4
> new file mode 100644
> index 000000000000..a2775592e09d
> --- /dev/null
> +++ b/m4/package_inih.m4
> @@ -0,0 +1,20 @@
> +AC_DEFUN([AC_PACKAGE_NEED_INI_H],
> +  [ AC_CHECK_HEADERS([ini.h])
> +    if test $ac_cv_header_ini_h = no; then
> +	echo
> +	echo 'FATAL ERROR: could not find a valid ini.h header.'
> +	echo 'Install the libinih development package.'
> +	exit 1
> +    fi
> +  ])
> +
> +AC_DEFUN([AC_PACKAGE_NEED_LIBINIH],
> +  [ AC_CHECK_LIB(inih, ini_parse,, [
> +	echo
> +	echo 'FATAL ERROR: could not find a valid inih library.'
> +	echo 'Install the libinih library package.'
> +	exit 1
> +    ])
> +    libinih=-linih
> +    AC_SUBST(libinih)
> +  ])
> -- 
> 2.28.0
> 
