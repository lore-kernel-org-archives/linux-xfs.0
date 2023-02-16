Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0063EC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:30:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjBPUay (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:30:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjBPUax (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:30:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292064B53D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:30:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B987B60A65
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F446C433EF;
        Thu, 16 Feb 2023 20:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579451;
        bh=WhGUrLQKGDaAQUugkpPy5eaWZXkTZNGnYpcpGjwR/3c=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=NPBs5Qi6sYHe/2EZ7sL0SDWu1M5Ktri/OUfmpEmkyROH4moDby9mqMbWX5nCKIR+j
         5iuBBQYz090elxe3lKrCF4DKZ6O9KSaWW55aGH3EPzm/PfMrGCUwwO2mYIy7noVPDc
         6DCbC9JdB+bvVGxfAbTJyCVs/Xft2zKHfvp4gcfN+5xhd1EmGfEMcZXTserJALavhJ
         eX0m6XyX8lHGEc5EdRXyBIv0XOAu9rSoiLhpvNUsnc6beh2cOBH3s0NiUJA4nVtiQ8
         M3lEk9xzLoZRrqM9aicrysXRhEgx5hWSlO2OuT6UAd9lHteMPc6P3+GWz1Ve+rc5DS
         rzlnlbMQovJlg==
Date:   Thu, 16 Feb 2023 12:30:50 -0800
Subject: [PATCHSET v9r2d1 0/2] xfsprogs: online checking of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657881656.3477709.1694162379388596172.stgit@magnolia>
In-Reply-To: <Y+6MxEgswrJMUNOI@magnolia>
References: <Y+6MxEgswrJMUNOI@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

With this patchset, we implement online repairs for parent pointers.
This is structured similarly to the directory repair code in that we
scan the entire filesystem looking for dirents and use them to
reconstruct the parent pointer information.

Note that the atomic swapext and block reaping code is NOT ported for
this PoC, so we do not commit any repairs.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-online-parent-repair

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-online-parent-repair
---
 include/xfs_inode.h |    6 +++++
 libxfs/xfs_parent.c |   56 +++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_parent.h |    8 +++++++
 3 files changed, 68 insertions(+), 2 deletions(-)

