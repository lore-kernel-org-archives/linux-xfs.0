Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08E63C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 03:02:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbiJLDC3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 23:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiJLDC2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 23:02:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA8EDA2AAB
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2022 20:02:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665543746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rogtay9PtspUCfXhfPWVXkVkap7s38YqBM9gxwFaMtU=;
        b=POZl7qfeuM1OPBRO7gJIYrVuL/TlVxOgm6tRPJJaLkjNAzRW1Kjr5/xPorf9QvfQg6UdR6
        6Gtfc/usFGYPrRmBdJ37W+VPvKVzbs6iwESb9pEby7RDzzLVuK0f2Ylml4lolOQtA18kSp
        kLXe+L6mGAEv81Tues/oVsp/UKW3GU8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-68-R22SsuHROu-gWJWszSIAUg-1; Tue, 11 Oct 2022 23:02:25 -0400
X-MC-Unique: R22SsuHROu-gWJWszSIAUg-1
Received: by mail-qt1-f197.google.com with SMTP id gd8-20020a05622a5c0800b0039cb77202eeso1706644qtb.0
        for <linux-xfs@vger.kernel.org>; Tue, 11 Oct 2022 20:02:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rogtay9PtspUCfXhfPWVXkVkap7s38YqBM9gxwFaMtU=;
        b=xSQuI1KK9JvYK7WyOi42xn5zPMUTk8qAqHhIra4pbXpt4MBn8VVDCaDhH/ZpKqVAsM
         XJzLos7i+iQPqBZqXSxoV4qWeCbo8AUK/KRVYfBE3qxBf3mItCgY8qKk+E9uE/i97QY1
         TaOfHu9YPi+8gCrUCI+zcWmUWnrnnudhGyVKFZlAYSujT6Z8O9RwWT2few1k7kHk4eFp
         ZtM9CSsBwqHyFrihg75uBKB5yb5ACflrM8otMVWE9ZhWyS8K7lQtrQPQZtmoymeA6t4H
         3ntPm1gnHTW53nxMvjLI8wSfIl+w3PBlNWwVTOUDTXLFwiNPTd5sOKN2SQ5QiHUFyBxv
         c5NA==
X-Gm-Message-State: ACrzQf01PqMyodF1maAF2EUwgVH6N0bvFWedponap3kcvEP3IHfbM1Xd
        zdT40oByM4F3yv7j2LzMNLuFWeG6Zh2z5mxEgwOgn3dk3wWZk4nb0+dPsv7vBnb0uuXm32SqS9u
        CX5gwUq7S2KMLZrxv4t/S
X-Received: by 2002:a05:620a:1927:b0:6ee:94f6:b9fb with SMTP id bj39-20020a05620a192700b006ee94f6b9fbmr987648qkb.80.1665543745092;
        Tue, 11 Oct 2022 20:02:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5P65cKr8cz4jC+OFfwmgZhJkQ43dnXWpf9KiivWA9GMiezkAp4YMSB/U/cn8Abz16S3r/OTw==
X-Received: by 2002:a05:620a:1927:b0:6ee:94f6:b9fb with SMTP id bj39-20020a05620a192700b006ee94f6b9fbmr987635qkb.80.1665543744807;
        Tue, 11 Oct 2022 20:02:24 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id bw5-20020a05622a098500b0039cba52974fsm1347670qtb.94.2022.10.11.20.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 20:02:24 -0700 (PDT)
Date:   Wed, 12 Oct 2022 11:02:20 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 2/4] xfs: add parent pointer test
Message-ID: <20221012030220.ng5xra7deoeutb77@zlang-mailbox>
References: <20221012013812.82161-1-catherine.hoang@oracle.com>
 <20221012013812.82161-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012013812.82161-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 11, 2022 at 06:38:10PM -0700, Catherine Hoang wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Add a test to verify basic parent pointers operations (create, move, link,
> unlink, rename, overwrite).
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  doc/group-names.txt |   1 +
>  tests/xfs/554       | 125 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/554.out   |  59 +++++++++++++++++++++
>  3 files changed, 185 insertions(+)
>  create mode 100755 tests/xfs/554
>  create mode 100644 tests/xfs/554.out
> 
> diff --git a/doc/group-names.txt b/doc/group-names.txt
> index ef411b5e..8e35c699 100644
> --- a/doc/group-names.txt
> +++ b/doc/group-names.txt
> @@ -77,6 +77,7 @@ nfs4_acl		NFSv4 access control lists
>  nonsamefs		overlayfs layers on different filesystems
>  online_repair		online repair functionality tests
>  other			dumping ground, do not add more tests to this group
> +parent			Parent pointer tests
>  pattern			specific IO pattern tests
>  perms			access control and permission checking
>  pipe			pipe functionality
> diff --git a/tests/xfs/554 b/tests/xfs/554
> new file mode 100755
> index 00000000..26914e4c
> --- /dev/null
> +++ b/tests/xfs/554
> @@ -0,0 +1,125 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test 554
> +#
> +# simple parent pointer test
> +#
> +
> +. ./common/preamble
> +_begin_fstest auto quick parent
> +
> +cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}

This's same with common cleanup function, you can remove this function.

> +
> +full()
> +{
> +    echo ""            >>$seqres.full
> +    echo "*** $* ***"  >>$seqres.full
> +    echo ""            >>$seqres.full
> +}

What's this function for? I didn't see this function is called in this case.
Am I missing something?

