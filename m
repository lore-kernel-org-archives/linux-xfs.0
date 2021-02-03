Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41184C433E9
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 16:12:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B5C264F7E
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 16:12:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbhBCQMT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 11:12:19 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60055 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234998AbhBCQL7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Feb 2021 11:11:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612368628;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ebM+kaJkVi7oCeKz5nfZNXY8/YSqXwyT3hFRROZuDo0=;
        b=LrqWUX7FlF27LlcEw3YYDMA81T/HWeZYF8PgkXIgIe7z7uy89Vq6gEicr3Zzpbd9G3WgFL
        EneboSh+sDs4TTM4tN+eb5dN++XQZ8e3JTd/imCU1U9EM/0/rZr5EwJX04Hz77uFbPeom8
        NEdlAwkmI6BN62DDkzXJ4DfbyYs0SnQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-329-DwJLoFefNJq1o4DsvPPrqQ-1; Wed, 03 Feb 2021 11:10:27 -0500
X-MC-Unique: DwJLoFefNJq1o4DsvPPrqQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEC0D1015C91;
        Wed,  3 Feb 2021 16:10:25 +0000 (UTC)
Received: from bfoster (ovpn-114-23.rdu2.redhat.com [10.10.114.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2AC6D544F3;
        Wed,  3 Feb 2021 16:10:25 +0000 (UTC)
Date:   Wed, 3 Feb 2021 11:10:23 -0500
From:   Brian Foster <bfoster@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Chandan Babu R <chandanrlinux@gmail.com>
Subject: Re: [PATCH] xfs: test a regression in dquot type checking
Message-ID: <20210203161023.GE3647012@bfoster>
References: <20210202194158.GR7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210202194158.GR7193@magnolia>
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

Reviewed-by: Brian Foster <bfoster@redhat.com>

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

