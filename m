Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32EBCC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:02:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiLaBBu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235809AbiLaBBt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:01:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0567F1DDE4
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:01:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ADF17B81E52
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CA1BC433D2;
        Sat, 31 Dec 2022 01:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448506;
        bh=5mim0xfNsn1wVWeeFVTqUdh9qgwcsYmavr3CtLJYoP4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fmG7sWbK84wySRdzG9gcxeSKlXMy2/qmjN+G9JhB4P1pA+SUnBvHOldTbh+YRwiyd
         nuR8GjrKwMFxpS02rnEVIKt1dG6UGu1Bh2z8aTtJadZJB7+kiuM2nSUUEoFOQIYfkL
         XwdIuTgRCRsZvWD2DdX5EThLvVyO0G+cQ4FFBYSfY2CVhFC56dXNoLeU82Zo0c6aem
         qknzA33k8aNEENAlVJmTg8CTKTz8vUJJoyp5GCceLK4FyLYEWMdxYA2OvgKscZFw8h
         QjWZEr/95c+OkKBl6e76tsaIlnnf8a6PRunCEaorTOl+w+iru+gppkW2WL2Akob52j
         ZaiSBPTuA8Gkw==
Subject: [PATCHSET v1.0 0/3] libxfs: widen EFI format to support rt
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:52 -0800
Message-ID: <167243879231.732626.2849871285052288588.stgit@magnolia>
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

Realtime reverse mapping (and beyond that, realtime reflink) needs to be
able to defer file mapping and extent freeing work in much the same
manner as is required on the data volume.  Make the extent freeing log
items operate on rt extents in preparation for realtime rmap.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=realtime-extfree-intents

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=realtime-extfree-intents
---
 libxfs/defer_item.c     |   18 ++++++++++++++++++
 libxfs/xfs_alloc.c      |   35 ++++++++++++++++++++++++++++-------
 libxfs/xfs_alloc.h      |   17 +++++++++++++++--
 libxfs/xfs_defer.c      |    1 +
 libxfs/xfs_defer.h      |    1 +
 libxfs/xfs_log_format.h |    7 +++++++
 libxfs/xfs_rtbitmap.c   |    4 ++++
 logprint/log_redo.c     |   20 ++++++++++++++++----
 8 files changed, 90 insertions(+), 13 deletions(-)

