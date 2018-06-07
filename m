Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pl0-f65.google.com ([209.85.160.65]:44615 "EHLO
        mail-pl0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932118AbeFGLhV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 Jun 2018 07:37:21 -0400
Date: Thu, 7 Jun 2018 19:37:13 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 5/6] xfs: abstract xfs_info into $XFS_INFO_PROG
Message-ID: <20180607113713.GA1103@desktop>
References: <152821697018.24976.12939094615403004592.stgit@magnolia>
 <152821700731.24976.1667061625518547754.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <152821700731.24976.1667061625518547754.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Tue, Jun 05, 2018 at 09:43:27AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Abstract calls to xfs_info into $XFS_INFO_PROG like we do for all other
> xfs utilities.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> ---
>  common/attr      |    2 +-
>  common/config    |    1 +
>  common/populate  |   18 +++++++++---------
>  common/rc        |    2 +-

Better to make xfs_info mandatory too when testing xfs, so I did the
below diff on commit

diff --git a/common/rc b/common/rc
index f04c9ea2fd89..9d6665b6c4d7 100644
--- a/common/rc
+++ b/common/rc
@@ -136,6 +136,7 @@ case "$FSTYP" in
         [ "$XFS_REPAIR_PROG" = "" ] && _fatal "xfs_repair not found"
         [ "$XFS_DB_PROG" = "" ] && _fatal "xfs_db not found"
         [ "$MKFS_XFS_PROG" = "" ] && _fatal "mkfs_xfs not found"
+        [ "$XFS_INFO_PROG" = "" ] && _fatal "xfs_info not found"

         . ./common/xfs
         ;;

Thanks,
Eryu
