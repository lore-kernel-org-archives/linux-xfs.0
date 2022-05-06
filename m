Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB45C433FE
	for <linux-xfs@archiver.kernel.org>; Fri,  6 May 2022 04:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235116AbiEFFDT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 6 May 2022 01:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389047AbiEFFDS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 6 May 2022 01:03:18 -0400
Received: from us-smtp-delivery-74.mimecast.com (us-smtp-delivery-74.mimecast.com [170.10.133.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3036743AC8
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 21:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651813175;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/nTGXde/7Tny4mUPzCUSJN45csnrVNJaPjIKsXb7Qug=;
        b=a2IrnKnbIq3I5Gr1HI2SO9IDg+GJmU9MGJwPB8FQxLDHmMZvSQl0UniRpjNw6MdrYIlUZE
        oMG2dHy/rrcSWNhSM+52k5dopdbEACw4RC/WVmhYHfTj4JW2qdKhus1n34rtWS20VC0eWC
        I/CdkXA7siTPSxNfvdlfFnJ2S/Hgp9A=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-300-a9NTN2GjNWezu32WWrlq_Q-1; Fri, 06 May 2022 00:59:33 -0400
X-MC-Unique: a9NTN2GjNWezu32WWrlq_Q-1
Received: by mail-qv1-f72.google.com with SMTP id j2-20020a0cfd42000000b0045ad9cba5deso1732766qvs.5
        for <linux-xfs@vger.kernel.org>; Thu, 05 May 2022 21:59:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=/nTGXde/7Tny4mUPzCUSJN45csnrVNJaPjIKsXb7Qug=;
        b=KBArdkV+xhB1PG62VXRqfzrOTieEicwIz6RX0Ep9yEiHVruow/6OTQloRkcOwi1ckc
         FQ+oq4WY9lV+4qza81cAIjrzgfPY9YpJjtLrOPA0etK3sjmZQxOl+MkpLmSzLagYeG8j
         KENWYLm3gN5Sd1pHe+EB8rI2mH+eg1rVkk8ixYqWc+SPAphVY+WkbYyZAD/jDEbkMAsW
         Zktu7tDQjXSij+mlbOviZLEo7a7fZm41NmszQUWG2PKikUoY1PRdzrmP7/LkUTHkN+ZD
         A5gFYa9Fum31DIhlLtCiYGLeRMFIwbbcz1bNY2g/leUzgcYLcFVfF6y1shTp7WNtdc0B
         8QiA==
X-Gm-Message-State: AOAM530SDW555I0adYzeifyXCKcdJC2MOqd5t1EKKhBLmOT0zFmgtKAY
        YjLT0ERgRN2kBtNwwLQTHks6PlZWvHDqoAdYaSN+o5B1Y2lSDl4+Aueg2hUpOoeje6yuLFGpYfD
        Jll7V0OYhyGMxw9d2OOAN
X-Received: by 2002:ac8:7c4e:0:b0:2f3:a1cd:b9d4 with SMTP id o14-20020ac87c4e000000b002f3a1cdb9d4mr1282040qtv.312.1651813172789;
        Thu, 05 May 2022 21:59:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzPKnNGrcH5RF80fHiClFrfYqPpzPqGc5i6Ibs0nMmVpIxrY6OtRa6ofuYXa7f2sVItPEgsYA==
X-Received: by 2002:ac8:7c4e:0:b0:2f3:a1cd:b9d4 with SMTP id o14-20020ac87c4e000000b002f3a1cdb9d4mr1282028qtv.312.1651813172441;
        Thu, 05 May 2022 21:59:32 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z6-20020ac84546000000b002f39b99f6b4sm1969207qtn.78.2022.05.05.21.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 21:59:31 -0700 (PDT)
Date:   Fri, 6 May 2022 12:59:26 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH] generic: soft quota limits testing within grace time
Message-ID: <20220506045926.apdcusyssfckzojs@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org,
        linux-xfs@vger.kernel.org
References: <20220505182555.370074-1-zlang@kernel.org>
 <20220505184344.GL27195@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220505184344.GL27195@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, May 05, 2022 at 11:43:44AM -0700, Darrick J. Wong wrote:
> On Fri, May 06, 2022 at 02:25:55AM +0800, Zorro Lang wrote:
> > After soft limits are exceeded, within the grace time, fs quota should
> > allow more space allocation before exceeding hard limits, even if
> > allocating many small files.
> > 
> > This case can cover bc37e4fb5cac (xfs: revert "xfs: actually bump
> > warning counts when we send warnings"). And will help to expose later
> > behavior changes on this side.
> 
> Isn't this already covered by generic/230?

No. They're similar, but the main difference at here:

 +	# Exceed the soft quota limit a bit at first
 +	su $qa_user -c "$XFS_IO_PROG -f -t -c 'pwrite 0 2m' -c fsync ${file}.0" >>$seqres.full 2>&1
 +	# Write more data more times under soft quota limit exhausted condition,
 +	# but not reach hard limit. To make sure the it won't trigger EDQUOT.
 +	for ((i=1; i<=100; i++));do
 +		su "$qa_user" -c "$XFS_IO_PROG -f -c 'pwrite 0 1m' -c fsync ${file}.$i" >>$seqres.full 2>&1
 +		if [ $? -ne 0 ];then
 +			log "Unexpected error (type=$type)!"
 +			break
 +		fi
 +	done

This case trys to exceed soft quota with *many writes*. We've talked about it in
IRC last month, the detailed chat log at below[1].

Thanks,
Zorro


[1]
2022-04-14 16:49 < zlang> https://lore.kernel.org/fstests/161526483668.1214319.17667836667890283825.stgit@magnolia/
2022-04-14 16:50 < zlang> djwong: About xfs/144 ^^, are we going to remove it, or change it to cover old quota warning behavior (without warn counter)?
2022-04-14 17:04 < zlang> Just due to notice your discussion in https://lore.kernel.org/linux-xfs/20220314180914.GN8224@magnolia/, and our downstream testing fails on xfs/144. So ask your plan :)
2022-04-14 22:53 < djwong> zlang: catherine is working on a patch to kill the warning counter limit feature entirely, since it's been largely busted for 20 years
2022-04-14 22:53 < djwong> so with that xfs/144 can be removed entirely
2022-04-14 23:11 < zlang> djwong: I'm wondering one thing, after the "the warning counter" feature being merged, why there's not any xfstests quota related cases fail on it
2022-04-14 23:12 < zlang> That might mean we miss some testing coverage
2022-04-14 23:13 < zlang> Maybe some code branches we never through, likes the place where you add "res->warnings++" :)
2022-04-14 23:15 < zlang> Even for us, we get the complaint from customers, before we find this behavior change by our testing
2022-04-14 23:19 < sandeen> djwong, if catherine would like to send the one-liner ASAP to make the next kernel, that would be fantastic, with a followup to remove the rest of the code ;)
2022-04-14 23:19 < zlang> So I'd like to change xfs/144 to cover old quota warning expected behavior,  What do you think?
2022-04-14 23:19 < sandeen> zlang, what old quota warning expected behavior?
2022-04-14 23:21 < sandeen> to be clear, there are two notions of "warnings" here.  thre is a netlink interface which can send the user over-quota notices. That has been there a long time, and exists for vfs quota too. But that is not really related to the quota warning counter/limit code, which is unique to xfs, and broken.
2022-04-14 23:22 < zlang> sandeen: https://paste.centos.org/view/c66654c0
2022-04-14 23:22 < zlang> old behavior means this testing won't fail ^^
2022-04-14 23:23 < zlang> Before, we always write one single file until exceed soft limit
2022-04-14 23:23 < zlang> We never tested write several small files until exceed soft limit
2022-04-14 23:23 < sandeen> if I am reading the test correctly, you have a soft limit of 2 megs and a hard limit of 500 megs. And you have a grace period of 6 days.
2022-04-14 23:24 < sandeen> Then you write 202 megs immediately.
2022-04-14 23:24 < zlang> Yes, create ~100 2M file
2022-04-14 23:24 < sandeen> all of this happens before the 6 days grace period expires, so all writes should succeed.
2022-04-14 23:25 < zlang> Yes
2022-04-14 23:25 < zlang> Before, we generally write one single 200M file to test the soft limit
2022-04-14 23:25 < sandeen> with the quota warning limit patch, they do not succeed. but that, IMHO, was a bug which needs to be fixed.
2022-04-14 23:25 < sandeen> oh I see.
2022-04-14 23:26 < sandeen> so you're suggesting that another test which exceeds soft quota with many writes is a good idea, and would have caught the quota warning /limit/ problem - right?
2022-04-14 23:26 < sandeen> that sounds reasonable to me
2022-04-14 23:33 < zlang> Due to the warning counter feature broke our customers' environment at first, but our regression test pass as usual.
2022-04-14 23:36 < zlang> So I hope a test can detect this behavior change, even if we really like to change that in one day, we can remove/change this test then.
2022-04-14 23:43 < zlang> And don't worry, I'll write that test after you revert that feature, just ask your plans :)

