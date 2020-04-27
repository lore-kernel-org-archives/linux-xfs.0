Return-Path: <SRS0=n/sd=6L=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BC6C4CECC
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 18:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6487E20728
	for <linux-xfs@archiver.kernel.org>; Mon, 27 Apr 2020 18:52:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="diqPOOrT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgD0Swf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 27 Apr 2020 14:52:35 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37064 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726189AbgD0Swd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 27 Apr 2020 14:52:33 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RInN7J180886;
        Mon, 27 Apr 2020 18:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=NUV4grcVbCI1gqMVeYY6epjaIltiXctuNrF3h9CweXs=;
 b=diqPOOrTp1TG5rHEU9DLrj9MiuylrK636MfR/XsAG2dV/dl2CXOXcmoWJPZLVyPtrnxk
 Et5KpnHNM8PVjyLkZPdsFageVMozd1WRIpiHChMp0XwwdfmOmnmmSnPAWfPT7PZfiU/u
 73c1Ama6nuv/4KY3qW0nOTudniIwW2FgmY8kHJfLbOCrYUYuMBU5P7muwiXs8+8Q4fnW
 F+hgjdS+XIIV3TEzlQZ2AGcCIKw2yFsZnyBr7M5+/JCicmTpwxbuvZJSgSOEuHqHwAg0
 U7Z3NYSkap+aEh6pplTgeEnzKbQvSIt6Yzv6Db9BEXTm5koFPvO5+u71yGBQWBV2Wh9j Qw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 30p2p00uy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 18:52:28 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03RImbro190753;
        Mon, 27 Apr 2020 18:50:28 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3030.oracle.com with ESMTP id 30mxpdwg8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 18:50:28 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 03RIoRXh004504;
        Mon, 27 Apr 2020 18:50:27 GMT
Received: from localhost (/10.159.145.123)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 27 Apr 2020 11:50:27 -0700
Date:   Mon, 27 Apr 2020 11:50:26 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: test per-type quota softlimit enforcement
 timeout
Message-ID: <20200427185026.GX6742@magnolia>
References: <20200426145141.22932-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426145141.22932-1-zlang@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270151
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9604 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 clxscore=1015
 bulkscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0 malwarescore=0
 mlxscore=0 suspectscore=0 mlxlogscore=999 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004270151
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sun, Apr 26, 2020 at 10:51:41PM +0800, Zorro Lang wrote:
> Set different block & inode grace timers for user, group and project
> quotas, then test softlimit enforcement timeout, make sure different
> grace timers as expected.
> 
> Signed-off-by: Zorro Lang <zlang@redhat.com>
> ---
> 
> Hi,
> 
> After generic/594 got merge, I'd like to re-send this case again. It still
> fails on XFS, but pass on ext4.

Can we get the XFS patch (re)sent upstream, please?

--D

