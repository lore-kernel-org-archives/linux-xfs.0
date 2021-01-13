Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36887C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 11:18:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4E6023359
	for <linux-xfs@archiver.kernel.org>; Wed, 13 Jan 2021 11:18:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbhAMLR5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 13 Jan 2021 06:17:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:35936 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727817AbhAMLRz (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 13 Jan 2021 06:17:55 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610536629; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=0nNaV3obvOumkdgqRVADfJ6GaX2ZgBCDIqKd1ZNzEF4=;
        b=mV8pcGw74DEB8+8zeTmfbY9sTxaBuOvtkuPuJxzwvSShL4m5CyIoRtKMxuxs/U7zxn//tW
        wKFJFZbjU1m5WyWEPSfHtvjyIApy3vH3yLW5AhxR+nbU/wGxmko3tqTzH0oGzI3c0A66H9
        XBsDCFM5WOdmoab5xvx1CIkcvJJUPJY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 13EA9AB92;
        Wed, 13 Jan 2021 11:17:09 +0000 (UTC)
From:   Nikolay Borisov <nborisov@suse.com>
To:     linux-xfs@vger.kernel.org
Cc:     david@fromorbit.com, Nikolay Borisov <nborisov@suse.com>
Subject: [RFC PATCH 0/3] Remove mrlock
Date:   Wed, 13 Jan 2021 13:17:03 +0200
Message-Id: <20210113111707.756662-1-nborisov@suse.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series removes mrlock_t and directly replaces i_lock and i_mmaplock with
rw_semaphore in xfs_inode. My end game with this is to eventually lift i_mmaplock
in VFS and use it from there. The necessity for the latter came up since BTRFS
is also about to get its own private version of i_mmaplock for the same use case.
This  will mean that all 3 major filesystems on linux (ext4/xfs/btrfs) wil share
the same lock. Christoph naturally suggested for the lock to be lifted to VFS.

Before proceeding with this work I'd like to get the opinion of XFS developers
whether doing that is acceptable for them. I've heard that Dave wants to eventually
convert the mmapsem to a range lock for XFS and implement a callback mechanism
for VFS to call into every filesystem...

I've only compile tested this and also the way the rwsem is checked for write
is admittedly a bit hackish but it can easily be changed to utilize lockdep.
I'm aware of https://lore.kernel.org/linux-xfs/20201102194135.174806-1-preichl@redhat.com/
but frankly that series went too far up to rev 10 which is a bit mind boggling...

Nikolay Borisov (3):
  xfs: Add is_rwsem_write_locked function
  xfs: Convert i_lock/i_mmaplock to  rw_semaphore
  xfs: Remove mrlock

 fs/xfs/mrlock.h          | 78 ----------------------------------------
 fs/xfs/xfs_inode.c       | 48 ++++++++++++++-----------
 fs/xfs/xfs_inode.h       |  6 ++--
 fs/xfs/xfs_linux.h       |  1 -
 fs/xfs/xfs_qm_syscalls.c |  2 +-
 fs/xfs/xfs_super.c       |  7 ++--
 6 files changed, 34 insertions(+), 108 deletions(-)
 delete mode 100644 fs/xfs/mrlock.h

--
2.25.1

