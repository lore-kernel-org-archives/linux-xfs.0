Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93243C83F33
	for <linux-xfs@archiver.kernel.org>; Mon,  4 Sep 2023 22:49:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231596AbjIDWtO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 18:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjIDWtN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2023 18:49:13 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D954CC
        for <linux-xfs@vger.kernel.org>; Mon,  4 Sep 2023 15:49:10 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-271c700efb2so867245a91.0
        for <linux-xfs@vger.kernel.org>; Mon, 04 Sep 2023 15:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1693867749; x=1694472549; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lOJw9QtOqVLXG0JRL3SLxF9B+sgcvGsT1z/iSC2KP7Q=;
        b=ub5Ye8iWpCKtNXTd0tS+myFQ4JV4jwtZl7fKZe/Q92JretEWnY8d/3/3xEPMahp+3X
         jfO5ihCbfS5jZaa6mSidfPkDCPW2eTxVZNpCf+U1L2BbtiJhMkqFbFWlUsczK5hglCjI
         mwu7yFdG8qk13Ns5kDKI+HTByQDnKN2eUQ53wjKXU4wUnSp4WW9thHik7w5dWTOWupqF
         89CmQ2oOHvI+dk00CWYilgUGvEa/bXyc9228rwwdmCu9BOixk9xpwxwuYWmUOCllDH7K
         mv/xOMeusfGU7xOJwQGdHEHGzfC9Jo3p8uI1n2VAWPPvlSMwl/jPVx0GIM71frQsTHXU
         kZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693867749; x=1694472549;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lOJw9QtOqVLXG0JRL3SLxF9B+sgcvGsT1z/iSC2KP7Q=;
        b=BN6a+5yAr4qsBOhVVdTPjOaUcXH4Clcm+QSG4d+MY+hXe8noEyENtUz2klWK1LptL0
         oSQlw6VeiRyzK4suoPighGh/1XGDcqcJtg87fw5fgZ6syy4iSznyQadNWKy+Gmr4/gM3
         pu9YVnQkF2WebWa2kCsgppY03Gjj2FsluQCRQHE+iIuyNSBa9Iu3WoaEKJ85ny2k+kBC
         skHjc0z6aFNpUn3Hx5bObYtCIUyUubmw8g8oLbTVqPrkjIkrkuw0Llpgy6e7o7PYWvF4
         tnRIJaXYEAsGWT1DHG3qDA+H+URr8SJwkZ6b99aYjXmiOLRaUxByfyHw03byjTdCN4cV
         +9Cw==
X-Gm-Message-State: AOJu0YyO6be35GmnAKcc0yUa8qGXsyIDey1NlwDMBgkeBVfhMe7MuHQx
        j01fpO+SGGxqjC2epR15f5mJkw==
X-Google-Smtp-Source: AGHT+IFtYJDqnJpah1PX3f33aAtM2uFyAolJh+xRbcsrU86Qc2utgFDYXg+rCm3zeG/jj9bYDryXlQ==
X-Received: by 2002:a17:90b:3b44:b0:268:553f:1938 with SMTP id ot4-20020a17090b3b4400b00268553f1938mr8071130pjb.4.1693867749400;
        Mon, 04 Sep 2023 15:49:09 -0700 (PDT)
Received: from dread.disaster.area (pa49-195-66-88.pa.nsw.optusnet.com.au. [49.195.66.88])
        by smtp.gmail.com with ESMTPSA id q18-20020a170902dad200b001b898595be7sm7986674plx.291.2023.09.04.15.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 15:49:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qdINV-00Atsn-2j;
        Tue, 05 Sep 2023 08:49:05 +1000
Date:   Tue, 5 Sep 2023 08:49:05 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     cheng.lin130@zte.com.cn
Cc:     djwong@kernel.org, linux-xfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, jiang.yong5@zte.com.cn,
        wang.liang82@zte.com.cn, liu.dong3@zte.com.cn
Subject: Re: [PATCH] xfs: introduce protection for drop nlink
Message-ID: <ZPZe4VkpxVfn5qNL@dread.disaster.area>
References: <ZOwu2vrzX/0dX89/@dread.disaster.area>
 <202309041042177773780@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <202309041042177773780@zte.com.cn>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Sep 04, 2023 at 10:42:17AM +0800, cheng.lin130@zte.com.cn wrote:
