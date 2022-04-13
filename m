Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483E4C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Apr 2022 17:56:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234912AbiDMR7A (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Apr 2022 13:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234149AbiDMR67 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Apr 2022 13:58:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E31A568300
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 10:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649872595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J6GEJ15mSukq/QKFETshzTgLJN1QsdHySvSu59mh3rw=;
        b=Eu7z873Mq/y4OfXX61hFkXSP5FFZyIYtEgYh4z2a/oQr4n6vtQFvVa1hr/pBCQlf+SrRt5
        UwvTAQ7JxcxkLEcFsdIEeOski5Ae3H1TebEwser4gaW7qW0bAsL3u5LIOgtQvJVf1q98ym
        YIZZZDJ8XgC3SiUex4EgJ77VWN+AxvQ=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-eNXnryNdMkSJjIuG7auC0g-1; Wed, 13 Apr 2022 13:56:31 -0400
X-MC-Unique: eNXnryNdMkSJjIuG7auC0g-1
Received: by mail-qv1-f71.google.com with SMTP id t12-20020a0cea2c000000b004443d7585f0so2326781qvp.19
        for <linux-xfs@vger.kernel.org>; Wed, 13 Apr 2022 10:56:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=J6GEJ15mSukq/QKFETshzTgLJN1QsdHySvSu59mh3rw=;
        b=n4WP2bE/L9vHqEf32igyydq47Nm91oN7+lHZO7zLlqrbNF36+LY9sbQDd0ixbF8Pcn
         IaRNmlVYD+QNo9T3YI8ajeC5VYUxZYK8remq1ImTgA8haNU3zKmOWWgp4ceHWwrdwAQf
         osr+lnxlQpnuIFS4WURFjuZzuDCgjQ5JRqsIdTLw2x1yf6GDf+rh9TwFCOfRJ3EcgYlS
         AloT2EvUPl+OXD/tNljo3knW75PnVqQRRJC9oCtizt1yUA4MBNtDTY2Bbxyk1ktCNN55
         bE+adbzFR031qviShf7ysXeNfqIcvPhyEqAKxqa1JsyNhQ0DiZ/Nxo5B0z4Y2dnEi8He
         5YBQ==
X-Gm-Message-State: AOAM530rYefGxP25aqSqbJJ3XTDx/7SWga8sRFcmwvIdf6ndf2OZQ22q
        AqcdM/3nLfymqkv347Vj6FSAvbCfi8C36QeOopYKieQ/wvjeDWWVpQpbAhJrinjGloZ2yTPpEmM
        pkkCCfxcJADriIKTeeWCr
X-Received: by 2002:a05:6214:4016:b0:446:1677:7913 with SMTP id kd22-20020a056214401600b0044616777913mr3267350qvb.56.1649872590712;
        Wed, 13 Apr 2022 10:56:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw3/flYx5mq4UQ81YOgoIrVlnM/fEIVExFAsM7nxYwJIqECn8WzhE5vnjid6pv4brFtpq307w==
X-Received: by 2002:a05:6214:4016:b0:446:1677:7913 with SMTP id kd22-20020a056214401600b0044616777913mr3267335qvb.56.1649872590461;
        Wed, 13 Apr 2022 10:56:30 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h5-20020ac85845000000b002edfd4b0503sm8509338qth.88.2022.04.13.10.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 10:56:29 -0700 (PDT)
Date:   Thu, 14 Apr 2022 01:56:23 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] xfs: test mkfs.xfs config file stack corruption
 issues
Message-ID: <20220413175623.imxaab7hqpiw723g@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164971769710.170109.8985299417765876269.stgit@magnolia>
 <164971770833.170109.18299545219088346786.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164971770833.170109.18299545219088346786.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 11, 2022 at 03:55:08PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Add a new regression test for a stack corruption problem uncovered in
> the mkfs config file parsing code.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  tests/xfs/831     |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/831.out |    2 ++
>  2 files changed, 70 insertions(+)
>  create mode 100755 tests/xfs/831
>  create mode 100644 tests/xfs/831.out
> 
> 
> diff --git a/tests/xfs/831 b/tests/xfs/831
> new file mode 100755
> index 00000000..a73f14ff
> --- /dev/null
> +++ b/tests/xfs/831
> @@ -0,0 +1,68 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test 831
> +#
> +# Regression test for xfsprogs commit:
> +#
> +# 99c78777 ("mkfs: prevent corruption of passed-in suboption string values")
> +#
> +. ./common/preamble
> +_begin_fstest auto quick mkfs
> +
> +_cleanup()
> +{
> +	rm -f $TEST_DIR/fubar.img
> +	cd /
> +	rm -r -f $tmp.*
> +}
> +
> +# Import common functions.
> +# . ./common/filter
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs xfs
> +_require_test
> +_require_xfs_mkfs_cfgfile
> +
> +# Set up a configuration file with an exact block size and log stripe unit
> +# so that mkfs won't complain about having to correct the log stripe unit
> +# size that is implied by the provided data device stripe unit.
> +cfgfile=$tmp.cfg
> +cat << EOF >> $tmp.cfg
> +[block]
> +size=4096
> +
> +[data]
> +su=2097152
> +sw=1
> +EOF
> +
> +# Some mkfs options store the user's value string for processing after certain
> +# geometry parameters (e.g. the fs block size) have been settled.  This is how
> +# the su= option can accept arguments such as "8b" to mean eight filesystem
> +# blocks.
> +#
> +# Unfortunately, on Ubuntu 20.04, the libini parser uses an onstack char[]
> +# array to store value that it parse, and it passes the address of this array
> +# to the parse_cfgopt.  The getstr function returns its argument, which is
> +# stored in the cli_params structure by the D_SU parsing code.  By the time we
> +# get around to interpreting this string, of course, the stack array has long
> +# since lost scope and is now full of garbage.  If we're lucky, the value will
> +# cause a number interpretation failure.  If not, the fs is configured with
> +# garbage geometry.
> +#
> +# Either way, set up a config file to exploit this vulnerability so that we
> +# can prove that current mkfs works correctly.
> +$XFS_IO_PROG -f -c "truncate 1g" $TEST_DIR/fubar.img
> +options=(-c options=$cfgfile -l sunit=8 -f -N $TEST_DIR/fubar.img)
> +$MKFS_XFS_PROG "${options[@]}" >> $seqres.full ||
> +	echo "mkfs failed"
> +
> +# success, all done
> +echo Silence is golden
> +status=0
> +exit
> diff --git a/tests/xfs/831.out b/tests/xfs/831.out
> new file mode 100644
> index 00000000..abe137e3
> --- /dev/null
> +++ b/tests/xfs/831.out
> @@ -0,0 +1,2 @@
> +QA output created by 831
> +Silence is golden
> 

