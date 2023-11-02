Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59803C41535
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Nov 2023 20:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbjKBUtD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Nov 2023 16:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjKBUtC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Nov 2023 16:49:02 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817B918B
        for <linux-xfs@vger.kernel.org>; Thu,  2 Nov 2023 13:48:59 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1cc29f39e7aso11079975ad.0
        for <linux-xfs@vger.kernel.org>; Thu, 02 Nov 2023 13:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1698958139; x=1699562939; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nPlOQs4H3ojv1i5CDb/ZZoP+yLZogQLFBQAjO2TQLUE=;
        b=o/YCnKX1u8C0Z+1hwL705zfGU4AeLkcMPv+pp+POddh4meeWltMnDnMAEWpxpA2mOK
         YLMq2cFxCe9cIt66Xbc9XIEwenryooypNsCE8tJuGcqinNPuoVSPHUeMyQRa7B/5PVGE
         q6ICS2eZL4KeUTFXc6AWjWGySGmGMXmyrvtQ3mgY9snUKu8qzZFDId4UBoB8DREkQqW0
         6V24HKn9rHg8r2ElkKHWNex6RbAC65qZLRYGm42jQx3dVNIuIcZSiDhOPs9wF8XcICy9
         xwXeyQq2sYUV471MMMc+DfKL17R6qKnhcZ6C6o1cMiLos8RWu+t5noZjQtIBQZVOmsZb
         XfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698958139; x=1699562939;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nPlOQs4H3ojv1i5CDb/ZZoP+yLZogQLFBQAjO2TQLUE=;
        b=iiXYPybh7abSwGkCkmw3MvFDnUX26nCLG1+rA3V7CniW9a0ilY0rztbQim+f/AEwG1
         gGwI9w7jZwQFQY/Qlhzs91BTP9SLXUTYPSYmv/wvGeUadK+Q6so6DYlbL1XV6Cj1dHTS
         Nvk9DccBxUCVYyX+TsFWACrBx29QrGobsxIrcdscpDoniijlupNtMPgla7+sCPxColHK
         vFWSJeaxsjeIQYGzfUpCGq2ObePm4FtxP8R3cvCAEWnrHv9+KzNCu0cj39DIqOFLS7pc
         ju74V/aWg+cfBKtbe6q/zcPttQLYVHl2c6SYIsFFADVXC0Cf45Umps2G8a17blhL7qht
         YReg==
X-Gm-Message-State: AOJu0Yw5rc8mnS6CcnxscdFlNStk4/k6drFykWYKxt7cIEVBDkoEQc8I
        h9u06fMVMOXkM+q9DvpBDA2b/w==
X-Google-Smtp-Source: AGHT+IE4Ajg7Dp58olVWG7i7o6t8cg/BphJAwnryFXtyTOEQ2IJedsUYfu/uVRiRP1oFGswlizAu3w==
X-Received: by 2002:a17:903:32c3:b0:1cc:453f:517b with SMTP id i3-20020a17090332c300b001cc453f517bmr13717854plr.0.1698958138903;
        Thu, 02 Nov 2023 13:48:58 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id f19-20020a170902e99300b001c61afa7009sm136641plb.114.2023.11.02.13.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 13:48:58 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qyecZ-007Nln-0P;
        Fri, 03 Nov 2023 07:48:55 +1100
Date:   Fri, 3 Nov 2023 07:48:55 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     Chandan Babu R <chandanbabu@kernel.org>, Jan Kara <jack@suse.cz>,
        "Darrick J. Wong" <djwong@kernel.org>, viro@zeniv.linux.org.uk,
        axboe@kernel.dk, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        dchinner@fromorbit.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [BUG REPORT] next-20231102: generic/311 fails on XFS with
 external log
Message-ID: <ZUQLN7UBlK6MQoK3@dread.disaster.area>
References: <87bkccnwxc.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20231102-teich-absender-47a27e86e78f@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231102-teich-absender-47a27e86e78f@brauner>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 02, 2023 at 03:54:48PM +0100, Christian Brauner wrote:
> On Thu, Nov 02, 2023 at 06:06:10PM +0530, Chandan Babu R wrote:
> > Hi,
> > 
> > generic/311 consistently fails when executing on a kernel built from
> > next-20231102.
> > 
> > The following is the fstests config file that was used during testing.
> > 
> > export FSTYP=xfs
> > 
> > export TEST_DEV=/dev/loop0
> > export TEST_DIR=/mnt/test
> > export TEST_LOGDEV=/dev/loop2
> > 
> > export SCRATCH_DEV=/dev/loop1
> > export SCRATCH_MNT=/mnt/scratch
> > export SCRATCH_LOGDEV=/dev/loop3
> 
> Thanks for the report. So dm flakey sets up:
> 
> /dev/dm-0 over /dev/loop0
> /dev/dm-1 over /dev/loop2
> 
> and then we mount an xfs filesystem with:
> 
> /dev/loop2 as logdev and /dev/loop0 as the main device.
> 
> So on current kernels what happens is that if you freeze the main
> device you end up:
> 
> bdev_freeze(dm-0)
> -> get_super(dm-0) # finds xfs sb
>    -> freeze_super(sb)
> 
> if you also freeze the log device afterwards via:
> 
> bdev_freeze(dm-1)
> -> get_super(dm-1) # doesn't find xfs sb because freezing only works for
>                    # main device
> 
> What's currently in -next allows you to roughly do the following:
> 
> bdev_freeze(dm-0)
> -> fs_bdev_freeze(dm-0->sb)
>    -> freeze_super(dm-0->sb) # returns 0
> 
> bdev_freeze(dm-1)
> -> fs_bdev_freeze(dm-1->sb)
>    -> freeze_super(dm-1->sb) # returns -EBUSY
> 
> So you'll see EBUSY because the superblock was already frozen when the
> main block device was frozen. I was somewhat expecting that we may run
> into such issues.
> 
> I think we just need to figure out what we want to do in cases the
> superblock is frozen via multiple devices. It would probably be correct
> to keep it frozen as long as any of the devices is frozen?

So this series removed the blockdev freeze nesting code that dm
suspend/resume functionality used (i.e. it allowed concurrent bdev
freeze/thaw works and leaves the bdev frozen until the last thaw
occurs). Removing bd_fsfreeze_count essentially removed this nesting
ability.

IMO, bdev_freeze() should still nest freeze/thaw across all devices
in the filesystem like it used to on the main device. This implies
that freeze_super() needs to know that it is being called from
bdev_freeze() and needs a freeze counter to allow concurrent bdev
freezes and only thaw the fs when the last freeze goes away....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
