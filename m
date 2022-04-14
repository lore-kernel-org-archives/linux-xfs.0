Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C977C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 14 Apr 2022 18:59:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344844AbiDNTBf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 14 Apr 2022 15:01:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345003AbiDNTBc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Apr 2022 15:01:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6CB4B186E9
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 11:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649962746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UkFyUxq95y4SEhEsvmmLMqPpqawmZDmzIVoyvb0a+us=;
        b=LSScNRgnmgioyesxHsmh1aefdh8mpl2C4sGZKkj6DquAN5jz6EA+jWvtyNWAL+aUkk3P8D
        ICychHKn4ivlrKDNVB+Fe0YZWuPH28fIM8iC4t2IDr3M+ohgMaG2y2b600+nvQJbn5EHD7
        sxuDfq3+ei09SYV0hEdrUyZUYIp0s1c=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-487-dDXmwNSlMZKRzFSUtdVeJw-1; Thu, 14 Apr 2022 14:59:02 -0400
X-MC-Unique: dDXmwNSlMZKRzFSUtdVeJw-1
Received: by mail-qk1-f199.google.com with SMTP id v14-20020a05620a0f0e00b00699f4ea852cso3890946qkl.9
        for <linux-xfs@vger.kernel.org>; Thu, 14 Apr 2022 11:59:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=UkFyUxq95y4SEhEsvmmLMqPpqawmZDmzIVoyvb0a+us=;
        b=fCofHjd6z5WfqOgMTvw2HpvH4F952dd+7vDtAIq74kZ5nVlRddzv64pkPVPmAdmPLu
         0tlvA5q9zZlgB4BOQdp/LeTDENEXc7V+ti6LDhSYon6CK1W4jbIEdg2acEPzwEZgwZ3Y
         g2Q5FRGAtwOCWAkUP+9FNV4B8R2FH/70LA+vU/0UovqHWEo9p3A+/Mw+Mj7DED8qbUbv
         v/y/ghUk9TzLjT9v1gd8HiKIfnBknhub9GDyu89JEI2hGhsjPjkyqQfFkhxcWF5jeVWw
         mp9flNccUQw5IhSwfejuQR7tFQw4n2hTGjoU0YgIJanvbKYpFF8fprFpcjiYRs1Hzbfc
         jhxQ==
X-Gm-Message-State: AOAM532Y8bFF+M2EMQO3ecj3FIq2ePKyo5z/33wJlQhL7zLyIekPArJL
        MMZcBDotx5azDLjZj3QY+9JNaDsxJ/bV1FaE2DGMh37C/5DSWSa4cuqvJOPYVgi7HSNaCeuL67A
        SsNPWd4WR4SAWkf0sYTYE
X-Received: by 2002:a05:620a:2586:b0:680:f846:4708 with SMTP id x6-20020a05620a258600b00680f8464708mr2918710qko.654.1649962741940;
        Thu, 14 Apr 2022 11:59:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxN5SMFyODng6rxtnOaiWayK84axAp0iGdo9vFUMd/ObEkbgU9mtkQvZOJJaFZnjIRFM/zVxw==
X-Received: by 2002:a05:620a:2586:b0:680:f846:4708 with SMTP id x6-20020a05620a258600b00680f8464708mr2918695qko.654.1649962741630;
        Thu, 14 Apr 2022 11:59:01 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d15-20020a05622a15cf00b002ef31d86837sm1662284qty.55.2022.04.14.11.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 11:59:01 -0700 (PDT)
Date:   Fri, 15 Apr 2022 02:58:56 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/4] xfs: make sure syncfs(2) passes back
 super_operations.sync_fs errors
Message-ID: <20220414185856.nmtg4xyh5atx7cp5@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164971767143.169983.12905331894414458027.stgit@magnolia>
 <164971767699.169983.772317637668809854.stgit@magnolia>
 <20220412093727.5zsuh7mucv2wlwgm@zlang-mailbox>
 <20220412172853.GG16799@magnolia>
 <20220414144330.yby7dsxzqeawekmc@zlang-mailbox>
 <20220414154234.GB17014@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220414154234.GB17014@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Apr 14, 2022 at 08:42:34AM -0700, Darrick J. Wong wrote:
