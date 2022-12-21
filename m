Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52204C4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 21 Dec 2022 00:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbiLUAVs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 20 Dec 2022 19:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiLUAVr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Dec 2022 19:21:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0845FD8;
        Tue, 20 Dec 2022 16:21:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5781361629;
        Wed, 21 Dec 2022 00:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AF8C433F0;
        Wed, 21 Dec 2022 00:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671582105;
        bh=zf2MLXxI9R6dp7djOV2z1oy05hD8H//2GiUpJ3IW1LA=;
        h=Subject:From:To:Cc:Date:From;
        b=QZfJUlkhpKLDvO4Q9KS6fsehzJ/WOVBYDLKdXoqZtJ7IoygJTVQ+pn+YiH1zLkypr
         KX9gNeLgbV9NxR1qtAyuQsFhiadYBovsHQzt9989Am3vNYtRRzMlF4qcYqUmhupadj
         jhmIqSwZ4QYlis3GXqE2PQFzOpGcqhBilWlSQoyvI4QSLntoSuux/OObX5IL1u7y6D
         cevX/rNDPkJc2mMWqa4pTB7YovXIHX4yfG6g544uW5/G6DjengLT3K7eMb2BpBExZT
         sLK7epTmL9FoVvDciz6bkrjytSEZLilkv+zv+lJWC7+3ZT7fI0Cu7SWG6v658snPe1
         Hwxqb/t7L3bRg==
Subject: [PATCHSET 0/3] fstests: fix tests for kernel 6.2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     Wengang Wang <wen.gang.wang@oracle.com>,
        Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 20 Dec 2022 16:21:45 -0800
Message-ID: <167158210534.235429.10062024114428012379.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Adjust filesystem tests to accomodate new code merged for kernel 6.2.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-merge-6.2

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-merge-6.2
---
 common/rc         |   15 ++++
 common/tracing    |   66 +++++++++++++++++
 tests/xfs/179     |   32 +++++++-
 tests/xfs/924     |  210 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/924.out |    2 +
 tests/xfs/925     |  123 +++++++++++++++++++++++++++++++
 tests/xfs/925.out |    2 +
 7 files changed, 447 insertions(+), 3 deletions(-)
 create mode 100644 common/tracing
 create mode 100755 tests/xfs/924
 create mode 100644 tests/xfs/924.out
 create mode 100755 tests/xfs/925
 create mode 100644 tests/xfs/925.out

