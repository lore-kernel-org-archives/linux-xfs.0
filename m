Return-Path: <SRS0=cOuX=EE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34EEEC4742C
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:27:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA75F2087E
	for <linux-xfs@archiver.kernel.org>; Thu, 29 Oct 2020 21:27:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="apLE2A6p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgJ2V1V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 29 Oct 2020 17:27:21 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:46800 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgJ2V1V (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Oct 2020 17:27:21 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TL9KYl085079;
        Thu, 29 Oct 2020 21:27:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=Y5aSX0Gcl0GpBGouJjv9CIiUvqPCKKz0dbP7q2lp6Lg=;
 b=apLE2A6p+TK60JV5qdXXFwLvaIDBJKCunuPRvvZdCH3XXs8+5Q9KM7bLFsMyWPnXJ29f
 UHtiUJAn2ldFgvksz3YeHIFDQ0n99quWVfyx5Izqvnu3LkMEyPCQJrxlOrnIBzZbO8NZ
 sBqsvdXGjQ6VS6RFyAAOppHY2M7kWDESp9gIW2qwD551CxsVpET0RwXqruwKQob3IA0L
 kEu/6K2SJJk3ir8iSQVjwg684+Av58mf9m/w5Ozs8nZi+uiM06M6lSfARsaZF8bKHxw/
 dte222vujg18BNvvn3kOpuqpi5bMEumZ28JgX8XlFNpJUqTV4r5NGu6wUo/56Dwa75gh aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 34c9sb7ak8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 29 Oct 2020 21:27:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 09TLQPtS074623;
        Thu, 29 Oct 2020 21:27:17 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 34cx1tpxv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Oct 2020 21:27:16 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 09TLREHr007269;
        Thu, 29 Oct 2020 21:27:14 GMT
Received: from localhost (/10.159.244.77)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 29 Oct 2020 14:27:14 -0700
Date:   Thu, 29 Oct 2020 14:27:13 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: test mkfs.xfs config files
Message-ID: <20201029212713.GF1061260@magnolia>
References: <20201027205450.2824888-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201027205450.2824888-1-david@fromorbit.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2010290149
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9789 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 spamscore=0 phishscore=0 clxscore=1015 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010290148
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 28, 2020 at 07:54:50AM +1100, Dave Chinner wrote:
> From: "Darrick J. Wong" <darrick.wong@oracle.com>
> 
> Simple tests of the upcoming mkfs.xfs config file feature.  First we
> have some simple tests of properly formatted config files, then
> improperly formatted config files, and finally we try to spot
> conflicts between config file options and the cli.
> 
> [dchinner: updated for new libinih-based implementation.]
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  common/xfs        |  10 +++
>  tests/xfs/716     | 219 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/716.out |  16 ++++
>  tests/xfs/717     | 195 +++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/717.out |  13 +++
>  tests/xfs/718     |  65 ++++++++++++++
>  tests/xfs/718.out |   2 +
>  tests/xfs/719     |  62 +++++++++++++
>  tests/xfs/719.out |   2 +
>  tests/xfs/720     |  64 ++++++++++++++
>  tests/xfs/720.out |   3 +
>  tests/xfs/group   |   5 ++
>  12 files changed, 656 insertions(+)
>  create mode 100755 tests/xfs/716
>  create mode 100644 tests/xfs/716.out
>  create mode 100755 tests/xfs/717
>  create mode 100644 tests/xfs/717.out
>  create mode 100755 tests/xfs/718
>  create mode 100644 tests/xfs/718.out
>  create mode 100755 tests/xfs/719
>  create mode 100644 tests/xfs/719.out
>  create mode 100755 tests/xfs/720
>  create mode 100644 tests/xfs/720.out
> 
> diff --git a/common/xfs b/common/xfs
> index 79dab058..abfd8a15 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -700,6 +700,16 @@ _require_xfs_mkfs_ciname()
>  		|| _notrun "need case-insensitive naming support in mkfs.xfs"
>  }
>  
> +# this test requires mkfs.xfs have configuration file support
> +_require_xfs_mkfs_cfgfile()
> +{
> +	echo > /tmp/a
> +	_scratch_mkfs_xfs_supported -c options=/tmp/a >/dev/null 2>&1
> +	res=$?
> +	rm -rf /tmp/a
> +	test $res -eq 0 || _notrun "need configuration file support in mkfs.xfs"
> +}
> +
>  # XFS_DEBUG requirements
>  _require_xfs_debug()
>  {
> diff --git a/tests/xfs/716 b/tests/xfs/716
> new file mode 100755
> index 00000000..d8ee7350
> --- /dev/null
> +++ b/tests/xfs/716
> @@ -0,0 +1,219 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 716
> +#
> +# Feed valid mkfs config files to the mkfs parser to ensure that they are
> +# recognized as valid.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap '_cleanup; exit $status' 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.* $def_cfgfile $fsimg
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_test
> +_require_scratch_nocheck
> +_require_xfs_mkfs_cfgfile
> +
> +def_cfgfile=$TEST_DIR/a
> +fsimg=$TEST_DIR/a.img
> +rm -rf $def_cfgfile $fsimg
> +truncate -s 20t $fsimg
> +
> +test_mkfs_config() {
> +	local cfgfile="$1"
> +	if [ -z "$cfgfile" ] || [ "$cfgfile" = "-" ]; then
> +		cfgfile=$def_cfgfile
> +		cat > $cfgfile
> +	fi
> +	$MKFS_XFS_PROG -c options=$cfgfile -f -N $fsimg >> $seqres.full 2> $tmp.err
> +	cat $tmp.err | _filter_test_dir
> +}
> +
> +echo Simplest config file
> +cat > $def_cfgfile << ENDL
> +[metadata]
> +crc = 0
> +ENDL
> +test_mkfs_config $def_cfgfile
> +
> +echo Piped-in config file
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 1
> +ENDL
> +
> +echo Full line comment
> +test_mkfs_config << ENDL
> +# This is a full line comment.
> +[metadata]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> + # This is a full line comment.
> +[metadata]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +#This is a full line comment.
> +[metadata]
> +crc = 0
> +ENDL
> +
> +echo End of line comment
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 0 ; This is an eol comment.

Hey, wait a minute, the manpage didn't say I could use semicolon
comments! :)

