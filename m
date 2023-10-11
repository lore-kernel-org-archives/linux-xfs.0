Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9FACD98C7
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Oct 2023 05:31:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjJKFbP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Oct 2023 01:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjJKFbO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Oct 2023 01:31:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD6094
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2023 22:31:13 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D2CC433C7;
        Wed, 11 Oct 2023 05:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697002272;
        bh=3YgUee4qoUE987bbe4BEyyfo+AAodauqgS9+MdtpCVE=;
        h=From:To:Cc:Subject:Date:From;
        b=rEsrpCIXU9uzJyv9tTcQCYOWmcL2+4ApP6SD+dgefe6oKAVto3yq11RU/eLxy9v5C
         Q7XATQ/7jjzt0Jx6YHoYYZIAE/oUJx6QvMr7dSeIfF3gR7Y5Vrg/ErEPUcOtLDk2Bt
         lZuHt/2FouLR7pSYAX/PVoXJ/q56odgJOsZd0J5cDK/Y1kCpUsF9jrDmKZgGfhe60Y
         9qTWhrzHAYFBSj+iFBg47AGcM+eWBZ1OuUgqZZ7Pgaik5hFlvVwh5GgKAlvQE3jVCu
         WQB1QyNc/o2OoGz6VNvRPWC7Dm7Rckn2q79fzxb+bKkW03Mf1YYZWqwfkQeJQi2OaU
         oB4mpDuonQ5QA==
User-agent: mu4e 1.8.10; emacs 27.1
From:   Chandan Babu R <chandanbabu@kernel.org>
To:     chandanbabu@kernel.org
Cc:     abaci@linux.alibaba.com, djwong@kernel.org,
        jiapeng.chong@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ruansy.fnst@fujitsu.com
Subject: [ANNOUNCE] xfs-linux: for-next updated to f809c3aae7b0
Date:   Wed, 11 Oct 2023 11:00:02 +0530
Message-ID: <875y3div38.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	https://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

f809c3aae7b0 xfs: Remove duplicate include

2 new commits:

Jiapeng Chong (1):
      [f809c3aae7b0] xfs: Remove duplicate include

Shiyang Ruan (1):
      [cbeacafaac88] xfs: correct calculation for agend and blockcount

Code Diffstat:

 fs/xfs/scrub/xfile.c        | 1 -
 fs/xfs/xfs_notify_failure.c | 6 +++---
 2 files changed, 3 insertions(+), 4 deletions(-)
