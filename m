Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7013CECAAA2
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Aug 2022 02:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbiH2C0Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 28 Aug 2022 22:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiH2C0X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 28 Aug 2022 22:26:23 -0400
Received: from out20-159.mail.aliyun.com (out20-159.mail.aliyun.com [115.124.20.159])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA6122A414
        for <linux-xfs@vger.kernel.org>; Sun, 28 Aug 2022 19:26:20 -0700 (PDT)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1422334|-1;BR=01201311R111S54rulernew998_84748_2000303;CH=blue;DM=|CONTINUE|false|;DS=CONTINUE|ham_news_journal|0.329774-0.0161248-0.654101;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047211;MF=wangyugui@e16-tech.com;NM=1;PH=DS;RN=1;RT=1;SR=0;TI=SMTPD_---.P2B-cMS_1661739977;
Received: from 192.168.2.112(mailfrom:wangyugui@e16-tech.com fp:SMTPD_---.P2B-cMS_1661739977)
          by smtp.aliyun-inc.com;
          Mon, 29 Aug 2022 10:26:18 +0800
Date:   Mon, 29 Aug 2022 10:26:20 +0800
From:   Wang Yugui <wangyugui@e16-tech.com>
To:     linux-xfs@vger.kernel.org
Subject: questions about hybird xfs wih ssd/hdd  by realtime subvol
Message-Id: <20220829102619.AE3B.409509F4@e16-tech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.75.04 [en]
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi,

I saw some info about hybird xfs wih ssd/hdd  by realtime subvol.

Hybrid XFS¡ªUsing SSDs to Supercharge HDDs at Facebook
https://www.usenix.org/conference/srecon19asia/presentation/shamasunder

There are some questions about how to control the data to save into
normal vol or realtime subvol firstly.

1, man xfsctl
here is XFS_XFLAG_REALTIME in man xfsctl of xfsprogs 5.0 , 
but there is no XFS_XFLAG_REALTIME in xfsprogs 5.14/5.19.
xfsctl(XFS_XFLAG_REALTIME) will be removed in the further?

2, Is there some tool to do xfsctl(XFS_XFLAG_REALTIME)?

3, we build a xfs filesystem with 1G device and 1G rtdev device. and
then we can save 2G data into this xfs filesystem.

Is there any tool/kernel option/kernel patch to control the data to save
into normal vol or realtime subvol firstly?

Best Regards
Wang Yugui (wangyugui@e16-tech.com)
2022/08/29


