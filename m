Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B618C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241824AbjEZAhN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241882AbjEZAhG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:37:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49A611BB
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:37:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D272561B68
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B84C433EF;
        Fri, 26 May 2023 00:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061420;
        bh=JjtWWy29H1XwkbITjFhJ9lE0CqZ6W9MdYaFtHlyx7sA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Y7IbrJlqXu7YnLvF9ngihWM8uN4Z2u/AvTxAFLbIhkLUAdSrkqA9qwAa0CKb5Xw/z
         98nfnzwdUoyz8bA95K2CCtg7tHF4EK/dqYIgfAzkP5mzoiCIE0EBTHEdySD0MNPPl+
         Ff9p4ffskzoSR8p1J7mnrZaDYo/QgaOWrCt7Dz/14wmxqTe8VErwUMfaAth23/mBMv
         6r2+8MnLvS4tc6XJ7rOcWO3ivi62eZPjnZmOd9ORK4rayRjrcSI0f+t3TkBQ/1TW0g
         AvG1t8RyhtFvwv0rlmuu0NQrH02LVcn8upglz2DJRsUCMV0an0mPum3BQKfGvFDKp5
         kQXHHMpN6jE3Q==
Date:   Thu, 25 May 2023 17:36:59 -0700
Subject: [PATCHSET v25.0 0/3] xfs: online fsck of iunlink buckets
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506068642.3738067.3524976114588613479.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series enhances the AGI scrub code to check the unlinked inode
bucket lists for errors, and fixes them if necessary.  Now that iunlink
pointer updates are virtual log items, we can batch updates pretty
efficiently in the logging code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-iunlink

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-iunlink
---
 fs/xfs/scrub/agheader.c        |   40 ++
 fs/xfs/scrub/agheader_repair.c |  746 ++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/trace.h           |  185 ++++++++++
 fs/xfs/xfs_inode.c             |    2 
 fs/xfs/xfs_inode.h             |    1 
 5 files changed, 927 insertions(+), 47 deletions(-)

