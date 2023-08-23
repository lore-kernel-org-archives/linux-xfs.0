Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765A5C27C40
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Aug 2023 22:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238210AbjHWWqw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 18:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238757AbjHWWqv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Aug 2023 18:46:51 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10A50E6A
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 15:46:48 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6bc9254a1baso4541977a34.2
        for <linux-xfs@vger.kernel.org>; Wed, 23 Aug 2023 15:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1692830807; x=1693435607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jhqGLJGZpAuyw/dy5G264cXJRmrVIOcCB68txOwuLjs=;
        b=C646+LzJH6rqyF0NoqLsvftIxQ7ZIDcNeTDebXaluPkrABVeRU9QO71OUp5TW5LONK
         RODHISwMAUFq0F8wJWY6dY+t5IPTvtuf1tVGOs34HPH0HIfQGeLWYDDW1pSduPKsfqRn
         9xipXctegvVYySjFNgqWUvgLLFSYarSuizfahA+fqrG/NF0NzxoTFdbU+FPUdhd45AhP
         3Vyny1DWO5vrrILHYk2brQzm0IZDN3iBaA+qvfu6j9E0ua8yHX/eI4MuWZhwCmlBEt/v
         vAELDkMTLHAQx9T5C6YGuJKTOak4DTJiE52NIngRU+g1aK2ncBkfWUagrMZzPrR7WIR6
         D0gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692830807; x=1693435607;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jhqGLJGZpAuyw/dy5G264cXJRmrVIOcCB68txOwuLjs=;
        b=dquNmiXak8pFmXw4Rbqi5T+wFeimUs0BU6BY6syNQCD8SJUxtKsVSgoceQOp7oI2Ra
         2WnMxQSm5j/YM/I9EJlhG+l2d45hmYdshzAo903ySzd5D14CTr6+nqyGGNRp4lrF3ngy
         0QLx8S7RuVIDPvF7tHMnJUnc9IIYzLNMN6rrtURODN2imYl4QYV1VQ13ouAtxP8IyHO1
         AJopAger6Yxf9UxcI0p4rJy70XYXdJbV+Y52QDfL8XU0rkKuahwCO+phuSP7KzJVe6SJ
         q3AfZ1r66qP4ToCIdaFA88ohOBHuhcx9N1lg9JB4p9AfP0tls7B5GGwP3QVYCwPFWAQ7
         EUyA==
X-Gm-Message-State: AOJu0YyeXyL9+vgB+H97zlwA2WKEJi+zlSQA+YqOSvzR9FitPFqCQNru
        HNujjEL8wgGm0NGAwljcLiFjDg==
X-Google-Smtp-Source: AGHT+IF0qKY4UKPkiwbNESoELXJAWZbTxYOWHRYQGFCeM+X4ofQuTRQT+j0tS73TVhb0Ve1fAsVIKQ==
X-Received: by 2002:a05:6358:3983:b0:13a:d269:bd23 with SMTP id b3-20020a056358398300b0013ad269bd23mr17378998rwe.16.1692830807220;
        Wed, 23 Aug 2023 15:46:47 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id t17-20020a63a611000000b0056129129ef8sm10049538pge.18.2023.08.23.15.46.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 15:46:46 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qYwce-005dby-04;
        Thu, 24 Aug 2023 08:46:44 +1000
Date:   Thu, 24 Aug 2023 08:46:44 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: read only mounts with fsopen mount API are busted
Message-ID: <ZOaMVBGFLQ83Mrpc@dread.disaster.area>
References: <20230823220225.3591135-1-david@fromorbit.com>
 <20230823221808.GF11263@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230823221808.GF11263@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Aug 23, 2023 at 03:18:08PM -0700, Darrick J. Wong wrote:
