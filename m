Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D4D0C433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:03:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381614AbiEEQHZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:07:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbiEEQHX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:07:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A9682CE19
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:03:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03F9661DA5
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:03:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549F9C385A4;
        Thu,  5 May 2022 16:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766619;
        bh=6i26ORDZOmK/0XAVFyB6LTCGS2xKwQj7soclv3GL//U=;
        h=Subject:From:To:Cc:Date:From;
        b=kwuAVrAtl2twRlYlOiVOk5ZGr4+8H/UzM0KnSqYfBtJYUO/Scl2/+0ODNqjwaugru
         hyhe1ldOQaHIlfDjkXbHkCF29oyN9sq9BZLO/V7b6VO//ytwXb4C/3z18FC8pjIESM
         JNBTmDmdrawkFb3LNjwfFRb7XUnXYqjHZLBrj4IotLAZlX4qyB0ZTgABh9SwPzshCo
         MLxCzIkbWOzRdP8EdeHZpBEwh8fpF8qAMI8yFK7GdAifcTB8kpHRfBXBGqHstO052x
         T/zfxrZD53V0rNIce7FFhIjt8e082fPT5YtOdn8PxEKKicG+bLaCFPGaODHgPz0s9U
         rfoF7fNLaY8cg==
Subject: [PATCHSET 0/3] xfsprogs: packaging improvements for debian
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:03:38 -0700
Message-ID: <165176661877.246788.7113237793899538040.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series rolls up a few packaging improvements for Debian.  First we
apply some cleanups to debian/rules; then bump the compat level from 9
to 11 because 9 is quite old now; and finally use debian's multiarch
rules to put libhandle in the correct place on the filesystem.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=debian-packaging
---
 configure.ac         |   11 +++++++++++
 debian/compat        |    2 +-
 debian/rules         |   18 +++++++++++++-----
 include/builddefs.in |    1 +
 m4/multilib.m4       |   12 ++++++++++++
 scrub/Makefile       |   11 ++++++-----
 6 files changed, 44 insertions(+), 11 deletions(-)

