Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40007C43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:50:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230497AbiF1UuI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiF1UuH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:50:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BBB331202
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:50:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9BA816184B
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06655C341C8;
        Tue, 28 Jun 2022 20:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449406;
        bh=scAfgj7JV3YhAHQJAXK9/VR3FefOUkwyzEzavyVH9/I=;
        h=Subject:From:To:Cc:Date:From;
        b=obXgY/RyYgjTOkM9HRaPStr+gJWpNlg+lhU09ykIoxNLi8qNQqnGrjRw6uTrvcQWV
         pzxyTcgXYENEOzobYKD/aPii+T3/KIT7PfhrNocp1TgUI1wmqLqb6k+VYD9cdpZW9w
         PF/8mIy5iILVar8ed1JT6iRJCvw9DacZDKSXVBTOuaTAXLmepE57fCyAItxq0x6DBT
         qkM2esaL92vFWSp0Ql3VPr/a36KVNKe70l4zAUn+Fv9drYxyU1wj48yTy9mpgYKPd3
         p/O4tsQCKYaIFURhUgoTqtxJglI0zyFmmMtUCHOrgwnOmQCfs0CtTUIDSHQik4MTBH
         qLvAWRhAQThgg==
Subject: [PATCHSET v3 0/3] xfs_repair: check rt bitmap and summary
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:50:05 -0700
Message-ID: <165644940561.1091513.10430076522811115702.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I was evaluating the effectiveness of xfs_repair vs. xfs_scrub with
realtime filesystems the other day, and noticed that repair doesn't
check the free rt extent count, the contents of the rt bitmap, or the
contents of the rt summary.  It'll rebuild them with whatever
observations it makes, but it doesn't actually complain about problems.
That's a bit untidy, so let's have it do that.

v3: rebase to 5.19
v2: only check the rt bitmap when the primary super claims there's a
    realtime section

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-check-rt-metadata
---
 repair/phase5.c     |   13 +++
 repair/protos.h     |    1 
 repair/rt.c         |  214 ++++++++++++++++++---------------------------------
 repair/rt.h         |   18 +---
 repair/xfs_repair.c |    7 +-
 5 files changed, 97 insertions(+), 156 deletions(-)

