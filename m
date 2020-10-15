Return-Path: <SRS0=m1l6=DW=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC3EAC433E7
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55D3A22248
	for <linux-xfs@archiver.kernel.org>; Thu, 15 Oct 2020 05:13:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="lls0bk3v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgJOFNG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 15 Oct 2020 01:13:06 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38828 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgJOFNG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 15 Oct 2020 01:13:06 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5Aljb170799;
        Thu, 15 Oct 2020 05:13:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5hiDit8KE1hg8rbC5ASmuU/cGPm8kpD177t0r/8eFNU=;
 b=lls0bk3vfXYPJZxqBPvD0s9gsNYWzX8KTnqmw3e/dTQk8Yr2aWQuFu9F2STzCfKGilM3
 9FFU6yWQe5QiyAXIeS7ajqlljC4n5R5r2mJ5E8L23/sur1tGo9bS6s8OBbOKx/XpL8ZH
 tsgXQehCVDwI5sXQxcGg0ifpULgLg5AzrL6gOYDJIB0X4vXSOzysVeR8gOTGzj7F/+gC
 j/SS3pHOvWlybRS720LQ5CKzuecDSw8mDOCtBze4x/zX1KTyHmLHMQTbws8OU2e37KTs
 uF+AV5ZFIyFDB7a5PCQas5pLn8EZTQqgt22aZ67r4oc14nYMZzdpRq+9JHP0abvzpzpk JQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 343pak1f5f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Oct 2020 05:13:03 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09F5BeAu042946;
        Thu, 15 Oct 2020 05:13:03 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 344by4nevw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Oct 2020 05:13:03 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09F5D15W025661;
        Thu, 15 Oct 2020 05:13:01 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 14 Oct 2020 22:13:00 -0700
Date:   Wed, 14 Oct 2020 22:13:00 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 0/5] mkfs: Configuration file defined options
Message-ID: <20201015051300.GM9832@magnolia>
References: <20201015032925.1574739-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201015032925.1574739-1-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 suspectscore=26 mlxscore=0 malwarescore=0 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150037
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9774 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=26
 impostorscore=0 priorityscore=1501 clxscore=1015 malwarescore=0
 adultscore=0 lowpriorityscore=0 spamscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010150037
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 15, 2020 at 02:29:20PM +1100, Dave Chinner wrote:
> Version 2:
> 
> - "-c file=xxx" > "-c options=xxx"
> - split out constification into new patch
> - removed debug output
> - fixed some comments
> - added man page stuff
> 
> Hi Folks,
> 
> Because needing config files for mkfs came up yet again in
> discussion, here is a simple implementation of INI format config
> files. These config files behave identically to options specified on
> the command line - the do not change defaults, they do not override
> CLI options, they are not overridden by cli options.
> 
> Example:
> 
> $ echo -e "[metadata]\ncrc = 0" > foo
> $ mkfs/mkfs.xfs -N -c options=foo -d file=1,size=100m blah
> Parameters parsed from config file foo successfully
> meta-data=blah                   isize=256    agcount=4, agsize=6400 blks
>          =                       sectsz=512   attr=2, projid32bit=1
>          =                       crc=0        finobt=0, sparse=0, rmapbt=0
>          =                       reflink=0
> data     =                       bsize=4096   blocks=25600, imaxpct=25
>          =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
> log      =internal log           bsize=4096   blocks=853, version=2
>          =                       sectsz=512   sunit=0 blks, lazy-count=1
> realtime =none                   extsz=4096   blocks=0, rtextents=0
> $
> 
> And there's a V4 filesystem as specified by the option defined
> in the config file. If we do:
> 
> $ mkfs/mkfs.xfs -N -c options=foo -m crc=1 -d file=1,size=100m blah
> -m crc option respecified
> Usage: mkfs.xfs
> .....
> $
> 
> You can see it errors out because the CRC option was specified in
> both the config file and on the CLI.
> 
> There's lots of stuff we can do to make the conflict and respec
> error messages better, but that doesn't change the basic
> functionality of config file based mkfs options. To allow for future
> changes to the way we want to apply config files, I created a
> full option subtype for config files. That means we can add another
> option to say "apply config file as default values rather than as
> options" if we decide that is functionality that we want to support.
> 
> However, policy decisions like that are completely separate to the
> mechanism, so these patches don't try to address desires to ship
> "tuned" configs, system wide option files, shipping distro specific
> defaults in config files, etc. This is purely a mechanism to allow
> users to specify options via files instead of on the CLI.  No more,
> no less.
> 
> This has only been given a basic smoke testing right now (see above!
> :).  I need to get Darrick's tests from the previous round of config

This was in the v1 series; have you gotten Darrick's fstests to do more
substantial testing? ;)

--D

> file bikeshedding working in my test environment to do more
> substantial testing of this....
> 
> Cheers,
> 
> Dave.
> 
> 
> Dave Chinner (5):
>   build: add support for libinih for mkfs
>   mkfs: add initial ini format config file parsing support
>   mkfs: constify various strings
>   mkfs: hook up suboption parsing to ini files
>   mkfs: document config files in mkfs.xfs(8)
> 
>  configure.ac         |   3 +
>  doc/INSTALL          |   5 +
>  include/builddefs.in |   1 +
>  include/linux.h      |   2 +-
>  m4/package_inih.m4   |  20 ++++
>  man/man8/mkfs.xfs.8  | 113 +++++++++++++++++++--
>  mkfs/Makefile        |   2 +-
>  mkfs/xfs_mkfs.c      | 228 ++++++++++++++++++++++++++++++++++++++-----
>  8 files changed, 340 insertions(+), 34 deletions(-)
>  create mode 100644 m4/package_inih.m4
> 
> -- 
> 2.28.0
> 
