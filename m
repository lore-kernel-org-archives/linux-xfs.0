Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7200EC19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 21:08:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiHIVIQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 17:08:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiHIVGv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 17:06:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628714A80F
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 14:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CC8D60BD6
        for <linux-xfs@vger.kernel.org>; Tue,  9 Aug 2022 21:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05A9C433C1;
        Tue,  9 Aug 2022 21:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660079206;
        bh=LuSUJShggl7IusWd1h2yFRo3z/EUcDU5a9vjizQ7EsA=;
        h=Subject:From:To:Cc:Date:From;
        b=KTtvmzY1DJVssSfSDXmDKqGbNLg0susBgsNMXATb5CTAkY0dGU/u69zQDNQQVbmv4
         7k8s6/B0JtPkxKRuKbGkVqQNeuWMAHvlJiyQBblaMCspzfBPeVhV9dhDsCzHZUAwRv
         qR22gduKYS2nUPkvKyyOB9jhAOdVAJ0RLJSyIORWt0iUbMCSYi28nN0nzEMkXQe+yN
         4DBcTGfo0faIBCEDi6ynimu/w/wf7yryUwKtlo2XEnVGXsXxmCEOrQo5do+NLiSyYt
         n+v7VfHiZNIvz2MsGOxRz1z9qhcexfSs/c4aZWLQ7WZZl7KeJmiV6NRSq+lVz9PHOk
         NCorDYS6QTIOw==
Subject: [PATCHSET v2 0/2] xfsprogs: random fixes for 5.19
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 09 Aug 2022 14:06:46 -0700
Message-ID: <166007920625.3294543.10714247329798384513.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a rollup of all the random fixes I've collected for xfsprogs
5.19.  At this point it's just an assorted collection, no particular
theme.  Some of them are leftovers from last week's posting.

v2: note the actual cause (too small filesystem) when we abort due to
    impossible log geometry

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
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/libxfs_io.h       |    1 +
 libxfs/rdwr.c            |    8 +++++
 logprint/log_misc.c      |    8 ++---
 repair/bmap.c            |    8 ++---
 repair/phase2.c          |    8 +++++
 repair/protos.h          |    1 +
 repair/xfs_repair.c      |   75 ++++++++++++++++++++++++++++++++++++++++------
 8 files changed, 94 insertions(+), 17 deletions(-)

