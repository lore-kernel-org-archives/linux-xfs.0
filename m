Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B80BC07E96
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02F9D61424
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhGCDAz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:00:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:59868 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhGCDAz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:00:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B7E461424;
        Sat,  3 Jul 2021 02:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281102;
        bh=Ep1z12cbbm7h6uKo6oFMab1CWNlGD0hEa/CI6jkh+2g=;
        h=Subject:From:To:Cc:Date:From;
        b=FTy/tcGFrz8KvSEt3W6kz4ztVx2aQz6TFs7greUpY18hIo/nafH1nwVvL7d67HsZr
         5M416gRK/lmikoQTyR+NZwIhDK/WPWchcpdc7pVHnP0Rhi3vo2XR5UX7o/r79JwdCr
         dOMh4WAHc8RR/aBlSqcfqJC1eYSLoTdzecFglgrEjW8eRUVmpeRXs5h44InhB1d8Dq
         vmPbTnDiHCQLJmx/iVeH4GyUu1wZ7Aa7AbUVxIfruS+3YTX7hYO1q2HXHJ4YyzKCn6
         XzqMym5ymf4b24hwkVmz7F5nn8C+/bRVzvV85P2dot8mTp7GdMeCOltZyEa/ZFs0ri
         K7jW4d28XzKJQ==
Subject: [PATCHSET 0/1] xfs_io: small improvements to statfs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 02 Jul 2021 19:58:22 -0700
Message-ID: <162528110197.38907.6647015481710886949.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Change the statfs command so that you can invoke any combination of the
three state calls.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=statfs-fixes
---
 io/stat.c         |  149 +++++++++++++++++++++++++++++++++++++++--------------
 man/man8/xfs_io.8 |   17 ++++++
 2 files changed, 127 insertions(+), 39 deletions(-)

