Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C1D1C3525A
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jan 2022 02:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236218AbiAZCSh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 21:18:37 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34414 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236219AbiAZCSh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 21:18:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3A01B81BD2
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jan 2022 02:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648D5C340E0;
        Wed, 26 Jan 2022 02:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643163515;
        bh=CKRP4/lgLsp5aM5QoKHWBHTjFEtd/zIWhs+31XVjShg=;
        h=Subject:From:To:Cc:Date:From;
        b=Qsr50c1qBZ92kAmNwu3x74r09MS2ENyjNbNK2XVBlA/VYUBv8J5yukCKVatBgBT+0
         7/Te5hpQ7madxdk2zuyjBuv3UoWyufi/miSEhsCSVXhfVV21cX9WteGgS1eyOgZEub
         1mIyUqFYLr6sfQH1Mnasdl5dhhPF/ga2PaFT4cfrCvxBCpK4ObgwopDaQ+X+HhZua3
         lB8eiHgQikSNEJaa3YAIWNlwUkcImW0z7NmcfgtAiulU1vjmPFXbf2iGrPIxRFVHup
         If7s76h81NhdSB0B9E+VDN8+9lo0DkJrRBRHHg3gB4Sg+0nR3Ou7lF6P0I7Sbp80Ro
         Bcid3dcwhYkng==
Subject: [PATCHSET 0/1] xfs: tighten GETBMAP input validation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 25 Jan 2022 18:18:35 -0800
Message-ID: <164316351504.2600306.5900193386929839795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

syzbot complained that the input validation for XFS_IOC_GETBMAP isn't as
strict as the one in the kvmalloc calls that it uses to stage the bmap
reporting.  This is an annoying use of maintainer time, but fix it anyway.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=getbmap-validation-5.17
---
 fs/xfs/xfs_ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

