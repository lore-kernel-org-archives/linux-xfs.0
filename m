Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0453C0018A
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Nov 2023 17:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232508AbjKARnf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Nov 2023 13:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231974AbjKARnd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 13:43:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E747DC1;
        Wed,  1 Nov 2023 10:43:27 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7073C1F74D;
        Wed,  1 Nov 2023 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1698860606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BKgU7PXImH1iO/Gfidz43SCBxUDiM+b1vjlZXIIJoLw=;
        b=qT0SdyxC7R3WLtfNwZ+LOMxOmkeVc2EUmFHzRsAJQAqtgnzskRtCU1/whUV8EaITQDDtpR
        0EHnK+43adFUTMMUHm1pj7fwQVb+9/GhvA8nAHCmMxnRJydjxLD4OqkyjAHK/JojzGkTop
        w8v5wR8X6uGNdCREOai98OrAlNPMT0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1698860606;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BKgU7PXImH1iO/Gfidz43SCBxUDiM+b1vjlZXIIJoLw=;
        b=gHqMXehBHu4edaJ6i3SAX0Y2E5Dw1F7tX7ckof6E7QNMBJh0ZHpNNq+gRel88g/d6SKrp8
        z4/3Lao7E5MzGLCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 572C013ADB;
        Wed,  1 Nov 2023 17:43:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id N8rHFD6OQmUlYQAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 01 Nov 2023 17:43:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id C7ED7A06E5; Wed,  1 Nov 2023 18:43:25 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Christian Brauner <brauner@kernel.org>
Cc:     <linux-fsdevel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        <linux-xfs@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
        Jan Kara <jack@suse.cz>,
        Kent Overstreet <kent.overstreet@linux.dev>,
        Brian Foster <bfoster@redhat.com>,
        linux-bcachefs@vger.kernel.org
Subject: [PATCH 1/7] bcachefs: Convert to bdev_open_by_path()
Date:   Wed,  1 Nov 2023 18:43:06 +0100
Message-Id: <20231101174325.10596-1-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231101173542.23597-1-jack@suse.cz>
References: <20231101173542.23597-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2324; i=jack@suse.cz; h=from:subject; bh=Ob0PQzZ8Jq9WpAfJA+ZOLADwBqFzDEL4g6I7733eXBQ=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBlQo4qfY1b5vP0uNrwSfo0fCP5xtWPQ9ln3zTqpPUy F4mIL3aJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZUKOKgAKCRCcnaoHP2RA2fAzCA ChaPW1pZOanUyhjpFIhk50n7Cx6o2p9BvjqUsTzxPUUz6G+ZTyh35hpl9h4YHpckxjPFED8MtyL4AM EucBwvED00occzs6RxvHRQMfIGpuS6iqwnKnfZNSOVt/Vu19mh4deH5bpAxLj3anctfGzlJqjtZFOh yIBbw0RN3YnJWFyz6KoEkMbh8NGhNI4UkqhPlp9bPBINY8dXm5C5SKC1rbsMJ86/hW8xQlr2KIYZSc zZbMQOtNeOk4UXvrKV3ofQvEukJdqmHPrGt+i8Hf7Ebn40zaC7IbxeDfNi6PTfNgGI+kHVhmOj8CdC htqlWP5IT3AoEpVEokTfrUCLiA12pA
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Convert bcachefs to use bdev_open_by_path() and pass the handle around.

CC: Kent Overstreet <kent.overstreet@linux.dev>
CC: Brian Foster <bfoster@redhat.com>
CC: linux-bcachefs@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/bcachefs/super-io.c    | 19 ++++++++++---------
 fs/bcachefs/super_types.h |  1 +
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/bcachefs/super-io.c b/fs/bcachefs/super-io.c
index 332d41e1c0a3..01a32c41a540 100644
--- a/fs/bcachefs/super-io.c
+++ b/fs/bcachefs/super-io.c
@@ -162,8 +162,8 @@ void bch2_sb_field_delete(struct bch_sb_handle *sb,
 void bch2_free_super(struct bch_sb_handle *sb)
 {
 	kfree(sb->bio);
-	if (!IS_ERR_OR_NULL(sb->bdev))
-		blkdev_put(sb->bdev, sb->holder);
+	if (!IS_ERR_OR_NULL(sb->bdev_handle))
+		bdev_release(sb->bdev_handle);
 	kfree(sb->holder);
 
 	kfree(sb->sb);
@@ -685,21 +685,22 @@ int bch2_read_super(const char *path, struct bch_opts *opts,
 	if (!opt_get(*opts, nochanges))
 		sb->mode |= BLK_OPEN_WRITE;
 
-	sb->bdev = blkdev_get_by_path(path, sb->mode, sb->holder, &bch2_sb_handle_bdev_ops);
-	if (IS_ERR(sb->bdev) &&
-	    PTR_ERR(sb->bdev) == -EACCES &&
+	sb->bdev_handle = bdev_open_by_path(path, sb->mode, sb->holder, &bch2_sb_handle_bdev_ops);
+	if (IS_ERR(sb->bdev_handle) &&
+	    PTR_ERR(sb->bdev_handle) == -EACCES &&
 	    opt_get(*opts, read_only)) {
 		sb->mode &= ~BLK_OPEN_WRITE;
 
-		sb->bdev = blkdev_get_by_path(path, sb->mode, sb->holder, &bch2_sb_handle_bdev_ops);
-		if (!IS_ERR(sb->bdev))
+		sb->bdev_handle = bdev_open_by_path(path, sb->mode, sb->holder, &bch2_sb_handle_bdev_ops);
+		if (!IS_ERR(sb->bdev_handle))
 			opt_set(*opts, nochanges, true);
 	}
 
-	if (IS_ERR(sb->bdev)) {
-		ret = PTR_ERR(sb->bdev);
+	if (IS_ERR(sb->bdev_handle)) {
+		ret = PTR_ERR(sb->bdev_handle);
 		goto out;
 	}
+	sb->bdev = sb->bdev_handle->bdev;
 
 	ret = bch2_sb_realloc(sb, 0);
 	if (ret) {
diff --git a/fs/bcachefs/super_types.h b/fs/bcachefs/super_types.h
index 78d6138db62d..b77d8897c9fa 100644
--- a/fs/bcachefs/super_types.h
+++ b/fs/bcachefs/super_types.h
@@ -4,6 +4,7 @@
 
 struct bch_sb_handle {
 	struct bch_sb		*sb;
+	struct bdev_handle	*bdev_handle;
 	struct block_device	*bdev;
 	struct bio		*bio;
 	void			*holder;
-- 
2.35.3

