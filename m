Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB6AC4742C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 20:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 96E4A20809
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 20:24:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T+G21ktp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgJ2UYr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 16:24:47 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:60086 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725764AbgJ2UYq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 16:24:46 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKOcbI088271;
        Thu, 29 Oct 2020 20:24:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=5Pw+fi9NjCuosMXAQJJwp7G7pk7Nbl7MfBGVDcpOzu8=;
 b=T+G21ktprrdg9+YA0e9Kn1woa3EvP2p8+MCPOELgYlno8fjzwkQKIZxIKxn9YieJaaha
 AgApVYJPyjhTAdi3yeova8HFb4Q+5ChfS6oTnzM1NYKgR31huyFzCBcCtAgaC3PDTPus
 a/8QGcjrjBj/cmYOXTRhrXLKvXvsKmTwZsoHMV3/PMPdeEEw7NOe/jsc/X0R/nh67JVC
 LUceqfQpKU3FR1OKQtH2S/x8OHOP/Z7NUIuYrxU43cF4bQ/618torjYy1eiku91R5Yi1
 b2MF/FnbxAAzwJsAlK0Zz17xWbw4rLNgHdGY/Hhkkx3ZL8M4moahHN8hevyyDxDgY6Vh Zg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 34dgm4cfvw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 20:24:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TKKPkP070578;
        Thu, 29 Oct 2020 20:24:44 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 34cx1tn6y3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 20:24:44 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TKOhq6012837;
        Thu, 29 Oct 2020 20:24:43 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 13:24:42 -0700
Date:   Thu, 29 Oct 2020 13:24:42 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: test the xfs_db ls command
Message-ID: <20201029202442.GZ1061252@magnolia>
References: <160382540004.1203622.14607732322524118731.stgit@magnolia>
 <160382541257.1203622.11553283849694190202.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <160382541257.1203622.11553283849694190202.stgit@magnolia>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=3 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 bulkscore=0 spamscore=0 phishscore=0 mlxlogscore=999
 suspectscore=3 clxscore=1015 mlxscore=0 malwarescore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290141
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 27, 2020 at 12:03:32PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure that the xfs_db ls command works the way the author thinks it
> does.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

FWIW, this test will have to change to accomodate some of the review
suggestions, so anyone looking at this series might as well wait until
v2.

--D

> ---
>  tests/xfs/918     |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/918.out |   23 ++++++++++++++
>  tests/xfs/group   |    1 +
>  3 files changed, 111 insertions(+)
>  create mode 100755 tests/xfs/918
>  create mode 100644 tests/xfs/918.out
> 
> 
> diff --git a/tests/xfs/918 b/tests/xfs/918
> new file mode 100755
> index 00000000..759943ac
> --- /dev/null
> +++ b/tests/xfs/918
> @@ -0,0 +1,87 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 918
> +#
> +# Make sure the xfs_db ls command works the way the author thinks it does.
> +# This means that we can list the current directory, list an arbitrary path,
> +# and we can't list things that aren't directories.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1    # failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_db_command "path"
> +_require_xfs_db_command "ls"
> +_require_scratch
> +
> +echo "Format filesystem and populate"
> +_scratch_mkfs > $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +$XFS_INFO_PROG $SCRATCH_MNT | grep -q ftype=1 || \
> +	_notrun "filesystem does not support ftype"
> +
> +filter_ls() {
> +	sed	-e "s/^$root_ino /rootd/g" \
> +		-e "s/^$a_ino /a_ino/g" \
> +		-e "s/^$b_ino /b_ino/g" \
> +		-e "s/^$c_ino /c_ino/g" \
> +		-e "s/^$d_ino /d_ino/g" \
> +		-e "s/^$e_ino /e_ino/g" |
> +	awk '{printf("%s %s %s %s %s\n", $1, $2, $3, $4, $5);}'
> +}
> +
> +mkdir $SCRATCH_MNT/a
> +mkdir $SCRATCH_MNT/a/b
> +$XFS_IO_PROG -f -c 'pwrite 0 61' $SCRATCH_MNT/a/c >> $seqres.full
> +ln $SCRATCH_MNT/a/c $SCRATCH_MNT/d
> +ln -s -f b $SCRATCH_MNT/a/e
> +
> +root_ino=$(stat -c '%i' $SCRATCH_MNT)
> +a_ino=$(stat -c '%i' $SCRATCH_MNT/a)
> +b_ino=$(stat -c '%i' $SCRATCH_MNT/a/b)
> +c_ino=$(stat -c '%i' $SCRATCH_MNT/a/c)
> +d_ino=$(stat -c '%i' $SCRATCH_MNT/d)
> +e_ino=$(stat -c '%i' $SCRATCH_MNT/a/e)
> +
> +_scratch_unmount
> +
> +echo "Manually navigate to root dir then list"
> +_scratch_xfs_db -c 'sb 0' -c 'addr rootino' -c ls | filter_ls
> +
> +echo "Use path to navigate to root dir then list"
> +_scratch_xfs_db -c 'path /' -c ls | filter_ls
> +
> +echo "Use path to navigate to /a then list"
> +_scratch_xfs_db -c 'path /a' -c ls | filter_ls
> +
> +echo "Use path to navigate to /a/b then list"
> +_scratch_xfs_db -c 'path /a/b' -c ls | filter_ls
> +
> +echo "Use path to navigate to /a/c then list"
> +_scratch_xfs_db -c 'path /a/c' -c ls | \
> +	sed -e "s/^$c_ino /c_ino /g" -e "s/<$c_ino>/<c_ino>/g" |
> +	awk '{printf("%s %s %s\n", $1, $2, $5);}'
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/918.out b/tests/xfs/918.out
> new file mode 100644
> index 00000000..2e0ad939
> --- /dev/null
> +++ b/tests/xfs/918.out
> @@ -0,0 +1,23 @@
> +QA output created by 918
> +Format filesystem and populate
> +Manually navigate to root dir then list
> +rootd directory 0x0000002e 1 .
> +rootd directory 0x0000172e 2 ..
> +a_ino directory 0x00000061 1 a
> +c_ino regular 0x00000064 1 d
> +Use path to navigate to root dir then list
> +rootd directory 0x0000002e 1 .
> +rootd directory 0x0000172e 2 ..
> +a_ino directory 0x00000061 1 a
> +c_ino regular 0x00000064 1 d
> +Use path to navigate to /a then list
> +a_ino directory 0x0000002e 1 .
> +rootd directory 0x0000172e 2 ..
> +b_ino directory 0x00000062 1 b
> +c_ino regular 0x00000063 1 c
> +e_ino symlink 0x00000065 1 e
> +Use path to navigate to /a/b then list
> +b_ino directory 0x0000002e 1 .
> +a_ino directory 0x0000172e 2 ..
> +Use path to navigate to /a/c then list
> +c_ino regular <c_ino>
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 82e02196..4b0caea4 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -526,3 +526,4 @@
>  763 auto quick rw realtime
>  915 auto quick quota
>  917 auto quick db
> +918 auto quick db
> 
