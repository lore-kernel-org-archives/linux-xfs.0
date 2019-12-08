Return-Path: <SRS0=TLwU=Z6=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9FC1C2D0BE
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Dec 2019 15:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA36C206D5
	for <linux-xfs@archiver.kernel.org>; Sun,  8 Dec 2019 15:44:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J1d4wwoi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbfLHPoA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Dec 2019 10:44:00 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37971 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbfLHPn7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Dec 2019 10:43:59 -0500
Received: by mail-pj1-f66.google.com with SMTP id l4so4749583pjt.5;
        Sun, 08 Dec 2019 07:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1ZP1cV3txDUP/apjZ4IZ8RoJyVPo9yJFc21qQU7sGQs=;
        b=J1d4wwoixZcqpZOnz4Zam1Pzy8UfEBQIBiCBIbWoyG+AppL0cVAWQIBtkkzdJA0d5J
         p3DqGumb8kpBnifR1571AzKGaljundYEMcaSsuSi2WaUW3HsWsbMSeETAVjdt/vZK42S
         0QxlNQMUX0aSes8HFm4WcUrNE+TtTk/kOy0qhIQ58UeGQqUmcFkV8rJn0jq+Fadj1wid
         XWxO0RkOt9aIckY2h4OpeTsOZXdpkg4li9WwHHtKkAh1SiZe8f4A9IwKF08dVDEtaxCK
         RpLM0Vujna9ZKarjjlcAGlOX4iBjHMV/uGzFZlNZPK+TUWjVv3Y/C7lXYCytpkPQMVos
         WI3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1ZP1cV3txDUP/apjZ4IZ8RoJyVPo9yJFc21qQU7sGQs=;
        b=sSiWAVh+Z++AcJZCgXeAUy0GWnoSTBh3y3KxalaDZ+o4tjNkkUP2CGtpjm9egQR7LZ
         SlR1fT1bR0lVeze0GRcoIzTKqH3Qkh2MaTkcwhR557RrDBQphQ8a5ZmGt08VRK+i41y5
         iiPuOlU710H2+BlpcyjXhZrdMEHNaCLK02iyEj9vX2OJeKgAAUP0YpzkyDV/XTlKAeNk
         j01NQ2WTb1CcbzpZhp78gZlMAw8bHLnOhqylWQEZDk6w6AP1FF7d1cmOYYvy8JYVkk1Q
         DOgVn8yNFO1l81EdzXY1Ym4zK50eDItsMlSG8BWFzZRONioW6aMIRM1tq1443ndksvBY
         kJmw==
X-Gm-Message-State: APjAAAVJvWykbjdp86WFVq9S1DV4FxgvcZGSohJVCRw2X73i075zn64k
        PdShhpJCvY6KUwHUsOrsidY=
X-Google-Smtp-Source: APXvYqyjVFpph7/24EuaCkLtlSkCRXfV12RopfUIZwS2NC7cgP+3sapHWD+hq/qUV4UzYntz/oF2Dw==
X-Received: by 2002:a17:902:6a8a:: with SMTP id n10mr25391320plk.146.1575819838806;
        Sun, 08 Dec 2019 07:43:58 -0800 (PST)
Received: from localhost ([178.128.102.47])
        by smtp.gmail.com with ESMTPSA id g10sm21828933pgh.35.2019.12.08.07.43.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Dec 2019 07:43:58 -0800 (PST)
Date:   Sun, 8 Dec 2019 23:43:53 +0800
From:   Eryu Guan <guaneryu@gmail.com>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     fstests@vger.kernel.org, kernel-team@fb.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v3] generic: test truncating mixed written/unwritten XFS
 realtime extent
