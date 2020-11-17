Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8066EC2D0E4
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 14:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BB6E20773
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Nov 2020 14:09:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NReczbaH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgKQOHP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Nov 2020 09:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729585AbgKQOHN (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Nov 2020 09:07:13 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E38C061A04
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 06:07:13 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id h9so25371786ybj.10
        for <linux-xfs@vger.kernel.org>; Tue, 17 Nov 2020 06:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=rw0Ed4Q8S7/0UOAJg6i7kX2tfO017R1DvnxFGE4XW9w=;
        b=NReczbaHu9/CFRDb3rdYVrym1fzuELIgzmiF/MaA0LhP6McoqXUvIt1+GWqRBSHUSW
         J+G5smAoIdIdorgeztNhxc5Hp2jzPwElnUVFEdjQWy+kWJt6EELV2uvDNshbwBt0Y7wo
         LtGflc9sQoffO21+ojbgkgjZQAzhLGMLASs/yfSH2FQsAesHOqWhKAggyXq2gxHlz+SE
         DQFI5bwzpRHkJ7tf99gWDfp+YGwCb0H3BN0BLLL5HTmVcQ8PQN+kuBK4ssD0De5hmqHp
         yUWCQOUr6+QhXISYNLA6ABu/QiSqy7Dyg2eEiDxT1w50/HuguMcbm2Rsbp2un5DTcsJl
         jNpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=rw0Ed4Q8S7/0UOAJg6i7kX2tfO017R1DvnxFGE4XW9w=;
        b=AY3rj3p9JVSDnLjFr2vhG8uNMKNNTj/4gcpG+vEgOK2+XNKWQozunuolzxZ8W84osM
         U+nYkQ7qOYGoNVaVlX4bKlxLz0P0awEdp3d9gZj6bDeD22Jh1uAeFV4ANXAoIWJvclHA
         +g7xvPwCnuBcNuhO5WbPURDLuyQT1SONDGuXOrUANxA8KW35UTuBKLjftEkB57l5FmGk
         UNXs5eummR4EjoabQcxirO3kW4f7/cOf4+GMsXcRbWre0DrfDC1TuWV0k0g3CLWEjd6O
         pyvxjL2z2Wn2rcwNEPL8W4u6Mka4W0ZtJdSBpZqKj30UaVDcdt+HTwSsUMmMciV+FfhX
         nimA==
X-Gm-Message-State: AOAM532uZwjeikKoNgJIh3Z295AUz9Xwl7lceUN5hwQaAi5nMCI+FLDz
        Ci4f6y1Nh/GstXMZLC7gwAREfipXZQA=
X-Google-Smtp-Source: ABdhPJxLL4xzfVKkB1iKAtBTgSADDClJLbPI3B9hR6JxqH7x/hZVCG3inPAnhmWtUy9asa1KCHNhTeqJtX8=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a25:7083:: with SMTP id l125mr35483953ybc.250.1605622032485;
 Tue, 17 Nov 2020 06:07:12 -0800 (PST)
Date:   Tue, 17 Nov 2020 14:07:00 +0000
Message-Id: <20201117140708.1068688-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH v7 0/8] add support for direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch series adds support for direct I/O with fscrypt using
blk-crypto. It has been rebased on fscrypt/master (i.e. the "master"
branch of the fscrypt tree at
https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git)

Patch 1 ensures that bios are not split in the middle of a crypto data
unit.

Till now, blk-crypto expected the offset and length of each bvec in a bio
to be aligned to the crypto data unit size. Patch 2 enables
blk-crypto-fallback to work without this requirement. It also relaxes the
alignment requirement that blk-crypto checks for - now, blk-crypto only
requires that the length of the I/O is aligned to the crypto data unit
size.

Patch 3 adds two functions to fscrypt that need to be called to determine
if direct I/O is supported for a request.

Patches 4 and 5 modify direct-io and iomap respectively to set bio crypt
contexts on bios when appropriate by calling into fscrypt.

