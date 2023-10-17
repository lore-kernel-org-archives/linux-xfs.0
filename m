Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11094CDB482
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Oct 2023 15:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344086AbjJQPqw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235208AbjJQPqj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Oct 2023 11:46:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321D1D69
        for <linux-xfs@vger.kernel.org>; Tue, 17 Oct 2023 08:46:33 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C455AC433C8;
        Tue, 17 Oct 2023 15:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697557592;
        bh=SxXITi4wSyFiFS1GTT/ic8llRa8WeopCWUmXl+GO4aw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=QDgw7foYCJOFDxlsnAEYflKjSzoFLjsjnofmXYpgUzDbZqBJnNbSxVL9fPaEZnG0r
         lBY1BM2rIHzhMcpevWo+JZnoKwdLN5KL6H3TVi2xXN6kMLfHAhmNo2/1VU9ELK4rRo
         hw1sc9L95IVRzCVuhJM4f4AuGO5aRH3g9d0rrisqTSyAsiK01FIBDApVlKnnTm37uE
         r4UACU/bfCZ2nWblwjpTclPsC1gSbqkiyVqHuFl5IOMVVKk8Gj7J1Ya7LAZXU4ucDR
         ltJajrqQjAHBmwn8BwdKU7Y15t0wTt5OPrZs0faWEnoDwi2zoNMU3jIHR5S5GCaGlh
         h1L4MMxJm0Lzg==
Date:   Tue, 17 Oct 2023 08:46:32 -0700
Subject: [PATCHSET RFC v1.1 0/8] xfs: refactor rtbitmap/summary macros
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, osandov@fb.com,
        linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <169755742135.3167663.6426011271285866254.stgit@frogsfrogsfrogs>
In-Reply-To: <169755692527.3152516.2094723855860721089.stg-ugh@frogsfrogsfrogs>
References: <169755692527.3152516.2094723855860721089.stg-ugh@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In preparation for adding block headers and enforcing endian order in
rtbitmap and rtsummary blocks, replace open-coded geometry computations
and fugly macros with proper helper functions that can be typechecked.
Soon we'll be needing to add more complex logic to the helpers.

v1.1: various cleanups suggested by hch

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

With a bit of luck, this should all go splendidly.
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refactor-rtbitmap-macros-6.7
---
 fs/xfs/libxfs/xfs_format.h     |   32 +++--
 fs/xfs/libxfs/xfs_rtbitmap.c   |  270 +++++++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_rtbitmap.h   |  115 +++++++++++++++++
 fs/xfs/libxfs/xfs_trans_resv.c |    9 +
 fs/xfs/libxfs/xfs_types.h      |    2 
 fs/xfs/scrub/rtsummary.c       |   39 +++---
 fs/xfs/scrub/trace.c           |    1 
 fs/xfs/scrub/trace.h           |    4 -
 fs/xfs/xfs_ondisk.h            |    4 +
 fs/xfs/xfs_rtalloc.c           |   39 +++---
 10 files changed, 377 insertions(+), 138 deletions(-)

