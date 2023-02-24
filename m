Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E869C61DA3
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Feb 2023 14:30:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjBXOaf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 24 Feb 2023 09:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjBXOae (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 24 Feb 2023 09:30:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B6563A1D
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2023 06:30:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 033C8B81C96
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2023 14:30:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2299FC433EF
        for <linux-xfs@vger.kernel.org>; Fri, 24 Feb 2023 14:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677249025;
        bh=0ftNCgBD3NB5xUFMN1PQAZKFmtU7Zyervy3HAWtFKMM=;
        h=Date:From:To:Subject:From;
        b=aZKax8hCs6naEFc2pFXRYW9McKsRS7oTUv3NR2lvcdjY7nQmuVJLgxqz/fiy9CmNp
         qtNlqa9cREt6JVuzHPSMnVHYP5oZ4gtbhIoULzrp47512QEXvUWwvqLOQ8wf/5FrKJ
         snFDzDuraqgz1CoEzuyugFL8sRssryJX6ho+lRcY83XGW+ymFAXLF3mwMFu9sxxhWS
         MOvwl7Ci1rKxLgcVvXBsZM+VLb/QFqT0+IaEsU0ZqVFB1VqMUEepuI0xR23XbR5n0V
         JP3b/fUVSWXTvaJbgOd9DqD84qK5ShOZ40vFPs0+VL0AhsM4837jUp5BR2cl4HuooD
         XC84PWG6Hw+yA==
Date:   Fri, 24 Feb 2023 15:30:22 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs: for-next updated to d6642ab8c
Message-ID: <20230224143022.yh6bz22e3ge4jue6@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs for-next branch, located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/refs/?h=for-next

Has just been updated.

Patches often get missed, so if your outstanding patches are properly reviewed on
the list and not included in this update, please let me know.

The new head of the for-next branch is commit:

d6642ab8cc934d9de12de631f5b0b3098022eb02

6 new commits:

Andrey Albershteyn (1):
      [a0d79cb37] xfs_db: make flist_find_ftyp() to check for field existance on disk

Arjun Shankar (1):
      [d6642ab8c] Remove several implicit function declarations

Darrick J. Wong (4):
      [5a77e0e7c] xfs_spaceman: fix broken -g behavior in freesp command
      [085fce0ba] xfs_scrub: fix broken realtime free blocks unit conversions
      [647078745] xfs_io: set fs_path when opening files on foreign filesystems
      [b1faed5f7] xfs_io: fix bmap command not detecting realtime files with xattrs

Code Diffstat:

 db/crc.c              |  2 +-
 db/flist.c            | 12 +++++++++---
 db/flist.h            |  3 ++-
 io/bmap.c             |  2 +-
 io/open.c             |  3 ++-
 m4/package_libcdev.m4 |  7 +++++--
 scrub/fscounters.c    |  2 +-
 spaceman/freesp.c     |  1 -
 8 files changed, 21 insertions(+), 11 deletions(-)

-- 
Carlos Maiolino
