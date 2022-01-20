Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A78B2C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345540AbiATA1n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:27:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48902 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345543AbiATA1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:27:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A081DB81A7F
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56735C004E1;
        Thu, 20 Jan 2022 00:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642638460;
        bh=5OIxiEn1Fu9LYKnTdbwMzQ4gSNlqvD3V+JeBp3aGlHY=;
        h=Subject:From:To:Cc:Date:From;
        b=OTqc9sNyuEQCqYdAJFnUa0Fa8bt6PNBmI3aWoS2zBjEL4ZMnHJ3y71YnBdpLf6i1L
         oQQhovlcfmFFd4Ai9UXouonPFReNLwQcyoLu/+66xeX3RDk5YtudB5ZTEVaAOvBXwp
         BkWOo9t7hHuNJY3FDddle8Ea52V4ScUAxH9KI8odSV3ONxjaMsXj6QPWbmv0ekewJ5
         7ddE2G39BomXGRGYfXFC6vFCAaYJjnPD3xKvXz2zrqQRFif62zOdkS5hC4CXhb15lm
         4MLt9EMTzy/mM+ydHq7EBnIsDaBDfp7W0+/up9MyD0BBnHrZwsjsa+Tju2V/V7CaCA
         d/2ryxNa75Z4Q==
Subject: [PATCHSET 0/2] xfsprogs: various 5.16 fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:27:40 -0800
Message-ID: <164263846006.874349.12874049913267940808.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Bug fixes for 5.16 include:

 - checking V5 feature bits in secondary superblocks against whatever we
   decide is the primary
 - consistently warning if repair can't check existing rmap and refcount
   btrees

Enjoy!

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-5.16-fixes
---
 repair/agheader.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 repair/phase4.c   |   20 +++---------
 repair/rmap.c     |   65 +++++++++++++++++++++++++++------------
 repair/rmap.h     |    4 +-
 4 files changed, 140 insertions(+), 37 deletions(-)

