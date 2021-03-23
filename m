Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14840C433E8
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2D1F619B8
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbhCWEU3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:46182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhCWEUB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:20:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E944D61992;
        Tue, 23 Mar 2021 04:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473201;
        bh=KMEAwYnJs7mVAmFXct8NlHOkucnY3rpIzKHup8Z5d1s=;
        h=Subject:From:To:Cc:Date:From;
        b=Cp5BZo+f7Jk6EDQgFMhP2epP70LLx48O1qiwW+kFnammCrRovxWgZkWHLbXnAdoLp
         YrNX6wtnPAZ5KIrSoHQq8cIETchN0Tsn8wCdhoh6zereE9AXMVWtdHtxNY+pbwK4PV
         pQAAsPiBJieByiQAWMO/HBY54HQqmsxaQtHFcRe24M3uay+ShMuULcP7BQhcOtd6rs
         baEOPz5B6DO1q3oXizl4ziNEFAv1zdWexq9vx9OzyBlKzquWf3NlcLwXBR9xyuh2hc
         NcCWogiCR1zLuYHup+KUJPrDOsx5UsfZjaIT/fEWf/Zncin71WmAoT7Kwar/j/GJ9I
         8ea0/4jp0hOtQ==
Subject: [PATCHSET 0/3] fstests: test kernel regressions fixed in 5.12
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     wenli xie <wlxie7296@gmail.com>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:20:00 -0700
Message-ID: <161647320063.3430465.17720673716578854275.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are new tests for problems that were fixed in upstream Linux
between 5.9 and 5.12.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=kernel-regressions
---
 common/rc              |   23 ++--------
 tests/generic/1300     |  108 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/1300.out |    2 +
 tests/generic/group    |    1 
 tests/overlay/025      |    2 -
 tests/overlay/106      |    2 -
 tests/overlay/107      |    2 -
 tests/overlay/108      |    2 -
 tests/overlay/109      |    2 -
 tests/xfs/049          |    2 -
 tests/xfs/759          |  102 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/759.out      |    2 +
 tests/xfs/760          |   68 ++++++++++++++++++++++++++++++
 tests/xfs/760.out      |    9 ++++
 tests/xfs/group        |    2 +
 15 files changed, 305 insertions(+), 24 deletions(-)
 create mode 100755 tests/generic/1300
 create mode 100644 tests/generic/1300.out
 create mode 100755 tests/xfs/759
 create mode 100644 tests/xfs/759.out
 create mode 100755 tests/xfs/760
 create mode 100644 tests/xfs/760.out

