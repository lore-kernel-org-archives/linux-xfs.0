Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47C2CC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 May 2022 16:04:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381616AbiEEQIA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 May 2022 12:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379571AbiEEQH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 May 2022 12:07:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A4B05712C
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 09:04:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CEEB0B82DEF
        for <linux-xfs@vger.kernel.org>; Thu,  5 May 2022 16:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF25C385AC;
        Thu,  5 May 2022 16:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651766654;
        bh=XvchizxKJUzCY/pMz/nuxYsyLFlpu0fMlIE56CYc5mE=;
        h=Subject:From:To:Cc:Date:From;
        b=Z5H6JNr+thyAfptcqZQPlVM+0smHIT2qEG+YiELbHM5S/Xv15F2TJSN6dAIedAfWM
         +x/vclzYbtnh6kOBhhYAWz6+US9jEj47xczrVhybuBVaLc1JnbiBLLmGlIliDfXX78
         SWH5ctfxkcGSW1c18GGrTaYCcKbDQmphkT3vo3qt+L07A4FCJVu0pkkCGAHuquPSCI
         wPDtIxFJl32fp3OWPmxKKXGZMzPhArN2YL7QF7LL8uwA9GPLwyK/78cgNpbfVQOGUP
         l8XDfEAYGiQRJa6vaec8XVZHM5gWIW6Xlzx5zyYurHpIG6jxBxhGFhUs6mopK57uyx
         MsZFJAn4YsgJQ==
Subject: [PATCHSET 0/2] xfs_db/xfs_repair: warn about bad btree heights
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 05 May 2022 09:04:14 -0700
Message-ID: <165176665416.246985.13192803422215905607.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While I was backporting 5.16 to libxfs, I noticed that repair and
metadump don't completely check the btree heights stored in the AGF/AGI
headers.  This series corrects that problem by making them all check.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=warn-bad-btree-levels
---
 db/metadump.c |   15 +++++++++++++++
 repair/scan.c |   29 ++++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

