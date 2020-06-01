Return-Path: <SRS0=XPcr=7O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B476DC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 16:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A5B020734
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Jun 2020 16:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P8piLE2p"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgFAQmI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 12:42:08 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37886 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFAQmH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 1 Jun 2020 12:42:07 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 051Gg0fA160918;
        Mon, 1 Jun 2020 16:42:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=DyrtrBTFj9vQS1OvV1YrokVHnbH/hihhZQkhFsnTNWk=;
 b=P8piLE2p6pOli5FVOlnPS5w4TOiC7P3Fn6QjWHPAmyLCBuct/W3N/c0Lgngs9Czsvkw6
 uI5TqFdt3m54R5uk7K/pVaHYP+WD5L7ZKmmEE0H9vhiFQV9v3dwsssAuzkNitmoUJxZz
 fDxp/XmUOPQS80R2j1nnJKFMs917YjPXt/WyneqCVlaD53Pj3g11RSuu0OmesBiho6bO
 48mRbgzS88YUctNOkD5ibl/q0Oah0qFcrEPiggfElzli01v+aHIQCIRxqTM/uI1ASUU4
 xNQRVaiOcPcEGR5s7VCUzkjZcxhwzMc8LslE/mAzb+/gi5nUYsyVItkjQi4xr2zZrpzF jA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31bewqqsuw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 01 Jun 2020 16:42:00 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 051GdB1r169767;
        Mon, 1 Jun 2020 16:40:00 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 31c1dvsw3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Jun 2020 16:40:00 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 051Gdw73000658;
        Mon, 1 Jun 2020 16:39:59 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 01 Jun 2020 09:39:57 -0700
Date:   Mon, 1 Jun 2020 09:39:57 -0700
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     Eryu Guan <guan@eryu.me>, Eric Sandeen <sandeen@redhat.com>,
        linux-xfs <linux-xfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH 2/4] generic: test per-type quota softlimit enforcement
 timeout
Message-ID: <20200601163957.GX8230@magnolia>
References: <ea649599-f8a9-deb9-726e-329939befade@redhat.com>
 <9c9a63f3-13ab-d5b6-923c-4ea684b6b2f8@redhat.com>
 <7102e1e3-bee6-7aa2-dce6-c0e7e0ce2983@redhat.com>
 <20200531161517.GC3363@desktop>
 <20200601124844.GI1938@dhcp-12-102.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200601124844.GI1938@dhcp-12-102.nay.redhat.com>
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 bulkscore=0 adultscore=0 suspectscore=1 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006010122
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9639 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 bulkscore=0
 phishscore=0 suspectscore=1 impostorscore=0 cotscore=-2147483648
 lowpriorityscore=0 mlxscore=0 adultscore=0 spamscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006010123
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 01, 2020 at 08:48:44PM +0800, Zorro Lang wrote:
> On Mon, Jun 01, 2020 at 12:15:17AM +0800, Eryu Guan wrote:
> > On Mon, May 18, 2020 at 03:00:11PM -0500, Eric Sandeen wrote:
> > > From: Zorro Lang <zlang@redhat.com>
> > > 
> > > Set different block & inode grace timers for user, group and project
> > > quotas, then test softlimit enforcement timeout, make sure different
> > > grace timers as expected.
> > > 
> > > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > > Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> > > ---
> > 
> > I saw the following failure as well on xfs (as Zorro mentioned in his v3
> > patch)
> > 
> >      -pwrite: Disk quota exceeded
> >      +pwrite: No space left on device
> > 
> > So this is an xfs issue that needs to be fixed? Just want to make sure
> > the current expected test result.
> 
> Hmm.... I think I'd better to filter ENOSPC|EDQUOT. I can't be sure all
> filesystems will return EDQUOT or ENOSPC 100%, especially for group and project
> quota.
> 
> But I think Eric's trying to change a return value of XFS quota. I don't know the
> current status.

Yeah, Eric fixed a few problems where a group quota overage would return
ENOSPC instead of EDQUOT; and a few more problems where a project quota
overage would return EDQUOT instead of ENOSPC.

