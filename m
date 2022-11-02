Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6961EC43217
	for <linux-xfs@archiver.kernel.org>; Wed,  2 Nov 2022 22:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiKBWgS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 2 Nov 2022 18:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231182AbiKBWgR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 2 Nov 2022 18:36:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11B4ABE25;
        Wed,  2 Nov 2022 15:36:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9AD7161C60;
        Wed,  2 Nov 2022 22:36:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7C3C433D6;
        Wed,  2 Nov 2022 22:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667428576;
        bh=c/Sz5QKHfG68/HCg3q4phBuxcp9yBpTL4v+7XW13II8=;
        h=Subject:From:To:Cc:Date:From;
        b=HLkukIDaLuXGEuke28Rn+/TnzuDr/rG10aaUIurkDPGCXOlmdKpqHskuLlQu17fBU
         Udu1MTTeknDy01SJuvu6opjNt9tXvhhOCBw7AonqrouGpiqdxtavP9tQF2+dtTBMul
         HW2HapPOUnI8irSmZFrxFT9ruX/gvx0MgmV7Eqbuuh4r7anD5Ark0cmN7X4w5ZNznM
         ZqkeOvr5Bm9BRptKEXDm29v4fpAofMR9vpYZ3tYeb4cjAaWWokk6b9JxrYXvIBU8sL
         wPSJ40rJ2U8GhYjkggz/hXqw5y3ceQE9KPU1myemJDcrULorTlPI0qhwY8epZJhM8/
         O7Q5T3fsXHqrg==
Subject: [PATCHSET v23.1 0/1] fstests: test xfs_scrub media scan
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 02 Nov 2022 15:36:15 -0700
Message-ID: <166742857552.1499365.12368724681885402947.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Use dm-error to simulate disk errors for written file extents and ensure
that the media scanner in xfs_scrub actually detects them.

v23.1: tidy up some loose ends, make it more obvious in dmerror where the
       awk and bash transitions happen

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-media-error-reporting

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-media-error-reporting
---
 common/dmerror    |  140 ++++++++++++++++++++++++++++++++++++++++++++++++
 common/xfs        |    9 +++
 tests/xfs/747     |  155 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/747.out |   12 ++++
 4 files changed, 316 insertions(+)
 create mode 100755 tests/xfs/747
 create mode 100644 tests/xfs/747.out

