Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94E7CC43381
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 03:18:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7250C64EDC
	for <linux-xfs@archiver.kernel.org>; Fri, 19 Feb 2021 03:18:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbhBSDSe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 18 Feb 2021 22:18:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhBSDSe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 Feb 2021 22:18:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E76BB64D74;
        Fri, 19 Feb 2021 03:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613704674;
        bh=4CI7agIJO9Q57+dFdncFgbDHDU9i+3xbNDjz7pgNveQ=;
        h=Subject:From:To:Cc:Date:From;
        b=N1SeA2Qweei3MuGWLv0bqRY+5CVqvOFAGfWlcmkoQn0F1CujjPW6szIO+03e61urs
         RBrG4drEVcrom4phF2y3z6nt0r6vv7cfYjSBkslsOmXd860AFLtrt28I4WKmGkvdgY
         mjvrY0punzB3EEVHKTwyIBOBb3BnRLWyPUYPDh7JyXxrJRUahFByZMaHM8k9RaRofi
         rsP5ZfMyXJKAPzg3cvT+5bl5udAz824L9YpBulf/nQeT2PCeFK+8K5LM8tdM83Yibe
         0UNxGmS5gbAGLmvCF7/03JLGyRVi5x93XK1soRdCrPyKNr7rE6MINkv0sMk46Fo1RV
         eM1X7sIbka19A==
Subject: [PATCHSET v2 0/4] xfs_repair: set needsrepair when dirtying
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 18 Feb 2021 19:17:53 -0800
Message-ID: <161370467351.2389661.12577563230109429304.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In the base needsrepair patchset, we set up the basics of handling the
new NEEDSREPAIR flag in xfsprogs.  This second series enables repair to
protect users against the system going down after repair begins to dirty
the filesystem but before it completes.  We start by adding a write hook
to the xfs_mount so that repair can intercept the first write to set
NEEDSREPAIR on the filesystem and the ondisk super, and finish off by
inserting error injection points into libxfs and xfs_repair so that
fstests can verify that this actually works.

v2: Improve documentation per reviewer request, fix some minor bugs,
    refactor repair's phase end function.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-set-needsrepair
---
 include/linux.h     |   13 +++++
 include/xfs_mount.h |    4 ++
 libxfs/init.c       |   68 +++++++++++++++++++++++++-
 libxfs/libxfs_io.h  |   19 +++++++
 libxfs/rdwr.c       |   10 +++-
 repair/globals.c    |    3 +
 repair/globals.h    |    3 +
 repair/xfs_repair.c |  132 ++++++++++++++++++++++++++++++++++++++++++++++++---
 8 files changed, 238 insertions(+), 14 deletions(-)

