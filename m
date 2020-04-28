Return-Path: <SRS0=0AGZ=6M=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B429C8300A
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 16:10:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3890D20746
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Apr 2020 16:10:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KM89gOiD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728603AbgD1QKh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Apr 2020 12:10:37 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:50118 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728597AbgD1QKg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Apr 2020 12:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588090234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OPCRBUoUCXO9Ea1BoAcvnNKnMlU95+19TDHtPbPvW+w=;
        b=KM89gOiD+wMyEZDCuAGNwfLQjtTyaVA4K1249xxmPnahOX5wjMPhSRajsxaYDyM27jDliD
        N98HqdDQF4F2LB80hnPQUmNU4rZlGKq04Azrnmb37vRhh31UszUgWfLmuuDhBDc1jZmosQ
        K5lDSAlZ/xBuLNVRjgw0VPPmGGXfNRA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-NKlVqgQMPHKbsaomH9PyGA-1; Tue, 28 Apr 2020 12:10:31 -0400
X-MC-Unique: NKlVqgQMPHKbsaomH9PyGA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 526941899521;
        Tue, 28 Apr 2020 16:10:30 +0000 (UTC)
Received: from localhost (dhcp-12-102.nay.redhat.com [10.66.12.102])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 05A445D9E2;
        Tue, 28 Apr 2020 16:10:26 +0000 (UTC)
Date:   Wed, 29 Apr 2020 00:23:10 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        sandeen@redhat.com
Subject: Re: [PATCH v2] generic: test per-type quota softlimit enforcement
 timeout
Message-ID: <20200428162309.GG14282@dhcp-12-102.nay.redhat.com>
Mail-Followup-To: "Darrick J. Wong" <darrick.wong@oracle.com>,
        fstests@vger.kernel.org, linux-xfs@vger.kernel.org,
        sandeen@redhat.com
References: <20200426145141.22932-1-zlang@redhat.com>
 <20200427185026.GX6742@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200427185026.GX6742@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 27, 2020 at 11:50:26AM -0700, Darrick J. Wong wrote:
> On Sun, Apr 26, 2020 at 10:51:41PM +0800, Zorro Lang wrote:
> > Set different block & inode grace timers for user, group and project
> > quotas, then test softlimit enforcement timeout, make sure different
> > grace timers as expected.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> > 
> > Hi,
> > 
> > After generic/594 got merge, I'd like to re-send this case again. It still
> > fails on XFS, but pass on ext4.
> 
> Can we get the XFS patch (re)sent upstream, please?

Hi Darrick,

After talking with Eric, I'll take this half-finished job. I'll fix some bugs
and change something and re-send patches(From Eric) again. I'll take a few time,
due to there're still some problems.

Thanks,
Zorro

