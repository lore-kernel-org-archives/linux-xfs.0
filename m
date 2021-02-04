Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F33C433E0
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 03:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F85764F60
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Feb 2021 03:59:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbhBDD7m (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 22:59:42 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41531 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232416AbhBDD7R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 22:59:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612411070;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oLw0Lty5d4Bodp4IRRyK/Zr9hr/X1fJaBUV6Q2GkbMI=;
        b=c/GEvcmwcN2JulvSfm6+JmWZiFUkELTqLjSQGvzhKFz7F/giD1MuCQPh/4OYv62ls1E3a6
        O0MSmi3YzIOUbX3y9z9VzbzedO1qLqnGJCw4nYVz5tssNbLQW6m7z9cC8CZ9cQNAMKwmva
        Hh3w3GIJdVpxw/0u/LzrKrYCC5/G9G4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-crDDSKR8PDuy9tcHeEfvdQ-1; Wed, 03 Feb 2021 22:57:48 -0500
X-MC-Unique: crDDSKR8PDuy9tcHeEfvdQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 80C908030B1;
        Thu,  4 Feb 2021 03:57:47 +0000 (UTC)
Received: from localhost (unknown [10.66.61.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0218D5B695;
        Thu,  4 Feb 2021 03:57:46 +0000 (UTC)
Date:   Thu, 4 Feb 2021 12:14:55 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
Subject: Re: [PATCH] xfs: test a regression in dquot type checking
Message-ID: <20210204041455.GF14354@localhost.localdomain>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
References: <20210202194158.GR7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202194158.GR7193@magnolia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Feb 02, 2021 at 11:41:58AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test for incorrect ondisk dquot type checking that
> was introduced in Linux 5.9.  The bug is that we can no longer switch a
> V4 filesystem from having group quotas to having project quotas (or vice
> versa) without logging corruption errors.  That is a valid use case, so
> add a regression test to ensure this can be done.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/766     |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/766.out |    5 ++++
>  tests/xfs/group   |    1 +
>  3 files changed, 69 insertions(+)
>  create mode 100755 tests/xfs/766
>  create mode 100644 tests/xfs/766.out
> 
> diff --git a/tests/xfs/766 b/tests/xfs/766
> new file mode 100755
> index 00000000..55bc03af
> --- /dev/null
> +++ b/tests/xfs/766
> @@ -0,0 +1,63 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0-or-later
> +# Copyright (c) 2021 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 766
> +#
> +# Regression test for incorrect validation of ondisk dquot type flags when
> +# we're switching between group and project quotas while mounting a V4
> +# filesystem.  This test doesn't actually force the creation of a V4 fs because
> +# even V5 filesystems ought to be able to switch between the two without
> +# triggering corruption errors.
> +#
> +# The appropriate XFS patch is:
> +# xfs: fix incorrect root dquot corruption error when switching group/project
> +# quota types
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
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/quota
> +
> +# real QA test starts here
> +_supported_fs xfs
> +_require_xfs_debug
> +_require_quota
> +_require_scratch
> +
> +rm -f $seqres.full
> +
> +echo "Format filesystem" | tee -a $seqres.full
> +_scratch_mkfs > $seqres.full
> +
> +echo "Mount with project quota" | tee -a $seqres.full
> +_qmount_option 'prjquota'
> +_qmount
> +_require_prjquota $SCRATCH_DEV
> +
> +echo "Mount with group quota" | tee -a $seqres.full
> +_qmount_option 'grpquota'
> +_qmount
> +$here/src/feature -G $SCRATCH_DEV || echo "group quota didn't mount?"
> +
> +echo "Check dmesg for corruption"
> +_check_dmesg_for corruption && \
> +	echo "should not have seen corruption messages"

Is this dmesg output need XFS_DEBUG? Or need XFS_WARN at least?

> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/766.out b/tests/xfs/766.out
> new file mode 100644
> index 00000000..18bd99f0
> --- /dev/null
> +++ b/tests/xfs/766.out
> @@ -0,0 +1,5 @@
> +QA output created by 766
> +Format filesystem
> +Mount with project quota
> +Mount with group quota
> +Check dmesg for corruption
> diff --git a/tests/xfs/group b/tests/xfs/group
> index fb78b0d7..cdca04b5 100644
> --- a/tests/xfs/group
> +++ b/tests/xfs/group
> @@ -545,6 +545,7 @@
>  763 auto quick rw realtime
>  764 auto quick repair
>  765 auto quick quota
> +766 auto quick quota
>  908 auto quick bigtime
>  909 auto quick bigtime quota
>  910 auto quick inobtcount
> 

