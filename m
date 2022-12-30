Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07351C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbiL3XDg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:03:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XDf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:03:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC5415FC1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:03:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE59761BA9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:03:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24384C433EF;
        Fri, 30 Dec 2022 23:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441414;
        bh=kvy92R98HVFLyc+5U2k9Il/hXTbO5EOJfHaXPHWHlmA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=COtxL7AdP7mpEIpP/cjSKDIwAyrz3JNYU1ihYaU2nq4GBEU8T0RN2qhsLsneyQRr/
         4l19a+DeUmvlPeJ9febdICawjw9xt/77yeU8rvZMPWIfUPgbbugadYBm6AuJ72iihW
         FMcPgDvzcm2Hl5cOF1p/j7oQiDtPVscfLeEyfsWjyd4zCd9p/k+k5jYCn14Jm3iZUj
         hqJ/NRtebsTEeTI+VU/7cIUqhjqWhIw7AK8u3+P8nJFGdr0UDJKH69BsHYWFbXeqL0
         3fDJXeF0okzkkt50TibAntRlaNxifOWGyNSkG6377VfMlg4uYM8gy0qdUuPG1+5I2r
         3vAaJ3T6kvF4Q==
Subject: [PATCHSET v24.0 0/3] xfs: indirect health reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:19 -0800
Message-ID: <167243839911.696295.17985265962177375571.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series enables the XFS health reporting infrastructure to remember
indirect health concerns when resources are scarce.  For example, if a
scrub notices that there's something wrong with an inode's metadata but
memory reclaim needs to free the incore inode, we want to record in the
perag data the fact that there was some inode somewhere with an error.
The perag structures never go away.

The first two patches in this series set that up, and the third one
provides a means for xfs_scrub to tell the kernel that it can forget the
indirect problem report.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=indirect-health-reporting
---
 fs/xfs/libxfs/xfs_fs.h        |    4 ++
 fs/xfs/libxfs/xfs_health.h    |   45 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c |    2 +
 fs/xfs/scrub/health.c         |   76 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/health.h         |    1 +
 fs/xfs/scrub/repair.c         |    1 +
 fs/xfs/scrub/scrub.c          |    6 +++
 fs/xfs/scrub/trace.h          |    4 ++
 fs/xfs/xfs_health.c           |   25 +++++++++----
 fs/xfs/xfs_inode.c            |   29 ++++++++++++++++
 fs/xfs/xfs_trace.h            |    1 +
 11 files changed, 182 insertions(+), 12 deletions(-)

