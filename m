Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51869 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727483AbfFQJy4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 17 Jun 2019 05:54:56 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] xfs_info: limit findmnt to find mounted xfs filesystems
Date: Mon, 17 Jun 2019 12:54:47 +0300
Message-Id: <20190617095447.3748-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

When running xfstests with -overlay, the xfs mount point
(a.k.a $OVL_BASE_SCRATCH_MNT) is used as the $SCRATCH_DEV argument
to the overlay mount, like this:

/dev/vdf /vdf xfs rw,relatime,attr2,inode64,noquota 0 0
/vdf /vdf/ovl-mnt overlay rw,lowerdir=/vdf/lower,upperdir=/vdf/upper...

Ever since commit bbb43745, when xfs_info started using findmnt,
when calling the helper `_supports_filetype /vdf` it returns false,
and reports: "/vdf/ovl-mnt: Not on a mounted XFS filesystem".

Fix this ambiguity by preferring to query a mounted XFS filesystem,
if one can be found.

Fixes: bbb43745 ("xfs_info: use findmnt to handle mounted block devices")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eric,

FYI, I don't *need* to fix xfs_info in order to fix xfstests
and I do plan to send an independent fix to xfstests, but this
seems like a correct fix regardless of the specific xfstests
regression.

Thanks,
Amir.

 spaceman/xfs_info.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/spaceman/xfs_info.sh b/spaceman/xfs_info.sh
index 1bf6d2c3..3b10dc14 100755
--- a/spaceman/xfs_info.sh
+++ b/spaceman/xfs_info.sh
@@ -40,7 +40,7 @@ case $# in
 
 		# If we find a mountpoint for the device, do a live query;
 		# otherwise try reading the fs with xfs_db.
-		if mountpt="$(findmnt -f -n -o TARGET "${arg}" 2> /dev/null)"; then
+		if mountpt="$(findmnt -t xfs -f -n -o TARGET "${arg}" 2> /dev/null)"; then
 			xfs_spaceman -p xfs_info -c "info" $OPTS "${mountpt}"
 			status=$?
 		else
-- 
2.17.1