> On Thu, Apr 14, 2022 at 10:43:30PM +0800, Zorro Lang wrote:
> > On Tue, Apr 12, 2022 at 10:28:53AM -0700, Darrick J. Wong wrote:
> > > On Tue, Apr 12, 2022 at 05:37:27PM +0800, Zorro Lang wrote:
> > > > On Mon, Apr 11, 2022 at 03:54:37PM -0700, Darrick J. Wong wrote:
> > > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > > 
> > > > > This is a regression test to make sure that nonzero error returns from
> > > > > a filesystem's ->sync_fs implementation are actually passed back to
> > > > > userspace when the call stack involves syncfs(2).
> > > > > 
> > > > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > > > ---
> > > > >  tests/xfs/839     |   42 ++++++++++++++++++++++++++++++++++++++++++
> > > > >  tests/xfs/839.out |    2 ++
> > > > >  2 files changed, 44 insertions(+)
> > > > >  create mode 100755 tests/xfs/839
> > > > >  create mode 100644 tests/xfs/839.out
> > > > > 
> > > > > 
> > > > > diff --git a/tests/xfs/839 b/tests/xfs/839
> > > > 
> > > > This case looks good to me. Just one question, is it possible to be a generic
> > > > case? From the code logic, it doesn't use xfs specified operations, but I'm
> > > > not sure if other filesystems would like to treat sync_fs return value as XFS.
> > > 
> > > Other filesystems (ext4 in particular) haven't been fixed to make
> > > ->sync_fs return error codes when the fs has been shut down via
> > > FS_IOC_SHUTDOWN.  We'll get there eventually, but for now I'd like to
> > > get this under test for XFS since we've applied those fixes.
> > 
> > If other filesystems intend to do that, how about using a generic case failure to
> > remind them they haven't done that :) If they don't intend that, keep this case
> > under xfs is good to me.
> 
> <shrug> I don't know if they do or not; I've been so strapped for time
> trying to get all these fixes out that I haven't had time to ask the
> ext4 or btrfs communities, let alone propose patches.
> 
> At the moment I'd really like to get as many patches out of djwong-dev
> as I can without people asking for more side projects.  As it stands
> today, landing the online fsck patchset is going to involve getting 185
> kernel patches, 95 xfsprogs patches, and 87 fstests patches all through
> review.

Sure, this case can be a xfs specified case at first. We'll see if need to
change it to be generic case later.

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> --D
> 
> > > 
> > > > > new file mode 100755
> > > > > index 00000000..9bfe93ef
> > > > > --- /dev/null
> > > > > +++ b/tests/xfs/839
> > > > > @@ -0,0 +1,42 @@
> > > > > +#! /bin/bash
> > > > > +# SPDX-License-Identifier: GPL-2.0
> > > > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > > > +#
> > > > > +# FS QA Test No. 839
> > > > > +#
> > > > > +# Regression test for kernel commits:
> > > > > +#
> > > > > +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
> > > > > +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> > > > 
> > > > BTW, after this change, now can I assume that sync(2) flushes all data and metadata
> > > > to underlying disk, if it returns 0.
> > > 
> > > Yes.
> > > 
> > > > Sorry, really confused on what these sync things
> > > > really guarantee :)
> > > 
> > > No worries -- the history of the sync variants has been very messy and
> > > confusing even to people on fsdevel.
> > > 
> > > --D
> > > 
> > > > 
> > > > Thanks,
> > > > Zorro
> > > > 
> > > > > +#
> > > > > +# During a code inspection, I noticed that sync_filesystem ignores the return
> > > > > +# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
> > > > > +# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
> > > > > +# that syncfs(2) does not capture internal filesystem errors that are neither
> > > > > +# visible from the block device (e.g. media error) nor recorded in s_wb_err.
> > > > > +# XFS historically returned 0 from ->sync_fs even if there were log failures,
> > > > > +# so that had to be corrected as well.
> > > > > +#
> > > > > +# The kernel commits above fix this problem, so this test tries to trigger the
> > > > > +# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
> > > > > +# hope that the EIO generated as a result of the filesystem being shut down is
> > > > > +# only visible via ->sync_fs.
> > > > > +#
> > > > > +. ./common/preamble
> > > > > +_begin_fstest auto quick shutdown
> > > > > +
> > > > > +# real QA test starts here
> > > > > +
> > > > > +# Modify as appropriate.
> > > > > +_require_xfs_io_command syncfs
> > > > > +_require_scratch_nocheck
> > > > > +_require_scratch_shutdown
> > > > > +
> > > > > +# Reuse the fs formatted when we checked for the shutdown ioctl, and don't
> > > > > +# bother checking the filesystem afterwards since we never wrote anything.
> > > > > +_scratch_mount
> > > > > +$XFS_IO_PROG -x -c 'shutdown -f ' -c syncfs $SCRATCH_MNT
> > > > > +
> > > > > +# success, all done
> > > > > +status=0
> > > > > +exit
> > > > > diff --git a/tests/xfs/839.out b/tests/xfs/839.out
> > > > > new file mode 100644
> > > > > index 00000000..f275cdcc
> > > > > --- /dev/null
> > > > > +++ b/tests/xfs/839.out
> > > > > @@ -0,0 +1,2 @@
> > > > > +QA output created by 839
> > > > > +syncfs: Input/output error
> > > > > 
> > > > 
> > > 
> > 
> 

