Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DB92C43214
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A76F60F6B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233041AbhG1AKC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:10:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232989AbhG1AKC (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:10:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8AFB4601FC;
        Wed, 28 Jul 2021 00:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627431001;
        bh=7vt9D71J0ut4UeGNTeX0B+0l+sT7wk/wTtjha2bndGw=;
        h=Subject:From:To:Cc:Date:From;
        b=lVxYZf0zKp6kXBXl1H0+YWzE8dqgZllsv7OAf2zJypoQbOHLPcKpDJsNTKLhBO6P+
         BaGSb+4qfSL1l/05nm//26DSNUofkrvu0K/KB/5jhnzsazINzcVq/TrSU38lThPvFx
         zM3KGUZW+PQRKqpzhVAUybxx8FNXcCu/+x9PkZSfb1Q5yE5+E5BplWxoph9CfJohdh
         6ZErUk93dCv3koI2FgvkfUh/d7iW44FZQx96rQlZp6GRACXrl1exKQSTMcYDHqJT+U
         FUldy3ZGzjxUCnE6qNcdHtAX5DOghbmVg6uFyIWEMNlQ4ugMFpynPLeT1MPJAy4HuF
         EVBt+JVbEWC9Q==
Subject: [PATCHSET 0/3] fstests: regression tests for 5.13/5.14 rt fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:10:01 -0700
Message-ID: <162743100128.3428143.7362558731136046380.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add regression tests to trigger some bugs in the realtime allocator that
were fixed in kernel 5.13 and 5.14.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=realtime-fixes
---
 tests/xfs/774     |   78 +++++++++++++++++++++++++
 tests/xfs/774.out |    5 ++
 tests/xfs/775     |  165 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/775.out |    3 +
 tests/xfs/776     |   57 ++++++++++++++++++
 tests/xfs/776.out |    5 ++
 tests/xfs/779     |  112 ++++++++++++++++++++++++++++++++++++
 tests/xfs/779.out |    2 +
 8 files changed, 427 insertions(+)
 create mode 100755 tests/xfs/774
 create mode 100644 tests/xfs/774.out
 create mode 100755 tests/xfs/775
 create mode 100644 tests/xfs/775.out
 create mode 100755 tests/xfs/776
 create mode 100644 tests/xfs/776.out
 create mode 100755 tests/xfs/779
 create mode 100644 tests/xfs/779.out