> V2 add _require_setquota_project
> 
> Thanks,
> Zorro
> 
>  common/quota          |   4 +
>  tests/generic/597     | 180 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/597.out |  41 ++++++++++
>  tests/generic/group   |   1 +
>  4 files changed, 226 insertions(+)
>  create mode 100755 tests/generic/597
>  create mode 100644 tests/generic/597.out
> 
> diff --git a/common/quota b/common/quota
> index 240e0bbc..1437d5f7 100644
> --- a/common/quota
> +++ b/common/quota
> @@ -217,6 +217,10 @@ _qmount()
>      if [ "$FSTYP" != "xfs" ]; then
>          quotacheck -ug $SCRATCH_MNT >>$seqres.full 2>&1
>          quotaon -ug $SCRATCH_MNT >>$seqres.full 2>&1
> +        # try to turn on project quota if it's supported
> +        if quotaon --help 2>&1 | grep -q '\-\-project'; then
> +            quotaon --project $SCRATCH_MNT >>$seqres.full 2>&1
> +        fi
>      fi
>      chmod ugo+rwx $SCRATCH_MNT
>  }
> diff --git a/tests/generic/597 b/tests/generic/597
> new file mode 100755
> index 00000000..52138b80
> --- /dev/null
> +++ b/tests/generic/597
> @@ -0,0 +1,180 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> +#
> +# FS QA Test No. 597
> +#
> +# Test per-type(user, group and project) filesystem quota timers, make sure
> +# enforcement
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	restore_project
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/quota
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +require_project()
> +{
> +	rm -f $tmp.projects $tmp.projid
> +	if [ -f /etc/projects ];then
> +		cat /etc/projects > $tmp.projects
> +	fi
> +	if [ -f /etc/projid ];then
> +		cat /etc/projid > $tmp.projid
> +	fi
> +
> +	cat >/etc/projects <<EOF
> +100:$SCRATCH_MNT/t
> +EOF
> +	cat >/etc/projid <<EOF
> +$qa_user:100
> +EOF
> +	PROJECT_CHANGED=1
> +}
> +
> +restore_project()
> +{
> +	if [ "$PROJECT_CHANGED" = "1" ];then
> +		rm -f /etc/projects /etc/projid
> +		if [ -f $tmp.projects ];then
> +			cat $tmp.projects > /etc/projects
> +		fi
> +		if [ -f $tmp.projid ];then
> +			cat $tmp.projid > /etc/projid
> +		fi
> +	fi
> +}
> +
> +init_files()
> +{
> +	local dir=$1
> +
> +	echo "### Initialize files, and their mode and ownership"
> +	touch $dir/file{1,2} 2>/dev/null
> +	chown $qa_user $dir/file{1,2} 2>/dev/null
> +	chgrp $qa_user $dir/file{1,2} 2>/dev/null
> +	chmod 777 $dir 2>/dev/null
> +}
> +
> +cleanup_files()
> +{
> +	echo "### Remove all files"
> +	rm -f ${1}/file{1,2,3,4,5,6}
> +}
> +
> +test_grace()
> +{
> +	local type=$1
> +	local dir=$2
> +	local bgrace=$3
> +	local igrace=$4
> +
> +	init_files $dir
> +	echo "--- Test block quota ---"
> +	# Firstly fit below block soft limit
> +	echo "Write 225 blocks..."
> +	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((225 * $BLOCK_SIZE))' \
> +		-c fsync $dir/file1" 2>&1 >>$seqres.full | \
> +		_filter_xfs_io_error | tee -a $seqres.full
> +	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> +	# Secondly overcome block soft limit
> +	echo "Rewrite 250 blocks plus 1 byte, over the block softlimit..."
> +	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((250 * $BLOCK_SIZE + 1))' \
> +		-c fsync $dir/file1" 2>&1 >>$seqres.full | \
> +		_filter_xfs_io_error | tee -a $seqres.full
> +	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> +	# Reset grace time here, make below grace time test more accurate
> +	setquota -$type $qa_user -T $bgrace $igrace $SCRATCH_MNT 2>/dev/null
> +	# Now sleep enough grace time and check that softlimit got enforced
> +	sleep $((bgrace + 1))
> +	echo "Try to write 1 one more block after grace..."
> +	su $qa_user -c "$XFS_IO_PROG -c 'truncate 0' -c 'pwrite 0 $BLOCK_SIZE' \
> +		$dir/file2" 2>&1 >>$seqres.full | _filter_xfs_io_error | \
> +		tee -a $seqres.full
> +	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> +	echo "--- Test inode quota ---"
> +	# And now the softlimit test for inodes
> +	# First reset space limits so that we don't have problems with
> +	# space reservations on XFS
> +	setquota -$type $qa_user 0 0 3 100 $SCRATCH_MNT
> +	echo "Create 2 more files, over the inode softlimit..."
> +	su $qa_user -c "touch $dir/file3 $dir/file4" 2>&1 >>$seqres.full | \
> +		_filter_scratch | tee -a $seqres.full
> +	repquota -v -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
> +	# Reset grace time here, make below grace time test more accurate
> +	setquota -$type $qa_user -T $bgrace $igrace $SCRATCH_MNT 2>/dev/null
> +	# Wait and check grace time enforcement
> +	sleep $((igrace+1))
> +	echo "Try to create one more inode after grace..."
> +	su $qa_user -c "touch $dir/file5" 2>&1 >>$seqres.full |
> +		_filter_scratch | tee -a $seqres.full
> +	repquota -v -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
> +	cleanup_files $dir
> +}
> +
> +# real QA test starts here
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch
> +_require_setquota_project
> +_require_quota
> +_require_user
> +_require_group
> +
> +_scratch_mkfs >$seqres.full 2>&1
> +_scratch_enable_pquota
> +_qmount_option "usrquota,grpquota,prjquota"
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
> +rm -rf $SCRATCH_MNT/t
> +mkdir $SCRATCH_MNT/t
> +$XFS_IO_PROG -r -c "chproj 100" -c "chattr +P" $SCRATCH_MNT/t
> +require_project
> +
> +echo "### Set up different grace timers to each type of quota"
> +UBGRACE=12
> +UIGRACE=10
> +GBGRACE=4
> +GIGRACE=2
> +PBGRACE=8
> +PIGRACE=6
> +
> +setquota -u $qa_user $((250 * $BLOCK_SIZE / 1024)) \
> +	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
> +setquota -u -t $UBGRACE $UIGRACE $SCRATCH_MNT
> +setquota -g $qa_user $((250 * $BLOCK_SIZE / 1024)) \
> +         $((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
> +setquota -g -t $GBGRACE $GIGRACE $SCRATCH_MNT
> +setquota -P $qa_user $((250 * $BLOCK_SIZE / 1024)) \
> +         $((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
> +setquota -P -t $PBGRACE $PIGRACE $SCRATCH_MNT
> +
> +echo; echo "### Test user quota softlimit and grace time"
> +test_grace u $SCRATCH_MNT $UBGRACE $UIGRACE
> +echo; echo "### Test group quota softlimit and grace time"
> +test_grace g $SCRATCH_MNT $GBGRACE $GIGRACE
> +echo; echo "### Test project quota softlimit and grace time"
> +test_grace P $SCRATCH_MNT/t $PBGRACE $PIGRACE
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/597.out b/tests/generic/597.out
> new file mode 100644
> index 00000000..57a68ee1
> --- /dev/null
> +++ b/tests/generic/597.out
> @@ -0,0 +1,41 @@
> +QA output created by 597
> +### Set up different grace timers to each type of quota
> +
> +### Test user quota softlimit and grace time
> +### Initialize files, and their mode and ownership
> +--- Test block quota ---
> +Write 225 blocks...
> +Rewrite 250 blocks plus 1 byte, over the block softlimit...
> +Try to write 1 one more block after grace...
> +pwrite: Disk quota exceeded
> +--- Test inode quota ---
> +Create 2 more files, over the inode softlimit...
> +Try to create one more inode after grace...
> +touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
> +### Remove all files
> +
> +### Test group quota softlimit and grace time
> +### Initialize files, and their mode and ownership
> +--- Test block quota ---
> +Write 225 blocks...
> +Rewrite 250 blocks plus 1 byte, over the block softlimit...
> +Try to write 1 one more block after grace...
> +pwrite: Disk quota exceeded
> +--- Test inode quota ---
> +Create 2 more files, over the inode softlimit...
> +Try to create one more inode after grace...
> +touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
> +### Remove all files
> +
> +### Test project quota softlimit and grace time
> +### Initialize files, and their mode and ownership
> +--- Test block quota ---
> +Write 225 blocks...
> +Rewrite 250 blocks plus 1 byte, over the block softlimit...
> +Try to write 1 one more block after grace...
> +pwrite: Disk quota exceeded
> +--- Test inode quota ---
> +Create 2 more files, over the inode softlimit...
> +Try to create one more inode after grace...
> +touch: cannot touch 'SCRATCH_MNT/t/file5': Disk quota exceeded
> +### Remove all files
> diff --git a/tests/generic/group b/tests/generic/group
> index 718575ba..10af4c41 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -598,3 +598,4 @@
>  594 auto quick quota
>  595 auto quick encrypt
>  596 auto quick
> +597 auto quick quota
> -- 
> 2.20.1
> 