> 
> --D
> 
> > Signed-off-by: Zorro Lang <zlang@redhat.com>
> > ---
> >  tests/generic/690     | 125 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/generic/690.out |   2 +
> >  2 files changed, 127 insertions(+)
> >  create mode 100755 tests/generic/690
> >  create mode 100644 tests/generic/690.out
> > 
> > diff --git a/tests/generic/690 b/tests/generic/690
> > new file mode 100755
> > index 00000000..b1d055dc
> > --- /dev/null
> > +++ b/tests/generic/690
> > @@ -0,0 +1,125 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 Red Hat Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 690
> > +#
> > +# Make sure filesystem quota works well, after soft limits are exceeded. The
> > +# fs quota should allow more space allocation before exceeding hard limits
> > +# and with in grace time.
> > +#
> > +# But different with other similar testing, this case trys to write many small
> > +# files, to cover bc37e4fb5cac (xfs: revert "xfs: actually bump warning counts
> > +# when we send warnings"). If there's a behavior change in one day, this case
> > +# might help to detect that too.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quota
> > +
> > +# Override the default cleanup function.
> > +_cleanup()
> > +{
> > +	restore_project
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
> > +create_project()
> > +{
> > +	rm -rf $SCRATCH_MNT/t
> > +	mkdir $SCRATCH_MNT/t
> > +	$XFS_IO_PROG -r -c "chproj 100" -c "chattr +P" $SCRATCH_MNT/t
> > +	chmod ugo+rwx $SCRATCH_MNT/t/
> > +
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
> > +		create_project
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
> > +		su "$qa_user" -c "$XFS_IO_PROG -f -c 'pwrite 0 1m' -c fsync ${file}.$i" >>$seqres.full 2>&1
> > +		if [ $? -ne 0 ];then
> > +			log "Unexpected error (type=$type)!"
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
> > diff --git a/tests/generic/690.out b/tests/generic/690.out
> > new file mode 100644
> > index 00000000..6f3723e3
> > --- /dev/null
> > +++ b/tests/generic/690.out
> > @@ -0,0 +1,2 @@
> > +QA output created by 690
> > +Silence is golden
> > -- 
> > 2.31.1
> > 
> 

