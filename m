Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F75C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 09:12:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C12261165
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 09:12:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235566AbhHXJN3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 05:13:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59780 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235435AbhHXJN3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 05:13:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629796365;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7GZvuXMPWT2bJCRJfFApnNtzxNgwRqXM4t95ZqjjCmY=;
        b=KUdoNlbFxTB+Ji9LdkQrikXahB4K6Uz35i1J31w1QCVnPaccjwQvJcz7E4fg6H1jMUZYCm
        DuR3wkoWOdegYdly0EyEPkdCj9u20Mc1Z9KNgu7pmKuE6B8XZDLe23UF+aPll7TuEgOk5y
        azh9UoeXob8YURZA2mONXWW6tHfMxGk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-CwLohivaOlSjXkDIUOqS7A-1; Tue, 24 Aug 2021 05:12:43 -0400
X-MC-Unique: CwLohivaOlSjXkDIUOqS7A-1
Received: by mail-pg1-f197.google.com with SMTP id 1-20020a630e41000000b002528846c9f2so11848796pgo.12
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 02:12:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=7GZvuXMPWT2bJCRJfFApnNtzxNgwRqXM4t95ZqjjCmY=;
        b=NX8+7ED93WNTDjyQskKkUZ8256G7j8SqbVnPWG/f70jmw/2UEXobhA681BekDoIbR5
         gXBieQbIyPE5LxdHIurBnZalKdW/c31bT+MlG/3eNDj8YbTAltPogATs+gAuAO2qljUT
         Q6hwkudb0Nex3+TWdXFatYrWiu46dgdkwYGDQwj59kpMzKA/5aS7UULQMQUMaEMn/tWd
         aUgcvOnedkScAhDMFxvjJjgB55eA2U/MIaIYAaD4XPlIEBTEFrWotFNQMuH556/ycFqZ
         mqLDliLYjTg0zDuUCuR6+eJz3BJLuhbwQamMmN4S69BG4EB5XHPilarZV+sZPsde6RUk
         6A3A==
X-Gm-Message-State: AOAM530fZTbALtt6Fqwbt4TjWh/EuZxqPK6Ekx6Y0hQgwulSnRgWc6zZ
        urr68JB/vtB3rDqvdcBY7K/Pdy5rgNds1JSJ5n1lCZvEcIl0DIwuNGYuR8QXIcApYxDLgwYUh58
        MtU95TUQMMDiHcg1KreZ0
X-Received: by 2002:a65:5a49:: with SMTP id z9mr35465036pgs.121.1629796362067;
        Tue, 24 Aug 2021 02:12:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxiGkqhF+dbZ54de0kiPqI04s0281rPWvqo7p576QDzNK5GYig1FmD7f7PQf6KVfgMXpcDzzg==
X-Received: by 2002:a65:5a49:: with SMTP id z9mr35465006pgs.121.1629796361583;
        Tue, 24 Aug 2021 02:12:41 -0700 (PDT)
Received: from fedora ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id 10sm2036190pjc.41.2021.08.24.02.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 02:12:41 -0700 (PDT)
Date:   Tue, 24 Aug 2021 17:33:28 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests@vger.kernel.org
Subject: Re: [RFC PATCH] generic: regression test for a FALLOC_FL_UNSHARE bug
 in XFS
Message-ID: <20210824093328.qnpwkp36y4ggah7g@fedora>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, fstests@vger.kernel.org
References: <20210824003739.GC12640@magnolia>
 <20210824003835.GD12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824003835.GD12640@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 23, 2021 at 05:38:35PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for "xfs: only set IOMAP_F_SHARED when
> providing a srcmap to a write".
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/generic/729     |   73 +++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/729.out |    2 +
>  2 files changed, 75 insertions(+)
>  create mode 100755 tests/generic/729
>  create mode 100644 tests/generic/729.out
> 
> diff --git a/tests/generic/729 b/tests/generic/729
> new file mode 100755
> index 00000000..269aed65
> --- /dev/null
> +++ b/tests/generic/729
> @@ -0,0 +1,73 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 729
> +#
> +# This is a regression test for "xfs: only set IOMAP_F_SHARED when providing a
> +# srcmap to a write".  If a user creates a sparse shared region in a file,
> +# convinces XFS to create a copy-on-write delayed allocation reservation
> +# spanning both the shared blocks and the holes, and then calls the fallocate
> +# unshare command to unshare the entire sparse region, XFS incorrectly tells
> +# iomap that the delalloc blocks for the holes are shared, which causes it to
> +# error out while trying to unshare a hole.
> +#
> +. ./common/preamble
> +_begin_fstest auto clone unshare
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -r -f $tmp.* $TEST_DIR/$seq
> +}
> +
> +# Import common functions.
> +. ./common/reflink
> +. ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs generic
> +_require_cp_reflink
> +_require_test_reflink
> +_require_test_program "punch-alternating"
> +_require_xfs_io_command "fpunch"

I didn't find "fpunch" in this case, but find "cowextsize". Did I
miss something?

Others looks good to me.
Reviewed-by: Zorro Lang <zlang@redhat.com>

cc fstests@vger.kernel.org, due to it's a patch to xfstests.

Thanks,
Zorro

> +_require_xfs_io_command "funshare"
> +
> +mkdir $TEST_DIR/$seq
> +file1=$TEST_DIR/$seq/a
> +file2=$TEST_DIR/$seq/b
> +
> +$XFS_IO_PROG -f -c "pwrite -S 0x58 -b 10m 0 10m" $file1 >> $seqres.full
> +
> +f1sum0="$(md5sum $file1 | _filter_test_dir)"
> +
> +_cp_reflink $file1 $file2
> +$here/src/punch-alternating -o 1 $file2
> +
> +f2sum0="$(md5sum $file2 | _filter_test_dir)"
> +
> +# set cowextsize to the defaults (128k) to force delalloc cow preallocations
> +test "$FSTYP" = "xfs" && $XFS_IO_PROG -c 'cowextsize 0' $file2
> +$XFS_IO_PROG -c "funshare 0 10m" $file2
> +
> +f1sum1="$(md5sum $file1 | _filter_test_dir)"
> +f2sum1="$(md5sum $file2 | _filter_test_dir)"
> +
> +test "${f1sum0}" = "${f1sum1}" || echo "file1 should not have changed"
> +test "${f2sum0}" = "${f2sum1}" || echo "file2 should not have changed"
> +
> +_test_cycle_mount
> +
> +f1sum2="$(md5sum $file1 | _filter_test_dir)"
> +f2sum2="$(md5sum $file2 | _filter_test_dir)"
> +
> +test "${f1sum2}" = "${f1sum1}" || echo "file1 should not have changed ondisk"
> +test "${f2sum2}" = "${f2sum1}" || echo "file2 should not have changed ondisk"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/generic/729.out b/tests/generic/729.out
> new file mode 100644
> index 00000000..0f175ae2
> --- /dev/null
> +++ b/tests/generic/729.out
> @@ -0,0 +1,2 @@
> +QA output created by 729
> +Silence is golden
> 

