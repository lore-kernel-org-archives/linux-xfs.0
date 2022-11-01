Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3B0BFA3743
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Nov 2022 06:24:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiKAGYh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 02:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbiKAGYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 02:24:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 914E411C2F
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 23:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667283819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=saWnuQOKtaAumCRsjukAoWUGi36thDoFWlF5PEVAIHo=;
        b=Ai/kUPOIsOdWr3ItwmT2at1x4PWACSucF08xItwIhh9RDKgJw1gbw5FdM2Spa9fx59az2A
        M6sWphHFvnbHHSFABFSMkXCieVL4THluR4OgretmDsDGRC42u7iuR5oEd9bJfAlYM2FmTP
        CWPNJ2VDnZN9lU8zQepXSSNNHSEQhog=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-456-M5QQXabsMh-YBhb5XyiX-Q-1; Tue, 01 Nov 2022 02:23:38 -0400
X-MC-Unique: M5QQXabsMh-YBhb5XyiX-Q-1
Received: by mail-qk1-f197.google.com with SMTP id bi38-20020a05620a31a600b006eeb2862816so11307975qkb.0
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 23:23:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=saWnuQOKtaAumCRsjukAoWUGi36thDoFWlF5PEVAIHo=;
        b=FYosRt4+Cjgi5o655b1Z9kzmKJ4odR6vLv6ADM/2xzW8jiNU/pjiGwIi+O2ezDVeIX
         ov19i4YlExsKOSKTMTyb6yVsJzL/NcrrrzoQVyKK/tKhPIEHeMzqONSoZr/F97TVV00d
         nFN2htuD65gBy7qD24b//TEzPyV2m5Ss1T/ZxRj3i1aumepeORBhIoIMaewHhwLpsT1J
         3/SbOuUqJ+HqZZxZmlAzw7dXkXnTGXbmpR4TC1PC7a3tvVBM283jifvYXy0yW/06ZIot
         yHV3M85+vIgIUwMqqUxECxU2uoW/0HwF+VY7Zi/YsW31U44/gVM7Foqdl1iDhZc/mUew
         krRQ==
X-Gm-Message-State: ACrzQf3gywWTxCfyUXtOsAjJdDeo4F8ZcMExUFgC0IEdX+mKl4+Xgiwz
        c4Zb5RLy1AFSDJgbw5vk3trNfu59xDrsv8eTTWHUJLdBhAfqjJ8s6k1QTGHSA8QuwZD35s6Qhjp
        voV2s0AtNFRVEDtS1ge0I
X-Received: by 2002:a05:620a:430d:b0:6d3:9dc9:d83d with SMTP id u13-20020a05620a430d00b006d39dc9d83dmr11985169qko.224.1667283817873;
        Mon, 31 Oct 2022 23:23:37 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Kj87ZlUnJkHY4ISqQ4ax2b45v6LJMsW92AJAGZRuLIv/e205FPr4nTh4l0Nkl8C7sx0fcrA==
X-Received: by 2002:a05:620a:430d:b0:6d3:9dc9:d83d with SMTP id u13-20020a05620a430d00b006d39dc9d83dmr11985162qko.224.1667283817585;
        Mon, 31 Oct 2022 23:23:37 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id bm2-20020a05620a198200b006cfc7f9eea0sm5988733qkb.122.2022.10.31.23.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 23:23:36 -0700 (PDT)
Date:   Tue, 1 Nov 2022 14:23:32 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v3 2/4] xfs: add parent pointer test
Message-ID: <20221101062332.n2dzuzo2l762dxjx@zlang-mailbox>
References: <20221028215605.17973-1-catherine.hoang@oracle.com>
 <20221028215605.17973-3-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028215605.17973-3-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 02:56:03PM -0700, Catherine Hoang wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Add a test to verify basic parent pointers operations (create, move, link,
> unlink, rename, overwrite).
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  doc/group-names.txt |   1 +
>  tests/xfs/554       | 101 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/554.out   |  59 ++++++++++++++++++++++++++
>  3 files changed, 161 insertions(+)
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

Hi,

xfs/554 has been taken, please rebase to the lastest for-next branch, or you
can a big enough number (e.g. 999) to avoid merging conflict, then I can rename
the name after merging.

> new file mode 100755
> index 00000000..44b77f9d
> --- /dev/null
> +++ b/tests/xfs/554
> @@ -0,0 +1,101 @@
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
> +# get standard environment, filters and checks
> +. ./common/parent
> +
> +# Modify as appropriate
> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_sysfs debug/larp

Is debug/larp needed by this case?

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
> +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqres.full 2>&1 \
> +	|| _fail "mkfs failed"
> +_check_scratch_fs
> +
> +_scratch_mount >>$seqres.full 2>&1 \
> +	|| _fail "mount failed"

_scratch_mount calls _fail() inside.

Thanks,
Zorro

> +
> +testfolder1="testfolder1"
> +testfolder2="testfolder2"
> +file1="file1"
> +file2="file2"
> +file3="file3"
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

