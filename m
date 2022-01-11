Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01425C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 23:22:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346664AbiAKXWo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 18:22:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233147AbiAKXWo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 18:22:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0281C06173F
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 15:22:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 380C1B81BE7
        for <linux-xfs@vger.kernel.org>; Tue, 11 Jan 2022 23:22:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B33C36AE9;
        Tue, 11 Jan 2022 23:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641943360;
        bh=6xhYuHC2Ni6iKL23Lv2WieCIEJLu/3+5xoapYmR8orc=;
        h=Subject:From:To:Cc:Date:From;
        b=ls04OZ27Pdk/j0Iz2aCiwt8QLpCnI3DpOwF6BPJwbvAHShhHk+wqlhUGSVL9Z7Cvz
         WaDJLuzS03PIJO64v+gNGtsvj3QesYgta+s2/cvf/nw+dywBHn/3F7ErchoiH8MfV/
         P3zlneriFZ9qWxTnOoHEpMzoT9VWiKbqkO7rzVdBUzVWFPnX9gl7U6V8/R/S0LgcRd
         Cb67ladQuuJgD5RZhoDo7SVYqH5tFx4hd21fV1je0s4iIl45QrFiJD0wJUk/pkk7Dn
         MXs3Hsm/5ja9A84FAA5d4ha99wv6BueIBGKuhFOPxMIKrjCBEpLiV7ZJAnfBoNByGf
         kho39zJVeOTaw==
Subject: [PATCHSET v2 0/3] xfs: kill dead ioctls for 5.17
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Eric Sandeen <sandeen@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 11 Jan 2022 15:22:40 -0800
Message-ID: <164194336019.3069025.16691952615002573445.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Let's retire some old ioctls that we don't want to support anymore!

v2: target FSSETDM too, and various tweaks to the ALLOCSP log messages

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-5.17-kill-ioctls
---
 fs/xfs/libxfs/xfs_fs.h |   37 ++++-------------
 fs/xfs/xfs_bmap_util.c |    7 +--
 fs/xfs/xfs_bmap_util.h |    2 -
 fs/xfs/xfs_file.c      |    3 -
 fs/xfs/xfs_ioctl.c     |  102 +++++++-----------------------------------------
 fs/xfs/xfs_ioctl.h     |    6 ---
 fs/xfs/xfs_ioctl32.c   |   27 -------------
 fs/xfs/xfs_ioctl32.h   |    4 --
 8 files changed, 27 insertions(+), 161 deletions(-)

