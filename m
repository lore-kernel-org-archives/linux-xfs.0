Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0F8AC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 27 Apr 2022 00:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355532AbiD0Ayk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Apr 2022 20:54:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356519AbiD0Ayi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Apr 2022 20:54:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C398A13DC5
        for <linux-xfs@vger.kernel.org>; Tue, 26 Apr 2022 17:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 810FEB823F5
        for <linux-xfs@vger.kernel.org>; Wed, 27 Apr 2022 00:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23955C385A4;
        Wed, 27 Apr 2022 00:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651020686;
        bh=JTMPh/peUfubVMWtmn+6XVIC5KEkJWnz3FI/jQ6AeEk=;
        h=Subject:From:To:Cc:Date:From;
        b=bgDF47sIXyxMBbLvkHgKRjq7SZxyu6WKHf6+UX1GeyHRJPqjp+XDeI46r9vNnazvW
         ryaRA60aATBXNb0QEBoIChivbzG3GQwXU7kq9HO1S8g0dkAnufbhBZBU2gNXAHCLq1
         QK11zrIwYoNWSNbCpTRosjp//Tq+HfXM+fRKH5OCGRbGwTazbdZF7v1tMNUNnhO8z3
         zAjJzXRnjQdGXUlkd6NBQ0j7NwTVGzpbgMp7YLT7yi8NLlZ2ZFd/88/shfdleUss68
         lXcenaRknwbAxUvTAwEs12yd0tT+D0NxP0olxO2ofFvttD6vgbJlyoKWlBeha3NMo/
         T6TQ5UJEQxv2Q==
Subject: [PATCHSET v2 0/4] xfs: fix rmap inefficiencies
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, david@fromorbit.com
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        linux-xfs@vger.kernel.org
Date:   Tue, 26 Apr 2022 17:51:25 -0700
Message-ID: <165102068549.3922526.15959517253241370597.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Reduce the performance impact of the reverse mapping btree when reflink
is enabled by using the much faster non-overlapped btree lookup
functions when we're searching the rmap index with a fully specified
key.  If we find the exact record we're looking for, great!  We don't
have to perform the full overlapped scan.  For filesystems with high
sharing factors this reduces the xfs_scrub runtime by a good 15%.

This has been shown to reduce the fstests runtime for realtime rmap
configurations by 30%, since the lack of AGs severely limits
scalability.

v2: simplify the non-overlapped lookup code per dave comments

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rmap-speedups-5.19
---
 fs/xfs/libxfs/xfs_rmap.c |  161 +++++++++++++++++++++++++++-------------------
 fs/xfs/libxfs/xfs_rmap.h |    7 +-
 fs/xfs/scrub/bmap.c      |   24 +------
 fs/xfs/xfs_trace.h       |    5 +
 4 files changed, 106 insertions(+), 91 deletions(-)

