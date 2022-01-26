Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8F49C3525A
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jan 2022 02:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbiAZCLt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jan 2022 21:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233572AbiAZCLq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jan 2022 21:11:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 860BFC06161C;
        Tue, 25 Jan 2022 18:11:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 43120B81B8C;
        Wed, 26 Jan 2022 02:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE455C340E0;
        Wed, 26 Jan 2022 02:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643163104;
        bh=ln28l0LfZh8ynRD5Y2+zLZ/kIsOQCNkanW090mnjWcI=;
        h=Subject:From:To:Cc:Date:From;
        b=oZSTjB5pE4W7BeaXIYOtNtHSUX8uwggLXwRHAReu0ICxxUqculPdlUx6LYAjgVWtB
         CuCg73ipvSxOSogjyrnl8VDloWyFzpJmXrKh0KRssyTI48dmm67JHqm7BflB9c8AkE
         Kb1FhemeJmI6Prid4vN1v/S/1w0tNhdC1m+vKvxS6tB1BDMNApQGZT4qPAmaj3Rqha
         MXk1ucUVNg4v3l0CW4nznEEPKrfSijPybAacyZ/SGMMGWuqCGctGahQHhSuL0z/pYh
         vQPdst3nvtNRNjbPG3xMM16rGZx2oOUZZddy0OTqzg5T15N83CWOqw/i8UZbh+eq53
         73juizA0Qc5kw==
Subject: [PATCHSET 0/2] fstests: new stuff for kernel 5.17
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Jan 2022 18:11:43 -0800
Message-ID: <164316310323.2594527.8578672050751235563.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add a new test to make sure that reflink actually clears the
setuid/setgid bits /and/ file capabilities correctly, and then port
fstests off the old ALLOCSP and FREESP ioctls since we've removed them
in 5.17.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-merge-5.17

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-merge-5.17
---
 common/rc             |    4 +-
 ltp/fsstress.c        |    4 ++
 tests/generic/950     |  108 +++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/950.out |   49 ++++++++++++++++++++
 tests/generic/951     |  118 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/951.out |   49 ++++++++++++++++++++
 tests/generic/952     |   71 +++++++++++++++++++++++++++++
 tests/generic/952.out |   13 +++++
 tests/xfs/107         |    1 
 9 files changed, 415 insertions(+), 2 deletions(-)
 create mode 100755 tests/generic/950
 create mode 100644 tests/generic/950.out
 create mode 100755 tests/generic/951
 create mode 100644 tests/generic/951.out
 create mode 100755 tests/generic/952
 create mode 100644 tests/generic/952.out

