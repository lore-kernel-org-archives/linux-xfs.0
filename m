Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754F7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:57:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235660AbiLaA5I (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbiLaA5H (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:57:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C4EF03A
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:57:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F11CE61D64
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:57:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DDC7C433EF;
        Sat, 31 Dec 2022 00:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448226;
        bh=hpfY6Ns7TovfBy/PQXp8yiqV/ui4PKMeaeenUxytdTc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tH8QsJl/4Of9buBVgtqt+qPqOy362h17wDJ9xQ7kkhJn8oPk/m3ADHXiqS8R6OK60
         0VR+ggyjoPtufDzzZ+aCQN3Ed2/tsHLXo2gi66SFB3CWwVWxzW12P3o4ppF4m2TIG9
         7oTaluB+8wRhO2r7+cwgA3l76Bv6ll/ucRsumk5hLOWN49tYzJnuHyIqLiBqHNYE8t
         pNyoooQdSwaKl96crlT/9m8HNnuFiFRyxc5KR0EKPgLmV0rEGOK8a5ZIU6ZcRmDTG8
         yfc+qfmrSoApK+rlVfZKrrSTLpVgTvoe2m4oBPk9FIjNcBBU6zvPSGTMDZ+/HdYtgV
         n+UIYXWLpifZA==
Subject: [PATCHSET v1.0 0/3] xfsprogs: enable FITRIM for the realtime section
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:58 -0800
Message-ID: <167243867862.713699.17132272459502557791.stgit@magnolia>
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

One thing that's been missing for a long time is the ability to tell
underlying storage that it can unmap the unused space on the realtime
device.  This short series exposes this functionality through FITRIM.
Callers that want ranged FITRIM should be aware that the realtime space
exists in the offset range after the data device.  However, it is
anticipated that most callers pass in offset=0 len=-1ULL and will not
notice or care.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-discard
---
 fs/xfs/xfs_discard.c |  167 +++++++++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_trace.h   |   20 ++++++
 2 files changed, 164 insertions(+), 23 deletions(-)

