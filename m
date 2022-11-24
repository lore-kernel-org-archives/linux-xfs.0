Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B42EC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Nov 2022 16:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbiKXQ7V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 11:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKXQ7U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Nov 2022 11:59:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BFA7AF4B
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 08:59:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8360362080
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 16:59:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8B84C433C1;
        Thu, 24 Nov 2022 16:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669309158;
        bh=cFUAhMDSmBpz9UVqix63x5W1wU4f4jZI5TlhbOKU48E=;
        h=Subject:From:To:Cc:Date:From;
        b=YnY/hCpyaJBalc6a62pOsVRh170+6NVxq4a3/pqUq97BaQ8HP/ACtNVDnwE56uSLb
         ioVO/iniFSQbvR9njDzZMmearlSftoZrPQTk1j2HsHgl28ctcXMT4qJDentDJspXhA
         RtZkWLG5/8M7hZBbMvBwpMHhidesP9SmcwWcs9iX9p6CfEvnXeXIdmUzNRx9GdFVjh
         GUojNxtLf4W6hJzinbtf+a1SaZW7SNc0pCStBaT4fPgsmUc2v7JVp+1KW7VCS4fqIj
         i3lV8qNv8Qw+PdJLUfNM8i6nROfvRGS+ckjwz/EdX3SDoxX6BdXItQ7u+xtVeP7Ir6
         FPIlxmfswNwgg==
Subject: [PATCHSET 0/3] xfs: fixes for 6.2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Nov 2022 08:59:18 -0800
Message-ID: <166930915825.2061853.2470510849612284907.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Bug fixes for XFS for 6.2.  The first one fixes stale bdev pagecache
contents after unmount, and the other two resolve gcc warnings.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-6.2-fixes
---
 fs/xfs/xfs_buf.c       |    1 +
 fs/xfs/xfs_trans_ail.c |    4 +++-
 fs/xfs/xfs_xattr.c     |    2 +-
 3 files changed, 5 insertions(+), 2 deletions(-)

