Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD4BFECAAA1
	for <linux-xfs@archiver.kernel.org>; Wed, 31 Aug 2022 00:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230453AbiHaAvY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 20:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiHaAvX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 20:51:23 -0400
Received: from out20-39.mail.aliyun.com (out20-39.mail.aliyun.com [115.124.20.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152BB4E85E
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 17:51:20 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.044377|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.035877-0.00285441-0.961269;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047194;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.P3t31yZ_1661907048;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.P3t31yZ_1661907048)
          by smtp.aliyun-inc.com;
          Wed, 31 Aug 2022 08:50:48 +0800
Date:   Wed, 31 Aug 2022 08:50:50 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: questions about hybird xfs wih ssd/hdd  by realtime subvol
Cc:     Carlos Maiolino <cem@kernel.org>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
In-Reply-To: <Yw11u/2ghadMfLMd@magnolia>
References: <20220830085718.9391.409509F4@e16-tech.com> <Yw11u/2ghadMfLMd@magnolia>
Message-Id: <20220831085049.59BB.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.75.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

> On Tue, Aug 30, 2022 at 08:57:21AM +0800, Wang Yugui wrote:
> > Hi,
> > 
> > > On Mon, Aug 29, 2022 at 10:26:20AM +0800, Wang Yugui wrote:
> > > > Hi,
> > > > 
> > > > I saw some info about hybird xfs wih ssd/hdd  by realtime subvol.
> > > > 
> > > > Hybrid XFS¡ªUsing SSDs to Supercharge HDDs at Facebook
> > > > https://www.usenix.org/conference/srecon19asia/presentation/shamasunder
> > > > 
> > > > There are some questions about how to control the data to save into
> > > > normal vol or realtime subvol firstly.
> > > > 
> > > > 1, man xfsctl
> > > > here is XFS_XFLAG_REALTIME in man xfsctl of xfsprogs 5.0 ,
> > > > but there is no XFS_XFLAG_REALTIME in xfsprogs 5.14/5.19.
> > > > xfsctl(XFS_XFLAG_REALTIME) will be removed in the further?
> > > 
> > > It's been a while since XFS uses FS_XFLAG features directly, so, what you're
> > > specifically looking for is FS_XFLAG_REALTIME. xfsprogs today only has a
> > > preprocessor define:
> > > 
> > > #define XFS_XFLAG_REALTIME	FS_XFLAG_REALTIME
> > > 
> > > FS_XFLAG_REALTIME is part of the xfs realtime, unlikely it's going away without
> > > the realtime filesystems going first, so, unlikely it's gonna happen.
> > > 
> > > > 
> > > > 2, Is there some tool to do xfsctl(XFS_XFLAG_REALTIME)?
> > > 
> > > You can use xfs_io's chattr command to add/remote the REALTIME attribute of a
> > > file.
> > > 
> > > 
> > > > 
> > > > 3, we build a xfs filesystem with 1G device and 1G rtdev device. and
> > > > then we can save 2G data into this xfs filesystem.
> > 
> > Sorry, I cheched again.
> > This is a xfs filesystem with 2G device and 2G rtdev device
> > 
> > > > Is there any tool/kernel option/kernel patch to control the data to save
> > > > into normal vol or realtime subvol firstly?
> > > 
> > > I didn't watch the talk you mentioned above, but when use an rt device, you
> > > don't use the 'normal' one then the rt later, or vice-versa, the rt-device is
> > > used to store data blocks for those files marked with the xattr above. For those
> > > files you want to store in the realtime device, you should add the above xattr
> > > to them.
> > 
> > Although I still fail to check/set the attr by 'lsattr/chattr', but I
> > can check the free space of 'normal' and realtime subvol now.
> > 
> > # xfs_db -c sb -c p /dev/sdb8 |grep 'fdblocks\|frextents'
> > typedef struct xfs_sb {
> > ...
> > 	uint64_t	sb_fdblocks;	/* free data blocks */
> > 	uint64_t	sb_frextents;	/* free realtime extents */
> > ...
> > }
> > 
> > And based the info from Carlos Maiolino
> > 
> > FB were running a modified kernel that selected the rt dev based on
> > the initial allocation size. Behaviour for them was predictable
> > because they also controlled the application that was storing the
> > data. See:
> > 
> > https://lore.kernel.org/linux-xfs/20171128215527.2510350-1-rwareing@fb.com/
> > 
> > With a dirty patch below for test only , Now realtime subvol will be used
> > as I expected, and that can be confirmed by
> > #xfs_db -c sb -c p /dev/sdb8 |grep 'fdblocks\|frextents'.
> 
> mkfs.xfs -d rtinherit=1...

'mkfs.xfs -d rtinherit=1' works very well. Thanks a lot.

I noticed that 'reflink not supported with realtime devices' both in
mkfs.xfs and in kernel/xfs(c14632ddac98 xfs: don't allow reflink +
realtime filesystems).

Is this a limit of current design?
or we just disable reflink when realtime devices  just for QoS/realtime?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/08/31


