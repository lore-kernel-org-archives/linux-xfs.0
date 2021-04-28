Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C78AC43461
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D871B61441
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Apr 2021 17:39:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbhD1RkM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:40:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:53062 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242594AbhD1RjT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Apr 2021 13:39:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619631513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rQOZN7IxjSHlv0oOnrka40qKI0FY8ICE6KaNY+o3iY0=;
        b=SzrI4WRxixN2z5yPzurHs0eHLxkVyYfJ66JTT08RXbZ4IOWrXLmngvPYKLfhjfXodpR23d
        6+tmcsd+iNlYqndW/v12kUqISi5bJH1TL7cNc6xvhxrsAoQ+XnJ6QrTcuTEOCtKx7/YVgZ
        rzls1ute4ez/dFaz+N99Q3yALmanrEU=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-209-b6kNB2O-McWW0cOeNmtuxg-1; Wed, 28 Apr 2021 13:38:31 -0400
X-MC-Unique: b6kNB2O-McWW0cOeNmtuxg-1
Received: by mail-qv1-f72.google.com with SMTP id s13-20020a0cdc0d0000b02901bbc03198caso6269239qvk.22
        for <linux-xfs@vger.kernel.org>; Wed, 28 Apr 2021 10:38:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rQOZN7IxjSHlv0oOnrka40qKI0FY8ICE6KaNY+o3iY0=;
        b=EjMG3W7mguEQlniBZP+jzSRCJ6qYsJmtwO61aBU96X0DVy2gb9qM1oLQBhpqz/41G5
         K4+qoRgZMOZ1YS0XHX4Jv/Y8nMxckr85N/85sm7/jCS6CqNCDdgvBUQ/ESQIgpAx5cOX
         9dbOm62Xlr3HPuwzY5Pgahvk1ktg05Wo8cwyAdGTvCgrWcAFsFITCJolAFd3Mu2tc8Yp
         9/f3Cxvj/E9VQfm49VZe+jXjuGvZitW67pHNYe1AfaQz4tbFwpJceHTVWFCfWbEosl88
         P7BCuqj2/XCYUZr483BbHU+XSBst/2yvSieu/m3ibAj+ALQW3EdSy3O5W5pDm47WUVQe
         yIYQ==
X-Gm-Message-State: AOAM533SWRCr3FEGxwHE6GGQV5ZsIEyn5Ej6U75WKn2PlETpI0vDXnGu
        OvXnR3r8CXrXXryEN6TiOBGmsajnRAXTlqy5wyRyw5AZOZ8Q8SVNUAu5eoZYEFBRTv5cPYiWxII
        GuBC6kj9uxNmrsdIbx5Jt
X-Received: by 2002:ac8:6b05:: with SMTP id w5mr15035423qts.204.1619631511109;
        Wed, 28 Apr 2021 10:38:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwf/gvo0Tj3PnvBCvo9l1LOCAkqfJcbUQU0I6jOrFPeF8yX2IhIeUfDy/39NEuArTZP0BpPxA==
X-Received: by 2002:ac8:6b05:: with SMTP id w5mr15035397qts.204.1619631510766;
        Wed, 28 Apr 2021 10:38:30 -0700 (PDT)
Received: from bfoster ([98.216.211.229])
        by smtp.gmail.com with ESMTPSA id n18sm472335qtv.87.2021.04.28.10.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 10:38:30 -0700 (PDT)
Date:   Wed, 28 Apr 2021 13:38:27 -0400
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCH 1/2] xfs: test what happens when we reset the root dir
 and it has xattrs
Message-ID: <YImdkx6ofgQ1t8CD@bfoster>
References: <161958291787.3452247.15296911612919535588.stgit@magnolia>
 <161958292387.3452247.4459342156885074164.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161958292387.3452247.4459342156885074164.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 27, 2021 at 09:08:43PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Make sure that we can reset the root directory and the xattrs are erased
> properly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/757     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/757.out |    7 ++++++
>  tests/xfs/group   |    1 +
>  3 files changed, 71 insertions(+)
>  create mode 100755 tests/xfs/757
>  create mode 100644 tests/xfs/757.out
> 
> 
> diff --git a/tests/xfs/757 b/tests/xfs/757
> new file mode 100755
> index 00000000..0b9914f6
> --- /dev/null
> +++ b/tests/xfs/757
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 757
> +#
> +# Make sure that attrs are handled properly when repair has to reset the root
> +# directory.
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 7 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -rf $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/populate
> +. ./common/fuzzy
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_scratch_nocheck
> +
> +rm -f $seqres.full
> +
> +echo "Format and populate btree attr root dir"
> +_scratch_mkfs > "$seqres.full" 2>&1
> +_scratch_mount
> +
> +blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
> +__populate_create_attr "${SCRATCH_MNT}" "$((64 * blksz / 40))" true
> +_scratch_unmount
> +
> +echo "Break the root directory"
> +_scratch_xfs_fuzz_metadata_field core.mode zeroes 'sb 0' 'addr rootino' >> $seqres.full 2>&1
> +
> +echo "Detect bad root directory"
> +_scratch_xfs_repair -n >> $seqres.full 2>&1 && \
> +	echo "Should have detected bad root dir"
> +
> +echo "Fix bad root directory"
> +_scratch_xfs_repair >> $seqres.full 2>&1
> +
> +echo "Detect fixed root directory"
> +_scratch_xfs_repair -n >> $seqres.full 2>&1
> +
> +echo "Mount test"
> +_scratch_mount
> +

Is the regression test here that attrs are erased after this sequence
(as suggested in the commit log), or that the fs mounts, or both? I'm
basically just wondering if we should also dump the xattrs on the root
dir as a last step (and expect NULL output)..? That aside:

Reviewed-by: Brian Foster <bfoster@redhat.com>

> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/757.out b/tests/xfs/757.out
> new file mode 100644
> index 00000000..9f3aed5a
> --- /dev/null
> +++ b/tests/xfs/757.out
> @@ -0,0 +1,7 @@
> +QA output created by 757
> +Format and populate btree attr root dir
> +Break the root directory
> +Detect bad root directory
> +Fix bad root directory
> +Detect fixed root directory
> +Mount test
> diff --git a/tests/xfs/group b/tests/xfs/group
> index 731f869c..76e31167 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -528,5 +528,6 @@
>  537 auto quick
>  538 auto stress
>  539 auto quick mount
> +757 auto quick attr repair
>  908 auto quick bigtime
>  909 auto quick bigtime quota
> 

