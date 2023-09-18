Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E45ACD3424
	for <linux-xfs@archiver.kernel.org>; Mon, 18 Sep 2023 23:12:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjIRXMM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 19:12:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjIRXML (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2023 19:12:11 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3785890;
        Mon, 18 Sep 2023 16:12:06 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B2CC433C8;
        Mon, 18 Sep 2023 23:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695078725;
        bh=DYUrraa5d+0gdnnutT4NvEXRrBNI5SLRUy1a1wNggtg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ePRKYxzhCvowevrvmlBEmHxWvDnISsHNsnPKpDU8rpAQI0M3n3hiOkVzoKE7FDWnc
         rCw6A7Et1KrqtENl5w4A/2UGIKnSOvvFQ5+XLNNO0ZUObPAbaK+ZQNzNhUJwkHt4Gf
         7it3shF76fiwO4NACW3er/IPueRVd9HMKrD/okbkRCCNmu3/iK2gncNdUxJukiP2fi
         /wc9nQ2bJhelHfhHzNLai7aehdhu1dDzP8HFAP0up0UtpGgic0l77O+IslF0VdQxZL
         tJ+IG6R8QXbnwKzpqZsBuNuRm/H/NhYX1g2ITTl4wRTOQwwELPy3a5ymAo1bHO6bQd
         Spnqx9gX/ycbQ==
Subject: [PATCH 1/2] iomap: don't skip reading in !uptodate folios when
 unsharing a range
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     ritesh.list@gmail.com, willy@infradead.org,
        linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
        ritesh.list@gmail.com, willy@infradead.org
Date:   Mon, 18 Sep 2023 16:12:05 -0700
Message-ID: <169507872536.772278.18183365318216726644.stgit@frogsfrogsfrogs>
In-Reply-To: <169507871947.772278.5767091361086740046.stgit@frogsfrogsfrogs>
References: <169507871947.772278.5767091361086740046.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Prior to commit a01b8f225248e, we would always read in the contents of a
!uptodate folio prior to writing userspace data into the folio,
allocated a folio state object, etc.  Ritesh introduced an optimization
that skips all of that if the write would cover the entire folio.

Unfortunately, the optimization misses the unshare case, where we always
have to read in the folio contents since there isn't a data buffer
supplied by userspace.  This can result in stale kernel memory exposure
if userspace issues a FALLOC_FL_UNSHARE_RANGE call on part of a shared
file that isn't already cached.

This was caught by observing fstests regressions in the "unshare around"
mechanism that is used for unaligned writes to a reflinked realtime
volume when the realtime extent size is larger than 1FSB, though I think
it applies to any shared file.

Cc: ritesh.list@gmail.com, willy@infradead.org
Fixes: a01b8f225248e ("iomap: Allocate ifs in ->write_begin() early")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/iomap/buffered-io.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)


diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index ae8673ce08b1..0350830fc989 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -640,11 +640,13 @@ static int __iomap_write_begin(const struct iomap_iter *iter, loff_t pos,
 	size_t poff, plen;
 
 	/*
-	 * If the write completely overlaps the current folio, then
+	 * If the write or zeroing completely overlaps the current folio, then
 	 * entire folio will be dirtied so there is no need for
 	 * per-block state tracking structures to be attached to this folio.
+	 * For the unshare case, we must read in the ondisk contents because we
+	 * are not changing pagecache contents.
 	 */
-	if (pos <= folio_pos(folio) &&
+	if (!(iter->flags & IOMAP_UNSHARE) && pos <= folio_pos(folio) &&
 	    pos + len >= folio_pos(folio) + folio_size(folio))
 		return 0;
 

