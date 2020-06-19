Return-Path: <SRS0=O+9a=AA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88DBAC433DF
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 04:47:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F71720CC7
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Jun 2020 04:47:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="tStn+cjJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgFSErm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 19 Jun 2020 00:47:42 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:38414 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725290AbgFSErm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 19 Jun 2020 00:47:42 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05J4gUJr070413;
        Fri, 19 Jun 2020 04:47:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=3J2oETwsXiNOLram6rYS34PrIGCRJJRD72P4x/eLKOY=;
 b=tStn+cjJdRMjeVXe3v72XCjJQueFFMUZ290G9htLpDMQsmEnZO4GMtQ6mhKdxegIKAJQ
 WI06wV3isVEtLXOWhCemm500o1QpeINOAay/f9aobwcIkuJus8fAMFe35R+awtWywwdR
 UT0w1bwlnIHtxRiARmpMOo4QYZ1nsBykcFW6wrBiPPelS5zD8N8UdB+x7coXTKIIHaCA
 Nu4wq4zyWJzMHs6BxqS+NXV+GHop6DiT5lm3RnEPr+njAWVtioD4EnapMCCC7FrbeMB1
 D2PrcFY7km6JJAWxJsL+rwnCxPP+BPr48ntMjBcnC9ZwYGpo2mhglTBmcbtwG15gwDGy DA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 31q6604ns6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 19 Jun 2020 04:47:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05J4lNTe074775;
        Fri, 19 Jun 2020 04:47:36 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 31q66uaaqw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jun 2020 04:47:36 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05J4lZih020824;
        Fri, 19 Jun 2020 04:47:35 GMT
Received: from localhost (/10.159.234.138)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 18 Jun 2020 21:47:35 -0700
Date:   Thu, 18 Jun 2020 21:47:34 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     peter green <plugwash@p10link.net>,
        Eric Sandeen <sandeen@redhat.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: Bug#953537: xfsdump fails to install in /usr merged system.
Message-ID: <20200619044734.GB11245@magnolia>
References: <998fa1cb-9e9f-93cf-15f0-e97e5ec54e9a@p10link.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <998fa1cb-9e9f-93cf-15f0-e97e5ec54e9a@p10link.net>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190031
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9656 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 bulkscore=0 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 spamscore=0 clxscore=1011 mlxlogscore=999 suspectscore=0 impostorscore=0
 cotscore=-2147483648 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006190030
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Jun 19, 2020 at 05:05:00AM +0100, peter green wrote:
> (original message was sent to nathans@redhat.com
> 953537@bugs.debian.org and linux-xfs@vger.kernel.org re-sending as
> plain-text only to linux-xfs@vger.kernel.org)
> 
> This bug has now caused xfsdump to be kicked out of testing which is
> making amanda unbuildable in testing.

Uhoh...

> 
> 
> > Yes, what's really needed here is for a change to be merged upstream
> > (as all other deb packaging artifacts are) otherwise this will keep
> > getting lost in time.
> To make it easier to upstream this I whipped up a patch that should
> solve the issue while only modifying the debian packaging and not
> touching the upstream makefiles. It is attached to this message and if
> I get no response I will likely do some further testing and then NMU
> it in Debian.
> 
> One issue I noticed is it's not all all obvious who upstream is. The
> sgi website listed in README seems to be long dead and there are no
> obvious upstream results in a google search for xfsdump. Gentoos page
> on xfsdump links to https://xfs.wiki.kernel.org but that page makes no
> mention of xfsdump.
> 
> I eventually poked around on git.kernel.org and my best guess is that
> https://git.kernel.org/pub/scm/fs/xfs/xfsdump-dev.git/ is the upstream
> git repository and linux-xfs@vger.kernel.org is the appropriate
> mailing list, I would appreciate comments on whether or not this is
> correct and updates to the documentation to reflect whatever the
> correct location is.

Yep, you've found us. :)

Uh... seeing how /sbin seems to be a symlink to /usr/sbin on more and
more distros now, how about we just change the upstream makefile to dump
them in /usr/sbin and forget all about the symlinks?

(He says, wondering what the actual maintainer will say...)

--D

> diff -Nru xfsdump-3.1.9/debian/changelog xfsdump-3.1.9+nmu1/debian/changelog
> --- xfsdump-3.1.9/debian/changelog	2020-01-31 17:30:58.000000000 +0000
> +++ xfsdump-3.1.9+nmu1/debian/changelog	2020-06-19 01:01:18.000000000 +0000
> @@ -1,3 +1,13 @@
> +xfsdump (3.1.9+nmu1) UNRELEASED; urgency=medium
> +
> +  * Non-maintainer upload.
> +  * Create and remove symlinks in postinst/preinst rather than including them
> +    in the package to support merged user systems. Based on a patch from
> +    Goffredo Baroncelli but adjusted to avoid the need for modifying upstream
> +    non-debian files. ( Closes: 953537 )
> +
> + -- Peter Michael Green <plugwash@debian.org>  Fri, 19 Jun 2020 01:01:18 +0000
> +
>  xfsdump (3.1.9) unstable; urgency=low
>  
>    * New upstream release
> diff -Nru xfsdump-3.1.9/debian/rules xfsdump-3.1.9+nmu1/debian/rules
> --- xfsdump-3.1.9/debian/rules	2020-01-31 17:30:58.000000000 +0000
> +++ xfsdump-3.1.9+nmu1/debian/rules	2020-06-19 01:01:18.000000000 +0000
> @@ -44,6 +44,9 @@
>  	-rm -rf $(dirme)
>  	$(pkgme) $(MAKE) -C . install
>  	$(pkgme) $(MAKE) dist
> +	#remove the symlinks in /usr/sbin, the postinst will create them
> +	#if appropriate for the users system 
> +	rm -f debian/xfsdump/usr/sbin/xfsdump debian/xfsdump/usr/sbin/xfsrestore
>  	dh_installdocs
>  	dh_installchangelogs
>  	dh_strip
> diff -Nru xfsdump-3.1.9/debian/xfsdump.postinst xfsdump-3.1.9+nmu1/debian/xfsdump.postinst
> --- xfsdump-3.1.9/debian/xfsdump.postinst	1970-01-01 00:00:00.000000000 +0000
> +++ xfsdump-3.1.9+nmu1/debian/xfsdump.postinst	2020-06-19 00:59:32.000000000 +0000
> @@ -0,0 +1,12 @@
> +#!/bin/sh
> +set -e
> +
> +if [ "$1" = 'configure' ]; then
> +  for file in xfsdump xfsrestore; do
> +    if [ ! -e /usr/sbin/$file ]; then
> +      ln -s /sbin/$file /usr/sbin/$file
> +    fi
> +  done
> +fi
> +
> +#DEBHELPER#
> diff -Nru xfsdump-3.1.9/debian/xfsdump.preinst xfsdump-3.1.9+nmu1/debian/xfsdump.preinst
> --- xfsdump-3.1.9/debian/xfsdump.preinst	1970-01-01 00:00:00.000000000 +0000
> +++ xfsdump-3.1.9+nmu1/debian/xfsdump.preinst	2020-06-19 01:01:18.000000000 +0000
> @@ -0,0 +1,12 @@
> +#!/bin/sh
> +set -e
> +
> +if [ "$1" = 'remove' ]; then
> +  for file in xfsdump xfsrestore; do
> +    if [ -L /usr/sbin/$file ]; then
> +      rm /usr/sbin/$file
> +    fi
> +  done
> +fi
> +
> +#DEBHELPER#

