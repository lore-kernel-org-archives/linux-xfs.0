Return-Path: <SRS0=UAxe=YQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24BACA9EB7
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 15:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A983D2086D
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Oct 2019 15:46:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eiTvXAmv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406921AbfJWPqH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Oct 2019 11:46:07 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40950 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406920AbfJWPqG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Oct 2019 11:46:06 -0400
Received: by mail-pf1-f194.google.com with SMTP id x127so13180900pfb.7;
        Wed, 23 Oct 2019 08:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qhP21l6x2Q5VGk0xSAFqQ/z2LwGG8VLczBmLUtLGjmA=;
        b=eiTvXAmvMIFAnvNZcmHRcaOcz1lLmX7QQcmD0CHmE2fQAUqoksYecIyXlAXYQKrooc
         nWw/+7J/XGqQxAUD2pUqzuIVZpzkoyiVvqrHvx2gQmCXXxAIHpjXmSUtx6bdP3vHCBao
         Zy2ThwFYXIXNpPZ+lj5+ArPsvYOApcGpm95kcOHuwUuKDbpDGjtPo7upJBPhZ449Gvj5
         buFwhXLJJGr3zN4XPA/o5s6sLzewhnS2kkVf/EsZq1jSHCcky0OsllgDOfZr/scwp31z
         OWjl2Hxbj7uGjggev2XvhaH1pN3iSIsyzg/UGJRoByCzD9YgpXsWvkQNRNCCK6bk7ruD
         2/SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qhP21l6x2Q5VGk0xSAFqQ/z2LwGG8VLczBmLUtLGjmA=;
        b=bPG8VcJS67lr9yYFoyo+6H59Ptm5wXUeMB35j96oZukk7DXlmu4r0Nj6rO4yD8knRc
         D07zJyYn0pKl++sg8ck5YPOgWlZmRi4rrervmr6GAhIJr7TQ5DPabRwD4yaMVTo5+CHR
         322gqBKQZQYNg+jPnpr3BYV5pg3eUbHINmanrBBwhbxBDt/Il3oQPq/9zEu5FtI0S+Ho
         THXVlGfUR9tOpITxhd6gyTK+A3TZWej8mRbvSy3/qaYLmMxA/VRGafwzxXMeQHvlP9Ve
         YmTdEeXkyITCSrhYAo0HTTTHd1EKKN5aT0XPeqPbvQHJu0ZsZHDD2KqgMbRRMsJxfMyM
         mC4Q==
X-Gm-Message-State: APjAAAV+UMEUkuWwWBJ7J00F/5UMhq2V6miz6AbdRkZEfAU9FYEQjnVe
        XIcI/dOxFlVo/npy3HfPnQo=
X-Google-Smtp-Source: APXvYqzVlhaVV+WioQq07jsGHsXvuU93FTEDeBd88DjdVKLqQt+/Yy1Gxg7JNwtCiz4px02Qxg2bbA==
X-Received: by 2002:a62:5209:: with SMTP id g9mr11721125pfb.28.1571845564152;
        Wed, 23 Oct 2019 08:46:04 -0700 (PDT)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id g9sm19960319pjl.20.2019.10.23.08.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 08:46:02 -0700 (PDT)
Date:   Wed, 23 Oct 2019 23:45:57 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: make sure the kernel and repair tools catch bad
 names
Message-ID: <20191023154552.GD2543@desktop>
References: <157170897992.1172383.2128928990011336996.stgit@magnolia>
 <157170899277.1172383.10473571682266133494.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157170899277.1172383.10473571682266133494.stgit@magnolia>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Oct 21, 2019 at 06:49:52PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Make sure we actually catch bad names in the kernel.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  tests/xfs/749     |  103 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/749.out |    4 ++
>  tests/xfs/group   |    1 +
>  3 files changed, 108 insertions(+)
>  create mode 100755 tests/xfs/749
>  create mode 100644 tests/xfs/749.out
> 
> 
> diff --git a/tests/xfs/749 b/tests/xfs/749
> new file mode 100755
> index 00000000..de219979
> --- /dev/null
> +++ b/tests/xfs/749
> @@ -0,0 +1,103 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-newer
> +# Copyright (c) 2019, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test No. 749
> +#
> +# See if we catch corrupt directory names or attr names with nulls or slashes
> +# in them.
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
> +	umount $mntpt > /dev/null 2>&1

