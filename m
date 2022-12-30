Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7799DC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235459AbiL3XUF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:20:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiL3XUF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:20:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EC21D0C6;
        Fri, 30 Dec 2022 15:20:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5121DB81DA2;
        Fri, 30 Dec 2022 23:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AE0C433D2;
        Fri, 30 Dec 2022 23:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442402;
        bh=KXJHUJuX5vkAdJBgo3a6iAjwNYPYtwqYFMAAuzglVHY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WRLqjCAfeyGlmdql/b1x7J331feDaQ2tDCsqVcUox7EpxgY4OLOg06Zmm4OgL98Vk
         qzDP1IlBQ7igfm33ZvLWhghupacFpU3daPTDunszpPtSR/0LfjmZ7tJeBVLivSo+fS
         yKwdhq6lP7RApjeI2oRqFGl2jlT8eEUj/DgO9fbgW1toELWdQph45FlUEJCPAXHDZ8
         PEQGDnSGbcQxqMtkdlh6e5j0KZH3lqQEL7KC7YpvpY9xOCrq6mlWcUsmDkbtIX1TqR
         wlQPXoH6HTalZrlyt6zv4I5EBYRsjEcB9S5cn4EDhK6Y4Ev6PVC5ow2n8QUa22qujb
         9//sRwTah7cXQ==
Subject: [PATCHSET v24.0 0/1] fstests: test automatic scrub optimization by
 default
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:00 -0800
Message-ID: <167243880076.733786.4193492627332162854.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This final patchset in the online fsck series enables the background
service to optimize filesystems by default.  This is the first step
towards enabling repairs by default.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-optimize-by-default

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-optimize-by-default
---
 tests/xfs/850     |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/850.out |   32 ++++++++++++++++
 2 files changed, 137 insertions(+)
 create mode 100755 tests/xfs/850
 create mode 100644 tests/xfs/850.out

