Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B260C4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Nov 2022 16:59:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiKXQ71 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 11:59:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKXQ70 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Nov 2022 11:59:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA06B70C9
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 08:59:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34B4762080
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 16:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914D5C433D6;
        Thu, 24 Nov 2022 16:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669309164;
        bh=P5lsVs2mbizYgQ41CiRtXuYMZIKsCctgdgZe1qA/7LQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=f4UCMMWkXd2nI8+YJ3/wtvjQbJbUSIgs5dHnHT1CR1uf44r+PmsXjgrZULQWoc5g8
         IrfewAvkzhX5Vnc1SUqNVeOYhsC31ZtuNkU9w8tBBEKpoARMk+WdFaM0ZUOW0zT3l0
         7iIUABH0XeoFF/9pJ1oZvxui20wxA01OEztNMM4bSceX6a/7aMBXqtbG5BmXoy7vcx
         HD1DVYSh7fRrjhir56XptPJMSeWhrrO2p9zsLfBUSMRgt74WNPeTA6o1RqBaNGSJUM
         XgIwzav0sIhoGarD2cjTdgb/084Es6DwcgIPRSbIVZy8HNXg2lJ3c7+c+aFW6p/m2B
         W9TtAl/HOpk7g==
Subject: [PATCH 1/3] xfs: invalidate block device page cache during unmount
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Nov 2022 08:59:24 -0800
Message-ID: <166930916399.2061853.16165124824627761814.stgit@magnolia>
In-Reply-To: <166930915825.2061853.2470510849612284907.stgit@magnolia>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Every now and then I see fstests failures on aarch64 (64k pages) that
trigger on the following sequence:

mkfs.xfs $dev
mount $dev $mnt
touch $mnt/a
umount $mnt
xfs_db -c 'path /a' -c 'print' $dev

99% of the time this succeeds, but every now and then xfs_db cannot find
/a and fails.  This turns out to be a race involving udev/blkid, the
page cache for the block device, and the xfs_db process.

udev is triggered whenever anyone closes a block device or unmounts it.
The default udev rules invoke blkid to read the fs super and create
symlinks to the bdev under /dev/disk.  For this, it uses buffered reads
through the page cache.

xfs_db also uses buffered reads to examine metadata.  There is no
coordination between xfs_db and udev, which means that they can run
concurrently.  Note there is no coordination between the kernel and
blkid either.

On a system with 64k pages, the page cache can cache the superblock and
the root inode (and hence the root dir) with the same 64k page.  If
udev spawns blkid after the mkfs and the system is busy enough that it
is still running when xfs_db starts up, they'll both read from the same
page in the pagecache.

The unmount writes updated inode metadata to disk directly.  The XFS
buffer cache does not use the bdev pagecache, nor does it invalidate the
pagecache on umount.  If the above scenario occurs, the pagecache no
longer reflects what's on disk, xfs_db reads the stale metadata, and
fails to find /a.  Most of the time this succeeds because closing a bdev
invalidates the page cache, but when processes race, everyone loses.

Fix the problem by invalidating the bdev pagecache after flushing the
bdev, so that xfs_db will see up to date metadata.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_buf.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index dde346450952..54c774af6e1c 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1945,6 +1945,7 @@ xfs_free_buftarg(
 	list_lru_destroy(&btp->bt_lru);
 
 	blkdev_issue_flush(btp->bt_bdev);
+	invalidate_bdev(btp->bt_bdev);
 	fs_put_dax(btp->bt_daxdev, btp->bt_mount);
 
 	kmem_free(btp);

