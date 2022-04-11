Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16DAFC433FE
	for <linux-xfs@archiver.kernel.org>; Mon, 11 Apr 2022 22:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350481AbiDKW5Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 11 Apr 2022 18:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350475AbiDKW5P (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 11 Apr 2022 18:57:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30187101E4;
        Mon, 11 Apr 2022 15:55:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DB77EB81999;
        Mon, 11 Apr 2022 22:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840C5C385A3;
        Mon, 11 Apr 2022 22:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649717697;
        bh=J0ee0DmXVTKY/0t+WqkErNl9cgwj8m2S14qK9mKTnwI=;
        h=Subject:From:To:Cc:Date:From;
        b=a+TqeKKbip6q70Gc7iOcFJeb13gr6Hd0RgnDCvhcQmB33zyAa4N+jtEFn9JLSyujO
         9q9f7/JxS05aQXyu1LuFy1bkveqQ4H6Znp7NLTQal0sBlzlk5ZEiyMk+hEfJSRwr7I
         iVyoT0aLz8j6lohCObyRgbODOKkn/p7FpUsSebH6PsD+f59v03dDSDZsV82aso+1n7
         /TzCrmHUU8CB0tMLZcbmLB3/oXerKPcpDbMx8CPTXRjLdfedc7LoAriMrJzV70Mpv/
         Io3lW/Q12AAS4htF5qftLsyb4nkFMb7Cpnxtgl8+klCjkOsurY+1zg/sB31Ag4f1GX
         PKumVC2k98Mdw==
Subject: [PATCHSET 0/3] fstests: updates for xfsprogs 5.15
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 11 Apr 2022 15:54:57 -0700
Message-ID: <164971769710.170109.8985299417765876269.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series contains test updates and fixes for things that were fixed
in 5.15.  Specifically, we now let the xfs_scrub binary tell us if it
supports Unicode checking (instead of grepping the binary!); test for a
regression in mkfs config file support prior to this release; and have
some adjustments for setting the minimum log size to 64MB>

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfsprogs-merge-5.15
---
 common/rc         |   12 +++++++++
 tests/xfs/216.out |   14 +++++------
 tests/xfs/831     |   68 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/831.out |    2 ++
 4 files changed, 89 insertions(+), 7 deletions(-)
 create mode 100755 tests/xfs/831
 create mode 100644 tests/xfs/831.out

