Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3386CC38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjARAxo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjARAxV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:53:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D15B3FF18;
        Tue, 17 Jan 2023 16:42:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CCEB9B81A85;
        Wed, 18 Jan 2023 00:41:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71544C433EF;
        Wed, 18 Jan 2023 00:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002517;
        bh=oCP8Shk5KoeM8np0iFQX6y3rRwAwKrDFxe8fagJNN74=;
        h=Date:Subject:From:To:Cc:From;
        b=tosrQTh53HucOBl1Z2jQLbvazRzN5IK5jZxcAiB1NtFzLWuEFAAW9Z2scfJ3n9FZl
         nALWc26ZxxnIFF21pDbKhyTGYeeeqNfUcRTDzDCjfPFxxBtXO7Fx6RglYIZY3z3NWM
         xksXCsghLLCeHuBOxTdv8aWw7TLSwxm/2KXsRh/rm/Jxyw/8MWCYE58Zci+ULInY9H
         nJSTqZHoRS6Mm6YNqzeQy9b+KdyHdmqvMnjg8MuR7Dyf89JCb7jqS1IXBBfEbgZw/2
         /r3XPvfrxZmvqOA91TIpPgVeHKslsKJt0qJ+IK8guS5t2e01xk/cysS2EgddbJx+ww
         uO3tP7HkXPS8w==
Date:   Tue, 17 Jan 2023 16:41:56 -0800
Subject: [PATCHSET 0/3] fstests: fix tests when XFS always_cow mode enabled
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167400102747.1914975.6709564559821901777.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adjust various adjustments or _notruns that need to happen
when always_cow mode is enabled in XFS.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-alwayscow-tests
---
 common/xfs        |    9 +++++++++
 tests/generic/392 |   10 ++++++++++
 tests/xfs/080     |    1 +
 tests/xfs/182     |    1 +
 tests/xfs/192     |    1 +
 tests/xfs/198     |    1 +
 tests/xfs/204     |    1 +
 tests/xfs/211     |    1 +
 tests/xfs/326     |   12 ++++++++++++
 tests/xfs/329     |    1 +
 tests/xfs/434     |    1 +
 tests/xfs/436     |    1 +
 tests/xfs/558     |    6 ++++++
 13 files changed, 46 insertions(+)

