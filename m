Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13A33C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiL3XF0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230074AbiL3XFZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:05:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40B41CFD0
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:05:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EA0A61BB9
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B2DC433EF;
        Fri, 30 Dec 2022 23:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441523;
        bh=wxHzXouCI7f4OwJ/SQAEOfu3QVArUaYmCae0+WjATBs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nBC0nvI9SuXEwW4Rdln4jxyP6+agIEUbhSA+lfS0r6LcmoxNmzXF1F+5CR04bVSDo
         SWg/+v2pzXm217GXWlMoeqraStkB/6bCMLx3uLty2l1tTQDGbrSgREB5W+cVsOuQpo
         iXIL54Ddtwzt/faJo1jpRPL5KpNqfKyHvZ9TMYhDDGLtLkE/aynmgUfa/LtifFYtVb
         NMmjfjsPQcxqp0fpNZnLvOv0p5w6F3M5rxzXHg5Kvo4Hq2qjPw8M2fL9GwVi7XQ6w4
         3LjlhvOqZnpb8VHOxNZBwxVgeB83MZzlQ4nnjenJlaJzQ4JTNiet/vEFyN0KW4No5U
         Sct1gIifmffcQ==
Subject: [PATCHSET v24.0 0/4] xfs: widen BUI formats to support realtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:44 -0800
Message-ID: <167243842459.699102.4471319762222972730.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Atomic extent swapping (and later, reverse mapping and reflink) on the
realtime device needs to be able to defer file mapping and extent
freeing work in much the same manner as is required on the data volume.
Make the BUI log items operate on rt extents in preparation for atomic
swapping and realtime rmap.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-bmap-intents

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-bmap-intents
---
 fs/xfs/libxfs/xfs_bmap.c       |   24 +++++-------------------
 fs/xfs/libxfs/xfs_log_format.h |    4 +++-
 fs/xfs/libxfs/xfs_rtbitmap.c   |   33 +++++++++++++++++++++++++++++++++
 fs/xfs/xfs_bmap_item.c         |   17 +++++++++++++++++
 fs/xfs/xfs_rtalloc.h           |    5 +++++
 fs/xfs/xfs_trace.h             |   23 ++++++++++++++++++-----
 6 files changed, 81 insertions(+), 25 deletions(-)

