Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1662C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 11 May 2022 16:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344847AbiEKQiR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 May 2022 12:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235018AbiEKQiR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 May 2022 12:38:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D8B546D940
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 09:38:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652287095;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hIit7AVRPygzDPvObAOu9mT3PicIn2ydwxLXX62q/eE=;
        b=P7z1pOCZp4mCa3uRMJ/GCYtf1UpADrAHkl+p5tfZljgzA7UDhWg300yv5WCtSKzigYI2D+
        VjefX+xlHtT7lbKXWr+teHp3doKuEb1DpE+u1L+CUvfIk6cIWFHTC4By3KfR4aqNR3h8zT
        XYce5hpu44jhyCr8eWsHPTm7ao9bX2M=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-0ASxCE5oPXyGZFNZSxJRkQ-1; Wed, 11 May 2022 12:38:13 -0400
X-MC-Unique: 0ASxCE5oPXyGZFNZSxJRkQ-1
Received: by mail-qk1-f200.google.com with SMTP id x191-20020a3763c8000000b0069fb66f3901so2217614qkb.12
        for <linux-xfs@vger.kernel.org>; Wed, 11 May 2022 09:38:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=hIit7AVRPygzDPvObAOu9mT3PicIn2ydwxLXX62q/eE=;
        b=YJuDHY6ozKaOb+NfbDfQY2XZMRANJ1wuhcT/OI+qDagLcm9+XfgpFCkFAVjQI4k/7f
         M7lSyi/Xd7NVNBynF2Ll2AD83yixSqj2QvXo6iqQ4mvwTzyXKkXr1xcgVISc41YTJI0Z
         1nRVQm8F84ppkH3ONnNHKICQJDF11/rHYVa8zAduyoD6lR1FbG71HJhIwdTIovK/DztZ
         g2QIj+uFl1VV6acY6lHPvhqdMlrktffHWO4eNkNazrN1/KOqyRh1eYT13bla00BPwG1R
         USaNzrSBWviNoFIssA1Hs2aLMp7aF+L2bYARl3pFVfY2JgnFWOkkA24NGQVUP7Lb96oI
         QpTg==
X-Gm-Message-State: AOAM532FyEb5l2SbAzgd8X8po3q0neRrIJ9plUokQQfwShU4du9cabuf
        03WUJDQOe/ST6sMqSExg5vvwCdrBvLF6Dg5iU83jwTbEUd/+R5jVMegy4MxnRY8KIdd3oFUlgLe
        fFusTfSuTobTwmOGAeacQ
X-Received: by 2002:ac8:5f85:0:b0:2f3:c5c8:8cb0 with SMTP id j5-20020ac85f85000000b002f3c5c88cb0mr24866163qta.408.1652287092798;
        Wed, 11 May 2022 09:38:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJypH3e0VUywc54EQP4woSh1fGAcJhJ2y2DbC1RkKlimNjBrX1QRbgRia7SjL7VHjiAgyjk33A==
X-Received: by 2002:ac8:5f85:0:b0:2f3:c5c8:8cb0 with SMTP id j5-20020ac85f85000000b002f3c5c88cb0mr24866132qta.408.1652287092488;
        Wed, 11 May 2022 09:38:12 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g10-20020ac8774a000000b002f39b99f695sm1518218qtu.47.2022.05.11.09.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 May 2022 09:38:11 -0700 (PDT)
Date:   Thu, 12 May 2022 00:38:06 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v2] generic: soft quota limits testing within grace time
Message-ID: <20220511163806.uc4z7td2remhdru3@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
References: <20220509183523.1809778-1-zlang@kernel.org>
 <20220511160106.GB27174@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511160106.GB27174@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, May 11, 2022 at 09:01:06AM -0700, Darrick J. Wong wrote:
> On Tue, May 10, 2022 at 02:35:23AM +0800, Zorro Lang wrote:
> > After soft limits are exceeded, within the grace time, fs quota
> > should allow more space allocation before exceeding hard limits,
> > even if allocating many small files.
> > 
> > This case can cover bc37e4fb5cac (xfs: revert "xfs: actually bump
> > warning counts when we send warnings"). And will help to expose
> > later behavior changes on this side.
> > 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> > 
> > Thanks review points from Darrick, V2 move _create_project_quota and
> > _restore_project_quota to common/quota and help them to be common.
> > 
> > Thanks,
> > Zorro
> > 
> >  common/quota          | 48 +++++++++++++++++++++++
> >  tests/generic/999     | 88 +++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/999.out |  2 +
> >  3 files changed, 138 insertions(+)
> >  create mode 100755 tests/generic/999
> >  create mode 100644 tests/generic/999.out
> > 
> > diff --git a/common/quota b/common/quota
> > index 7fa1a61a..67698f74 100644
> > --- a/common/quota
> > +++ b/common/quota
> > @@ -351,5 +351,53 @@ _qsetup()
> >  	echo "Using type=$type id=$id" >> $seqres.full
> >  }
> >  
> > +# Help to create project quota on directory, works for xfs and other fs.
> > +# Usage: _create_project_quota <dirname> <projid> [name]
> > +# Although the [name] is optional, better to specify it if need a fixed name.
> > +_create_project_quota()
> > +{
> > +	local prjdir=$1
> > +	local id=$2
> > +	local name=$3
> > +
> > +	if [ -z "$name" ];then
> > +		name=`echo $projdir | tr \/ \_`
> > +	fi
> > +
> > +	rm -rf $prjdir
> > +	mkdir $prjdir
> > +	chmod ugo+rwx $prjdir
> > +
> > +	if [ -f /etc/projects -a ! -f $tmp.projects.bk ];then
> > +		cat /etc/projects > $tmp.projects.bk
> > +		echo >/etc/projects
> > +	fi
> > +	if [ -f /etc/projid -a ! -f $tmp.projid.bk ];then
> > +		cat /etc/projid > $tmp.projid.bk
> > +		echo >/etc/projid
> > +	fi
> > +
> > +	cat >>/etc/projects <<EOF
> > +$id:$prjdir
> > +EOF
> > +	cat >>/etc/projid <<EOF
> > +$name:$id
> > +EOF
> > +	$XFS_IO_PROG -r -c "chproj $id" -c "chattr +P" $prjdir
> > +}
> > +
> > +# If you've called _create_project_quota, then use this function in _cleanup
> > +_restore_project_quota()
> > +{
> > +	if [ -f $tmp.projects.bk ];then
> > +		cat $tmp.projects.bk > /etc/projects && \
> > +			rm -f $tmp.projects.bk
> > +	fi
> > +	if [ -f $tmp.projid.bk ];then
> > +		cat $tmp.projid.bk > /etc/projid && \
> > +			rm -f $tmp.projid.bk
> > +	fi
> > +}
> 
> When I asked you to hoist this, to common/quota, I also meant that you
> should port generic/603 to use the new common helpers.

