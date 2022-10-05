Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB491C433FE
	for <linux-xfs@archiver.kernel.org>; Wed,  5 Oct 2022 22:30:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiJEWat (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Oct 2022 18:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiJEWas (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Oct 2022 18:30:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB9A1EEC4;
        Wed,  5 Oct 2022 15:30:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0885B81F7A;
        Wed,  5 Oct 2022 22:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D19BC433C1;
        Wed,  5 Oct 2022 22:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665009044;
        bh=fJPK+wpWaJL3FodWHs2P+KK7vPpUul/5CWtq5gJQX3k=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=IJJMse6S8XPlkS47Nh1P/nTRfkexFG6g2mLUMU19MYUAUiRzT1tp8lYXCvO9q6GBq
         aePLvdD3bDYujpMdD8tilIg0kYKVzWqrsLPadzArqOD90BzDxwzMVt2BdZUgN7xq2H
         f8Bce7dJQL+PYEbi72tZ5hvW9aUD+uEdwDve2tnnDOe6eijxZNbcM+ZUcdIRc1MxSx
         oWFUzzrah9AUySR6Nvui5gnwG8eTMEdYzg349yfIIpRJ4CKE4YjZnQl6oKfk8z9scx
         Fc8KlN05L+WDbHzNUA2ZAHd28qxIU1Jex2RQ6FAQ6oZxZFazV5cDoWWu2ymKoGZNWf
         Z7PWczHZ88KrQ==
Subject: [PATCH 2/6] xfs/114: fix missing reflink requires
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 05 Oct 2022 15:30:44 -0700
Message-ID: <166500904418.886939.1997572513247565981.stgit@magnolia>
In-Reply-To: <166500903290.886939.12532028548655386973.stgit@magnolia>
References: <166500903290.886939.12532028548655386973.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

This test both requires cp --reflink and the scratch filesystem to
support reflink.  Add the missing _requires calls.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Zorro Lang <zlang@redhat.com>
---
 tests/xfs/114 |    2 ++
 1 file changed, 2 insertions(+)


diff --git a/tests/xfs/114 b/tests/xfs/114
index 3aec814a5d..858dc3998e 100755
--- a/tests/xfs/114
+++ b/tests/xfs/114
@@ -18,6 +18,8 @@ _begin_fstest auto quick clone rmap collapse insert
 # real QA test starts here
 _supported_fs xfs
 _require_test_program "punch-alternating"
+_require_cp_reflink
+_require_scratch_reflink
 _require_xfs_scratch_rmapbt
 _require_xfs_io_command "falloc"
 _require_xfs_io_command "fcollapse"

