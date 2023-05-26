Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA048C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjEZAcG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbjEZAcF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:32:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD252195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61C6964B2A
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C502FC433EF;
        Fri, 26 May 2023 00:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685061123;
        bh=b4Ii1y4zFZF8euxcU31L/ZfxZdic+9CXRlR9Rd5D4j0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Ac03K26X3MgjgtIDM31y9HZZa3BlbpwNwDZG10yibhhZYKDcPVDgvRAqX+KFeTqLa
         uU+YC6j/gkcP5LgN0XC8hKKlZ/sEQdelpn6yKhQRVSrCTp5xKIvplGT0ZZcPXc+Iwg
         WYp9ZcWml+c+hYHdRFOYfzIYOVYBOI8YQurNoQit7yOQLqQltKGysFgGpCbnU32sWv
         5LzpN6RopnszuU7FTl7anXtGDkclyPAQlmA5JeKghbjlng7S5uVLUC8bGEA45mj790
         CnSypsY5Hya5X5paJOD9LzSjYWUrkAh6XwHxE6qJHdD9xSKXaRGzVVXLxzI4gPsfwP
         PG9qDKR22XThw==
Date:   Thu, 25 May 2023 17:32:03 -0700
Subject: [PATCHSET v25.0 0/3] xfs: indirect health reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506061141.3732817.12069555992432067658.stgit@frogsfrogsfrogs>
In-Reply-To: <20230526000020.GJ11620@frogsfrogsfrogs>
References: <20230526000020.GJ11620@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series enables the XFS health reporting infrastructure to remember
indirect health concerns when resources are scarce.  For example, if a
scrub notices that there's something wrong with an inode's metadata but
memory reclaim needs to free the incore inode, we want to record in the
perag data the fact that there was some inode somewhere with an error.
The perag structures never go away.

The first two patches in this series set that up, and the third one
provides a means for xfs_scrub to tell the kernel that it can forget the
indirect problem report.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=indirect-health-reporting

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=indirect-health-reporting
---
 fs/xfs/libxfs/xfs_fs.h        |    4 ++
 fs/xfs/libxfs/xfs_health.h    |   45 ++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_buf.c |    2 +
 fs/xfs/scrub/health.c         |   76 ++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/scrub/health.h         |    1 +
 fs/xfs/scrub/repair.c         |    1 +
 fs/xfs/scrub/scrub.c          |    6 +++
 fs/xfs/scrub/trace.h          |    4 ++
 fs/xfs/xfs_health.c           |   25 +++++++++----
 fs/xfs/xfs_inode.c            |   35 +++++++++++++++++++
 fs/xfs/xfs_trace.h            |    1 +
 11 files changed, 188 insertions(+), 12 deletions(-)

