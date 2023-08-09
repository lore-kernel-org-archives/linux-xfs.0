Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE271C07E8E
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Aug 2023 22:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbjHIWGB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 18:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233043AbjHIWF5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 18:05:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B81C212A;
        Wed,  9 Aug 2023 15:05:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xK+hj1hEYeZWT3M55/B6bE7sbXHBn8KbDjMjOOEHDF0=; b=4ZnuSNHinXvVhvWuz8x0n0kaA0
        jGNBdR3F5YwmW6TXCIkkFevmVBDSipJ9X7m31kswlqafmNkiK0tg7biZq/XtKLqJk4V4w6oCP2kFT
        tN2p7l0c/UciVAfrlnwUl29Kbu4xHjelWWqpx2B9XxkYBBO/Ohug4xUfy4gJLkg6S+xSIGiEqu7DT
        cufsTMZAoT73lP6chubHkr4IpbaeokvUQjGKxjkNyGlGoavJ0/aIAwS3j6qivHvKFW1GnPnTYxgma
        bSybWN2h5TJI8UhEU6/C77vBgrj0lzAcKBGtMeg4Rl7q+l7q6URNEclaSW1W0A0xmonYv9zRXwC0I
        XIryUxVQ==;
Received: from [4.28.11.157] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qTrJO-005xp3-0e;
        Wed, 09 Aug 2023 22:05:50 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sungjong Seo <sj1557.seo@samsung.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ntfs3@lists.linux.dev, linux-xfs@vger.kernel.org
Subject: [PATCH 12/13] ntfs3: don't call sync_blockdev in ntfs_put_super
Date:   Wed,  9 Aug 2023 15:05:44 -0700
Message-Id: <20230809220545.1308228-13-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230809220545.1308228-1-hch@lst.de>
References: <20230809220545.1308228-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

kill_block_super will call sync_blockdev just a tad later already.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christian Brauner <brauner@kernel.org>
---
 fs/ntfs3/super.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/ntfs3/super.c b/fs/ntfs3/super.c
index bb985d3756d949..727138933a9324 100644
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -629,8 +629,6 @@ static void ntfs_put_super(struct super_block *sb)
 	put_mount_options(sbi->options);
 	ntfs3_free_sbi(sbi);
 	sb->s_fs_info = NULL;
-
-	sync_blockdev(sb->s_bdev);
 }
 
 static int ntfs_statfs(struct dentry *dentry, struct kstatfs *buf)
-- 
2.39.2

