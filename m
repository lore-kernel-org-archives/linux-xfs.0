Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 218C0CE79A4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:58:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjIYV6U (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:58:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjIYV6T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:58:19 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F19511F
        for <linux-xfs@vger.kernel.org>; Mon, 25 Sep 2023 14:58:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1DAC433C8;
        Mon, 25 Sep 2023 21:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695679093;
        bh=tZm5L7LsGAvj0iOp/U/6vDL3J5PXTpE8LWNjRE3An0g=;
        h=Subject:From:To:Cc:Date:From;
        b=LV8qiXC+RCeHKW+T7CdmpaNtLVi0ztNNAQNRsXxzZPGrrEw0Bnw0xueIb5DH5RTLy
         F71Mpr2cV4/IxiU/vs8ZFzZcmNJQIsE63Xbk3Qf4QTIG4iGi8GeTBsZTtz/YMrrNuI
         hIaFKZtxNz6lw72mqfnG85yrzFktCGRq4dn21Uk8axUDEIA08mqI6eKAnolxcbPXR2
         4Rv7RI6iifhEFj39BR+mYlPmMZIJpQvd7gXHu5efzfXXYaBYzZoPTHxKAdS0UiBEsH
         FSqn+OXtlR2KcpwYMhwUAOcUZniR7igriKjlKdVBRWTu61+G0mLDa0S1quQA5HoGBI
         RFN45zt+GuIWQ==
Subject: [PATCHSET 0/5] libxfs: sync with 6.6
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     Jan Kara <jack@suse.cz>, Jeff Layton <jlayton@kernel.org>,
        Dave Chinner <dchinner@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        linux-xfs@vger.kernel.org
Date:   Mon, 25 Sep 2023 14:58:12 -0700
Message-ID: <169567909240.2318286.10628058261852886648.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Synchronize libxfs with the kernel.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=libxfs-6.6-sync
---
 include/xfs_inode.h      |   34 +++++++++++++++++++++++++++++++---
 libxfs/xfs_fs.h          |    6 +++++-
 libxfs/xfs_inode_buf.c   |    5 +++--
 libxfs/xfs_sb.c          |    3 ++-
 libxfs/xfs_trans_inode.c |    2 +-
 5 files changed, 42 insertions(+), 8 deletions(-)

