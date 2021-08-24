Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51737C4320A
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 07:33:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E5BD61262
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Aug 2021 07:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhHXHeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Aug 2021 03:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbhHXHeV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 Aug 2021 03:34:21 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA937C061575
        for <linux-xfs@vger.kernel.org>; Tue, 24 Aug 2021 00:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aIsgwaJ6eZnVEusmS7q1F79Wrfl+xd3lZzGLR6/5B08=; b=Fofz7VSvRFftH21T4iYs8cRgp4
        MifNSOhE2OkRaAiRCODPFV/amfYOR4YQeNYxnV7L+pVFI338VX88NqZVAPQhm0szuCp73WGSJNaRC
        TiRFufvm2EiWUXvvyAq/pte4QYgApW8tIEr7hOR60KGIvhXGsH92xcUpJ9tBfc6RpgS4udX2WYful
        TtD5Uw01DjFd1fUoIHTdIYXAlVWixY8wSW56c8ZZBrrOcVyvZocz4OmjNCIVjTp5JPnq4IA91u1ec
        c7ZLlyrdMCcc77YSndhgxZnHEmLp1gDmTyaTYAmPvSBHEdi5+u6IsiofPvwfpcEq+qvnVvS+MNvp0
        Htf0aWVg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mIQvb-00Aijz-1L; Tue, 24 Aug 2021 07:33:12 +0000
Date:   Tue, 24 Aug 2021 08:32:59 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: only set IOMAP_F_SHARED when providing a srcmap to
 a write
Message-ID: <YSSgq3RE5kB+TC7b@infradead.org>
References: <20210824003739.GC12640@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210824003739.GC12640@magnolia>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This looks fine.  But the cmap flag somehow tripped me up, and while
looking for a better name I just came up with the variant below that
avoids the need for the local variable entirely.  Either version is
fine with me:

Reviewed-by: Christoph Hellwig <hch@lst.de>

---
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index d8cd2583dedbf..66f138437b425 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1064,11 +1064,11 @@ xfs_buffered_write_iomap_begin(
 		error = xfs_bmbt_to_iomap(ip, srcmap, &imap, 0);
 		if (error)
 			return error;
-	} else {
-		xfs_trim_extent(&cmap, offset_fsb,
-				imap.br_startoff - offset_fsb);
+		return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
 	}
-	return xfs_bmbt_to_iomap(ip, iomap, &cmap, IOMAP_F_SHARED);
+
+	xfs_trim_extent(&cmap, offset_fsb, imap.br_startoff - offset_fsb);
+	return xfs_bmbt_to_iomap(ip, iomap, &cmap, 0);
 
 out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
