Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635B8C3A5A6
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 00:20:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3191C217D6
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 00:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568938814;
	bh=whtg9oZhhQ83/SMR4ITmKU6t73b04BUAGMv2yYLZ73M=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=vcvyoKegrqkClT6hj7E6P9aCWuuYdAJNeM34nCa4taxMXW7zksuNucaEO/kXql0FV
	 36XLG7twLNqeN/vMoHJPzlLa05n1+oHkSb4TZQb1fEJwGF2SjutQCfU/t6eL3Uj/Fd
	 j5yQnEeR78G9u7rq0lV2a7kCV6NQzP17mBNTTt/4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391335AbfITAUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 20:20:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390558AbfITAUF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 20:20:05 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AF99217D6;
        Fri, 20 Sep 2019 00:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568938802;
        bh=whtg9oZhhQ83/SMR4ITmKU6t73b04BUAGMv2yYLZ73M=;
        h=From:To:Cc:Subject:Date:From;
        b=Lg59m7Z5sr0N36PDZL/d7z82z2lq2EsJHItwLW5m5fUVwQd9xxQa8aEYGpdDSACyc
         hdNdIPOyB79InVf8ka0hWPMxayUoYeeLBKwCalIntbc8SnQ3PG+r0ftEVaWkU6p+0u
         beOxedWi7l3j31DMWwhRfC+sl4Z9ZAdOYAJXh+y8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-xfs@vger.kernel.org
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 0/8] xfsprogs: support fscrypt API additions in xfs_io
Date:   Thu, 19 Sep 2019 17:18:14 -0700
Message-Id: <20190920001822.257411-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello,

This patchset updates xfs_io to support the new fscrypt ioctls that were
merged for 5.4 (https://git.kernel.org/torvalds/c/734d1ed83e1f9b7b).

New commands are added to wrap the new ioctls to manage filesystem
encryption keys: 'add_enckey', 'rm_enckey', and 'enckey_status'.  Also,
the existing 'get_encpolicy' and 'set_encpolicy' commands are updated to
support getting/setting v2 encryption policies.

The purpose of all this is to allow xfstests to test these new APIs.

Note: currently only ext4, f2fs, and ubifs support encryption.  But I
was told previously that since the fscrypt API is generic and may be
supported by XFS in the future, the command-line wrappers for the
fscrypt ioctls should be in xfs_io rather than in xfstests directly
(https://marc.info/?l=fstests&m=147976255831951&w=2).

This patchset applies to the latest "for-next" branch of xfsprogs
(commit ac8b6c380865).  It can also be retrieved from tag
"fscrypt-key-mgmt-improvements_2019-09-19" of
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/xfsprogs-dev.git

No changes since v1 other than rebasing.

Eric Biggers (8):
  xfs_io/encrypt: remove unimplemented encryption modes
  xfs_io/encrypt: update to UAPI definitions from Linux v5.4
  xfs_io/encrypt: add new encryption modes
  xfs_io/encrypt: extend 'get_encpolicy' to support v2 policies
  xfs_io/encrypt: extend 'set_encpolicy' to support v2 policies
  xfs_io/encrypt: add 'add_enckey' command
  xfs_io/encrypt: add 'rm_enckey' command
  xfs_io/encrypt: add 'enckey_status' command

 io/encrypt.c      | 786 ++++++++++++++++++++++++++++++++++++++++------
 man/man8/xfs_io.8 |  70 ++++-
 2 files changed, 750 insertions(+), 106 deletions(-)

-- 
2.23.0.351.gc4317032e6-goog

