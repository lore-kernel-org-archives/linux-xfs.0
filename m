Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 449DEC433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Oct 2022 01:01:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiJSBBF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Oct 2022 21:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiJSBBE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 21:01:04 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51993DD8A8
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 18:01:01 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so15555803pjl.3
        for <linux-xfs@vger.kernel.org>; Tue, 18 Oct 2022 18:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s7QJ7SdlsIG1U13jT8OAN5pEED7jDCpLLPiz3DCJKqk=;
        b=qjvnzNXY6W+Mej/487jyIftiyeLhJUpfuTokOtL87e2QNZUD97H5fSh2Iur4E+OhaL
         2QQLNvisGIhnPI5pIEpiuCWg0SOIY0bGBF3wLpmR3FluSMQX5gdMLXCRve20X0KOQFuS
         6SDEm/D1eHVc3LxD+e9GSU029hlXZNEIa6Da5fImucwWL3oWES0teYtBUlypQWVa3oYo
         brE9i3ICX0+LE3Jgofckaea/1VbHL1oAXqxLGVV0qecy6FnnGaHFGTm4e7RsebXjuOjT
         gW5scrbD8s5Sq8rTtH8zCB3aNOLB758JOFlq8Cy9jq5xjktqmyDHnVMrjyT1avnRuUTx
         fb+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s7QJ7SdlsIG1U13jT8OAN5pEED7jDCpLLPiz3DCJKqk=;
        b=d0jz8SSHt2MF17dSDl6I6mjJGLSW+820h0PgBEyrJTmgPNe3Msdk2p3TNNBckS3ajL
         EvNZpktaUPusE8276GYxZFTVSX/6pRtVFRQv7MXfiO1tON6k5ftBI/75I6MZo57EswTg
         JeL7WbEYAMsSA/g4VhTy3jp5k0/JdUVPQp8yUMtNpnzgOfS5pyFPXYZ1mBxvk1YucjG7
         d7bx3328E9V7bpZMSmynUurGShXD4+IHBHX9HyDT+OttyIQbN4jB/wFam8kszrM4ozDL
         6/zKcxF3QaNUrpC3D7N4UVZdSlwa/OiJg5cnEyZdQi3ZImwMFVEBVygh3anw2mpbsEpT
         QWJQ==
X-Gm-Message-State: ACrzQf3JuIbX1cx+onxAhXeK/52kmUUbtS4B4Xrtwx3F5PgRmexzaCTH
        DKTcy4VRmCL06bxV5Fv3qY5+8g==
X-Google-Smtp-Source: AMsMyM7fXjNREYwAdjO1eddTVHVL7WPAyHB/W7aHQgd5zLYP20IFTcNJPex3CtX876BDO5C1XZaNhg==
X-Received: by 2002:a17:902:8542:b0:179:eb8d:f41d with SMTP id d2-20020a170902854200b00179eb8df41dmr5564546plo.62.1666141260730;
        Tue, 18 Oct 2022 18:01:00 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-106-210.pa.nsw.optusnet.com.au. [49.181.106.210])
        by smtp.gmail.com with ESMTPSA id 6-20020a170902c10600b001728ac8af94sm9288883pli.248.2022.10.18.18.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Oct 2022 18:00:59 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1okxS4-003fUC-Tj; Wed, 19 Oct 2022 12:00:56 +1100
Date:   Wed, 19 Oct 2022 12:00:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Wu Guanghao <wuguanghao3@huawei.com>, cem@kernel.org,
        linux-xfs@vger.kernel.org,
        "liuzhiqiang (I)" <liuzhiqiang26@huawei.com>
Subject: Re: [PATCH] mkfs: acquire flock before modifying the device
 superblock
Message-ID: <20221019010056.GU3600936@dread.disaster.area>
References: <b359751c-2397-bcd1-9065-583afb2f93ef@huawei.com>
 <Y0mCauklwsDwImi8@magnolia>
 <663ca1f7-01f4-14f4-242c-2e4b9038f7e2@huawei.com>
 <Y08V8lCfrKFRFYTH@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y08V8lCfrKFRFYTH@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Oct 18, 2022 at 02:09:06PM -0700, Darrick J. Wong wrote:
