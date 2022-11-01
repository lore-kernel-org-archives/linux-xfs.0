Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96599FA373D
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Nov 2022 06:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiKAG2I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 02:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKAG2G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 02:28:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5653C12ACD
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 23:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667284023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B44DM3HeVGCFFWufpEK+98RsYsPAqd9+V4kQqwnENdg=;
        b=RifIwLBAjlKNhuADItZMiYxyBNg92eobbV4QqHbwRuRGz8HAq1z+/8sklpb0xcNhlWTULy
        ZKy6UjgwEmL5qZqeGsDZ/jjQpsu68vqK4GtdGLK6q4CabwAx4BdfQTmgyxieMKX+KBaPIy
        QmKXkTar9cidEQeQH94uNeEJ4OJjL0c=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-121-P-TnX6MpOPa18QRqJLUPbQ-1; Tue, 01 Nov 2022 02:27:02 -0400
X-MC-Unique: P-TnX6MpOPa18QRqJLUPbQ-1
Received: by mail-qk1-f198.google.com with SMTP id j13-20020a05620a288d00b006be7b2a758fso11266975qkp.1
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 23:27:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B44DM3HeVGCFFWufpEK+98RsYsPAqd9+V4kQqwnENdg=;
        b=lj2eSiQJvvyru0T2TjXEOygUeb5gtgnwfxyWCo6QnZozXO2RoUWpJt5AodgIyIr4FZ
         szsvok2/Hq8kVfvQFjNQvTX1DqdMhYm5thbAnyNvDNTlHzAKxjNe7JwIG6Oui6xwjnnA
         UhZIeztXKUdeUy5ijE5dBtB9hKpZ7Qj9JLLs+xvC7yS3ybK8/TBvXFmFV+IJkOGyscj+
         70jmirXnpnGEpH3HTWnZ7DPlP5FoBYmd4G0plK2x0GOrKk+AH3hgVe1JoZyFtnZKF3CD
         vqd2Lecu21dQehTX0UyCiror4UoaBv65a+0i80fTg9L05+3uOVVRJr9PMuAX2hsKvC+r
         l7cw==
X-Gm-Message-State: ACrzQf0u2hiZm3jw9GDsQIn5BDqpkHYXOzgA8nnlS1M2H3YU3ALiY6WQ
        M2lixB1ebDh00Ed6CorK2x4Nc9VF3TkwqYxC7HH4o+1QHyOuFvs+Dt7vE8HDSYHzjYBdw5/QTDj
        r3KPuPs8IBwpnCs5WSijk
X-Received: by 2002:a05:622a:3d2:b0:3a4:ecf9:1a2d with SMTP id k18-20020a05622a03d200b003a4ecf91a2dmr13799413qtx.589.1667284020986;
        Mon, 31 Oct 2022 23:27:00 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6O5DWckA4f8mw6NnEBmVUKybQ7xPUIFm8xfkC/i4gmGzPw5T2gdb8gRtGYVF/IvdT2JbrZOg==
X-Received: by 2002:a05:622a:3d2:b0:3a4:ecf9:1a2d with SMTP id k18-20020a05622a03d200b003a4ecf91a2dmr13799403qtx.589.1667284020578;
        Mon, 31 Oct 2022 23:27:00 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id ay7-20020a05620a178700b006cfc1d827cbsm5982601qkb.9.2022.10.31.23.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 23:26:59 -0700 (PDT)
Date:   Tue, 1 Nov 2022 14:26:55 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v3 3/4] xfs: add multi link parent pointer test
Message-ID: <20221101062655.46ggqqdfhbkmblrr@zlang-mailbox>
References: <20221028215605.17973-1-catherine.hoang@oracle.com>
 <20221028215605.17973-4-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028215605.17973-4-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 02:56:04PM -0700, Catherine Hoang wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Add a test to verify parent pointers while multiple links to a file are
> created and removed.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---
>  tests/xfs/555     |   69 ++++
>  tests/xfs/555.out | 1002 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 1071 insertions(+)
>  create mode 100755 tests/xfs/555
>  create mode 100644 tests/xfs/555.out
> 
> diff --git a/tests/xfs/555 b/tests/xfs/555
> new file mode 100755
> index 00000000..02de3f15
> --- /dev/null
> +++ b/tests/xfs/555