$UMOUNT_PROG

> +	test -n "$loopdev" && _destroy_loop_device $loopdev > /dev/null 2>&1
> +	rm -r -f $imgfile $mntpt $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_supported_os Linux
> +_require_test

_require_attrs is also needed

> +
> +rm -f $seqres.full
> +
> +imgfile=$TEST_DIR/img-$seq
> +mntpt=$TEST_DIR/mount-$seq
> +testdir=$mntpt/testdir
> +testfile=$mntpt/testfile
> +nullstr="too_many_beans"
> +slashstr="are_bad_for_you"
> +
> +# Format image file
> +truncate -s 40m $imgfile

$XFS_IO_PROG -fc "truncate 40m" $imgfile

> +loopdev=$(_create_loop_device $imgfile)
> +$MKFS_XFS_PROG $loopdev >> $seqres.full

_mkfs_dev $loopdev ?

> +
> +# Mount image file
> +mkdir -p $mntpt
> +mount $loopdev $mntpt

_mount $loopdev $mntpt

> +
> +# Create directory entries
> +mkdir -p $testdir
> +touch $testdir/$nullstr
> +touch $testdir/$slashstr
> +
> +# Create attrs
> +touch $testfile
> +$ATTR_PROG -s $nullstr -V heh $testfile >> $seqres.full
> +$ATTR_PROG -s $slashstr -V heh $testfile >> $seqres.full
> +
> +# Corrupt the entries
> +umount $mntpt

$UMOUNT_PROG $mntpt

> +_destroy_loop_device $loopdev
> +cp $imgfile $imgfile.old
> +sed -b \
> +	-e "s/$nullstr/too_many\x00beans/g" \
> +	-e "s/$slashstr/are_bad\/for_you/g" \
> +	-i $imgfile
> +test "$(md5sum < $imgfile)" != "$(md5sum < $imgfile.old)" ||
> +	_fail "sed failed to change the image file?"
> +rm -f $imgfile.old
> +loopdev=$(_create_loop_device $imgfile)
> +mount $loopdev $mntpt

_mount $loopdev $mntpt

> +
> +# Try to access the corrupt metadata
> +ls $testdir >> $seqres.full 2> $tmp.err
> +attr -l $testfile >> $seqres.full 2>> $tmp.err

$ATTR_PROG

> +cat $tmp.err | _filter_test_dir
> +
> +# Does scrub complain about this?
> +if _supports_xfs_scrub $mntpt $loopdev; then
> +	$XFS_SCRUB_PROG -n $mntpt >> $seqres.full 2>&1
> +	res=$?
> +	test $((res & 1)) -eq 0 && \
> +		echo "scrub failed to report corruption ($res)"
> +fi
> +
> +# Does repair complain about this?
> +umount $mntpt

$UMOUNT_PROG

> +$XFS_REPAIR_PROG -n $loopdev >> $seqres.full 2>&1
> +res=$?
> +test $res -eq 1 || \
> +	echo "repair failed to report corruption ($res)"
> +
> +_destroy_loop_device $loopdev
> +loopdev=
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/749.out b/tests/xfs/749.out
> new file mode 100644
> index 00000000..db704c87
> --- /dev/null
> +++ b/tests/xfs/749.out
> @@ -0,0 +1,4 @@
> +QA output created by 749
> +ls: cannot access 'TEST_DIR/mount-749/testdir': Structure needs cleaning
> +attr_list: Structure needs cleaning
> +Could not list "(null)" for TEST_DIR/mount-749/testfile

I got the following diff on my fedora 30 test vm, where attr version is
attr-2.4.48-5.fc30.x86_64, perhaps the attr output has been changed?
Looks like we need a filter, or use _getfattr?

-Could not list "(null)" for TEST_DIR/mount-148/testfile
+Could not list TEST_DIR/mount-148/testfile

Thanks,
Eryu

> diff --git a/tests/xfs/group b/tests/xfs/group
> index f4ebcd8c..9600cb4e 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -507,3 +507,4 @@
>  509 auto ioctl
>  510 auto ioctl quick
>  511 auto quick quota
> +749 auto quick fuzzers
> 
