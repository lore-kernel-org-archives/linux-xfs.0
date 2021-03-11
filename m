Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8F95C433E6
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 11:12:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6FCEE64F01
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Mar 2021 11:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232500AbhCKLLb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Mar 2021 06:11:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbhCKLLD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Mar 2021 06:11:03 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA29EC061574;
        Thu, 11 Mar 2021 03:11:02 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id t26so13462643pgv.3;
        Thu, 11 Mar 2021 03:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=EDrUQU5LSCvxtU/HS0Uih0T0vlADvX0GeES+CXdSs1E=;
        b=VT9XCZY2bnkvSopK3JVGAS0C4Tqwxhus92HVa1x0idkUonYJ5uZxk5GKCUcx0Z2kHr
         eZ/c9Bx5j13I2iT0gsBOa3syq+dvdHcJA1iVmVu28FcVnh96cIJb2foUZklhmzRNJga+
         +Nzgi5kqHkKPmuEmLwPkFdeOlHsncGdyhZHnI2Ji3jUwuq/93iMx5i1BD2HCBRcWl81o
         qDEkeCBmWafqAawTZzrRAeSdCA7KumRQ4lPWWTFct7m1O5/5FTQTEiYzXsPLxTKChY+f
         Wh7xkErdVvhbMHVtcW9p1tu1ZghGuvKxBadg9WU+Vg83ZGqBaMex9OhkFmqlqEC8eAyO
         xSgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=EDrUQU5LSCvxtU/HS0Uih0T0vlADvX0GeES+CXdSs1E=;
        b=i+eCZ/hThqwNZbNiSBsFfWauam711E0YCmHN05is0k4csUIK8+JHcR4pJwRVRW/TsK
         jotHEgXwTCGQ5uLC9r80l3sKTluE6bzpmIVYlM1jhehSiSG1x8786J4MviEu2Y9zOxA1
         HoFh2qHgreXVRHHTIbBx1AWGNrt8TdScrA7bekREb8wtnYwaVWIxBVhDnsG95kwl14aS
         TzXVytvQSkzSEyPbkCLisM7/WzbnUlbZJSJRASq0zVWX6HopdHp/k/OTLN9hU+msafXd
         Qcye8lKQ/lwDCkCROt2ONLJ6qLh6CfVr71U640PIVZH5Ie3Q3j8tSVI3+xESp/W+wswQ
         sA6w==
X-Gm-Message-State: AOAM530IG9O34FzOISy2Wc8GBJhejjty1KVDF0Hi/RSJb5ZiK9aZ5YqO
        DBgT4qNHXL3IpnDluEIzz/I=
X-Google-Smtp-Source: ABdhPJzcM/oyR097Z6VlaZrBQjucwe8rXZFO6iDsbSNKidIXhz7sgz6C3wKQNGs0pqPhVLyYLr/JdQ==
X-Received: by 2002:a65:5806:: with SMTP id g6mr6624890pgr.112.1615461062425;
        Thu, 11 Mar 2021 03:11:02 -0800 (PST)
Received: from garuda ([122.171.53.181])
        by smtp.gmail.com with ESMTPSA id z4sm2163849pgv.73.2021.03.11.03.11.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Mar 2021 03:11:02 -0800 (PST)
