Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E054FC433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Nov 2021 19:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231683AbhKWT45 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Nov 2021 14:56:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:37602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230491AbhKWT45 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Nov 2021 14:56:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCAF46023D;
        Tue, 23 Nov 2021 19:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637697228;
        bh=NBtLKElha1XAkce6fnPRQHhGmniVwAGwATa3UqA+fsE=;
        h=Subject:From:To:Cc:Date:From;
        b=Znthio4arj/TAqOsIM6m8j45KVSk+wI+sVCaXOMgkIY1769bk9VLhpU/dh6NIlcMI
         ru3OEpLnp2vHvCOyeiB/rF1WgvRkn+g70sxvYUBjkpTqVZfKUYhunF+6MdhaE1uDs2
         8XypkpTzb8ooLR8Smh5qgpMxF+2qs5d/cdDZYesf7eoatNSukgqC4QF+kjjFAmjdXB
         KRIiCqnfEUeJ6te3SE/yfguVvMVmgILvt86vgwmTfUVFNoybTJUDTkegkAo5reeqhI
         Xrd/Dl/FnpSHRf/kVEW/eSZsTVCLXGcaHmwO6uiYKSHCpe503S+3hKePO4LZKrOakT
         JUYGyTJ9rDMqg==
Subject: [PATCHSET 0/2] xfs: fixes for 5.14.1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Bastian Germann <bage@debian.org>,
        Helmut Grohne <helmut@subdivi.de>,
        Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Tue, 23 Nov 2021 11:53:48 -0800
Message-ID: <163769722838.871940.2491721496902879716.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This quick series fixes some build problems in xfsprogs 5.14.0.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.14-fixes
---
 configure.ac         |    1 +
 include/atomic.h     |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 include/builddefs.in |    4 ++++
 include/libxlog.h    |    4 ++--
 libfrog/crc32.c      |    7 ++++++-
 libxfs/init.c        |    4 ++++
 m4/package_urcu.m4   |   19 +++++++++++++++++++
 repair/phase2.c      |    2 +-
 8 files changed, 83 insertions(+), 4 deletions(-)

