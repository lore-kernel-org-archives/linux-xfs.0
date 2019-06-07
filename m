Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:45270 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729625AbfFGT3C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 7 Jun 2019 15:29:02 -0400
Subject: [PATCH 6/6] libxfs-diff: try harder to find the kernel equivalent
 libxfs files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 07 Jun 2019 12:28:58 -0700
Message-ID: <155993573805.2343365.14121664229730887571.stgit@magnolia>
In-Reply-To: <155993569512.2343365.15510991248022865602.stgit@magnolia>
References: <155993569512.2343365.15510991248022865602.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we're syncing userspace libxfs/ files with kernel fs/xfs/
files, teach the diff tool to try fs/xfs/xfs_foo.c if
fs/xfs/libxfs/xfs_foo.c doesn't exist.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tools/libxfs-diff |    1 +
 1 file changed, 1 insertion(+)


diff --git a/tools/libxfs-diff b/tools/libxfs-diff
index fa57c004..c18ad487 100755
--- a/tools/libxfs-diff
+++ b/tools/libxfs-diff
@@ -22,5 +22,6 @@ dir="$(readlink -m "${dir}/..")"
 
 for i in libxfs/xfs*.[ch]; do
 	kfile="${dir}/$i"
+	test -f "${kfile}" || kfile="$(echo "${kfile}" | sed -e 's|libxfs/||g')"
 	diff -Naurpw --label "$i" <(sed -e '/#include/d' "$i") --label "${kfile}" <(sed -e '/#include/d' "${kfile}")
 done
