Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234DB17C7DC
	for <linux-xfs@vger.kernel.org>; Fri, 23 Aug 2024 00:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371205; cv=none; b=rCMPzEV4+qYLsLzh1Kdp7Xc6836G4r/IjMkYcXEAbtQKJ/8uo8kIQxcflE9VV7wY7Gz8SfhkgrSV8wTJflb8nqxHJptNGP/XecJQmnDR9Jvmxg5KcSvVNmeE6lOc5+GHDOOoJWkU/Wx8p5rHEto5WlOOmdmsBFiUPsRpDRzWEJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371205; c=relaxed/simple;
	bh=01UDe+VY+BY5MAHOTVxF/KaXmZaZFoGjAnUT1iZTN1g=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JRSnBwkoZkFpDD/av5DM9dhcpPi9Dfq8FYPEBetlbIlLWzxKlkUbESk/Wf5QNoujQt6N6oOjMRDywX9ui5QqMqzr7nLwEwHiTwKlSl/l93nwLQWKfB1ZIW+c2fTnbvtMRFXjAMcI7ggS9Wr121/xB/ybwfv3WsUytNnuDJQSljI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ByOJdoqN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ByOJdoqN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E028FC4AF10;
	Fri, 23 Aug 2024 00:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371204;
	bh=01UDe+VY+BY5MAHOTVxF/KaXmZaZFoGjAnUT1iZTN1g=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ByOJdoqN6Ndn3b2v6h03XkQA9wvqfylE43tx4BSDDojkFyAOx7QaqfgKBHhzhzobQ
	 8aF5s1SXpsa7VY2tBAI2F2gRDI78F8iUQEROufCjoyHy2qX/dDTdgSgrlqdhhl2Z86
	 Lkr38lgMSBGOCCI9q6wzM0mgGTCl7XBHrh9D0P6RnaRvw84tC8v4DZSBwAwGR46QLO
	 +cj43BK2MtlKi4/uyYnjMu5A5lG14xNd4CmWes9XLtFAc3vusjX2CN+m5Vxyi0Aonh
	 S+ZY4QOl8muSxi0P5yoCi/Qy98530KREPLqAhEq0xFgifUQD8euTd8Ss6k4dzIbaK/
	 WGthlXBgNdYuQ==
Date: Thu, 22 Aug 2024 17:00:04 -0700
Subject: [PATCH 5/9] xfs: Fix the owner setting issue for rmap query in xfs
 fsmap
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Zizhi Wo <wozizhi@huawei.com>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <172437083836.56860.11859978469978791125.stgit@frogsfrogsfrogs>
In-Reply-To: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
References: <172437083728.56860.10056307551249098606.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Zizhi Wo <wozizhi@huawei.com>

I notice a rmap query bug in xfs_io fsmap:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv' /mnt
 EXT: DEV    BLOCK-RANGE           OWNER              FILE-OFFSET      AG AG-OFFSET             TOTAL
   0: 253:16 [0..7]:               static fs metadata                  0  (0..7)                    8
   1: 253:16 [8..23]:              per-AG metadata                     0  (8..23)                  16
   2: 253:16 [24..39]:             inode btree                         0  (24..39)                 16
   3: 253:16 [40..47]:             per-AG metadata                     0  (40..47)                  8
   4: 253:16 [48..55]:             refcount btree                      0  (48..55)                  8
   5: 253:16 [56..103]:            per-AG metadata                     0  (56..103)                48
   6: 253:16 [104..127]:           free space                          0  (104..127)               24
   ......

Bug:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
[root@fedora ~]#
Normally, we should be able to get one record, but we got nothing.

The root cause of this problem lies in the incorrect setting of rm_owner in
the rmap query. In the case of the initial query where the owner is not
set, __xfs_getfsmap_datadev() first sets info->high.rm_owner to ULLONG_MAX.
This is done to prevent any omissions when comparing rmap items. However,
if the current ag is detected to be the last one, the function sets info's
high_irec based on the provided key. If high->rm_owner is not specified, it
should continue to be set to ULLONG_MAX; otherwise, there will be issues
with interval omissions. For example, consider "start" and "end" within the
same block. If high->rm_owner == 0, it will be smaller than the founded
record in rmapbt, resulting in a query with no records. The main call stack
is as follows:

xfs_ioc_getfsmap
  xfs_getfsmap
    xfs_getfsmap_datadev_rmapbt
      __xfs_getfsmap_datadev
        info->high.rm_owner = ULLONG_MAX
        if (pag->pag_agno == end_ag)
	  xfs_fsmap_owner_to_rmap
	    // set info->high.rm_owner = 0 because fmr_owner == -1ULL
	    dest->rm_owner = 0
	// get nothing
	xfs_getfsmap_datadev_rmapbt_query

The problem can be resolved by simply modify the xfs_fsmap_owner_to_rmap
function internal logic to achieve.

After applying this patch, the above problem have been solved:
[root@fedora ~]# xfs_io -c 'fsmap -vvvv -d 0 3' /mnt
 EXT: DEV    BLOCK-RANGE      OWNER              FILE-OFFSET      AG AG-OFFSET        TOTAL
   0: 253:16 [0..7]:          static fs metadata                  0  (0..7)               8

Fixes: e89c041338ed ("xfs: implement the GETFSMAP ioctl")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 85dbb46452ca0..3a30b36779db5 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -71,7 +71,7 @@ xfs_fsmap_owner_to_rmap(
 	switch (src->fmr_owner) {
 	case 0:			/* "lowest owner id possible" */
 	case -1ULL:		/* "highest owner id possible" */
-		dest->rm_owner = 0;
+		dest->rm_owner = src->fmr_owner;
 		break;
 	case XFS_FMR_OWN_FREE:
 		dest->rm_owner = XFS_RMAP_OWN_NULL;

