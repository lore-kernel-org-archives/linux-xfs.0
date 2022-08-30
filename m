Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA7B0ECAAD3
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 00:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiH3A6F convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Aug 2022 20:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbiH3A5q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Aug 2022 20:57:46 -0400
Received: from out20-51.mail.aliyun.com (out20-51.mail.aliyun.com [115.124.20.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8096D89CCD
        for <linux-xfs@vger.kernel.org>; Mon, 29 Aug 2022 17:57:25 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.04442906|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0048522-0.000334645-0.994813;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047207;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=3;RT=3;SR=0;TI=SMTPD_---.P2zrOju_1661821039;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.P2zrOju_1661821039)
          by smtp.aliyun-inc.com;
          Tue, 30 Aug 2022 08:57:20 +0800
Date:   Tue, 30 Aug 2022 08:57:21 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     Carlos Maiolino <cem@kernel.org>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: questions about hybird xfs wih ssd/hdd  by realtime subvol
Cc:     linux-xfs@vger.kernel.org
In-Reply-To: <20220829082440.o3qzqdn44pw7z2ou@andromeda>
References: <20220829102619.AE3B.409509F4@e16-tech.com> <20220829082440.o3qzqdn44pw7z2ou@andromeda>
Message-Id: <20220830085718.9391.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8BIT
X-Mailer: Becky! ver. 2.75.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

> On Mon, Aug 29, 2022 at 10:26:20AM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > I saw some info about hybird xfs wih ssd/hdd  by realtime subvol.
> > 
> > Hybrid XFS¡ªUsing SSDs to Supercharge HDDs at Facebook
> > https://www.usenix.org/conference/srecon19asia/presentation/shamasunder
> > 
> > There are some questions about how to control the data to save into
> > normal vol or realtime subvol firstly.
> > 
> > 1, man xfsctl
> > here is XFS_XFLAG_REALTIME in man xfsctl of xfsprogs 5.0 ,
> > but there is no XFS_XFLAG_REALTIME in xfsprogs 5.14/5.19.
> > xfsctl(XFS_XFLAG_REALTIME) will be removed in the further?
> 
> It's been a while since XFS uses FS_XFLAG features directly, so, what you're
> specifically looking for is FS_XFLAG_REALTIME. xfsprogs today only has a
> preprocessor define:
> 
> #define XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
> 
> FS_XFLAG_REALTIME is part of the xfs realtime, unlikely it's going away without
> the realtime filesystems going first, so, unlikely it's gonna happen.
> 
> > 
> > 2, Is there some tool to do xfsctl(XFS_XFLAG_REALTIME)?
> 
> You can use xfs_io's chattr command to add/remote the REALTIME attribute of a
> file.
> 
> 
> > 
> > 3, we build a xfs filesystem with 1G device and 1G rtdev device. and
> > then we can save 2G data into this xfs filesystem.

Sorry, I cheched again.
This is a xfs filesystem with 2G device and 2G rtdev device

> > Is there any tool/kernel option/kernel patch to control the data to save
> > into normal vol or realtime subvol firstly?
> 
> I didn't watch the talk you mentioned above, but when use an rt device, you
> don't use the 'normal' one then the rt later, or vice-versa, the rt-device is
> used to store data blocks for those files marked with the xattr above. For those
> files you want to store in the realtime device, you should add the above xattr
> to them.

Although I still fail to check/set the attr by 'lsattr/chattr', but I
can check the free space of 'normal' and realtime subvol now.

# xfs_db -c sb -c p /dev/sdb8 |grep 'fdblocks\|frextents'
typedef struct xfs_sb {
...
	uint64_t	sb_fdblocks;	/* free data blocks */
	uint64_t	sb_frextents;	/* free realtime extents */
...
}

And based the info from Carlos Maiolino

FB were running a modified kernel that selected the rt dev based on
the initial allocation size. Behaviour for them was predictable
because they also controlled the application that was storing the
data. See:

https://lore.kernel.org/linux-xfs/20171128215527.2510350-1-rwareing@fb.com/

With a dirty patch below for test only , Now realtime subvol will be used
as I expected, and that can be confirmed by
#xfs_db -c sb -c p /dev/sdb8 |grep 'fdblocks\|frextents'.

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index f4cc8a1aaeb4..d19e0fa34c1a 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -868,6 +868,9 @@ xfs_init_new_inode(
                flags |= XFS_ILOG_DEV;
                break;
        case S_IFREG:
+               if (xfs_has_realtime(ip->i_mount))
+                       ip->i_diflags |= XFS_DIFLAG_REALTIME;
+               fallthrough;
        case S_IFDIR:
                if (pip && (pip->i_diflags & XFS_DIFLAG_ANY))
                        xfs_inode_inherit_flags(ip, pip);

Thanks a lot.

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/08/30

