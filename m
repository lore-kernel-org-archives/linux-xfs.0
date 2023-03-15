Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CD8C7618A
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 00:52:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbjCOAwp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 20:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbjCOAwl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 20:52:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675905BDB4;
        Tue, 14 Mar 2023 17:52:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 012C861A87;
        Wed, 15 Mar 2023 00:52:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43470C433EF;
        Wed, 15 Mar 2023 00:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678841551;
        bh=G4DsRQrsabLKjrEKBtTj/JCJhbH3juucnRlkL2IbMv4=;
        h=Subject:From:To:Cc:Date:From;
        b=QiorGGzaFpAsiMFIVOC0vPE3JzHxMp1jDlkFDzkFjGFnxkA92lXzx5j26oWgASEJR
         nSRbzHANMj5MUdzYnMpYU97kaIrU34sBODe3RMNfJc0yaNt1A6EfaUGHNGjKkROym4
         qEQih2eulvPpBdvAXxrK5uwksZsTuLTTJAuQqfY/dQ+PpifWM4pJSqqQcw4ueB7io6
         af9ZLQ2kcMt+jH1Ej0AXGGyHR0cuG0iO18SzRreTf1aEnBc6b94+JCToaijZfBaOJl
         Hs9b/gxx3Qv2HRj7MuCjvMLI3fOdY9TWXCqgW0RP0mqB1pgLmVFD59L5HPoXfNAXU+
         a0fh06TZlR6oA==
Subject: [PATCHSET v3 00/15] fstests: improve junit xml reporting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Qu Wenruo <wqu@suse.com>, Leah Rumancik <leah.rumancik@gmail.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        leah.rumancik@gmail.com, quwenruo.btrfs@gmx.com, tytso@mit.edu
Date:   Tue, 14 Mar 2023 17:52:30 -0700
Message-ID: <167884155064.2482843.4310780034948240980.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series improves the fstests reporting code in several ways.  First,
change the ./check code to generate the report after every test, so that
a cluster-based fstest scheduler can reschedule tests after a VM crash.
Personally, I was using it to get live status on my tests dashboard.

The bulk of the patches in here improve the junit xml reporting so that
we (a) actually declare which xml schema we're trying to emit and (b)
capture a lot more information about what was being tested.

v2: shorten indenting in the schema file, record .dmesg files as a
separate kernel-log tag, clarify what the timestamp attribute means,
record the test suite start time and report generation time as separate
attributes, make it possible to pass in a list of report variables,
encode cdata correctly

v3: Reviewed-and-tested-by: Leah Rumancik <leah.rumancik@gmail.com>

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xunit-reporting-improvements
---
 README        |    3 +
 check         |   11 +++
 common/ext4   |    5 +
 common/report |  130 +++++++++++++++++++++++++-----
 common/xfs    |   11 +++
 doc/xunit.xsd |  246 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 386 insertions(+), 20 deletions(-)
 create mode 100644 doc/xunit.xsd

