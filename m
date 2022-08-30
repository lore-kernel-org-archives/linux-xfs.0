Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A40AECAAD3
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 02:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbiH3C2R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 22:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiH3C2Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 22:28:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2EB9E2E8
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 19:28:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 318F9B815D1
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 02:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C751BC433D6;
        Tue, 30 Aug 2022 02:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661826491;
        bh=8SzvNk3YxAGYPNQZYQtcYYyK6aUb46XIvmrAUUwnHPA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EC13o+jlUuHd1pQZ9iwdaJewvHBqx7Wi0+fAe7rLU/tkZXMmScQ+x7ig4ql42qeMD
         z4WLccv3htC4bz55+J5ZXlv9bS223/uoA1Hbn1dUKeXOXHEaKnpUdmobuCTOzuvitq
         JjVnhnbClE4nMbZhpWtF02D1/B5X3AfbA9pDHNkb9itVz7/5RZTRfYQ4eVyy1R0hAZ
         g51jARExLkY3m3mEulsLQXaHUZUhdzjbo3GTpYtecqaDQKvcKNNpERCbLN6kwMi/PR
         MCZ3k/glVw80OVR3yqNLexNw2D9U6YoySeiIavzEuGSYJo26ane2TwVl2Vbvfv1RNh
         CN2+kvwGavmIQ==
Date:   Mon, 29 Aug 2022 19:28:11 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Wang Yugui <wangyugui@e16-tech.com>
Cc:     Carlos Maiolino <cem@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Subject: Re: questions about hybird xfs wih ssd/hdd  by realtime subvol
Message-ID: <Yw11u/2ghadMfLMd@magnolia>
References: <20220829102619.AE3B.409509F4@e16-tech.com>
 <20220829082440.o3qzqdn44pw7z2ou@andromeda>
 <20220830085718.9391.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220830085718.9391.409509F4@e16-tech.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 08:57:21AM +0800, Wang Yugui wrote:
> Hi,
> 
> > On Mon, Aug 29, 2022 at 10:26:20AM +0800, Wang Yugui wrote:
> > > Hi,
> > > 
> > > I saw some info about hybird xfs wih ssd/hdd  by realtime subvol.
> > > 
> > > Hybrid XFS—Using SSDs to Supercharge HDDs at Facebook
> > > https://www.usenix.org/conference/srecon19asia/presentation/shamasunder
> > > 
> > > There are some questions about how to control the data to save into
> > > normal vol or realtime subvol firstly.
> > > 
> > > 1, man xfsctl
> > > here is XFS_XFLAG_REALTIME in man xfsctl of xfsprogs 5.0 ,
> > > but there is no XFS_XFLAG_REALTIME in xfsprogs 5.14/5.19.
> > > xfsctl(XFS_XFLAG_REALTIME) will be removed in the further?
> > 
> > It's been a while since XFS uses FS_XFLAG features directly, so, what you're
> > specifically looking for is FS_XFLAG_REALTIME. xfsprogs today only has a
> > preprocessor define:
> > 
> > #define XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
> > 
> > FS_XFLAG_REALTIME is part of the xfs realtime, unlikely it's going away without
> > the realtime filesystems going first, so, unlikely it's gonna happen.
> > 
> > > 
> > > 2, Is there some tool to do xfsctl(XFS_XFLAG_REALTIME)?
> > 
> > You can use xfs_io's chattr command to add/remote the REALTIME attribute of a
> > file.
> > 
> > 
> > > 
> > > 3, we build a xfs filesystem with 1G device and 1G rtdev device. and
> > > then we can save 2G data into this xfs filesystem.
> 
> Sorry, I cheched again.
> This is a xfs filesystem with 2G device and 2G rtdev device
> 
> > > Is there any tool/kernel option/kernel patch to control the data to save
> > > into normal vol or realtime subvol firstly?
> > 
> > I didn't watch the talk you mentioned above, but when use an rt device, you
> > don't use the 'normal' one then the rt later, or vice-versa, the rt-device is
> > used to store data blocks for those files marked with the xattr above. For those
> > files you want to store in the realtime device, you should add the above xattr
> > to them.
> 
> Although I still fail to check/set the attr by 'lsattr/chattr', but I
> can check the free space of 'normal' and realtime subvol now.
> 
> # xfs_db -c sb -c p /dev/sdb8 |grep 'fdblocks\|frextents'
> typedef struct xfs_sb {
> ...
> 	uint64_t	sb_fdblocks;	/* free data blocks */
> 	uint64_t	sb_frextents;	/* free realtime extents */
> ...
> }
> 
> And based the info from Carlos Maiolino
> 
> FB were running a modified kernel that selected the rt dev based on
> the initial allocation size. Behaviour for them was predictable
> because they also controlled the application that was storing the
> data. See:
> 
> https://lore.kernel.org/linux-xfs/20171128215527.2510350-1-rwareing@fb.com/
> 
> With a dirty patch below for test only , Now realtime subvol will be used
> as I expected, and that can be confirmed by
> #xfs_db -c sb -c p /dev/sdb8 |grep 'fdblocks\|frextents'.

mkfs.xfs -d rtinherit=1...

--D

> diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> index f4cc8a1aaeb4..d19e0fa34c1a 100644
> --- a/fs/xfs/xfs_inode.c
> +++ b/fs/xfs/xfs_inode.c
> @@ -868,6 +868,9 @@ xfs_init_new_inode(
>                 flags |= XFS_ILOG_DEV;
>                 break;
>         case S_IFREG:
> +               if (xfs_has_realtime(ip->i_mount))
> +                       ip->i_diflags |= XFS_DIFLAG_REALTIME;
> +               fallthrough;
>         case S_IFDIR:
>                 if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
>                         xfs_inode_inherit_flags(ip, pip);
> 
> Thanks a lot.
> 
> Best Regards
> Wang Yugui (wangyugui@e16-tech.com)
> 2022/08/30
> 
