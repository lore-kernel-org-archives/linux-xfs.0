Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7107C64ED6
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Mar 2023 16:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCAQFo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Mar 2023 11:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbjCAQFn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Mar 2023 11:05:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5263B64F
        for <linux-xfs@vger.kernel.org>; Wed,  1 Mar 2023 08:05:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 869B4612B1
        for <linux-xfs@vger.kernel.org>; Wed,  1 Mar 2023 16:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92AFC4339B;
        Wed,  1 Mar 2023 16:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677686729;
        bh=A2mGb7zlDIfA6SBgKezp5UzrzkvOGR1Ht01EB7nC1X8=;
        h=Subject:From:To:Cc:Date:From;
        b=uR0s+xjX0s1emLJLSTopyDYkCNZyv3o2Ra93549SGyF+ZlPULph4fZ3xrkIQsGMxx
         7TnoJMW1eZxCiVO1ojQd+RoGi/N+7TBjdzKhhsdNExZWr8HHl//BLZJjWa542HuDDh
         neyBZy/ArRpPULPgXx4Dn1N4WbrY10okbL0Nlptrz9yIb0wRpxJVEmfCQh+1I6UWjx
         1ij7LUolNsatz2jibMQYORp6+z/7iUSdKNlzVxK7voefwa5OsFIfaZg3WSu0FIVdne
         vVVBx5zaXYInKUZc8IGd8cClBefj9qkozuqCWivU1oVaanwT96cF9KBEk7ZJ/U/pVi
         ZeL7WGZ/fjt6Q==
Subject: [PATCHSET v2 0/3] xfsprogs: random fixes for 6.2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, daan.j.demeyer@gmail.com
Date:   Wed, 01 Mar 2023 08:05:28 -0800
Message-ID: <167768672841.4130726.1758921319115777334.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a rollup of the remaining random fixes I've collected for
xfsprogs 6.2.  First, we now check for invalid dirent names in the
protofile rather than let mkfs spit out a corrupt filesystem.

Second, we add some -p options so that one can specify a protofile in
the configuration file, and then make it so that users can turn on
substituting slashes for spaces in the dirent names in the protofile.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.2
---
 man/man8/mkfs.xfs.8.in |   32 +++++++++++++++++++--
 mkfs/proto.c           |   37 +++++++++++++++++++++++--
 mkfs/proto.h           |    3 +-
 mkfs/xfs_mkfs.c        |   72 +++++++++++++++++++++++++++++++++++++++++++-----
 4 files changed, 129 insertions(+), 15 deletions(-)