References: <161526480371.1214319.3263690953532787783.stgit@magnolia> <161526483668.1214319.17667836667890283825.stgit@magnolia>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 06/10] xfs: test quota softlimit warning functionality
In-reply-to: <161526483668.1214319.17667836667890283825.stgit@magnolia>
Date:   Thu, 11 Mar 2021 16:40:58 +0530
Message-ID: <87im5yc5dp.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 09 Mar 2021 at 10:10, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Make sure that quota softlimits work, which is to say that one can
> exceed the softlimit up to warnlimit times before it starts enforcing
> that.
>
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/915     |  162 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/915.out |  151 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/group   |    1
>  3 files changed, 314 insertions(+)
>  create mode 100755 tests/xfs/915
>  create mode 100644 tests/xfs/915.out
>
>
> diff --git a/tests/xfs/915 b/tests/xfs/915
> new file mode 100755
> index 00000000..a2cdbbb7
> --- /dev/null
> +++ b/tests/xfs/915
> @@ -0,0 +1,162 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 915
> +#
> +# Check that quota softlimit warnings work the way they should.  This means
> +# that we can disobey the softlimit up to warnlimit times before it turns into
> +# hard(er) enforcement.  This is a functional test for quota warnings, but
> +# since the functionality has been broken for decades, this is also a
> +# regression test for commit 4b8628d57b72 ("xfs: actually bump warning counts
> +# when we send warnings").
> +
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
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_quota
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +qsetup()
> +{
> +	opt=$1
> +	enforce=0
> +	if [ $opt = "u" -o $opt = "uno" ]; then
> +		type=u
> +		eval `_choose_uid`
> +	elif [ $opt = "g" -o $opt = "gno" ]; then
> +		type=g
> +		eval `_choose_gid`
> +	elif [ $opt = "p" -o $opt = "pno" ]; then
> +		type=p
> +		eval `_choose_prid`
> +	fi
> +	[ $opt = "u" -o $opt = "g" -o $opt = "p" ] && enforce=1
> +
> +	echo "Using type=$type id=$id" >> $seqres.full
> +}
> +
> +exercise() {
> +	_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
> +	cat $tmp.mkfs >>$seqres.full
> +
> +	# keep the blocksize and data size for dd later
> +	. $tmp.mkfs
> +
> +	_qmount
> +
> +	qsetup $1
> +
> +	echo "Using type=$type id=$id" >>$seqres.full
> +
> +	echo
> +	echo "*** report initial settings" | tee -a $seqres.full
> +	$XFS_QUOTA_PROG -x \
> +		-c "limit -$type isoft=3 ihard=500000 $id" \
> +		-c "warn -$type -i -d 13" \
> +		$SCRATCH_DEV
> +	$XFS_QUOTA_PROG -x \
> +		-c "state -$type" >> $seqres.full
> +	$XFS_QUOTA_PROG -x \
> +		-c "repquota -birnN -$type" $SCRATCH_DEV |
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
> +
> +	echo
> +	echo "*** push past the soft inode limit" | tee -a $seqres.full
> +	_file_as_id $SCRATCH_MNT/softok1 $id $type $bsize 0
> +	_file_as_id $SCRATCH_MNT/softok2 $id $type $bsize 0
> +	_file_as_id $SCRATCH_MNT/softok3 $id $type $bsize 0
> +	_file_as_id $SCRATCH_MNT/softwarn1 $id $type $bsize 0
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +		-c "repquota -birnN -$type" $SCRATCH_DEV |
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
> +
> +	echo
> +	echo "*** push further past the soft inode limit" | tee -a $seqres.full
> +	for warn_nr in $(seq 2 5); do
> +		_file_as_id $SCRATCH_MNT/softwarn$warn_nr $id $type $bsize 0
> +	done
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +		-c "repquota -birnN -$type" $SCRATCH_DEV |
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
> +
> +	echo
> +	echo "*** push past the soft inode warning limit" | tee -a $seqres.full
> +	for warn_nr in $(seq 6 15); do
> +		_file_as_id $SCRATCH_MNT/softwarn$warn_nr $id $type $bsize 0
> +	done
> +	$XFS_QUOTA_PROG -D $tmp.projects -P $tmp.projid -x \
> +		-c "repquota -birnN -$type" $SCRATCH_DEV |
> +		_filter_quota_report | LC_COLLATE=POSIX sort -ru
> +
> +	echo
> +	echo "*** unmount"
> +	_scratch_unmount
> +}
> +
> +_scratch_mkfs > $seqres.full
> +_scratch_mount >> $seqres.full
> +
> +chmod a+rwx $SCRATCH_MNT $seqres.full	# arbitrary users will write here
> +bsize=$(_get_file_block_size $SCRATCH_MNT)
> +_scratch_unmount
> +
> +cat >$tmp.projects <<EOF
> +1:$SCRATCH_MNT
> +EOF
> +
> +cat >$tmp.projid <<EOF
> +root:0
> +scratch:1
> +EOF
> +
> +projid_file="$tmp.projid"
> +
> +echo "*** user"
> +_qmount_option "uquota"
> +exercise u
> +
> +echo "*** group"
> +_qmount_option "gquota"
> +exercise g
> +
> +echo "*** uqnoenforce"
> +_qmount_option "uqnoenforce"
> +exercise uno
> +
> +echo "*** gqnoenforce"
> +_qmount_option "gqnoenforce"
> +exercise gno
> +
> +echo "*** pquota"
> +_qmount_option "pquota"
> +exercise p
> +
> +echo "*** pqnoenforce"
> +_qmount_option "pqnoenforce"
> +exercise pno
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/915.out b/tests/xfs/915.out
> new file mode 100644
> index 00000000..c3bb855e
> --- /dev/null
> +++ b/tests/xfs/915.out
> @@ -0,0 +1,151 @@
> +QA output created by 915
> +*** user
> +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> +         = sunit=XXX swidth=XXX, unwritten=X
> +naming   =VERN bsize=XXX
> +log      =LDEV bsize=XXX blocks=XXX
> +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> +
> +*** report initial settings
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** push past the soft inode limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 4 3 500000 01 [7 days] 0 0 0 00 [--------]
> +
> +*** push further past the soft inode limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 8 3 500000 05 [7 days] 0 0 0 00 [--------]
> +
> +*** push past the soft inode warning limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 16 3 500000 13 [7 days] 0 0 0 00 [--------]
> +
> +*** unmount
> +*** group
> +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> +         = sunit=XXX swidth=XXX, unwritten=X
> +naming   =VERN bsize=XXX
> +log      =LDEV bsize=XXX blocks=XXX
> +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> +
> +*** report initial settings
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** push past the soft inode limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 4 3 500000 01 [7 days] 0 0 0 00 [--------]
> +
> +*** push further past the soft inode limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 8 3 500000 05 [7 days] 0 0 0 00 [--------]
> +
> +*** push past the soft inode warning limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 16 3 500000 13 [7 days] 0 0 0 00 [--------]
> +
> +*** unmount
> +*** uqnoenforce
> +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> +         = sunit=XXX swidth=XXX, unwritten=X
> +naming   =VERN bsize=XXX
> +log      =LDEV bsize=XXX blocks=XXX
> +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> +
> +*** report initial settings
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** push past the soft inode limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 4 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** push further past the soft inode limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 8 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** push past the soft inode warning limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 18 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** unmount
> +*** gqnoenforce
> +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> +         = sunit=XXX swidth=XXX, unwritten=X
> +naming   =VERN bsize=XXX
> +log      =LDEV bsize=XXX blocks=XXX
> +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> +
> +*** report initial settings
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** push past the soft inode limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 4 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** push further past the soft inode limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 8 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** push past the soft inode warning limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 18 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** unmount
> +*** pquota
> +meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
> +data     = bsize=XXX blocks=XXX, imaxpct=PCT
> +         = sunit=XXX swidth=XXX, unwritten=X
> +naming   =VERN bsize=XXX
> +log      =LDEV bsize=XXX blocks=XXX
> +realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
> +
> +*** report initial settings
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 0 3 500000 00 [--------] 0 0 0 00 [--------]
> +
> +*** push past the soft inode limit
> +[ROOT] 0 0 0 00 [--------] 3 0 0 13 [--------] 0 0 0 00 [--------]
> +[NAME] 0 0 0 00 [--------] 4 3 500000 02 [7 days] 0 0 0 00 [--------]

At this point in the test we have created 4 files.
1. softok{1,2,3}
2. softwarn1

So we have exceeded the soft inode limit (i.e. 3) once. But the warning has
been issued twice.

_file_as_id() changes the project id of parent of each of the above files.  In
this case all the above listed files have $SCRATCH_MNT as the parent. So by
the time softok2 is created we have already reached the soft inode limit of 3
(parent and the two softok{1,2} files) and creation of softok3 and softwarn1
generates the two warnings listed above. If this explaination is correct,
shouldn't 'Used' inode count have a value of 5 (including the inode associated
with $SCRATCH_MNT)?

--
chandan