> +
> +# get standard environment, filters and checks
> +. ./common/filter
> +. ./common/reflink
> +. ./common/inject
> +. ./common/parent
> +
> +# Modify as appropriate
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_sysfs debug/larp
> +_require_xfs_io_error_injection "larp"
> +_require_xfs_parent
> +_require_xfs_io_command "parent"
> +
> +# real QA test starts here
> +
> +# Create a directory tree using a protofile and
> +# make sure all inodes created have parent pointers
> +
> +protofile=$tmp.proto
> +
> +cat >$protofile <<EOF
> +DUMMY1
> +0 0
> +: root directory
> +d--777 3 1
> +: a directory
> +testfolder1 d--755 3 1
> +file1 ---755 3 1 /dev/null
> +$
> +: back in the root
> +testfolder2 d--755 3 1
> +file2 ---755 3 1 /dev/null
> +: done
> +$
> +EOF
> +
> +if [ $? -ne 0 ]
> +then
> +    _fail "failed to create test protofile"
> +fi

It just writes a general file, right? Is there any special reason might cause
write fail?

I think we don't need to check each step's return value. And if we fail to write
a file, bash helps to output error message to break golden image too.

Thanks,
Zorro

> +
> +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
> +	|| _fail "mkfs failed"
> +_check_scratch_fs
> +
> +_scratch_mount >>$seqres.full 2>&1 \
> +	|| _fail "mount failed"
> +
> +testfolder1="testfolder1"
> +testfolder2="testfolder2"
> +file1="file1"
> +file2="file2"
> +file3="file3"
> +file4="file4"
> +file5="file5"
> +file1_ln="file1_link"
> +
> +echo ""
> +# Create parent pointer test
> +_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1"
> +
> +echo ""
> +# Move parent pointer test
> +mv $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder2/$file1
> +_verify_parent "$testfolder2" "$file1" "$testfolder2/$file1"
> +
> +echo ""
> +# Hard link parent pointer test
> +ln $SCRATCH_MNT/$testfolder2/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln
> +_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
> +_verify_parent "$testfolder1" "$file1_ln" "$testfolder2/$file1"
> +_verify_parent "$testfolder2" "$file1"    "$testfolder1/$file1_ln"
> +_verify_parent "$testfolder2" "$file1"    "$testfolder2/$file1"
> +
> +echo ""
> +# Remove hard link parent pointer test
> +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file1)"
> +rm $SCRATCH_MNT/$testfolder2/$file1
> +_verify_parent "$testfolder1" "$file1_ln" "$testfolder1/$file1_ln"
> +_verify_no_parent "$file1" "$ino" "$testfolder1/$file1_ln"
> +
> +echo ""
> +# Rename parent pointer test
> +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln)"
> +mv $SCRATCH_MNT/$testfolder1/$file1_ln $SCRATCH_MNT/$testfolder1/$file2
> +_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
> +_verify_no_parent "$file1_ln" "$ino" "$testfolder1/$file2"
> +
> +echo ""
> +# Over write parent pointer test
> +touch $SCRATCH_MNT/$testfolder2/$file3
> +_verify_parent "$testfolder2" "$file3" "$testfolder2/$file3"
> +ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder2/$file3)"
> +mv -f $SCRATCH_MNT/$testfolder2/$file3 $SCRATCH_MNT/$testfolder1/$file2
> +_verify_parent "$testfolder1" "$file2" "$testfolder1/$file2"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/554.out b/tests/xfs/554.out
> new file mode 100644
> index 00000000..67ea9f2b
> --- /dev/null
> +++ b/tests/xfs/554.out
> @@ -0,0 +1,59 @@
> +QA output created by 554
> +
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1
> +
> +*** testfolder2 OK
> +*** testfolder2/file1 OK
> +*** testfolder2/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder2/file1
> +
> +*** testfolder1 OK
> +*** testfolder1/file1_link OK
> +*** testfolder1/file1_link OK
> +*** Verified parent pointer: name:file1_link, namelen:10
> +*** Parent pointer OK for child testfolder1/file1_link
> +*** testfolder1 OK
> +*** testfolder2/file1 OK
> +*** testfolder1/file1_link OK
> +*** Verified parent pointer: name:file1_link, namelen:10
> +*** Parent pointer OK for child testfolder2/file1
> +*** testfolder2 OK
> +*** testfolder1/file1_link OK
> +*** testfolder2/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link
> +*** testfolder2 OK
> +*** testfolder2/file1 OK
> +*** testfolder2/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder2/file1
> +
> +*** testfolder1 OK
> +*** testfolder1/file1_link OK
> +*** testfolder1/file1_link OK
> +*** Verified parent pointer: name:file1_link, namelen:10
> +*** Parent pointer OK for child testfolder1/file1_link
> +*** testfolder1/file1_link OK
> +
> +*** testfolder1 OK
> +*** testfolder1/file2 OK
> +*** testfolder1/file2 OK
> +*** Verified parent pointer: name:file2, namelen:5
> +*** Parent pointer OK for child testfolder1/file2
> +*** testfolder1/file2 OK
> +
> +*** testfolder2 OK
> +*** testfolder2/file3 OK
> +*** testfolder2/file3 OK
> +*** Verified parent pointer: name:file3, namelen:5
> +*** Parent pointer OK for child testfolder2/file3
> +*** testfolder1 OK
> +*** testfolder1/file2 OK
> +*** testfolder1/file2 OK
> +*** Verified parent pointer: name:file2, namelen:5
> +*** Parent pointer OK for child testfolder1/file2
> -- 
> 2.25.1
> 