The libinih page https://github.com/benhoyt/inih says you can though.

Would you mind making a note of that in patch 5 above, please?

--D

> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 0 ;This is an eol comment.
> +ENDL
> +
> +echo Multiple directives
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 0
> +finobt = 0
> +ENDL
> +
> +echo Multiple sections
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 0
> +
> +[inode]
> +sparse = 0
> +ENDL
> +
> +echo No directives at all
> +test_mkfs_config << ENDL
> +[metadata]
> +ENDL
> +
> +echo Space around the section name
> +test_mkfs_config << ENDL
> + [metadata]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata] 
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> + [metadata] 
> +crc = 0
> +ENDL
> +
> +echo Single space around the key/value directive
> +test_mkfs_config << ENDL
> +[metadata]
> + crc=0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc =0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc= 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc=0 
> +ENDL
> +
> +echo Two spaces around the key/value directive
> +test_mkfs_config << ENDL
> +[metadata]
> + crc =0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> + crc= 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> + crc=0 
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc =0 
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc= 0 
> +ENDL
> +
> +echo Three spaces around the key/value directive
> +test_mkfs_config << ENDL
> +[metadata]
> + crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> + crc= 0 
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 0 
> +ENDL
> +
> +echo Four spaces around the key/value directive
> +test_mkfs_config << ENDL
> +[metadata]
> + crc = 0 
> +ENDL
> +
> +echo Arbitrary spaces and tabs
> +test_mkfs_config << ENDL
> +[metadata]
> +	  crc 	  	=   	  	 0	  	 	  
> +ENDL
> +
> +echo ambiguous comment/section names
> +test_mkfs_config << ENDL
> +[metadata]
> +#[data]
> +crc = 0
> +ENDL
> +
> +echo ambiguous comment/variable names
> +test_mkfs_config << ENDL
> +[metadata]
> +#foo = 0 ; is this a comment or a key '#foo' ?
> +ENDL
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/716.out b/tests/xfs/716.out
> new file mode 100644
> index 00000000..4c6e9fad
> --- /dev/null
> +++ b/tests/xfs/716.out
> @@ -0,0 +1,16 @@
> +QA output created by 716
> +Simplest config file
> +Piped-in config file
> +Full line comment
> +End of line comment
> +Multiple directives
> +Multiple sections
> +No directives at all
> +Space around the section name
> +Single space around the key/value directive
> +Two spaces around the key/value directive
> +Three spaces around the key/value directive
> +Four spaces around the key/value directive
> +Arbitrary spaces and tabs
> +ambiguous comment/section names
> +ambiguous comment/variable names
> diff --git a/tests/xfs/717 b/tests/xfs/717
> new file mode 100755
> index 00000000..031d59f1
> --- /dev/null
> +++ b/tests/xfs/717
> @@ -0,0 +1,195 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 717
> +#
> +# Feed invalid mkfs config files to the mkfs parser to ensure that they are
> +# recognized as invalid.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap '_cleanup; exit $status' 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.* $def_cfgfile $fsimg
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_test
> +_require_scratch_nocheck
> +_require_xfs_mkfs_cfgfile
> +
> +def_cfgfile=$TEST_DIR/a
> +fsimg=$TEST_DIR/a.img
> +rm -rf $def_cfgfile $fsimg
> +truncate -s 20t $fsimg
> +
> +test_mkfs_config() {
> +	local cfgfile="$1"
> +	if [ -z "$cfgfile" ] || [ "$cfgfile" = "-" ]; then
> +		cfgfile=$def_cfgfile
> +		cat > $cfgfile
> +	fi
> +	$MKFS_XFS_PROG -c options=$cfgfile -f -N $fsimg >> $seqres.full 2> $tmp.err
> +	if [ $? -eq 0 ]; then
> +		echo "Test passed, should have failed! Config file parameters:"
> +		cat $cfgfile
> +	fi
> +}
> +
> +echo Spaces in a section name
> +test_mkfs_config << ENDL
> +[meta data]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[meta	data]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[ metadata]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata ]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[ metadata ]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[ metadata] 
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata ] 
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> + [ metadata]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> + [metadata ]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> + [ metadata ]
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> + [metadata ] 
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> + [ metadata ] 
> +crc = 0
> +ENDL
> +test_mkfs_config << ENDL
> +   	 		 	 [	  	 		metadata		  	  	    	  ] 	 	 	    	
> +crc = 0
> +ENDL
> +
> +echo Spaces in the middle of a key name
> +test_mkfs_config << ENDL
> +[metadata]
> +c rc = 0
> +ENDL
> +
> +echo Invalid value
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = waffles
> +ENDL
> +
> +echo Nonexistent sections
> +test_mkfs_config << ENDL
> +[goober]
> +crc = 0
> +ENDL
> +
> +echo Nonexistent keys
> +test_mkfs_config << ENDL
> +[metadata]
> +goober = 0
> +ENDL
> +
> +echo Only zero or one
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 50
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = -1
> +ENDL
> +
> +echo sysctl style files
> +test_mkfs_config << ENDL
> +metadata.crc = 1
> +ENDL
> +
> +echo binaries
> +test_mkfs_config $MKFS_XFS_PROG 2>&1 | sed -e "s#$MKFS_XFS_PROG#MKFS_XFS_PROG#g"
> +
> +echo respecified options
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 0
> +crc = 1
> +ENDL
> +
> +echo respecified sections
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 0
> +[metadata]
> +crc = 1
> +ENDL
> +
> +echo ambiguous comment/section names
> +test_mkfs_config << ENDL
> +[meta#data]
> +crc = 0
> +ENDL
> +
> +echo ambiguous comment/variable names
> +test_mkfs_config << ENDL
> +[metadata]
> +fo#o = 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +foo#=# 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +foo =# 0
> +ENDL
> +test_mkfs_config << ENDL
> +[metadata]
> +crc = 0;This is an eol comment.
> +ENDL
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/717.out b/tests/xfs/717.out
> new file mode 100644
> index 00000000..61fff561
> --- /dev/null
> +++ b/tests/xfs/717.out
> @@ -0,0 +1,13 @@
> +QA output created by 717
> +Spaces in a section name
> +Spaces in the middle of a key name
> +Invalid value
> +Nonexistent sections
> +Nonexistent keys
> +Only zero or one
> +sysctl style files
> +binaries
> +respecified options
> +respecified sections
> +ambiguous comment/section names
> +ambiguous comment/variable names
> diff --git a/tests/xfs/718 b/tests/xfs/718
> new file mode 100755
> index 00000000..e2beca41
> --- /dev/null
> +++ b/tests/xfs/718
> @@ -0,0 +1,65 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 718
> +#
> +# Test formatting with a well known config file.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap '_cleanup; exit $status' 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.* $def_cfgfile $fsimg
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_test
> +_require_scratch_nocheck
> +_require_xfs_mkfs_cfgfile
> +
> +echo "Silence is golden"
> +
> +def_cfgfile=$TEST_DIR/a
> +fsimg=$TEST_DIR/a.img
> +rm -rf $def_cfgfile $fsimg
> +truncate -s 20t $fsimg
> +
> +cat > $def_cfgfile << ENDL
> +[metadata]
> +crc = 1
> +rmapbt = 1
> +reflink = 1
> +
> +[inode]
> +sparse = 1
> +ENDL
> +
> +$MKFS_XFS_PROG -c options=$def_cfgfile -f $SCRATCH_DEV > $tmp.mkfs
> +cat $tmp.mkfs >> $seqres.full
> +grep -q 'crc=1' $tmp.mkfs || echo 'v5 not enabled'
> +grep -q 'rmapbt=1' $tmp.mkfs || echo 'rmap not enabled'
> +grep -q 'reflink=1' $tmp.mkfs || echo 'reflink not enabled'
> +grep -q 'sparse=1' $tmp.mkfs || echo 'sparse inodes not enabled'
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/718.out b/tests/xfs/718.out
> new file mode 100644
> index 00000000..1dad5ab3
> --- /dev/null
> +++ b/tests/xfs/718.out
> @@ -0,0 +1,2 @@
> +QA output created by 718
> +Silence is golden
> diff --git a/tests/xfs/719 b/tests/xfs/719
> new file mode 100755
> index 00000000..15ff3f27
> --- /dev/null
> +++ b/tests/xfs/719
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 719
> +#
> +# Test formatting with a config file that contains conflicting options.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap '_cleanup; exit $status' 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.* $def_cfgfile
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_test
> +_require_scratch_nocheck
> +_require_xfs_mkfs_cfgfile
> +
> +echo "Silence is golden"
> +
> +def_cfgfile=$TEST_DIR/a
> +rm -rf $def_cfgfile
> +
> +cat > $def_cfgfile << ENDL
> +[metadata]
> +crc = 0
> +rmapbt = 1
> +reflink = 1
> +
> +[inode]
> +sparse = 1
> +ENDL
> +
> +$MKFS_XFS_PROG -c options=$def_cfgfile -f $SCRATCH_DEV > $tmp.mkfs 2>&1
> +if [ $? -eq 0 ]; then
> +	echo "mkfs.xfs did not fail!"
> +	cat $tmp.mkfs
> +fi
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/719.out b/tests/xfs/719.out
> new file mode 100644
> index 00000000..25585fa0
> --- /dev/null
> +++ b/tests/xfs/719.out
> @@ -0,0 +1,2 @@
> +QA output created by 719
> +Silence is golden
> diff --git a/tests/xfs/720 b/tests/xfs/720
> new file mode 100755
> index 00000000..a917e9a6
> --- /dev/null
> +++ b/tests/xfs/720
> @@ -0,0 +1,64 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2020 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 720
> +#
> +# Test formatting with conflicts between the config file and the cli.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap '_cleanup; exit $status' 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.* $def_cfgfile
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_test
> +_require_scratch_nocheck
> +_require_xfs_mkfs_cfgfile
> +
> +cfgfile=$TEST_DIR/a
> +rm -rf $cfgfile
> +
> +# disable crc in config file, enable rmapbt (which requires crc=1) in cli
> +cat > $cfgfile << ENDL
> +[metadata]
> +crc = 0
> +ENDL
> +
> +$MKFS_XFS_PROG -c options=$cfgfile -f -m rmapbt=1 $SCRATCH_DEV > $tmp.mkfs 2>&1
> +cat $tmp.mkfs >> $seqres.full
> +grep 'rmapbt not supported without CRC support' $tmp.mkfs
> +
> +# enable rmapbt (which requires crc=1) in config file, disable crc in cli
> +cat > $cfgfile << ENDL
> +[metadata]
> +rmapbt = 1
> +ENDL
> +
> +$MKFS_XFS_PROG -c options=$cfgfile -f -m crc=0 $SCRATCH_DEV > $tmp.mkfs 2>&1
> +cat $tmp.mkfs >> $seqres.full
> +grep 'rmapbt not supported without CRC support' $tmp.mkfs
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/720.out b/tests/xfs/720.out
> new file mode 100644
> index 00000000..1d2cf2ef
> --- /dev/null
> +++ b/tests/xfs/720.out
> @@ -0,0 +1,3 @@
> +QA output created by 720
> +rmapbt not supported without CRC support
> +rmapbt not supported without CRC support
> diff --git a/tests/xfs/group b/tests/xfs/group
> index b89c0a4e..4d558e22 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -519,3 +519,8 @@
>  519 auto quick reflink
>  520 auto quick reflink
>  521 auto quick realtime growfs
> +716 auto quick mkfs
> +717 auto quick mkfs
> +718 auto quick mkfs
> +719 auto quick mkfs
> +720 auto quick mkfs
> -- 
> 2.28.0
> 
