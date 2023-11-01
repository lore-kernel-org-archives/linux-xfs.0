Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6571C04E85
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Nov 2023 17:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344562AbjKARnm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 1 Nov 2023 13:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233394AbjKARni (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 1 Nov 2023 13:43:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56CFC115;
        Wed,  1 Nov 2023 10:43:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id B881A21A41;
        Wed,  1 Nov 2023 17:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1698860606; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BsxXilB8VtCWD9uJ48g6IisnMmSxhnqquY6XcPZlAKQ=;
        b=qfnzs8DT7yNoCyRCiEfgwweelCcCNnhDKYjy65J8od5FjaRZYtuQ+qQJhVUCDKTN3Ky0kS
        UhI8vabTpxc8luwHCzWIUJCnps+IwZP9QtTy5BDSSldLovGbrXcHaGu3Kf97dp+LDqjFD2
        D4mtr1ewM2NojGSIJlu+zDox8YodfSM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1698860606;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BsxXilB8VtCWD9uJ48g6IisnMmSxhnqquY6XcPZlAKQ=;
        b=qNX80e5RN09U7lmTJyabsszy6iJuhCmAGejuFXQWPv9qncGkn6WSRUk3YoTtlkdm5lnPIT
        ozEvR31D4EutLUCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A9C821348D;
        Wed,  1 Nov 2023 17:43:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id d8FuKT6OQmUuYQAAMHmgww
        (envelope-from <jack@suse.cz>); Wed, 01 Nov 2023 17:43:26 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
        id E3E89A076D; Wed,  1 Nov 2023 18:43:25 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Christian Brauner <brauner@kernel.org>
Cc:     <linux-fsdevel@vger.kernel.org>, <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@infradead.org>,
        Kees Cook <keescook@google.com>,
        syzkaller <syzkaller@googlegroups.com>,
        Alexander Popov <alex.popov@linux.com>,
        <linux-xfs@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
        Jan Kara <jack@suse.cz>
Subject: [PATCH 5/7] fs: Block writes to mounted block devices
Date:   Wed,  1 Nov 2023 18:43:10 +0100
Message-Id: <20231101174325.10596-5-jack@suse.cz>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231101173542.23597-1-jack@suse.cz>
References: <20231101173542.23597-1-jack@suse.cz>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=744; i=jack@suse.cz; h=from:subject; bh=T/eItSVb7GcAYjznkgJHNYn7HD+3ITlTRTvdImRwJ2E=; b=owEBbQGS/pANAwAIAZydqgc/ZEDZAcsmYgBlQo4ubiwBwif8qp1536oKopFx3GfrPsJ5t7c/7aOj 1jG1waqJATMEAAEIAB0WIQSrWdEr1p4yirVVKBycnaoHP2RA2QUCZUKOLgAKCRCcnaoHP2RA2TkYCA DrJ56qaR1IQHLAf07UimuEs8suyyRufEgDz9zttWEJ7ZIIN0LmxsFinrw7ZJWHbbV/DrKpB0oeX/Uh xE8r6AHulGkMbasTJNABoZDxovW6HqZ8QEWh+1/RdG5p6NloxvvMCdDHILjDQwJtQN6eDfdGuAVjSI q3WTHOfnkh6x6cpuQWEUwTLQWm8FBAOb2sKa3PQaN2Qnus+ukMGqF0JZhX9JpkO46S9ielqaiW3ZUi xuyR4j/7LyNTtjxEDWuQwZT62dkwA3JgaNu6tr1+Gvc1svvBjzwVgf/8pldrHC3dC5i+lmG53BCZTx wzY85qVmI3fqOg587aQp0FyMKTd0oh
X-Developer-Key: i=jack@suse.cz; a=openpgp; fpr=93C6099A142276A28BBE35D815BC833443038D8C
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Ask block layer to block writes to block devices mounted by filesystems.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/blkdev.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0e0c0186aa32..9f6c3373f9fc 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1494,7 +1494,8 @@ extern const struct blk_holder_ops fs_holder_ops;
  * as stored in sb->s_flags.
  */
 #define sb_open_mode(flags) \
-	(BLK_OPEN_READ | (((flags) & SB_RDONLY) ? 0 : BLK_OPEN_WRITE))
+	(BLK_OPEN_READ | BLK_OPEN_RESTRICT_WRITES | \
+	 (((flags) & SB_RDONLY) ? 0 : BLK_OPEN_WRITE))
 
 struct bdev_handle {
 	struct block_device *bdev;
-- 
2.35.3

