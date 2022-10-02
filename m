Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334ACC433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbiJBSZH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229981AbiJBSZG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:25:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8644C16591
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:25:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3AFB5B80D81
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:25:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB979C433C1;
        Sun,  2 Oct 2022 18:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735103;
        bh=RemKJj0+Jscxfs2cQxqmNV1gpkKESiVOZg8h2+htJQE=;
        h=Subject:From:To:Cc:Date:From;
        b=MXvNh3wYfApJgbcc5UQOFkjxNDsGKr7wLQk/ANNINxbevfaBZmHDBE2+ZJrx57Tfg
         qJFA9gJB2D2v1d0CWyI1Xo1Eyq/IKvX5YayOa6CU3PBkDoTz5i6lf1RSWO+9Z2/QOa
         1Wa0UsmKP5JyGdLtGS/9zrJU+e0Kg5diEaNtaLi8uHQ+bSqWVWkC8hZq10ausEwp6i
         YJdo8xm3WfG04DR3jEWhCrQBisd8MVBpGhk1PQW9WXrJMp5gWt0W7BN1bEiqO3I2pg
         axowYHYKWu7NDzOJmFgh7ImdUk1QlfnondXZebDTlCKeiJy+B30NP0aw1bwMPBcksF
         99SAYH9BdWL2A==
Subject: [PATCHSET v23.1 0/4] xfs: strengthen rmapbt scrubbing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:47 -0700
Message-ID: <166473484745.1085478.8596810118667983511.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series strengthens space allocation record cross referencing by
using our improved xbitmaps to compute the difference between space used
according to the rmap records and the primary metadata, and reports
cross-referencing errors for any discrepancies.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-strengthen-rmap-checking
---
 fs/xfs/Makefile       |    2 
 fs/xfs/scrub/bitmap.c |   22 +++
 fs/xfs/scrub/bitmap.h |    1 
 fs/xfs/scrub/rmap.c   |  313 +++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 336 insertions(+), 2 deletions(-)

