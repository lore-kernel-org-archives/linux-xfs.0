Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A45FC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Apr 2022 10:38:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236826AbiDLKka (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Apr 2022 06:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381735AbiDLKfY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Apr 2022 06:35:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 69FAB5F8C4
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 02:37:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649756255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WjvePjoNps3WHzPA3kQ/inZHgSIM6RNRmnAXcju2jgw=;
        b=SBAYV+Xdmbq2OCMFjotFkKEw1U83osdD/dv67kApmsWayVtPzJbVi/P1h9lOjjjSCIIuN6
        xV6ZhSZcfndJmFtpraJDgQY1I/OWpgeP2XU3gKrUo6jxZ/ACNBk9krTSd++JlNrmq3+q1/
        wo/b74K4u7YawmqExHqQv/GnLdqwTeI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-9WFCbR0tM3SNpnX10X53qQ-1; Tue, 12 Apr 2022 05:37:34 -0400
X-MC-Unique: 9WFCbR0tM3SNpnX10X53qQ-1
Received: by mail-qk1-f197.google.com with SMTP id bj2-20020a05620a190200b005084968bb24so9247426qkb.23
        for <linux-xfs@vger.kernel.org>; Tue, 12 Apr 2022 02:37:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=WjvePjoNps3WHzPA3kQ/inZHgSIM6RNRmnAXcju2jgw=;
        b=NXIbaiPsiihrgdzkF669RK0XStyqsZqHPDL028NW226wawuPemrYI6+bJmiuMS1lPW
         bQ334abDW8HXGXI7cVve+6YNbqKvfJAWzhv4uveO5zBaS0yq7/xglE0WzBUiRE/7yn/v
         3INUCUs0fJ8VjXj6FWPsmkkSQbH2VeSIfpEuyXFrvs6TA6m0XmzIdeYJINj9Fz7Ca475
         3wJ9tCrBzoDuWEClWFQxA6TcOqSfi37kiXxjP7XCqcXFBuRN20nF+4ji4ycY/09LzcJY
         zGBt5qFAe53/WFAYa5D4KAiyPuOlC7Q3Nfy+pbJxbkzpOZRDEpYVu3hOLbXcnQMapd2e
         WQRw==
X-Gm-Message-State: AOAM53097AULxSd5mrZM4AFhVujDYRdKklLkorEumZQN1RRkJP2Chbx5
        Jpv6we1N0pl5m5I+iPLqVMGxJWEdR5ROuSiEvWt32UX4mhVfT1by88yROqYmdCdn0Gy5h2cq/RQ
        MKgsGMsSNP2hbPby1SV09
X-Received: by 2002:ac8:5851:0:b0:2e1:eba3:3beb with SMTP id h17-20020ac85851000000b002e1eba33bebmr2579258qth.20.1649756254072;
        Tue, 12 Apr 2022 02:37:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJztKnQnu54fHqq+eZ3MNLUHFlQ75PMDmAL3rOlhuBTNSu19FBVt9D4f2wcMra63IISZpXN2nw==
X-Received: by 2002:ac8:5851:0:b0:2e1:eba3:3beb with SMTP id h17-20020ac85851000000b002e1eba33bebmr2579249qth.20.1649756253701;
        Tue, 12 Apr 2022 02:37:33 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id c13-20020a37e10d000000b0069c268c37f1sm2999524qkm.23.2022.04.12.02.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 02:37:32 -0700 (PDT)
Date:   Tue, 12 Apr 2022 17:37:27 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: make sure syncfs(2) passes back
 super_operations.sync_fs errors
Message-ID: <20220412093727.5zsuh7mucv2wlwgm@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971767699.169983.772317637668809854.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164971767699.169983.772317637668809854.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Apr 11, 2022 at 03:54:37PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> This is a regression test to make sure that nonzero error returns from
> a filesystem's ->sync_fs implementation are actually passed back to
> userspace when the call stack involves syncfs(2).
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tests/xfs/839     |   42 ++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/839.out |    2 ++
>  2 files changed, 44 insertions(+)
>  create mode 100755 tests/xfs/839
>  create mode 100644 tests/xfs/839.out
> 
> 
> diff --git a/tests/xfs/839 b/tests/xfs/839

This case looks good to me. Just one question, is it possible to be a generic
case? From the code logic, it doesn't use xfs specified operations, but I'm
not sure if other filesystems would like to treat sync_fs return value as XFS.

> new file mode 100755
> index 00000000..9bfe93ef
> --- /dev/null
> +++ b/tests/xfs/839
> @@ -0,0 +1,42 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +#
> +# FS QA Test No. 839
> +#
> +# Regression test for kernel commits:
> +#
> +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
> +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")

BTW, after this change, now can I assume that sync(2) flushes all data and metadata
to underlying disk, if it returns 0. Sorry, really confused on what these sync things
really guarantee :)

Thanks,
Zorro

> +#
> +# During a code inspection, I noticed that sync_filesystem ignores the return
> +# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
> +# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
> +# that syncfs(2) does not capture internal filesystem errors that are neither
> +# visible from the block device (e.g. media error) nor recorded in s_wb_err.
> +# XFS historically returned 0 from ->sync_fs even if there were log failures,
> +# so that had to be corrected as well.
> +#
> +# The kernel commits above fix this problem, so this test tries to trigger the
> +# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
> +# hope that the EIO generated as a result of the filesystem being shut down is
> +# only visible via ->sync_fs.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick shutdown
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_require_xfs_io_command syncfs
> +_require_scratch_nocheck
> +_require_scratch_shutdown
> +
> +# Reuse the fs formatted when we checked for the shutdown ioctl, and don't
> +# bother checking the filesystem afterwards since we never wrote anything.
> +_scratch_mount
> +$XFS_IO_PROG -x -c 'shutdown -f ' -c syncfs $SCRATCH_MNT
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/xfs/839.out b/tests/xfs/839.out
> new file mode 100644
> index 00000000..f275cdcc
> --- /dev/null
> +++ b/tests/xfs/839.out
> @@ -0,0 +1,2 @@
> +QA output created by 839
> +syncfs: Input/output error
> 

