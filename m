Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B992C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236333AbiLaDWS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:22:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiLaDWM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:22:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEFF312A80;
        Fri, 30 Dec 2022 19:22:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A5B961D63;
        Sat, 31 Dec 2022 03:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1B9C433D2;
        Sat, 31 Dec 2022 03:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456930;
        bh=uIkuzTIGRAEIdxXiClCQcAB4x3pq5NNVaEDisgYGNIA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=POSxXT6naAUgdFn4hwA5zX2I/B7zP/X6nWIfRh0OCXD1Ip9udinX3UkCnZRYgRDWA
         Ez6F6/lBFNyqJnBcTHDArOkr+lKmFuQJAp3+vX06PV7UHw3AcJwvO4QHMumAIZ2sB1
         aqKDJfOONTblEBIw0rZ91U2DTIkmSUbjJK+Ma6kRv/i7ocMTrmfQsos5fKu6PKijgb
         5CFx+hTVb3n5Mv6sJ3b6hO5XDohLaUHdfhDh94JXWZ5HSWUk97XdIS6n30buUEOeVA
         E97qkWhfExdOSoO/kDT26TdTt2qmlfCJsAvXl3iFk+AGj+kQKd+HBNWT6yXverCqTz
         VOo+p7Zk5Y4Bw==
Subject: [PATCHSET 0/1] fstests: functional test for refcount reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:21:14 -0800
Message-ID: <167243887484.742012.14569558642146398379.stgit@magnolia>
In-Reply-To: <Y69Uw6W5aclS115x@magnolia>
References: <Y69Uw6W5aclS115x@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add a short functional test for the new GETFSREFCOUNTS ioctl that allows
userspace to query reference count information for a given range of
physical blocks.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=report-refcounts

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=report-refcounts

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=report-refcounts
---
 common/rc           |    4 +
 doc/group-names.txt |    1 
 tests/xfs/921       |  168 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/921.out   |    4 +
 4 files changed, 175 insertions(+), 2 deletions(-)
 create mode 100755 tests/xfs/921
 create mode 100644 tests/xfs/921.out

