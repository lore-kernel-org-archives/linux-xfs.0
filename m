Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90644C19F2D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Aug 2022 21:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiHIVCL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Aug 2022 17:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230496AbiHIVBL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Aug 2022 17:01:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AF82CDD3;
        Tue,  9 Aug 2022 14:01:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 57B0660BA0;
        Tue,  9 Aug 2022 21:01:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE24EC433D6;
        Tue,  9 Aug 2022 21:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660078861;
        bh=KhxNujvNRehuK9PUVkp3aAbkkJ3vv/m4wgTSH6bGqk0=;
        h=Subject:From:To:Cc:Date:From;
        b=WoPTPdw2dc01a34OlxaxREbtcYQROeq2+MeNS/55A2KyjLy5TiYhVVpM/Cknd7yPR
         B4iwQyXa1S6cV9I5XGJNXW+t45rgMsmZfbR3Aisljeuv+pl4FUpmn0Wy7atoVJpq4x
         0bRlgAC1hY4Qr/FQ4xRL0kzDExha9+JUpSmBYDii4PFWovnko3OQgZ0uxlxkXVYb+L
         DqMt+SpqXmOwXLEkSadaBvReBzDCH6qcda3WVsd+O+oL2l1B/ft8dnWtNmMZQ11VeW
         JqEUNV8aYjU/4GFVKE0OmQQFi3p/v/niIB5ZgtPWfDZnB9U19Hn+caHhnnOQVgX754
         1zdjOdm0t5XkQ==
Subject: [PATCHSET v3 0/1] dmerror: support external log and rt devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 09 Aug 2022 14:01:01 -0700
Message-ID: <166007886131.3276417.10030668570359997591.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are a growing number of fstests that examine what happens to a
filesystem when the block device underneath it goes offline.  Many of
them do this to simulate system crashes, and none of them (outside of
btrfs) can handle filesystems with multiple devices.  XFS is one of
those beasts that does, so enhance the dm-error helpers to take the log
and rt devices offline when they're testing the data device.

v2: rebase atop ext4 fixes and v2022-07-31 release.
v3: rebase atop ext4 fixes and v2022-08-07 release.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=dmerror-on-rt-devices
---
 common/dmerror    |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 tests/generic/441 |    2 -
 tests/generic/487 |    2 -
 3 files changed, 156 insertions(+), 7 deletions(-)

