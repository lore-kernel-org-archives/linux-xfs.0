Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D41AFC4332F
	for <linux-xfs@archiver.kernel.org>; Mon, 14 Nov 2022 11:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235493AbiKNLgw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 14 Nov 2022 06:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiKNLgw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 14 Nov 2022 06:36:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 354B3E0C7
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 03:36:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A002CCE0F4D
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 11:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 576F0C433D7
        for <linux-xfs@vger.kernel.org>; Mon, 14 Nov 2022 11:36:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668425803;
        bh=zqmU+Z0mRZlI0FuFuUzHT47GHoBIHDc5DimDirUtVfw=;
        h=Date:From:To:Subject:From;
        b=rHrprTVLs/RE7jm5MUrTY7mbHCYj5XWpGHLfEcGM9RpAQH59GJltLet9yZrFH1mP3
         iASEu3DhYa8zxVjlei5uIbKrwT5aWZW+x4auU/nduF7rdc5+/Nd0xLaHPUw3WEm8fZ
         61oYOFL7WYaKAqKAXiMIK8RUxqJD9xNEdVrhfSzB0yhwBIBOAr95Kp33kghg0l1i6H
         ZWb1Ze1UumKpA4iuks8wTIYcNzxM5N37rYqvlGik7ZrMCx7pcQFyyi51cM9rSjNpfZ
         FwLvLWqxG6xgqmNy4g0lHZMcWL1IQ/pPHcEhKOnhwSm/oB2hw87jGBjVz/MO0rhn+6
         GwTfzXXCYiAcA==
Date:   Mon, 14 Nov 2022 12:36:39 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs-6.0.0 released
Message-ID: <20221114113639.mxgewf2zjgokr6cb@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The xfsprogs repository at:

        git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged for a v6.0.0 release. The condensed changelog
since v6.0.0-rc0 is below.

Tarballs are available at:

https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.gz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.xz
https://www.kernel.org/pub/linux/utils/fs/xfs/xfsprogs/xfsprogs-6.0.0.tar.sign

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the master branch is commit:

3498b6802 xfsprogs: Release v6.0.0

New Commits:

Andrey Albershteyn (5):
      [f103166a9] xfs_quota: separate quota info acquisition into get_dquot()
      [2c1e7aefd] xfs_quota: separate get_dquot() and dump_file()
      [79e651743] xfs_quota: separate get_dquot() and report_mount()
      [6c007276a] xfs_quota: utilize XFS_GETNEXTQUOTA for ranged calls in report/dump
      [f2fde322d] xfs_quota: apply -L/-U range limits in uid/gid/pid loops

Carlos Maiolino (1):
      [3498b6802] xfsprogs: Release v6.0.0

Jakub Bogusz (1):
      [f034a3215] Polish translation update for xfsprogs 5.19.0.

Xiaole He (1):
      [d878935dd] xfs_db: use preferable macro to seek offset for local dir3 entry fields

 VERSION          |     2 +-
 configure.ac     |     2 +-
 db/dir2sf.c      |     6 +-
 debian/changelog |     6 +
 doc/CHANGES      |     5 +
 po/pl.po         | 21351 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++------------------------------------------------------------------------------------------
 quota/report.c   |   343 ++-
 7 files changed, 11248 insertions(+), 10467 deletions(-)


I needed to do a forced update to the tree, to fix a patch authoring mistake,
since both push and forced push were done only a few minutes apart, I hope it
didn't cause any trouble for anyone, otherwise, please accept my apologies.

-- 
Carlos Maiolino
