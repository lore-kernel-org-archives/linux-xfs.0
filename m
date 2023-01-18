Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41DD2C00A5A
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjARAyJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjARAxi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:53:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B924A202
        for <linux-xfs@vger.kernel.org>; Tue, 17 Jan 2023 16:42:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AF8161598
        for <linux-xfs@vger.kernel.org>; Wed, 18 Jan 2023 00:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B689FC433EF;
        Wed, 18 Jan 2023 00:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002528;
        bh=zzl5JUBYtbqeXpwSsf4DChPzmm4dtUoSOgKFo/i53Tg=;
        h=Date:Subject:From:To:Cc:From;
        b=pHWKsa3KpJ7OM1QcjdXboo6zgiqG/VC05s8ev9P9WKJLkGvBGix3riEH1NK03PX+E
         0YbMZBGes/4LuWTncC/pTZWhrdwlNKCum+YBOGqujZ0ASGJRCMpZQr6E1554LAoFee
         VDL38R8Vv7lNiF+PFJJzdMgsXPThjy1JZLR1K359tSZVuCECwC/De8ZZJKSiYS8zXN
         6Ti4uW4mN2DhVOBDltSug0iLjxnGOaEgHl3UGnaID1kLC9qRMwWtgLqvoKeS4U6Xfd
         5hPUMq5xpQjfp6RGxPzhdjjf5+IB5/Oi5o1gUwPCidaZxyWHmiZA+r5NinT/ogmZXj
         Ti2eDeZ3V76XA==
Date:   Tue, 17 Jan 2023 16:42:08 -0800
Subject: [PATCHSET 0/3] xfs-documentation: updates for 6.1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org, chandan.babu@oracle.com,
        allison.henderson@oracle.com
Message-ID: <167400163279.1925795.1487663139527842585.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a pile of updates detailing the changes made during 2022 for
kernel 6.1.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=xfsdocs-6.2-updates
---
 .../allocation_groups.asciidoc                     |   25 +++--
 .../journaling_log.asciidoc                        |  109 ++++++++++++++++++++
 design/XFS_Filesystem_Structure/magic.asciidoc     |    2 
 .../XFS_Filesystem_Structure/ondisk_inode.asciidoc |   61 ++++++++++-
 4 files changed, 184 insertions(+), 13 deletions(-)

