Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:59848 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfFZChi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jun 2019 22:37:38 -0400
Subject: [PATCH 07/10] libxfs-diff: try harder to find the kernel equivalent
 libxfs files
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Jun 2019 19:37:33 -0700
Message-ID: <156151665396.2286979.8848777429156280703.stgit@magnolia>
In-Reply-To: <156151660523.2286979.13694849827562044045.stgit@magnolia>
References: <156151660523.2286979.13694849827562044045.stgit@magnolia>
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
