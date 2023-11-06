Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49373C4332F
	for <linux-xfs@archiver.kernel.org>; Mon,  6 Nov 2023 20:33:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232976AbjKFUd5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 6 Nov 2023 15:33:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232927AbjKFUd5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Nov 2023 15:33:57 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F5AD51
        for <linux-xfs@vger.kernel.org>; Mon,  6 Nov 2023 12:33:54 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6bf03b98b9bso4530439b3a.1
        for <linux-xfs@vger.kernel.org>; Mon, 06 Nov 2023 12:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1699302833; x=1699907633; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sg2rkss5RspQNiqU9dKvjec/jMo25nMwjuRNUc3lZBU=;
        b=fLcuYMRRrNTxVdzKUy9f+GyAohkopZ0AZcJt0UxwBUl6bWNQnA0wXX+yFgH8WvVDRV
         nZYYGIsNSd5655dZZduwEbcdA6/cQfR2NOzZ+exDSqJr+k64f0wFPfRlXykOp2MC0FNS
         ypXasXJPntzA7Hx70bVRTdNUpy37rZkf8slBZjPnpuluPYOJwP7fCX7Qg32IKKHKE1iJ
         8p2pzRmfnQy8o+uyV2RL+VWXlvcDwV9lvhLqFFfqc+y3SAdNnVOkd10Z9AaqURdmlX9L
         IGPZuTkSrQph+xlDBI1uoHrVEk+TB/Ghflww0LCqxXApUKEMQmgXCvFw0ce59f9r9so1
         gZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699302833; x=1699907633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sg2rkss5RspQNiqU9dKvjec/jMo25nMwjuRNUc3lZBU=;
        b=uARagxjMDqsrluFQTkkr9YA+JoELeHBC4K6gCvZPPPiK5YKRcvCZ+YYV9H6Nnwmsf5
         DoAkg7Esp9Uq27R1bsbB44iXwIpqyIMcCA/wAlr9N1cZ5E0IRPeta0P/l6k4Mb+OULpO
         faX9rT8gaOeYOZoRNrGJBzLcEXZ0sIwU2GXVNAnZSXMecRBvtPdmnMeCl4lpdMWzeCFO
         wuY+SeE/aHsHP2cqkxzLc8Wd+UFUP8+oVkB9F9q9+dpGWoXz1FVEiAWB0NIRZfXOJXxa
         tWnO+oawyYYBKAfoB/+YvY/i7U1ZKWRnTT68zN+rW66ok/BYhDilZ2o5Q2V9195BZ/0x
         2RhA==
X-Gm-Message-State: AOJu0YyJGb99N1el1Iojdek7Ww0eEJKpiU5Px1/SZH5Osx1XPXAnSzyg
        F5qzseIXh9YjIVzGuTbs0U6eQpkxOIk8180tOuw=
X-Google-Smtp-Source: AGHT+IHhA4+UBYBhPexxtTyUf34vdsdZzA6mZr+HM8jG/yTm5syKSDKfRF50pcK4kDlVc5OEQLnuZg==
X-Received: by 2002:a05:6a20:6a0a:b0:17a:eff5:fbbe with SMTP id p10-20020a056a206a0a00b0017aeff5fbbemr788846pzk.8.1699302833514;
        Mon, 06 Nov 2023 12:33:53 -0800 (PST)
Received: from dread.disaster.area (pa49-180-20-59.pa.nsw.optusnet.com.au. [49.180.20.59])
        by smtp.gmail.com with ESMTPSA id w2-20020a056a0014c200b0069ee4242f89sm6190182pfu.13.2023.11.06.12.33.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 12:33:52 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1r06IA-00986B-17;
        Tue, 07 Nov 2023 07:33:50 +1100
Date:   Tue, 7 Nov 2023 07:33:50 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J. Wong" <djwong@kernel.org>,
        Carlos Maiolino <carlos@maiolino.me>
Subject: Re: [Bug report][fstests generic/047] Internal error !(flags &
 XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.
 Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
Message-ID: <ZUlNroz8l5h1s1oF@dread.disaster.area>
References: <20231029041122.bx2k7wwm7otebjd5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <ZUiECgUWZ/8HKi3k@dread.disaster.area>
 <20231106192627.ilvijcbpmp3l3wcz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231106192627.ilvijcbpmp3l3wcz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Nov 07, 2023 at 03:26:27AM +0800, Zorro Lang wrote:
> On Mon, Nov 06, 2023 at 05:13:30PM +1100, Dave Chinner wrote:
> > On Sun, Oct 29, 2023 at 12:11:22PM +0800, Zorro Lang wrote:
> > > Hi xfs list,
> > > 
> > > Recently I always hit xfs corruption by running fstests generic/047 [1], and
> > > it show more failures in dmesg[2], e.g:
> > 
> > OK, g/047 is an fsync test.
> > 
> > > 
> > >   XFS (loop1): Internal error !(flags & XFS_DABUF_MAP_HOLE_OK) at line 2572 of file fs/xfs/libxfs/xfs_da_btree.c.  Caller xfs_dabuf_map.constprop.0+0x26c/0x368 [xfs]
> > 
> > Ok, a directory block index translated to a hole in the file
> > mapping. That's bad...
....
> > > _check_xfs_filesystem: filesystem on /dev/loop1 is inconsistent (r)
> > > *** xfs_repair -n output ***
> > > Phase 1 - find and verify superblock...
> > > Phase 2 - using internal log
> > >         - zero log...
> > >         - scan filesystem freespace and inode maps...
> > >         - found root inode chunk
> > > Phase 3 - for each AG...
> > >         - scan (but don't clear) agi unlinked lists...
> > >         - process known inodes and perform inode discovery...
> > >         - agno = 0
> > > bad nblocks 9 for inode 128, would reset to 0
> > > no . entry for directory 128
> > > no .. entry for root directory 128
> > > problem with directory contents in inode 128
> > > would clear root inode 128
> > > bad nblocks 8 for inode 131, would reset to 0
> > > bad nblocks 8 for inode 132, would reset to 0
> > > bad nblocks 8 for inode 133, would reset to 0
> > > ...
> > > bad nblocks 8 for inode 62438, would reset to 0
> > > bad nblocks 8 for inode 62439, would reset to 0
> > > bad nblocks 8 for inode 62440, would reset to 0
> > > bad nblocks 8 for inode 62441, would reset to 0
> > 
> > Yet all the files - including the data files that were fsync'd - are
> > all bad.
> > 
> > Aparently the journal has been recovered, but lots of metadata
> > updates that should have been in the journal are missing after
> > recovery has completed? That doesn't make a whole lot of sense -
> > when did these tests start failing? Can you run a bisect?
> 
> Hi Dave,
> 
> Thanks for your reply :) I tried to do a kernel bisect long time, but
> find nothing ... Then suddently, I found it's failed from a xfsprogs
> change [1].
> 
> Although that's not the root cause of this bug (on s390x), it just
> enabled "nrext64" by default, which I never tested on s390x before.
> For now, we know this's an issue about this feature, and only on
> s390x for now.

That's not good. Can you please determine if this is a zero-day bug
with the nrext64 feature? I think it was merged in 5.19, so if you
could try to reproduce it on a 5.18 and 5.19 kernels first, that
would be handy.

Also, from your s390 kernel build, can you get the pahole output
for the struct xfs_dinode both for a good kernel and a bad kernel?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
