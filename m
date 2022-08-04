Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77096C19F2A
	for <linux-xfs@archiver.kernel.org>; Thu,  4 Aug 2022 18:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235219AbiHDSG2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 4 Aug 2022 14:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239701AbiHDSG0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 4 Aug 2022 14:06:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B089A2CE0F
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 11:06:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65683B82414
        for <linux-xfs@vger.kernel.org>; Thu,  4 Aug 2022 18:06:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F305C433D7;
        Thu,  4 Aug 2022 18:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659636383;
        bh=66Vj/Hi/bWwAY6NSyAYmzq/qljbh0ulmHlfThKKhNBM=;
        h=Subject:From:To:Cc:Date:From;
        b=Ox4KnHl0du3ZF6tmNjR/6haTMMOPB1J4+w0+oKDp2uHBxxAolCbyWo7m7Z0vDE+y4
         aQ8con2aHCfG49Duhu+X0HS40AWiBX9QfcVJgbL36CwarQSKqAEloP7OKKmaui4eqF
         /gyqxbyGtvYjToqyrIGG+Aoz3rykF9I2XVqO5jF3Q679/1XIk1hWMbWtfi8kk251Du
         ydNRYX2jgWptUU7GLiT5VCbI6Mez00t2NfHiIywOZBl2z1qBWsBWlG50tZE41iJVXW
         cq8RJMnrlGbon6+8zyHLMdrPrB4AMN6xjiRB+CE2Ul/cCARG1HAc6A60W3CJGp+vMy
         QlTnfsobzNX3w==
Subject: [PATCHSET 0/2] xfs: random fixes for 6.0
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Thu, 04 Aug 2022 11:06:22 -0700
Message-ID: <165963638241.1272632.9852314965190809423.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a couple of bug fixes for 6.0.  The first patch teaches XFS to
report errors from disk write cache flushes up the stack; and the second
fixes an intermittent hang I see during quotacheck when reclaim and
the quotacheck dquot flush race to write the dquot buffer to disk.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.0-fixes
---
 fs/xfs/xfs_file.c |   22 ++++++++++++++--------
 fs/xfs/xfs_log.c  |   11 +++++++++--
 fs/xfs/xfs_qm.c   |    5 +++++
 3 files changed, 28 insertions(+), 10 deletions(-)