> On Thu, Aug 24, 2023 at 08:02:25AM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Recently xfs/513 started failing on my test machines testing "-o
> > ro,norecovery" mount options. This was being emitted in dmesg:
> > 
> > [ 9906.932724] XFS (pmem0): no-recovery mounts must be read-only.
> > 
> > Turns out, readonly mounts with the fsopen()/fsconfig() mount API
> > have been busted since day zero. It's only taken 5 years for debian
> > unstable to start using this "new" mount API, and shortly after this
> > I noticed xfs/513 had started to fail as per above.
> > 
> > The syscall trace is:
> > 
> > fsopen("xfs", FSOPEN_CLOEXEC)           = 3
> > mount_setattr(-1, NULL, 0, NULL, 0)     = -1 EINVAL (Invalid argument)
> > .....
> > fsconfig(3, FSCONFIG_SET_STRING, "source", "/dev/pmem0", 0) = 0
> > fsconfig(3, FSCONFIG_SET_FLAG, "ro", NULL, 0) = 0
> > fsconfig(3, FSCONFIG_SET_FLAG, "norecovery", NULL, 0) = 0
> > fsconfig(3, FSCONFIG_CMD_CREATE, NULL, NULL, 0) = -1 EINVAL (Invalid argument)
> > close(3)                                = 0
> > 
> > Showing that the actual mount instantiation (FSCONFIG_CMD_CREATE) is
> > what threw out the error.
> > 
> > During mount instantiation, we call xfs_fs_validate_params() which
> > does:
> > 
> >         /* No recovery flag requires a read-only mount */
> >         if (xfs_has_norecovery(mp) && !xfs_is_readonly(mp)) {
> >                 xfs_warn(mp, "no-recovery mounts must be read-only.");
> >                 return -EINVAL;
> >         }
> > 
> > and xfs_is_readonly() checks internal mount flags for read only
> > state. This state is set in xfs_init_fs_context() from the
> > context superblock flag state:
> > 
> >         /*
> >          * Copy binary VFS mount flags we are interested in.
> >          */
> >         if (fc->sb_flags & SB_RDONLY)
> >                 set_bit(XFS_OPSTATE_READONLY, &mp->m_opstate);
> > 
> > With the old mount API, all of the VFS specific superblock flags
> > had already been parsed and set before xfs_init_fs_context() is
> > called, so this all works fine.
> > 
> > However, in the brave new fsopen/fsconfig world,
> > xfs_init_fs_context() is called from fsopen() context, before any
> > VFS superblock have been set or parsed. Hence if we use fsopen(),
> > the internal XFS readonly state is *never set*. Hence anything that
> > depends on xfs_is_readonly() actually returning true for read only
> > mounts is broken if fsopen() has been used to mount the filesystem.
> > 
> > Fix this by moving this internal state initialisation to
> > xfs_fs_fill_super() before we attempt to validate the parameters
> > that have been set prior to the FSCONFIG_CMD_CREATE call being made.
> > 
> > Signed-off-by: Dave Chinner <dchinner@redhat.com>
> 
> Huh.  Wow.  I would have expected to find /anything/ in fstests that
> exercises the new mount api, but:
> 
> lax:~/cdev/work/fstests(0)> git grep -E '(fsconfig|fspick|fsopen)'
> lax:~/cdev/work/fstests(1)>
> 
> What other weird things are lurking here?

For everyone not on #xfs on oftc, here's a summary of the last day
or so since I discovered the above problem.

New xfs/270 failures with the fsconfig/fsopen mount API tell us that
unknown RO-compat bit mounts have also been completely broken since
~2018.

xfs/270 has been shutting down with superblock corruption after
mounting with an unknown RO-compat bit since 2018, but the attempt
to remount rw detects the unknown RO-compat bit before the code
checks for a shutdown situation, and hence the test passes even on a
shut down filesystem. Hence the test passes, and nobody has noticed
that the RO feature compat functionality is completely broken....

Which then lead us to the fact we are using RO-compat bits for
reflink and rmapbt, which introduce new log items and so actually
have log incompat feature bit requirements. RO-compat bits
don't cover recovery of unknown log features, just prevent new
modifications of the filesystem post-mount. So allowing log recovery
when RO-compat feature bits are set is also broken because we
screwed up reflink/rmapbt feature bit definitions, and that's
effective zero-day bugs for those features.

And, well, we modelled the XFS RO-compat functionality on the ext4
feature bit behaviour, so.....

> Anyhow, I guess that's a side effect of xfs_mount mirroring some of the
> vfs state flags, so....

Yup. But I don't see a way to easily avoid that...

> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks!

-Dave.
-- 
Dave Chinner
david@fromorbit.com
