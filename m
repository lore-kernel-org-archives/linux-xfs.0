Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CFAC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 15:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245141AbiDNPsu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 11:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242764AbiDNOz2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 10:55:28 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 63B93DEB95
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 07:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649947418;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QuJiJFITGoHkwzMAJZMGJPEcNOBJ93d2xdHTYzi4rIU=;
        b=XDUAH7Hp52kQR05ZzdtD/1jt20EdI5AnlSL+TOo0Oe2104RNMW9O1c6e2Mwa7H1Y8invo+
        0kxkTajNNZqz07xg/jLrHX/xBDME7GCNwQzEfQh0I8gMz0JutgfsA4SB7yEwrKv6Jm9l7z
        IFcQf6BuThI9AzLNulx6jH83O7+UiQM=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-S1SJ6NqEMJyy9ZW0IzjhCA-1; Thu, 14 Apr 2022 10:43:37 -0400
X-MC-Unique: S1SJ6NqEMJyy9ZW0IzjhCA-1
Received: by mail-qv1-f70.google.com with SMTP id e10-20020a0562140d8a00b00443c3595342so4555654qve.8
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 07:43:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=QuJiJFITGoHkwzMAJZMGJPEcNOBJ93d2xdHTYzi4rIU=;
        b=w3solRBU4DxFcbf1XbcC3GU+/v77Uh9Kqc7OipfI7cHbj0Lm2fOwZMZeX0K8d3dykH
         ybqzubTkZg4dOYFfxvgpHo+qlmt5VKmkNLLqUufiWqmA33UeF74IDl9kUGpM7F9iZQQX
         0srtQ2D9NVvjrRPTL6SHzD9QTFVLi1Ji1H87QwvPaBeF8IKtioQMwLCFINLCHW4MT5YH
         6HhSr2UO4zoagReZ9VmFUg94TWbCkaJOySag/j1gAsUUHIXAipW0PimRk3c4DiWp2mjj
         ax2ve6hzLE0Syf7kfUKzSKmtEB/1GsybUDMPad+aETRPVb379r2ocL/WjoMvqFrzNQHg
         Qzvw==
X-Gm-Message-State: AOAM532+qYhoCe7hJhkAXj8xMHrFx3Z11Gf6TOgVpvKEejWSBcOLXiUU
        j2PC8ET8wMGhxmbd1em9iUGSXBXDJ4/nvKYvJwNV221PiuU9pAA8zLWOPc8fbS+57gCVvh1bLlz
        kDi+TcjMVRGKdRyJ5sdUE
X-Received: by 2002:a05:6214:19c8:b0:444:32f0:2351 with SMTP id j8-20020a05621419c800b0044432f02351mr13031397qvc.109.1649947416554;
        Thu, 14 Apr 2022 07:43:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzubj5M+q00GpcegJK6T6HMs+CwCb40vr8nPHINMAqqQZbUICFGJLMTBaK0moSHYgLDR4/qFg==
X-Received: by 2002:a05:6214:19c8:b0:444:32f0:2351 with SMTP id j8-20020a05621419c800b0044432f02351mr13031377qvc.109.1649947416257;
        Thu, 14 Apr 2022 07:43:36 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id o14-20020a05622a138e00b002e1e78c899fsm1219575qtk.53.2022.04.14.07.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 07:43:35 -0700 (PDT)
Date:   Thu, 14 Apr 2022 22:43:30 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: make sure syncfs(2) passes back
 super_operations.sync_fs errors
Message-ID: <20220414144330.yby7dsxzqeawekmc@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971767699.169983.772317637668809854.stgit@magnolia>
 <20220412093727.5zsuh7mucv2wlwgm@zlang-mailbox>
 <20220412172853.GG16799@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412172853.GG16799@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 12, 2022 at 10:28:53AM -0700, Darrick J. Wong wrote:
> On Tue, Apr 12, 2022 at 05:37:27PM +0800, Zorro Lang wrote:
> > On Mon, Apr 11, 2022 at 03:54:37PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > This is a regression test to make sure that nonzero error returns from
> > > a filesystem's ->sync_fs implementation are actually passed back to
> > > userspace when the call stack involves syncfs(2).
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/xfs/839     |   42 ++++++++++++++++++++++++++++++++++++++++++
> > >  tests/xfs/839.out |    2 ++
> > >  2 files changed, 44 insertions(+)
> > >  create mode 100755 tests/xfs/839
> > >  create mode 100644 tests/xfs/839.out
> > > 
> > > 
> > > diff --git a/tests/xfs/839 b/tests/xfs/839
> > 
> > This case looks good to me. Just one question, is it possible to be a generic
> > case? From the code logic, it doesn't use xfs specified operations, but I'm
> > not sure if other filesystems would like to treat sync_fs return value as XFS.
> 
> Other filesystems (ext4 in particular) haven't been fixed to make
> ->sync_fs return error codes when the fs has been shut down via
> FS_IOC_SHUTDOWN.  We'll get there eventually, but for now I'd like to
> get this under test for XFS since we've applied those fixes.

If other filesystems intend to do that, how about using a generic case failure to
remind them they haven't done that :) If they don't intend that, keep this case
under xfs is good to me.

> 
> > > new file mode 100755
> > > index 00000000..9bfe93ef
> > > --- /dev/null
> > > +++ b/tests/xfs/839
> > > @@ -0,0 +1,42 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test No. 839
> > > +#
> > > +# Regression test for kernel commits:
> > > +#
> > > +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
> > > +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> > 
> > BTW, after this change, now can I assume that sync(2) flushes all data and metadata
> > to underlying disk, if it returns 0.
> 
> Yes.
> 
> > Sorry, really confused on what these sync things
> > really guarantee :)
> 
> No worries -- the history of the sync variants has been very messy and
> confusing even to people on fsdevel.
> 
> --D
> 
> > 
> > Thanks,
> > Zorro
> > 
> > > +#
> > > +# During a code inspection, I noticed that sync_filesystem ignores the return
> > > +# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
> > > +# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
> > > +# that syncfs(2) does not capture internal filesystem errors that are neither
> > > +# visible from the block device (e.g. media error) nor recorded in s_wb_err.
> > > +# XFS historically returned 0 from ->sync_fs even if there were log failures,
> > > +# so that had to be corrected as well.
> > > +#
> > > +# The kernel commits above fix this problem, so this test tries to trigger the
> > > +# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
> > > +# hope that the EIO generated as a result of the filesystem being shut down is
> > > +# only visible via ->sync_fs.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto quick shutdown
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> > > +_require_xfs_io_command syncfs
> > > +_require_scratch_nocheck
> > > +_require_scratch_shutdown
> > > +
> > > +# Reuse the fs formatted when we checked for the shutdown ioctl, and don't
> > > +# bother checking the filesystem afterwards since we never wrote anything.
> > > +_scratch_mount
> > > +$XFS_IO_PROG -x -c 'shutdown -f ' -c syncfs $SCRATCH_MNT
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/xfs/839.out b/tests/xfs/839.out
> > > new file mode 100644
> > > index 00000000..f275cdcc
> > > --- /dev/null
> > > +++ b/tests/xfs/839.out
> > > @@ -0,0 +1,2 @@
> > > +QA output created by 839
> > > +syncfs: Input/output error
> > > 
> > 
> 