Oh, yes, g/603 is another quota related case written by me. I'll change that
too.

> 
> (That /can/ be a followup patch though, since 603 does a few more things
> in its project quota setup code.)

Sure.

> 
> > +
> >  # make sure this script returns success
> >  /bin/true
> > diff --git a/tests/generic/999 b/tests/generic/999
> > new file mode 100755
> > index 00000000..103a74f9
> > --- /dev/null
> > +++ b/tests/generic/999
> > @@ -0,0 +1,88 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Red Hat Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test No. 999
> > +#
> > +# Make sure filesystem quota works well, after soft limits are exceeded. The
> > +# fs quota should allow more space allocation before exceeding hard limits
> > +# and with in grace time.
> > +#
> > +# But different with other similar testing, this case trys to write many small
> 
> "tries"
> 
> > +# files, to cover bc37e4fb5cac (xfs: revert "xfs: actually bump warning counts
> > +# when we send warnings"). If there's a behavior change in one day, this case
> 
> "If there's a behavior change some day,"

Thanks for the english teaching :)

> 
> > +# might help to detect that too.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quota
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	_restore_project_quota
> > +	cd /
> > +	rm -r -f $tmp.*
> > +}
> > +
> > +# Import common functions.
> > +. ./common/quota
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_require_scratch
> > +_require_quota
> > +_require_user
> > +_require_group
> > +
> > +# Make sure the kernel supports project quota
> > +_scratch_mkfs >$seqres.full 2>&1
> > +_scratch_enable_pquota
> > +_qmount_option "prjquota"
> > +_qmount
> > +_require_prjquota $SCRATCH_DEV
> > +
> > +exercise()
> > +{
> > +	local type=$1
> > +	local file=$SCRATCH_MNT/testfile
> > +
> > +	echo "= Test type=$type quota =" >>$seqres.full
> > +	_scratch_unmount
> > +	_scratch_mkfs >>$seqres.full 2>&1
> > +	if [ "$1" = "P" ];then
> > +		_scratch_enable_pquota
> > +	fi
> > +	_qmount
> > +	if [ "$1" = "P" ];then
> > +		_create_project_quota $SCRATCH_MNT/t 100 $qa_user
> > +		file=$SCRATCH_MNT/t/testfile
> > +	fi
> > +
> > +	setquota -${type} $qa_user 1M 500M 0 0 $SCRATCH_MNT
> > +	setquota -${type} -t 86400 86400 $SCRATCH_MNT
> > +	repquota -v -${type} $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> > +	# Exceed the soft quota limit a bit at first
> > +	su $qa_user -c "$XFS_IO_PROG -f -t -c 'pwrite 0 2m' -c fsync ${file}.0" >>$seqres.full 2>&1
> > +	# Write more data more times under soft quota limit exhausted condition,
> > +	# but not reach hard limit. To make sure the it won't trigger EDQUOT.
> > +	for ((i=1; i<=100; i++));do
> 
> I forget, is there a test like this that also goes to the hard limit?

I can't rememeber all, below generic cases might about hardlimt

g/327: Ensure that we can't go over the hard block limit when reflinking
g/328: Ensure that we can't go over the hard block limit when CoWing a file
g/385: Test renames accross project boundaries
g/566: Test chgrp with group quota hard limit
g/681: Test unprivileged link files with project quota limit
g/682: Test unprivileged move files with project quota limit

There maybe not generic case to do basic quota hard/soft limig test, but
there're some xfs specific cases might do what you said above, likes xfs/050,
xfs/299, xfs/153.

Thanks,
Zorro

> 
> (The rest of the logic here looks sound, fwiw)
> 
> --D
> 
> > +		su "$qa_user" -c "$XFS_IO_PROG -f -c 'pwrite 0 1m' -c fsync ${file}.$i" >>$seqres.full 2>&1
> > +		if [ $? -ne 0 ];then
> > +			echo "Unexpected error (type=$type)!"
> > +			break
> > +		fi
> > +	done
> > +	repquota -v -${type} $SCRATCH_MNT | grep -v "^root" >>$seqres.full 2>&1
> > +}
> > +
> > +_qmount_option "usrquota"
> > +exercise u
> > +_qmount_option "grpquota"
> > +exercise g
> > +_qmount_option "prjquota"
> > +exercise P
> > +
> > +echo "Silence is golden"
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/generic/999.out b/tests/generic/999.out
> > new file mode 100644
> > index 00000000..3b276ca8
> > --- /dev/null
> > +++ b/tests/generic/999.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 999
> > +Silence is golden
> > -- 
> > 2.31.1
> > 
> 

