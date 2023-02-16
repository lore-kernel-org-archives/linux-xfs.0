Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F35C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:28:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBPU2u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:28:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjBPU2t (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:28:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D560E196A9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:28:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D77EB82992
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD83C433EF;
        Thu, 16 Feb 2023 20:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676579326;
        bh=65JhO0kNSWBJtUPJR8WzB3a3Lc++cg6lpAapYQAD22A=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=NzZXJ+VZjXTTtjeQrbChrQuvCSGPaboADGmU6ycZEBu892upyUFohwX2MPSWfOrlx
         3nx2NgeBmxMBUVLEMhuR86D71tXvuGxokwn+seMmR+fXQ7ENMWoST/g+cNSHK4mR1d
         TKtibLn/JCzB1dypNU+NLWRgxNvbpQhu8o5InLKF+nBfPiTq/Cp2elq/MQw5GuhmDt
         wKvxiCUjer/Mpp8MwttjIcdyi40M+garmBSmrhoFk1VR51lG8heI09EWBg1F1koURL
         Qx5MvcPnzgh5Zms6u0z6HPhWn4PUKjbJ6vNLSD91u9V9b/wnwqKssTs6aNOQ69Y2Y6
         Cx16OjRopFQ6g==
Date:   Thu, 16 Feb 2023 12:28:45 -0800
Subject: [PATCHSET v9r2d1 0/3] xfs: use flex arrays for XFS_IOC_GETPARENTS
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657876236.3475586.14505209064881107848.stgit@magnolia>
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

Change the XFS_IOC_GETPARENTS structure definitions so that we can pack
parent pointer information more densely, in a manner similar to the
attrlistmulti ioctl.  This also reduces the amount of memory that has to
be copied back to userspace if the buffer doesn't fill up.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=pptrs-ioctl-flexarray

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=pptrs-ioctl-flexarray

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=pptrs-ioctl-flexarray
---
 fs/xfs/libxfs/xfs_fs.h    |   75 ++++++++++++++++++++-------------------------
 fs/xfs/xfs_ioctl.c        |   67 +++++++++++++++++++++++++++++-----------
 fs/xfs/xfs_ondisk.h       |    4 +-
 fs/xfs/xfs_parent_utils.c |   57 +++++++++++++++++++++-------------
 fs/xfs/xfs_parent_utils.h |   11 ++++++-
 fs/xfs/xfs_trace.h        |   30 +++++++++---------
 6 files changed, 143 insertions(+), 101 deletions(-)