Patches 6 and 7 allow ext4 and f2fs direct I/O to support fscrypt without
falling back to buffered I/O.

Patch 8 updates the fscrypt documentation for direct I/O support.
The documentation now notes the required conditions for inline encryption
and direct I/O on encrypted files.

This patch series was tested by running xfstests with test_dummy_encryption
with and without the 'inlinecrypt' mount option, and there were no
meaningful regressions. One regression was for generic/587 on ext4,
but that test isn't compatible with test_dummy_encryption in the first
place, and the test "incorrectly" passes without the 'inlinecrypt' mount
option - a patch will be sent out to exclude that test when
test_dummy_encryption is turned on with ext4 (like the other quota related
tests that use user visible quota files).

Changes v6 => v7:
 - add patches 1 and 2 to allow blk-crypto to work with user buffers not
   aligned to crypto data unit size, so that direct I/O doesn't require
   that alignment either.
 - some cleanups

Changes v5 => v6:
 - fix bug with fscrypt_limit_io_blocks() and make it ready for 64 bit
   block numbers.
 - remove Reviewed-by for Patch 1 due to significant changes from when
   the Reviewed-by was given.

Changes v4 => v5:
 - replace fscrypt_limit_io_pages() with fscrypt_limit_io_block(), which
   is now called by individual filesystems (currently only ext4) instead
   of the iomap code. This new function serves the same end purpose as
   the one it replaces (ensuring that DUNs within a bio are contiguous)
   but operates purely with blocks instead of with pages.
 - make iomap_dio_zero() set bio_crypt_ctx's again, instead of just a
   WARN_ON() since some folks prefer that instead.
 - add Reviewed-by's

Changes v3 => v4:
 - Fix bug in iomap_dio_bio_actor() where fscrypt_limit_io_pages() was
   being called too early (thanks Eric!)
 - Improve comments and fix formatting in documentation
 - iomap_dio_zero() is only called to zero out partial blocks, but
   direct I/O is only supported on encrypted files when I/O is
   blocksize aligned, so it doesn't need to set encryption contexts on
   bios. Replace setting the encryption context with a WARN_ON(). (Eric)

Changes v2 => v3:
 - add changelog to coverletter

Changes v1 => v2:
 - Fix bug in f2fs caused by replacing f2fs_post_read_required() with
   !fscrypt_dio_supported() since the latter doesn't check for
   compressed inodes unlike the former.
 - Add patches 6 and 7 for fscrypt documentation
 - cleanups and comments

Eric Biggers (5):
  fscrypt: add functions for direct I/O support
  direct-io: add support for fscrypt using blk-crypto
  iomap: support direct I/O with fscrypt using blk-crypto
  ext4: support direct I/O with fscrypt using blk-crypto
  f2fs: support direct I/O with fscrypt using blk-crypto

Satya Tangirala (3):
  block: ensure bios are not split in middle of crypto data unit
  blk-crypto: don't require user buffer alignment
  fscrypt: update documentation for direct I/O support

 Documentation/filesystems/fscrypt.rst |  21 ++-
 block/bio.c                           |   1 +
 block/blk-crypto-fallback.c           | 212 +++++++++++++++++++-------
 block/blk-crypto-internal.h           |  18 +++
 block/blk-crypto.c                    |  19 +--
 block/blk-merge.c                     |  96 ++++++++++--
 block/blk-mq.c                        |   3 +
 block/bounce.c                        |   4 +
 fs/crypto/crypto.c                    |   8 +
 fs/crypto/inline_crypt.c              |  74 +++++++++
 fs/direct-io.c                        |  15 +-
 fs/ext4/file.c                        |  10 +-
 fs/ext4/inode.c                       |   7 +
 fs/f2fs/f2fs.h                        |   6 +-
 fs/iomap/direct-io.c                  |   6 +
 include/linux/fscrypt.h               |  18 +++
 16 files changed, 431 insertions(+), 87 deletions(-)

-- 
2.29.2.299.gdc1121823c-goog

