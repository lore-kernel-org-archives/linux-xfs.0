Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33BEFC433B4
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Apr 2021 21:00:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0874561206
	for <linux-xfs@archiver.kernel.org>; Tue, 13 Apr 2021 21:00:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhDMVBI (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Apr 2021 17:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229832AbhDMVBI (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 13 Apr 2021 17:01:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C47FE61158;
        Tue, 13 Apr 2021 21:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618347647;
        bh=TJpiB3cjepHZeJqNU9E6kdravp/fn7LOgre+dYVFQxg=;
        h=Subject:From:To:Cc:Date:From;
        b=PZBUDoL3ByPAxZij0++cqgpg6VltODzgXFtHhnRhCZoNRJm+XN4r6Yi+TnnJjO3OA
         DD8xWPB6TQmx0/Bicnx0FGZlrY2TcvYr42/gtWyHJeUvSZoNU/JOTacVR9TZXkSKjA
         N3m0zRdxc8PbM3YRtyIlWPOVRZo1Lj0v6s3ijYY/fuf77Lf+7tAQM40tXXZ1CUGbyy
         +XmaxKexzIOBgXstbTUVMcQFQ/olaeyqJQI0IKVQKK5mXkY4RcF0ItXfl6luOPGanb
         DonTmT9zQoT3m0jCztSVsww8SHL7thGwEAwPbUqu9Efs2s7xgBBpG1BPQDr6TETH+9
         IYyRCsf065B5A==
Subject: [PATCHSET 0/2] xfsprogs: random fixes for 5.12
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 13 Apr 2021 14:00:46 -0700
Message-ID: <161834764606.2607077.6884775882008256887.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset contains various minor fixes for the 5.12 release.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 db/xfs_admin.sh  |    9 ++++-----
 libfrog/fsgeom.c |    6 ++++--
 2 files changed, 8 insertions(+), 7 deletions(-)