Message-ID: <20191208154350.GL8664@desktop>
References: <110dbf3ff8c8004e4eecef2cc2e84dfe2d3ddd9f.1575416911.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <110dbf3ff8c8004e4eecef2cc2e84dfe2d3ddd9f.1575416911.git.osandov@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Dec 03, 2019 at 03:51:52PM -0800, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> 
> The only XFS-specific part of this test is the setup, so we can make the
> rest a generic test. It's slow, though, as it needs to write 8GB to
> convert a big unwritten extent to written.
> 
> Signed-off-by: Omar Sandoval <osandov@fb.com>
> ---
> Changes from v2 -> v3:
> 
> - Use _create_loop_device and _destroy_loop_device instead of losetup
> 
> Changes from v1 -> v2:
> 
> - If rtdev is not configured, fall back to loop device on test
>   filesystem
> - Use XFS_IO_PROG instead of fallocate/sync/dd
> - Use truncate instead of rm
> - Add comments explaining the steps
> 
>  tests/generic/589     | 100 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/589.out |   2 +
>  tests/generic/group   |   1 +
>  3 files changed, 103 insertions(+)
>  create mode 100755 tests/generic/589
>  create mode 100644 tests/generic/589.out
> 
> diff --git a/tests/generic/589 b/tests/generic/589
> new file mode 100755
> index 00000000..aab37bb4
> --- /dev/null
> +++ b/tests/generic/589
> @@ -0,0 +1,100 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2019 Facebook.  All Rights Reserved.
> +#
> +# FS QA Test 589
> +#
> +# Test "xfs: fix realtime file data space leak" and "xfs: don't check for AG
> +# deadlock for realtime files in bunmapi". On XFS without the fix, truncate
> +# will hang forever. On other filesystems, this just tests writing into big
> +# fallocates.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	test -n "$loop" && _destroy_loop_device "$loop"
> +	rm -f "$TEST_DIR/$seq"
> +}
> +
> +. ./common/rc
> +. ./common/filter
> +
> +rm -f $seqres.full
> +
> +_supported_fs generic
> +_supported_os Linux
> +_require_scratch_nocheck
> +
> +maxextlen=$((0x1fffff))
> +bs=4096
> +rextsize=4
> +filesz=$(((maxextlen + 1) * bs))
> +
> +extra_options=""
> +# If we're testing XFS, set up the realtime device to reproduce the bug.
> +if [[ $FSTYP = xfs ]]; then
> +	# If we don't have a realtime device, set up a loop device on the test
> +	# filesystem.
> +	if [[ $USE_EXTERNAL != yes || -z $SCRATCH_RTDEV ]]; then
> +		_require_test
> +		loopsz="$((filesz + (1 << 26)))"
> +		_require_fs_space "$TEST_DIR" $((loopsz / 1024))
> +		$XFS_IO_PROG -c "truncate $loopsz" -f "$TEST_DIR/$seq"
> +		loop="$(_create_loop_device "$TEST_DIR/$seq")"
> +		USE_EXTERNAL=yes
> +		SCRATCH_RTDEV="$loop"
> +	fi
> +	extra_options="$extra_options -bsize=$bs"
> +	extra_options="$extra_options -r extsize=$((bs * rextsize))"
> +	extra_options="$extra_options -d agsize=$(((maxextlen + 1) * bs / 2)),rtinherit=1"

reflink is enabled by default since xfsprogs v5.1.0, and this causes
_scratch_mkfs to fail as "reflink not supported with realtime devices",
so I added a check here

	if _scratch_mkfs_xfs_supported -m reflink=0 >/dev/null 2>&1; then
		extra_options="$extra_options -m reflink=0"
	fi

Thanks,
Eryu

> +_scratch_mount
> +_require_fs_space "$SCRATCH_MNT" $((filesz / 1024))
> +
> +# Allocate maxextlen + 1 blocks. As long as the allocator does something sane,
> +# we should end up with two extents that look something like:
> +#
> +# u3.bmx[0-1] = [startoff,startblock,blockcount,extentflag]
> +# 0:[0,0,2097148,1]
> +# 1:[2097148,2097148,4,1]
> +#
> +# Extent 0 has blockcount = ALIGN_DOWN(maxextlen, rextsize). Extent 1 is
> +# adjacent and has blockcount = rextsize. Both are unwritten.
> +$XFS_IO_PROG -c "falloc 0 $filesz" -c fsync -f "$SCRATCH_MNT/file"
> +
> +# Write extent 0 + one block of extent 1. Our extents should end up like so:
> +#
> +# u3.bmx[0-1] = [startoff,startblock,blockcount,extentflag]
> +# 0:[0,0,2097149,0]
> +# 1:[2097149,2097149,3,1]
> +#
> +# Extent 0 is written and has blockcount = ALIGN_DOWN(maxextlen, rextsize) + 1,
> +# Extent 1 is adjacent, unwritten, and has blockcount = rextsize - 1 and
> +# startblock % rextsize = 1.
> +#
> +# The -b is just to speed things up (doing GBs of I/O in 4k chunks kind of
> +# sucks).
> +$XFS_IO_PROG -c "pwrite -b 1M -W 0 $(((maxextlen + 2 - rextsize) * bs))" \
> +	"$SCRATCH_MNT/file" >> "$seqres.full"
> +
> +# Truncate the extents.
> +$XFS_IO_PROG -c "truncate 0" -c fsync "$SCRATCH_MNT/file"
> +
> +# We need to do this before the loop device gets torn down.
> +_scratch_unmount
> +_check_scratch_fs
> +
> +echo "Silence is golden"
> +status=0
> +exit
> diff --git a/tests/generic/589.out b/tests/generic/589.out
> new file mode 100644
> index 00000000..5ab6ab10
> --- /dev/null
> +++ b/tests/generic/589.out
> @@ -0,0 +1,2 @@
> +QA output created by 589
> +Silence is golden
> diff --git a/tests/generic/group b/tests/generic/group
> index 87d7441c..be6f4a43 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -591,3 +591,4 @@
>  586 auto quick rw prealloc
>  587 auto quick rw prealloc
>  588 auto quick log clone
> +589 auto prealloc preallocrw dangerous
> -- 
> 2.24.0
> 
