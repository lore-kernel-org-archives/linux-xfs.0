Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC28C433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 16:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AD6F64F2A
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 16:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhCOQlG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 12:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:54310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232437AbhCOQko (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Mar 2021 12:40:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20BA364F33
        for <linux-xfs@vger.kernel.org>; Mon, 15 Mar 2021 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615826444;
        bh=kYD4hnJPPxh8QGgZdYmY/0GbLfOBQNtrIOorOCIiqss=;
        h=Date:From:To:Subject:From;
        b=to32hcoWZKaV7SBUnvVMoQRvKS9d8ocaLqdETaLAfDN6A1rxdO3TqmFZ2Vz57+hpb
         pTh2iKZ1D0Q9ljgCathGKWz3enFcGk7O7jP+ic+0bLX86KdJeLQjx/wJJJUREFkW1X
         GuBysa9SfOl8sGdYurBW2AVvZhGRXsIEpk2sehqF7/X/m8AqH1EQJ4w0M+RTAIfJ6E
         zkZFj2wMw4cvL4r+wqVa+zgp7NXZMyTyvhx3N4IdXRtW7tiUhgCHj2FFr4bSxIr8F4
         aLroMhoaTLY/JWPZkZ6VTRf01PiBM25ky5KG2JayveVNWitfwUI8DoGEdYaxL/Qjn+
         Cxmo++QDSi6/Q==
Date:   Mon, 15 Mar 2021 09:40:44 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next **rebased** to 8723d5ba8bda
Message-ID: <20210315164044.GD22100@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been rebased.  The patch to avoid inode btree cycle deadlocks
during inode walks requires deferred inode inactivation and I
accidentally committed that into the fixes topic branch.  This /should/
fix all the complaints in Zorro's recent bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=212289

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.

The new head of the for-next branch is commit:

8723d5ba8bda xfs: also reject BULKSTAT_SINGLE in a mount user namespace

New Commits:

Bhaskar Chowdhury (1):
      [08a204387e80] docs: ABI: Fix the spelling oustanding to outstanding in the file sysfs-fs-xfs

Christoph Hellwig (1):
      [8723d5ba8bda] xfs: also reject BULKSTAT_SINGLE in a mount user namespace

Darrick J. Wong (2):
      [b5a08423da9d] xfs: fix quota accounting when a mount is idmapped
      [d336f7ebc650] xfs: force log and push AIL to clear pinned inodes when aborting mount


Code Diffstat:

 Documentation/ABI/testing/sysfs-fs-xfs |  2 +-
 fs/xfs/xfs_inode.c                     | 14 +++---
 fs/xfs/xfs_itable.c                    |  6 +++
 fs/xfs/xfs_mount.c                     | 90 +++++++++++++++++-----------------
 fs/xfs/xfs_symlink.c                   |  3 +-
 5 files changed, 61 insertions(+), 54 deletions(-)