> > On Mon, Aug 28, 2023 at 11:29:51AM +0800, cheng.lin130@zte.com.cn wrote:
> > > > On Sat, Aug 26, 2023 at 10:54:11PM +0800, cheng.lin130@zte.com.cn wrote:
> > > > > > > In the old kernel version, this situation was
> > > > > > > encountered, but I don't know how it happened. It was already a scene
> > > > > > > with directory errors: "Too many links".
> > > > How do you overflow the directory link count in XFS? You can't fit
> > > > 2^31 unique names in the directory data segment - the directory will
> > > > ENOSPC at 32GB of name data, and that typically occurs with at most
> > > > 300-500 million dirents (depending on name lengths) in the
> > > > directory.
> > > > IOWs, normal operation shouldn't be able overflow the directory link
> > > > count at all, and so underruns shouldn't occur, either.
> > > Customer's explanation: in the nlink incorrect directory, not many directories
> > > will be created, and normally there are only 2 regular files.
> > > And only found this one directory with incorrect nlink when xfs_repair.
> > > systemd-fsck[5635]: Phase 2 - using internal log
> > > systemd-fsck[5635]: - zero log...
> > > systemd-fsck[5635]: - scan filesystem freespace and inode maps...
> > > systemd-fsck[5635]: agi unlinked bucket 9 is 73 in ag 22 (inode=23622320201)
> > So the directory inode is on the unlinked list, as I suggested it
> > would be.
> Yes.
> > > systemd-fsck[5635]: - 21:46:00: scanning filesystem freespace - 32 of 32 allocation groups done
> > > systemd-fsck[5635]: - found root inode chunk
> > > ...
> > How many other inodes were repaired or trashed or moved to
> > lost+found?
> Just (inode=23622320201) repaired.

So only one inode on the unlinked list, and it's the inode with
the bad link count.

> > > systemd-fsck[5635]: Phase 7 - verify and correct link counts...
> > > systemd-fsck[5635]: resetting inode 23622320201 nlinks from 4294967284 to 2
> > The link count of the directory inode on the unlinked list was
> > actually -12, so this isn't an "off by one" error. It's still just 2
> > adjacent bits being cleared when they shouldn't have been, though.
> > What is the xfs_info (or mkfs) output for the filesystem that this
> > occurred on?
> meta-data=/dev/mapper/vg_gbaseserver-lv_gbaseserver isize=512 agcount=32, agsize=78643168 blks
>          = sectsz=512 attr=2, projid32bit=1
>          = crc=1 finobt=0 spinodes=0

Ok, crcs are enabled, so it's likely not storage level corruption.

> data     = bsize=4096 blocks=2516581376, imaxpct=5
>          = sunit=0 swidth=0 blks
> naming   =version 2 bsize=4096 ascii-ci=0 ftype=1
> log      =internal bsize=4096 blocks=521728, version=2
>          = sectsz=512 sunit=0 blks, lazy-count=1
> realtime =none extsz=4096 blocks=0, rtextents=0
> 
> > ......
> > > If it's just a incorrect count of one dicrectory, after ignore it, the fs
> > > can work normally(with error). Is it worth stopping the entire fs
> > > immediately for this condition?
> > The inode is on the unlinked list with a non-zero link count. That
> > means it cannot be removed from the unlinked list (because the inode
> > will not be freed during inactivation) and so the unlinked list is
> > effectively corrupt. Anything that removes an inode or creates a
> > O_TMPFILE or uses RENAME_WHITEOUT can trip over this corrupt
> > unlinked list and have things go from bad to worse. Hence the
> If protect the nlink not to underflow(minimum value of nlink is 0),
> does it means can avoid unlinked list to be corrupted？

The VFS already warns when an underflow occurs - stuff has already
gone wrong at this point, and if we are going to do anything then
we should be shutting the filesystem down at this point because
something is corrupt either in memory or on disk, and continuing
after underflow propagates the corruption and makes things worse...

The fact that your customer's system didn't log warnings about the
link count going from 0 to -1 when the link count was -12 on disk
(like it should if this happens via xfs_droplink() -> drop_link())
it really brings into question how this situation silently
occurred....

Until we actually understand the root cause of the bad value and why
it occurred silently in a decade old kernel, trying to fix it in a
current upstream kernel is premature.

> > corruption is not limited to the directory inode or operations
> > involving that directory inode. We generally shut down the
> > filesystem when this sort of corruption occurs - it needs to be
> > repaired ASAP, otherwise other stuff will randomly fail and
> > you'll still end up with a shut down filesystem. Better to fail
> > fast in corruption cases than try to ignore it and vainly hope
> > that everything will work out for the best....  Cheers, Dave.
> > --
> Directly shutdown filesystem is really a relatively safe approach.
> But for customer, it's suddenly and unprepared. If keep fs
> available as possible (If can be achieved) and allow delayed
> repair, then customer can make more preparations before do that.
> Do you preferred more to shutdown filesystem directly?

Yes, if we've detected corruption in a modification situation (such
as an unlink) we need to shut down the filesystem. Propagating a
corruption from in-memory to on-disk is the worst thing we can do.
As such, XFS has had a policy since the mid 1990s that we shut down
the filesystem immediately rather than risk propagating a corruption
into on-disk structures.

This will change in the future as we start to leverage online repair
in response to corruption detections like this. But that's not a
magic bullet, and that does not help the situation with problems on
RHEL-7 era kernels....

-Dave.

-- 
Dave Chinner
david@fromorbit.com