> 
> --D
> 
> > V2 add _require_setquota_project
> > 
> > Thanks,
> > Zorro
> > 
> >  common/quota          |   4 +
> >  tests/generic/597     | 180 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/597.out |  41 ++++++++++
> >  tests/generic/group   |   1 +
> >  4 files changed, 226 insertions(+)
> >  create mode 100755 tests/generic/597
> >  create mode 100644 tests/generic/597.out
> > 
> > diff --git a/common/quota b/common/quota
> > index 240e0bbc..1437d5f7 100644
> > --- a/common/quota
> > +++ b/common/quota
> > @@ -217,6 +217,10 @@ _qmount()
> >      if [ "$FSTYP" != "xfs" ]; then
> >          quotacheck -ug $SCRATCH_MNT >>$seqres.full 2>&1
> >          quotaon -ug $SCRATCH_MNT >>$seqres.full 2>&1
> > +        # try to turn on project quota if it's supported
> > +        if quotaon --help 2>&1 | grep -q '\-\-project'; then
> > +            quotaon --project $SCRATCH_MNT >>$seqres.full 2>&1
> > +        fi
> >      fi
> >      chmod ugo+rwx $SCRATCH_MNT
> >  }
> > diff --git a/tests/generic/597 b/tests/generic/597
> > new file mode 100755
> > index 00000000..52138b80
> > --- /dev/null
> > +++ b/tests/generic/597
> > @@ -0,0 +1,180 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2020 Red Hat, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 597
> > +#
> > +# Test per-type(user, group and project) filesystem quota timers, make sure
> > +# enforcement
> > +#
> > +seq=`basename $0`
> > +seqres=$RESULT_DIR/$seq
> > +echo "QA output created by $seq"
> > +
> > +here=`pwd`
> > +tmp=/tmp/$$
> > +status=1	# failure is the default!
> > +trap "_cleanup; exit \$status" 0 1 2 3 15
> > +
> > +_cleanup()
> > +{
> > +	restore_project
> > +	cd /
> > +	rm -f $tmp.*
> > +}
> > +
> > +# get standard environment, filters and checks
> > +. ./common/rc
> > +. ./common/filter
> > +. ./common/quota
> > +
> > +# remove previous $seqres.full before test
> > +rm -f $seqres.full
> > +
> > +require_project()
> > +{
> > +	rm -f $tmp.projects $tmp.projid
> > +	if [ -f /etc/projects ];then
> > +		cat /etc/projects > $tmp.projects
> > +	fi
> > +	if [ -f /etc/projid ];then
> > +		cat /etc/projid > $tmp.projid
> > +	fi
> > +
> > +	cat >/etc/projects <<EOF
> > +100:$SCRATCH_MNT/t
> > +EOF
> > +	cat >/etc/projid <<EOF
> > +$qa_user:100
> > +EOF
> > +	PROJECT_CHANGED=1
> > +}
> > +
> > +restore_project()
> > +{
> > +	if [ "$PROJECT_CHANGED" = "1" ];then
> > +		rm -f /etc/projects /etc/projid
> > +		if [ -f $tmp.projects ];then
> > +			cat $tmp.projects > /etc/projects
> > +		fi
> > +		if [ -f $tmp.projid ];then
> > +			cat $tmp.projid > /etc/projid
> > +		fi
> > +	fi
> > +}
> > +
> > +init_files()
> > +{
> > +	local dir=$1
> > +
> > +	echo "### Initialize files, and their mode and ownership"
> > +	touch $dir/file{1,2} 2>/dev/null
> > +	chown $qa_user $dir/file{1,2} 2>/dev/null
> > +	chgrp $qa_user $dir/file{1,2} 2>/dev/null
> > +	chmod 777 $dir 2>/dev/null
> > +}
> > +
> > +cleanup_files()
> > +{
> > +	echo "### Remove all files"
> > +	rm -f ${1}/file{1,2,3,4,5,6}
> > +}
> > +
> > +test_grace()
> > +{
> > +	local type=$1
> > +	local dir=$2
> > +	local bgrace=$3
> > +	local igrace=$4
> > +
> > +	init_files $dir
> > +	echo "--- Test block quota ---"
> > +	# Firstly fit below block soft limit
> > +	echo "Write 225 blocks..."
> > +	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((225 * $BLOCK_SIZE))' \
> > +		-c fsync $dir/file1" 2>&1 >>$seqres.full | \
> > +		_filter_xfs_io_error | tee -a $seqres.full
> > +	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> > +	# Secondly overcome block soft limit
> > +	echo "Rewrite 250 blocks plus 1 byte, over the block softlimit..."
> > +	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((250 * $BLOCK_SIZE + 1))' \
> > +		-c fsync $dir/file1" 2>&1 >>$seqres.full | \
> > +		_filter_xfs_io_error | tee -a $seqres.full
> > +	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> > +	# Reset grace time here, make below grace time test more accurate
> > +	setquota -$type $qa_user -T $bgrace $igrace $SCRATCH_MNT 2>/dev/null
> > +	# Now sleep enough grace time and check that softlimit got enforced
> > +	sleep $((bgrace + 1))
> > +	echo "Try to write 1 one more block after grace..."
> > +	su $qa_user -c "$XFS_IO_PROG -c 'truncate 0' -c 'pwrite 0 $BLOCK_SIZE' \
> > +		$dir/file2" 2>&1 >>$seqres.full | _filter_xfs_io_error | \
> > +		tee -a $seqres.full
> > +	repquota -v -$type $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> > +	echo "--- Test inode quota ---"
> > +	# And now the softlimit test for inodes
> > +	# First reset space limits so that we don't have problems with
> > +	# space reservations on XFS
> > +	setquota -$type $qa_user 0 0 3 100 $SCRATCH_MNT
> > +	echo "Create 2 more files, over the inode softlimit..."
> > +	su $qa_user -c "touch $dir/file3 $dir/file4" 2>&1 >>$seqres.full | \
> > +		_filter_scratch | tee -a $seqres.full
> > +	repquota -v -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
> > +	# Reset grace time here, make below grace time test more accurate
> > +	setquota -$type $qa_user -T $bgrace $igrace $SCRATCH_MNT 2>/dev/null
> > +	# Wait and check grace time enforcement
> > +	sleep $((igrace+1))
> > +	echo "Try to create one more inode after grace..."
> > +	su $qa_user -c "touch $dir/file5" 2>&1 >>$seqres.full |
> > +		_filter_scratch | tee -a $seqres.full
> > +	repquota -v -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
> > +	cleanup_files $dir
> > +}
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_supported_os Linux
> > +_require_scratch
> > +_require_setquota_project
> > +_require_quota
> > +_require_user
> > +_require_group
> > +
> > +_scratch_mkfs >$seqres.full 2>&1
> > +_scratch_enable_pquota
> > +_qmount_option "usrquota,grpquota,prjquota"
> > +_qmount
> > +_require_prjquota $SCRATCH_DEV
> > +BLOCK_SIZE=$(_get_file_block_size $SCRATCH_MNT)
> > +rm -rf $SCRATCH_MNT/t
> > +mkdir $SCRATCH_MNT/t
> > +$XFS_IO_PROG -r -c "chproj 100" -c "chattr +P" $SCRATCH_MNT/t
> > +require_project
> > +
> > +echo "### Set up different grace timers to each type of quota"
> > +UBGRACE=12
> > +UIGRACE=10
> > +GBGRACE=4
> > +GIGRACE=2
> > +PBGRACE=8
> > +PIGRACE=6
> > +
> > +setquota -u $qa_user $((250 * $BLOCK_SIZE / 1024)) \
> > +	$((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
> > +setquota -u -t $UBGRACE $UIGRACE $SCRATCH_MNT
> > +setquota -g $qa_user $((250 * $BLOCK_SIZE / 1024)) \
> > +         $((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
> > +setquota -g -t $GBGRACE $GIGRACE $SCRATCH_MNT
> > +setquota -P $qa_user $((250 * $BLOCK_SIZE / 1024)) \
> > +         $((1000 * $BLOCK_SIZE / 1024)) 3 100 $SCRATCH_MNT
> > +setquota -P -t $PBGRACE $PIGRACE $SCRATCH_MNT
> > +
> > +echo; echo "### Test user quota softlimit and grace time"
> > +test_grace u $SCRATCH_MNT $UBGRACE $UIGRACE
> > +echo; echo "### Test group quota softlimit and grace time"
> > +test_grace g $SCRATCH_MNT $GBGRACE $GIGRACE
> > +echo; echo "### Test project quota softlimit and grace time"
> > +test_grace P $SCRATCH_MNT/t $PBGRACE $PIGRACE
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/597.out b/tests/generic/597.out
> > new file mode 100644
> > index 00000000..57a68ee1
> > --- /dev/null
> > +++ b/tests/generic/597.out
> > @@ -0,0 +1,41 @@
> > +QA output created by 597
> > +### Set up different grace timers to each type of quota
> > +
> > +### Test user quota softlimit and grace time
> > +### Initialize files, and their mode and ownership
> > +--- Test block quota ---
> > +Write 225 blocks...
> > +Rewrite 250 blocks plus 1 byte, over the block softlimit...
> > +Try to write 1 one more block after grace...
> > +pwrite: Disk quota exceeded
> > +--- Test inode quota ---
> > +Create 2 more files, over the inode softlimit...
> > +Try to create one more inode after grace...
> > +touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
> > +### Remove all files
> > +
> > +### Test group quota softlimit and grace time
> > +### Initialize files, and their mode and ownership
> > +--- Test block quota ---
> > +Write 225 blocks...
> > +Rewrite 250 blocks plus 1 byte, over the block softlimit...
> > +Try to write 1 one more block after grace...
> > +pwrite: Disk quota exceeded
> > +--- Test inode quota ---
> > +Create 2 more files, over the inode softlimit...
> > +Try to create one more inode after grace...
> > +touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
> > +### Remove all files
> > +
> > +### Test project quota softlimit and grace time
> > +### Initialize files, and their mode and ownership
> > +--- Test block quota ---
> > +Write 225 blocks...
> > +Rewrite 250 blocks plus 1 byte, over the block softlimit...
> > +Try to write 1 one more block after grace...
> > +pwrite: Disk quota exceeded
> > +--- Test inode quota ---
> > +Create 2 more files, over the inode softlimit...
> > +Try to create one more inode after grace...
> > +touch: cannot touch 'SCRATCH_MNT/t/file5': Disk quota exceeded
> > +### Remove all files
> > diff --git a/tests/generic/group b/tests/generic/group
> > index 718575ba..10af4c41 100644
> > --- a/tests/generic/group
> > +++ b/tests/generic/group
> > @@ -598,3 +598,4 @@
> >  594 auto quick quota
> >  595 auto quick encrypt
> >  596 auto quick
> > +597 auto quick quota
> > -- 
> > 2.20.1
> > 
> 

