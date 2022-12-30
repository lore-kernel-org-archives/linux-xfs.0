Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C9E1C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:59:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235739AbiLaA73 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:59:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235677AbiLaA72 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:59:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9231C913
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:59:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC3E461D6D
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:59:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A61C433D2;
        Sat, 31 Dec 2022 00:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448366;
        bh=HyojCy7Y6mrtKBpi0S3Re97eIvqFexdAR9NMj1yZLTU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=BvA0mRiJkFVxWpsB+LK8sY3EEep+EZn719lZ2wanLq7tRJhS+WGRgtZ6VryoZvEog
         R56niR+9cV4GNf7DqzTQ/zJ4uBMikPFK9tCVjQl75rn9kQ1SS2SwrTf3lYiHwIi09p
         6QMYIZU6JYefWCxChj3aHIQxn0FXNPzdrs7epJnodzJn2DzufIPc54Saml+UHGLnSG
         CNBzby/ZhND8nunETLzvjMncrEf7uHqYSu4l5/4qKbYIaZKv5Vm67gCB2Uv4egcOE8
         qLcvSt+mld90kfCx7aEL8Ugz7AyZRwqCO4Od7AEYmgJpdOX3iFjTBlE4yzXKdU72cp
         YoPOq58u+Y8EA==
Subject: [PATCHSET v1.0 0/3] xfs: enable quota for realtime voluems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:42 -0800
Message-ID: <167243872224.719004.160021889997830176.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

At some point, I realized that I've refactored enough of the quota code
in XFS that I should evaluate whether or not quota actually works on
realtime volumes.  It turns out that with two exceptions, it actually
does seem to work properly!  There are three broken pieces that I've
found so far: chown doesn't work, the quota accounting goes wrong when
the rt bitmap changes size, and the VFS quota ioctls don't report the
realtime warning counts or limits.  Hence this series fixes two things
in XFS and re-enables rt quota after a break of a couple decades.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-quotas

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-quotas

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-quotas
---
 fs/xfs/xfs_qm.c      |   56 +++++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_rtalloc.c |   24 +++++++--------------
 fs/xfs/xfs_trans.c   |   31 ++++++++++++++++++++++++++--
 3 files changed, 67 insertions(+), 44 deletions(-)