> On Tue, Oct 18, 2022 at 10:45:54AM +0800, Wu Guanghao wrote:
> > 
> > 
> > 在 2022/10/14 23:38, Darrick J. Wong 写道:
> > > On Fri, Oct 14, 2022 at 04:41:35PM +0800, Wu Guanghao wrote:
> > >> We noticed that systemd has an issue about symlink unreliable caused by
> > >> formatting filesystem and systemd operating on same device.
> > >> Issue Link: https://github.com/systemd/systemd/issues/23746
> > >>
> > >> According to systemd doc, a BSD flock needs to be acquired before
> > >> formatting the device.
> > >> Related Link: https://systemd.io/BLOCK_DEVICE_LOCKING/
> > > 
> > > TLDR: udevd wants fs utilities to use advisory file locking to
> > > coordinate (re)writes to block devices to avoid collisions between mkfs
> > > and all the udev magic.
> > > 
> > > Critically, udev calls flock(LOCK_SH | LOCK_NB) to trylock the device in
> > > shared mode to avoid blocking on fs utilities; if the trylock fails,
> > > they'll move on and try again later.  The old O_EXCL-on-blockdevs trick
> > > will not work for that usecase (I guess) because it's not a shared
> > > reader lock.  It's also not the file locking API.
> > > 
> > >> So we acquire flock after opening the device but before
> > >> writing superblock.
> > > 
> > > xfs_db and xfs_repair can write to the filesystem too; shouldn't this
> > > locking apply to them as well?
> > > 
> > xfs_db is an interactive operation.If a lock is added, the lock may be held
> > for too long.
> 
> xfs_db can also write to the filesystem; see -x mode.
> 
> But first -- let's zoom out here.  You're adding flock() calls to
> xfsprogs to coordinate two userspace programs udev and mkfs.xfs.  Why
> wouldn't you add the same flock()ing to the rest of the xfs utilities so
> that they also don't step on each other?
> 
> xfs_mdrestore can also write an XFS image to a block device, so what
> makes it special?
> 
> > xfs_repair only repairs the data inside the file system ,so it's
> > unlikely to conflict with systemd. So these two commands aren't locked.
> 
> "Unlikely" isn't good enough -- xfsprogs don't control the udev rules,
> which means that a program invoked by a udev rule could read just about
> anywhere in the block device.  Hence we need to prevent udev from
> getting confused about /any/ block that xfs_repair might write.
> 
> (You /do/ know that xfs_db and xfs_repair can rewrite the primary
> superblock, right?)

I'm kinda in agreement with Darrick here - we have multiple tools
that can create a new filesystem image on a block device, or modify
an existing filesystem image.

mkfs.xfs, xfs_mdrestore, and xfs_copy can all write new filesystem
images to block devices. Hence if mkfs.xfs needs protection, so do
these other utilities.

xfs_repair, xfs_db, xfs_growfs, etc all modify the filesystem in
ways that udev rules might want to know about - changes to superblock
features, fs geometry, filesystem size, etc - can all come about as
a result of running them.

> > There is still a problem with this solution, systemd only lock the main
> > block device, not the partition device. So if we're operating on a
> > partitioned device, the lock won't work. Currently we are still
> > communicating with systemd.
> 
> Er... well, I guess it's good to know that xfs isn't /completely/ behind
> the curve here.

Well, it does seem kinda arbitrary - this is the first I've heard of
such bdev access rules being introduced.

It also doesn't seem well thought out or executed - userspace
infrastructure makes up a rule for accessing block devices, the rule
doesn't work on common configurations, the rule isn't communicated
or discussed with projects that it directly affects, there's no
obvious plan for hwo to support unsupported configs, nobody really
knows what utilities should obey the rule, etc.

We know we have problems with race conditions caused by udev probing
block devices and eacing with mkfs, mount, unmount, etc causing
exclusive opens to randomly fail (we still see people proposing
"sleep 2" after an unmount to fix spurious "failed" filesystem tests
every so often). So if there's a rule that says "lock the block
device to avoid udev probing races", then why wouldn't we want to
make all the tools we have "play nice" by being able to detect and
avoid udev related race conditions rather than have to work around
spurious failures that result from udev probing races?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
