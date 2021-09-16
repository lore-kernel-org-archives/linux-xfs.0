Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6585C433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 11:34:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7FF056139F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Sep 2021 11:34:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhIPLfr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Sep 2021 07:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:58172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234769AbhIPLfq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 16 Sep 2021 07:35:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE9B061248;
        Thu, 16 Sep 2021 11:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631792066;
        bh=AzQ59LXEZsX17lBXhJAdRIl0TrT+xb1Y1MbXZuaRj70=;
        h=From:To:Cc:Subject:Date:From;
        b=HYoHmLqGZZqzqS5e/Ymg4NRkkLokYLW60vDGii8UCjAqk+cj2YmgIXPHrQ9+oA7/i
         11XvPvyZl86TRa8A/lAmZt6y72vdG5xKPnGAi77TBWPLpXYH6YzNizz9EIlPh6XFFT
         M7pNDVhcHK9/6J7f2mFc4v+dELlxxldeCC0mrfNh7ekv9PfsCwb54d1NC/o18dj4oY
         jU6nklGVns7amLqG5uIqhHMaxDgyYKlIwJp80+dRQQJS325lU1tWujpfxG0W+fdM4G
         LkQ4cEB8W6dGctXz6rRA+Zlzq92JvNd88EIlftO//i28/ywjzVOdj6zqxJrVW31A5k
         DikBDOFET5GLw==
From:   Sasha Levin <sashal@kernel.org>
To:     stable-commits@vger.kernel.org, djwong@kernel.org
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Patch "iomap: pass writeback errors to the mapping" has been added to the 5.14-stable tree
Date:   Thu, 16 Sep 2021 07:34:24 -0400
Message-Id: <20210916113424.697761-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This is a note to let you know that I've just added the patch titled

    iomap: pass writeback errors to the mapping

to the 5.14-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     iomap-pass-writeback-errors-to-the-mapping.patch
and it can be found in the queue-5.14 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.



commit 140bbef57113ae67aea10307f03bb925df8589d5
Author: Darrick J. Wong <djwong@kernel.org>
Date:   Tue Aug 10 18:32:55 2021 -0700

    iomap: pass writeback errors to the mapping
    
    [ Upstream commit b69eea82d37d9ee7cfb3bf05103549dd4ed5ffc3 ]
    
    Modern-day mapping_set_error has the ability to squash the usual
    negative error code into something appropriate for long-term storage in
    a struct address_space -- ENOSPC becomes AS_ENOSPC, and everything else
    becomes EIO.  iomap squashes /everything/ to EIO, just as XFS did before
    that, but this doesn't make sense.
    
    Fix this by making it so that we can pass ENOSPC to userspace when
    writeback fails due to space problems.
    
    Signed-off-by: Darrick J. Wong <djwong@kernel.org>
    Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
    Signed-off-by: Sasha Levin <sashal@kernel.org>

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 87ccb3438bec..b06138c6190b 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1016,7 +1016,7 @@ iomap_finish_page_writeback(struct inode *inode, struct page *page,
 
 	if (error) {
 		SetPageError(page);
-		mapping_set_error(inode->i_mapping, -EIO);
+		mapping_set_error(inode->i_mapping, error);
 	}
 
 	WARN_ON_ONCE(i_blocks_per_page(inode, page) > 1 && !iop);
