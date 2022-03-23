Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7064DC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Mar 2022 02:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241392AbiCWCqO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 22 Mar 2022 22:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241387AbiCWCqN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 22 Mar 2022 22:46:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C70370851
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 19:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648003483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iqZJTiI3Axj6oVewHbRkIIjJ5aF5iBnJmE5907yPAVc=;
        b=Y8dRgIDgAsBhWXvxodMMvujY077a600VpK9xknr+FtiyueE/zIgM0ayWTCmtO3rcef99qm
        v3HwD8RgdIzlyWrosv2BWljrKnhhS06TGoqXZYXAfVYYBERvRTJsGzYaXFzrEn/T6QO4eC
        tsxxu3xFApqMW0WzGpQ2axo7k74+Q6U=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-90-e2dWYi89NY-_lZzR8IyWCA-1; Tue, 22 Mar 2022 22:44:39 -0400
X-MC-Unique: e2dWYi89NY-_lZzR8IyWCA-1
Received: by mail-qt1-f197.google.com with SMTP id k11-20020ac8604b000000b002e1a4109edeso181114qtm.15
        for <linux-xfs@vger.kernel.org>; Tue, 22 Mar 2022 19:44:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=iqZJTiI3Axj6oVewHbRkIIjJ5aF5iBnJmE5907yPAVc=;
        b=L6RgUo8WSL5LLYiyHCs7iLAy4NntiHRQ7/SzdM/ADsaWo7XFnbqZv78D9leygxW8Pq
         oO7pNfsoszSaHeRUpM2yv1JzUjZT2KF1kxcZFR4qPtBVzrCho/MdwTSbfhuFinKErC1n
         Sw9Mz8rISRcZPvDPV9wf6P8ZfqbuhMEcpVB9lib6r7gZD3n1WRFvLJh2FBtXI4HLSPMt
         ErDbFPVJD3fmoM76rS/0hG+8vqV/R0vTxbq5+mJ4u1oWAjYaODx/piA2hQw4fFGLEuj4
         4l2grk39BvTmqV09tTRi8cKyfbmV7MDLDG1glU9ezDQ+fFXr2r4ytMWqYjwhWHoJInvP
         qisQ==
X-Gm-Message-State: AOAM531w5GsBwWCcTlWQ7GANIxTI5vkG9EoQnpNSfhqI+BNcMEPA68Mh
        s/tck3NfAJHEeGw7MRX5j2+Sfkrgp9xjsGQMxz+YtiLEzY598bIXf12zBvAxSgHeG0U1gta6EoV
        61SEsOinTtLor1eWdD7b6
X-Received: by 2002:a37:9fca:0:b0:67e:5b65:8031 with SMTP id i193-20020a379fca000000b0067e5b658031mr12790652qke.168.1648003479352;
        Tue, 22 Mar 2022 19:44:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyHcICZGirl5M3aoPOGEaZiiXCpjLSKyxtk4rktLVG9tkMm18HlEpj+QHcPEb0NPHD9KopUWQ==
X-Received: by 2002:a37:9fca:0:b0:67e:5b65:8031 with SMTP id i193-20020a379fca000000b0067e5b658031mr12790641qke.168.1648003479030;
        Tue, 22 Mar 2022 19:44:39 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id h8-20020ac87d48000000b002e1c6faae9csm15167579qtb.28.2022.03.22.19.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 19:44:38 -0700 (PDT)
Date:   Wed, 23 Mar 2022 10:44:32 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: make sure syncfs(2) passes back
 super_operations.sync_fs errors
Message-ID: <20220323024432.44wf2xhpv3z55txp@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164740142940.3371809.12686819717405148022.stgit@magnolia>
 <164740143497.3371809.2959237196772812909.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164740143497.3371809.2959237196772812909.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Mar 15, 2022 at 08:30:35PM -0700, Darrick J. Wong wrote:
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

Can this case be a generic case, with the help of _require_scratch_shutdown
and _require_xfs_io_command?

Thanks,
Zorro

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