That'll be coming in the 5.8 merge, which I should get on...

--D

> Thanks,
> Zorro
> 
> > 
> > >  common/quota          |   4 +
> > >  tests/generic/600     | 187 ++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/600.out |  41 +++++++++
> > >  tests/generic/group   |   1 +
> > >  4 files changed, 233 insertions(+)
> > >  create mode 100755 tests/generic/600
> > >  create mode 100644 tests/generic/600.out
> > > 
> > > diff --git a/common/quota b/common/quota
> > > index 240e0bbc..1437d5f7 100644
> > > --- a/common/quota
> > > +++ b/common/quota
> > > @@ -217,6 +217,10 @@ _qmount()
> > >      if [ "$FSTYP" != "xfs" ]; then
> > >          quotacheck -ug $SCRATCH_MNT >>$seqres.full 2>&1
> > >          quotaon -ug $SCRATCH_MNT >>$seqres.full 2>&1
> > > +        # try to turn on project quota if it's supported
> > > +        if quotaon --help 2>&1 | grep -q '\-\-project'; then
> > > +            quotaon --project $SCRATCH_MNT >>$seqres.full 2>&1
> > > +        fi
> > >      fi
> > >      chmod ugo+rwx $SCRATCH_MNT
> > >  }
> > > diff --git a/tests/generic/600 b/tests/generic/600
> > > new file mode 100755
> > > index 00000000..03b4dcb3
> > > --- /dev/null
> > > +++ b/tests/generic/600
> > > @@ -0,0 +1,187 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 600
> > > +#
> > > +# Test per-type(user, group and project) filesystem quota timers, make sure
> > > +# enforcement
> > > +#
> > > +seq=`basename $0`
> > > +seqres=$RESULT_DIR/$seq
> > > +echo "QA output created by $seq"
> > > +
> > > +here=`pwd`
> > > +tmp=/tmp/$$
> > > +status=1	# failure is the default!
> > > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > > +
> > > +_cleanup()
> > > +{
> > > +	restore_project
> > > +	cd /
> > > +	rm -f $tmp.*
> > > +}
> > > +
> > > +# get standard environment, filters and checks
> > > +. ./common/rc
> > > +. ./common/filter
> > > +. ./common/quota
> > > +
> > > +# remove previous $seqres.full before test
> > > +rm -f $seqres.full
> > > +
> > > +require_project()
> > > +{
> > > +	rm -f $tmp.projects $tmp.projid
> > > +	if [ -f /etc/projects ];then
> > > +		cat /etc/projects > $tmp.projects
> > > +	fi
> > > +	if [ -f /etc/projid ];then
> > > +		cat /etc/projid > $tmp.projid
> > > +	fi
> > > +
> > > +	cat >/etc/projects <<EOF
> > > +100:$SCRATCH_MNT/t
> > > +EOF
> > > +	cat >/etc/projid <<EOF
> > > +$qa_user:100
> > > +EOF
> > > +	PROJECT_CHANGED=1
> > > +}
> > > +
> > > +restore_project()
> > > +{
> > > +	if [ "$PROJECT_CHANGED" = "1" ];then
> > > +		rm -f /etc/projects /etc/projid
> > > +		if [ -f $tmp.projects ];then
> > > +			cat $tmp.projects > /etc/projects
> > > +		fi
> > > +		if [ -f $tmp.projid ];then
> > > +			cat $tmp.projid > /etc/projid
> > > +		fi
> > > +	fi
> > > +}
> > > +
> > > +init_files()
> > > +{
> > > +	local dir=$1
> > > +
> > > +	echo "### Initialize files, and their mode and ownership"
> > > +	touch $dir/file{1,2} 2>/dev/null
> > > +	chown $qa_user $dir/file{1,2} 2>/dev/null
> > > +	chgrp $qa_user $dir/file{1,2} 2>/dev/null
> > > +	chmod 777 $dir 2>/dev/null
> > > +}
> > > +
> > > +cleanup_files()
> > > +{
> > > +	echo "### Remove all files"
> > > +	rm -f ${1}/file{1,2,3,4,5,6}
> > > +}
> > > +
> > > +test_grace()
> > > +{
> > > +	local type=$1
> > > +	local dir=$2
> > > +	local bgrace=$3
> > > +	local igrace=$4
> > > +
> > > +	init_files $dir
> > > +	echo "--- Test block quota ---"
> > > +	# Firstly fit below block soft limit
> > > +	echo "Write 225 blocks..."
> > > +	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((225 * $BLOCK_SIZE))' \
> > > +		-c fsync $dir/file1" 2>&1 >>$seqres.full | \
> > > +		_filter_xfs_io_error | tee -a $seqres.full
> > > +	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> > > +	# Secondly overcome block soft limit
> > > +	echo "Rewrite 250 blocks plus 1 byte, over the block softlimit..."
> > > +	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((250 * $BLOCK_SIZE + 1))' \
> > > +		-c fsync $dir/file1" 2>&1 >>$seqres.full | \
> > > +		_filter_xfs_io_error | tee -a $seqres.full
> > > +	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> > > +	# Reset grace time here, make below grace time test more accurate
> > > +	setquota -$type $qa_user -T $bgrace $igrace $SCRATCH_MNT 2>/dev/null
> > > +	# Now sleep enough grace time and check that softlimit got enforced
> > > +	sleep $((bgrace + 1))
> > > +	echo "Try to write 1 one more block after grace..."
> > > +	su $qa_user -c "$XFS_IO_PROG -c 'truncate 0' -c 'pwrite 0 $BLOCK_SIZE' \
> > > +		$dir/file2" 2>&1 >>$seqres.full | _filter_xfs_io_error | \
> > > +		tee -a $seqres.full
> > > +	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> > > +	echo "--- Test inode quota ---"
> > > +	# And now the softlimit test for inodes
> > > +	# First reset space limits so that we don't have problems with
> > > +	# space reservations on XFS
> > > +	setquota -$type $qa_user 0 0 3 100 $SCRATCH_MNT
> > > +	echo "Create 2 more files, over the inode softlimit..."
> > > +	su $qa_user -c "touch $dir/file3 $dir/file4" 2>&1 >>$seqres.full | \
> > > +		_filter_scratch | tee -a $seqres.full
> > > +	repquota -v -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
> > > +	# Reset grace time here, make below grace time test more accurate
> > > +	setquota -$type $qa_user -T $bgrace $igrace $SCRATCH_MNT 2>/dev/null
> > > +	# Wait and check grace time enforcement
> > > +	sleep $((igrace+1))
> > > +	echo "Try to create one more inode after grace..."
> > > +	su $qa_user -c "touch $dir/file5" 2>&1 >>$seqres.full |
> > > +		_filter_scratch | tee -a $seqres.full
> > > +	repquota -v -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
> > > +	cleanup_files $dir
> > > +}
> > > +
> > > +# real QA test starts here
> > > +_supported_fs generic
> > > +_supported_os Linux
> > > +_require_scratch
> > > +_require_setquota_project
> > > +_require_quota
> > > +_require_user
> > > +_require_group
> > 
> > Hmm, also needs _require_scratch_xfs_crc when FSTYP is xfs, otherwise v4
> > xfs fails as
> > 
> > +mount: /mnt/scratch: wrong fs type, bad option, bad superblock on /dev/mapper/testvg-lv2, missing codepage or helper program, or other error.
> > +qmount failed
> > 
> > and dmesg says
> > 
> > XFS (dm-2): Super block does not support project and group quota together
> > 
> > Thanks,
> > Eryu
> > 
> > > +
> > > +_scratch_mkfs >$seqres.full 2>&1
> > > +_scratch_enable_pquota
> > > +_qmount_option "usrquota,grpquota,prjquota"
> > > +_qmount
> > > +_require_prjquota $SCRATCH_DEV
> > > +BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
> > > +rm -rf $SCRATCH_MNT/t
> > > +mkdir $SCRATCH_MNT/t
> > > +$XFS_IO_PROG -r -c "chproj 100" -c "chattr +P" $SCRATCH_MNT/t
> > > +require_project
> > > +
> > > +echo "### Set up different grace timers to each type of quota"
> > > +UBGRACE=12
> > > +UIGRACE=10
> > > +GBGRACE=4
> > > +GIGRACE=2
> > > +PBGRACE=8
> > > +PIGRACE=6
> > > +
> > > +setquota -u $qa_user $((250 * $BLOCK_SIZE / 1024)) \
> > > +	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
> > > +setquota -u -t $UBGRACE $UIGRACE $SCRATCH_MNT
> > > +echo; echo "### Test user quota softlimit and grace time"
> > > +test_grace u $SCRATCH_MNT $UBGRACE $UIGRACE
> > > +# Reset the user quota space & inode limits, avoid it affect later test
> > > +setquota -u $qa_user 0 0 0 0 $SCRATCH_MNT
> > > +
> > > +setquota -g $qa_user $((250 * $BLOCK_SIZE / 1024)) \
> > > +	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
> > > +setquota -g -t $GBGRACE $GIGRACE $SCRATCH_MNT
> > > +echo; echo "### Test group quota softlimit and grace time"
> > > +test_grace g $SCRATCH_MNT $GBGRACE $GIGRACE
> > > +# Reset the group quota space & inode limits, avoid it affect later test
> > > +setquota -g $qa_user 0 0 0 0 $SCRATCH_MNT
> > > +
> > > +setquota -P $qa_user $((250 * $BLOCK_SIZE / 1024)) \
> > > +	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
> > > +setquota -P -t $PBGRACE $PIGRACE $SCRATCH_MNT
> > > +echo; echo "### Test project quota softlimit and grace time"
> > > +test_grace P $SCRATCH_MNT/t $PBGRACE $PIGRACE
> > > +# Reset the project quota space & inode limits
> > > +setquota -P $qa_user 0 0 0 0 $SCRATCH_MNT
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/600.out b/tests/generic/600.out
> > > new file mode 100644
> > > index 00000000..6e15eaeb
> > > --- /dev/null
> > > +++ b/tests/generic/600.out
> > > @@ -0,0 +1,41 @@
> > > +QA output created by 600
> > > +### Set up different grace timers to each type of quota
> > > +
> > > +### Test user quota softlimit and grace time
> > > +### Initialize files, and their mode and ownership
> > > +--- Test block quota ---
> > > +Write 225 blocks...
> > > +Rewrite 250 blocks plus 1 byte, over the block softlimit...
> > > +Try to write 1 one more block after grace...
> > > +pwrite: Disk quota exceeded
> > > +--- Test inode quota ---
> > > +Create 2 more files, over the inode softlimit...
> > > +Try to create one more inode after grace...
> > > +touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
> > > +### Remove all files
> > > +
> > > +### Test group quota softlimit and grace time
> > > +### Initialize files, and their mode and ownership
> > > +--- Test block quota ---
> > > +Write 225 blocks...
> > > +Rewrite 250 blocks plus 1 byte, over the block softlimit...
> > > +Try to write 1 one more block after grace...
> > > +pwrite: Disk quota exceeded
> > > +--- Test inode quota ---
> > > +Create 2 more files, over the inode softlimit...
> > > +Try to create one more inode after grace...
> > > +touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
> > > +### Remove all files
> > > +
> > > +### Test project quota softlimit and grace time
> > > +### Initialize files, and their mode and ownership
> > > +--- Test block quota ---
> > > +Write 225 blocks...
> > > +Rewrite 250 blocks plus 1 byte, over the block softlimit...
> > > +Try to write 1 one more block after grace...
> > > +pwrite: Disk quota exceeded
> > > +--- Test inode quota ---
> > > +Create 2 more files, over the inode softlimit...
> > > +Try to create one more inode after grace...
> > > +touch: cannot touch 'SCRATCH_MNT/t/file5': Disk quota exceeded
> > > +### Remove all files
> > 
> 
