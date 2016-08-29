Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F04CC7CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 03:12:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B261E304032
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 01:12:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BHMKjPfAsmgN2Pph (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 01:12:51 -0700 (PDT)
From: Artem Savkov <asavkov@redhat.com>
Subject: [PATCH v2] Make __xfs_xattr_put_listen preperly report errors.
Date: Mon, 29 Aug 2016 10:12:33 +0200
Message-Id: <1472458353-19615-1-git-send-email-asavkov@redhat.com>
In-Reply-To: <20160828225501.GJ19025@dastard>
References: <20160828225501.GJ19025@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Artem Savkov <asavkov@redhat.com>, Eric Sandeen <sandeen@sandeen.net>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Commit 2a6fba6 "xfs: only return -errno or success from attr ->put_listent"
changes the returnvalue of __xfs_xattr_put_listen to 0 in case when there is
insufficient space in the buffer assuming that setting context->count to -1
would be enough, but all of the ->put_listent callers only check seen_enough.
This results in a failed assertion:
XFS: Assertion failed: context->count >= 0, file: fs/xfs/xfs_xattr.c, line: 175
in insufficient buffer size case.

This is only reproducible with at least 2 xattrs and only when the buffer
gets depleted before the last one.

Furthermore if buffersize is such that it is enough to hold the last xattr's
name, but not enough to hold the sum of preceeding xattr names listxattr won't
fail with ERANGE, but will suceed returning last xattr's name without the
first character. The first character end's up overwriting data stored at
(context->alist - 1).

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 fs/xfs/xfs_xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index ea62245..6290093 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -147,6 +147,7 @@ __xfs_xattr_put_listent(
 	arraytop = context->count + prefix_len + namelen + 1;
 	if (arraytop > context->firstu) {
 		context->count = -1;	/* insufficient space */
+		context->seen_enough = 1;
 		return 0;
 	}
 	offset = (char *)context->alist + context->count;
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
