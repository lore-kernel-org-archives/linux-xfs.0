Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9584BCD611C
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 18:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbjJISZs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 14:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233096AbjJISZr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 14:25:47 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EC3A3
        for <linux-xfs@vger.kernel.org>; Mon,  9 Oct 2023 11:25:46 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78BDC433C7;
        Mon,  9 Oct 2023 18:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696875946;
        bh=jIBrvPzmIO9UjKTrV3O9GxN75hpA93YUVBHyWgwzPyI=;
        h=Subject:From:To:Cc:Date:From;
        b=f7Yasxki34b92vVyzXt5UAHsvrB04L3wosuUm0wOGE6JxoNPhJKeXj87ABsl7XJi2
         rbYuLoHCvp8AqvVns+sZqYRoAhn83hrjXW7lm5MKBm1YgjXrF/oz14ZEIEm0TpBMry
         twGdobXAy3kMtU1DrA8Uv7psAnluPf54OGEpbHnY+4P4B4RRPBjW/bwFJsW4vP2lk3
         Z21ehccI8qoORzrEik7NBkvzq/CNvEwQrRYwcsH+bzMX1NiQIaa8wLvLnxre9wljjS
         g2R+TAgOXbw3vGyxSKVjTfJfpaifFk/+ozVxWF5x6DCvrsboEdiP1hEi8vJcQbPY/V
         Hasr9qe93Mrtw==
Subject: [PATCHSET 0/2] xfs: bug fixes for 6.6
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 09 Oct 2023 11:25:45 -0700
Message-ID: <169687594536.3969352.5780413854846204650.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Bug fixes for XFS for 6.6.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.6-fixes
---
 fs/xfs/libxfs/xfs_ag.c   |    6 ++++++
 fs/xfs/xfs_extent_busy.c |    3 ++-
 2 files changed, 8 insertions(+), 1 deletion(-)