Hi,

xfs/555 is taken too.

> @@ -0,0 +1,69 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022, Oracle and/or its affiliates.  All Rights Reserved.
> +#
> +# FS QA Test 555
> +#
> +# multi link parent pointer test
> +#
> +. ./common/preamble
> +_begin_fstest auto quick parent
> +
> +# get standard environment, filters and checks
> +. ./common/parent
> +
> +# Modify as appropriate

This comment can be removed

> +_supported_fs xfs
> +_require_scratch
> +_require_xfs_sysfs debug/larp

Is debug/larp really needed by this case?

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
> +: done
> +$
> +EOF
> +
> +_scratch_mkfs -f -n parent=1 -p $protofile >>$seqresres.full 2>&1 \
> +	|| _fail "mkfs failed"
> +_check_scratch_fs
> +
> +_scratch_mount >>$seqres.full 2>&1 \
> +	|| _fail "mount failed"

This _fail isn't needed, due to _scratch_mount calls _fail() inside.

Thanks,
Zorro

> +
> +testfolder1="testfolder1"
> +file1="file1"
> +file1_ln="file1_link"
> +
> +echo ""
> +# Multi link parent pointer test
> +NLINKS=100
> +for (( j=0; j<$NLINKS; j++ )); do
> +	ln $SCRATCH_MNT/$testfolder1/$file1 $SCRATCH_MNT/$testfolder1/$file1_ln.$j
> +	_verify_parent "$testfolder1" "$file1_ln.$j" "$testfolder1/$file1"
> +	_verify_parent "$testfolder1" "$file1" "$testfolder1/$file1_ln.$j"
> +done
> +# Multi unlink parent pointer test
> +for (( j=$NLINKS-1; j<=0; j-- )); do
> +	ino="$(stat -c '%i' $SCRATCH_MNT/$testfolder1/$file1_ln.$j)"
> +	rm $SCRATCH_MNT/$testfolder1/$file1_ln.$j
> +	_verify_no_parent "$file1_ln.$j" "$ino" "$testfolder1/$file1"
> +done
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/555.out b/tests/xfs/555.out
> new file mode 100644
> index 00000000..eb63ff3a
> --- /dev/null
> +++ b/tests/xfs/555.out
> @@ -0,0 +1,1002 @@
> +QA output created by 555
> +
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.0 OK
> +*** Verified parent pointer: name:file1_link.0, namelen:12
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.0 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.0
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.1 OK
> +*** Verified parent pointer: name:file1_link.1, namelen:12
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.1 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.1
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.2 OK
> +*** Verified parent pointer: name:file1_link.2, namelen:12
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.2 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.2
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.3 OK
> +*** Verified parent pointer: name:file1_link.3, namelen:12
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.3 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.3
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.4 OK
> +*** Verified parent pointer: name:file1_link.4, namelen:12
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.4 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.4
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.5 OK
> +*** Verified parent pointer: name:file1_link.5, namelen:12
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.5 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.5
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.6 OK
> +*** Verified parent pointer: name:file1_link.6, namelen:12
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.6 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.6
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.7 OK
> +*** Verified parent pointer: name:file1_link.7, namelen:12
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.7 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.7
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.8 OK
> +*** Verified parent pointer: name:file1_link.8, namelen:12
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.8 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.8
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.9 OK
> +*** Verified parent pointer: name:file1_link.9, namelen:12
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.9 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.9
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.10 OK
> +*** Verified parent pointer: name:file1_link.10, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.10 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.10
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.11 OK
> +*** Verified parent pointer: name:file1_link.11, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.11 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.11
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.12 OK
> +*** Verified parent pointer: name:file1_link.12, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.12 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.12
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.13 OK
> +*** Verified parent pointer: name:file1_link.13, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.13 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.13
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.14 OK
> +*** Verified parent pointer: name:file1_link.14, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.14 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.14
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.15 OK
> +*** Verified parent pointer: name:file1_link.15, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.15 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.15
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.16 OK
> +*** Verified parent pointer: name:file1_link.16, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.16 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.16
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.17 OK
> +*** Verified parent pointer: name:file1_link.17, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.17 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.17
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.18 OK
> +*** Verified parent pointer: name:file1_link.18, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.18 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.18
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.19 OK
> +*** Verified parent pointer: name:file1_link.19, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.19 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.19
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.20 OK
> +*** Verified parent pointer: name:file1_link.20, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.20 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.20
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.21 OK
> +*** Verified parent pointer: name:file1_link.21, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.21 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.21
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.22 OK
> +*** Verified parent pointer: name:file1_link.22, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.22 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.22
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.23 OK
> +*** Verified parent pointer: name:file1_link.23, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.23 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.23
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.24 OK
> +*** Verified parent pointer: name:file1_link.24, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.24 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.24
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.25 OK
> +*** Verified parent pointer: name:file1_link.25, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.25 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.25
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.26 OK
> +*** Verified parent pointer: name:file1_link.26, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.26 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.26
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.27 OK
> +*** Verified parent pointer: name:file1_link.27, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.27 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.27
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.28 OK
> +*** Verified parent pointer: name:file1_link.28, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.28 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.28
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.29 OK
> +*** Verified parent pointer: name:file1_link.29, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.29 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.29
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.30 OK
> +*** Verified parent pointer: name:file1_link.30, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.30 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.30
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.31 OK
> +*** Verified parent pointer: name:file1_link.31, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.31 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.31
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.32 OK
> +*** Verified parent pointer: name:file1_link.32, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.32 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.32
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.33 OK
> +*** Verified parent pointer: name:file1_link.33, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.33 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.33
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.34 OK
> +*** Verified parent pointer: name:file1_link.34, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.34 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.34
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.35 OK
> +*** Verified parent pointer: name:file1_link.35, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.35 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.35
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.36 OK
> +*** Verified parent pointer: name:file1_link.36, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.36 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.36
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.37 OK
> +*** Verified parent pointer: name:file1_link.37, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.37 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.37
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.38 OK
> +*** Verified parent pointer: name:file1_link.38, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.38 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.38
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.39 OK
> +*** Verified parent pointer: name:file1_link.39, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.39 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.39
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.40 OK
> +*** Verified parent pointer: name:file1_link.40, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.40 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.40
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.41 OK
> +*** Verified parent pointer: name:file1_link.41, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.41 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.41
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.42 OK
> +*** Verified parent pointer: name:file1_link.42, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.42 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.42
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.43 OK
> +*** Verified parent pointer: name:file1_link.43, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.43 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.43
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.44 OK
> +*** Verified parent pointer: name:file1_link.44, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.44 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.44
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.45 OK
> +*** Verified parent pointer: name:file1_link.45, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.45 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.45
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.46 OK
> +*** Verified parent pointer: name:file1_link.46, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.46 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.46
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.47 OK
> +*** Verified parent pointer: name:file1_link.47, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.47 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.47
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.48 OK
> +*** Verified parent pointer: name:file1_link.48, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.48 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.48
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.49 OK
> +*** Verified parent pointer: name:file1_link.49, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.49 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.49
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.50 OK
> +*** Verified parent pointer: name:file1_link.50, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.50 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.50
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.51 OK
> +*** Verified parent pointer: name:file1_link.51, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.51 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.51
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.52 OK
> +*** Verified parent pointer: name:file1_link.52, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.52 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.52
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.53 OK
> +*** Verified parent pointer: name:file1_link.53, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.53 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.53
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.54 OK
> +*** Verified parent pointer: name:file1_link.54, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.54 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.54
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.55 OK
> +*** Verified parent pointer: name:file1_link.55, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.55 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.55
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.56 OK
> +*** Verified parent pointer: name:file1_link.56, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.56 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.56
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.57 OK
> +*** Verified parent pointer: name:file1_link.57, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.57 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.57
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.58 OK
> +*** Verified parent pointer: name:file1_link.58, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.58 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.58
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.59 OK
> +*** Verified parent pointer: name:file1_link.59, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.59 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.59
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.60 OK
> +*** Verified parent pointer: name:file1_link.60, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.60 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.60
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.61 OK
> +*** Verified parent pointer: name:file1_link.61, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.61 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.61
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.62 OK
> +*** Verified parent pointer: name:file1_link.62, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.62 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.62
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.63 OK
> +*** Verified parent pointer: name:file1_link.63, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.63 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.63
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.64 OK
> +*** Verified parent pointer: name:file1_link.64, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.64 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.64
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.65 OK
> +*** Verified parent pointer: name:file1_link.65, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.65 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.65
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.66 OK
> +*** Verified parent pointer: name:file1_link.66, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.66 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.66
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.67 OK
> +*** Verified parent pointer: name:file1_link.67, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.67 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.67
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.68 OK
> +*** Verified parent pointer: name:file1_link.68, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.68 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.68
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.69 OK
> +*** Verified parent pointer: name:file1_link.69, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.69 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.69
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.70 OK
> +*** Verified parent pointer: name:file1_link.70, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.70 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.70
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.71 OK
> +*** Verified parent pointer: name:file1_link.71, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.71 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.71
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.72 OK
> +*** Verified parent pointer: name:file1_link.72, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.72 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.72
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.73 OK
> +*** Verified parent pointer: name:file1_link.73, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.73 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.73
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.74 OK
> +*** Verified parent pointer: name:file1_link.74, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.74 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.74
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.75 OK
> +*** Verified parent pointer: name:file1_link.75, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.75 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.75
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.76 OK
> +*** Verified parent pointer: name:file1_link.76, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.76 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.76
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.77 OK
> +*** Verified parent pointer: name:file1_link.77, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.77 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.77
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.78 OK
> +*** Verified parent pointer: name:file1_link.78, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.78 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.78
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.79 OK
> +*** Verified parent pointer: name:file1_link.79, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.79 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.79
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.80 OK
> +*** Verified parent pointer: name:file1_link.80, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.80 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.80
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.81 OK
> +*** Verified parent pointer: name:file1_link.81, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.81 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.81
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.82 OK
> +*** Verified parent pointer: name:file1_link.82, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.82 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.82
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.83 OK
> +*** Verified parent pointer: name:file1_link.83, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.83 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.83
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.84 OK
> +*** Verified parent pointer: name:file1_link.84, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.84 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.84
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.85 OK
> +*** Verified parent pointer: name:file1_link.85, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.85 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.85
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.86 OK
> +*** Verified parent pointer: name:file1_link.86, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.86 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.86
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.87 OK
> +*** Verified parent pointer: name:file1_link.87, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.87 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.87
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.88 OK
> +*** Verified parent pointer: name:file1_link.88, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.88 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.88
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.89 OK
> +*** Verified parent pointer: name:file1_link.89, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.89 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.89
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.90 OK
> +*** Verified parent pointer: name:file1_link.90, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.90 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.90
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.91 OK
> +*** Verified parent pointer: name:file1_link.91, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.91 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.91
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.92 OK
> +*** Verified parent pointer: name:file1_link.92, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.92 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.92
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.93 OK
> +*** Verified parent pointer: name:file1_link.93, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.93 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.93
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.94 OK
> +*** Verified parent pointer: name:file1_link.94, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.94 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.94
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.95 OK
> +*** Verified parent pointer: name:file1_link.95, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.95 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.95
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.96 OK
> +*** Verified parent pointer: name:file1_link.96, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.96 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.96
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.97 OK
> +*** Verified parent pointer: name:file1_link.97, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.97 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.97
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.98 OK
> +*** Verified parent pointer: name:file1_link.98, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.98 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.98
> +*** testfolder1 OK
> +*** testfolder1/file1 OK
> +*** testfolder1/file1_link.99 OK
> +*** Verified parent pointer: name:file1_link.99, namelen:13
> +*** Parent pointer OK for child testfolder1/file1
> +*** testfolder1 OK
> +*** testfolder1/file1_link.99 OK
> +*** testfolder1/file1 OK
> +*** Verified parent pointer: name:file1, namelen:5
> +*** Parent pointer OK for child testfolder1/file1_link.99
> -- 
> 2.25.1
> 

