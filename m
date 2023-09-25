Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52351CE79A6
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:42:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbjIYVms (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbjIYVms (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:42:48 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C15CA3;
        Mon, 25 Sep 2023 14:42:42 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D7AC433C8;
        Mon, 25 Sep 2023 21:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695678161;
        bh=GEO52P1Fqte1BdgkIqb2eg7a+Tu8PISPLmBN9P3eqR4=;
        h=Subject:From:To:Cc:Date:From;
        b=Lg9qjfx8U+DsEhhFaPo7YHdEsLZ0EULIvbOIMoHRsVG1oPwt4T5DjzmRInvkOky5Q
         CJ69K97ZpDoz+GdL1j9UsTExDcIQoBXAMVRmiviybd0Iiw5xws49WE6je7HrzXOa3W
         g1R5rxpwDKRc6vy/XktkfNaUCJh1JMnMDccxVZxRjTMziUrXG06KV3QTFsL9PAUtMK
         e2PfdV9H5yD3ZCgeI4gc0gYR66sAg9QvdII9A5FuQn1TWLC29xJ30Bx4RYnNczp6Ce
         ZalhRaslf7QId7Q0i/UiTgV04PP4FaJVEMwgkPPc1oNjdmFSTVRbbRvWZ0XkuXJoyG
         nurymsd2UsfGA==
Subject: [PATCHSET 0/1] fstests: disallow LARP on old fses
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 25 Sep 2023 14:42:41 -0700
Message-ID: <169567816120.2269819.5620379594030200785.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Before enabling logged xattrs, make sure the filesystem is new enough
that it actually supports log incompat features.  Fix up tests to reflect
this new reality.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-larp-requirements

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-larp-requirements
---
 tests/xfs/018 |   13 +++++++++++++
 1 file changed, 13 insertions(+)

