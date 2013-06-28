Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0B7A87F3F
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 10:11:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E6B428F8050
	for <xfs@oss.sgi.com>; Fri, 28 Jun 2013 08:11:41 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id YUdeW273TCtIQGyg (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Jun 2013 08:11:41 -0700 (PDT)
Date: Fri, 28 Jun 2013 11:11:38 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH 6/6] ioctl eofblocks: require non-privileged users to
	specify uid/gid match
Message-ID: <20130628111138.68d0b486@oracle.com>
In-Reply-To: <20130626020924.GD29376@dastard>
References: <20130619110948.0bfafa2b@oracle.com>
	<20130620001341.GM29338@dastard>
	<20130620095410.1917d235@oracle.com>
	<20130620220311.GT29376@dastard>
	<20130621111420.5592707e@oracle.com>
	<20130624003316.GH29376@dastard>
	<20130624091035.6274800f@oracle.com>
	<20130626020924.GD29376@dastard>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, "Eric W. Biederman" <ebiederm@gmail.com>, xfs@oss.sgi.com

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 fs/xfs/xfs_ioctl.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 487dca5..123314e 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1655,6 +1655,23 @@ xfs_file_ioctl(
 		if (error)
 			return -XFS_ERROR(error);
 
+		/* non-privileged users should not be able to trim blocks on
+		 * objects they cannot write to, so require them to specify
+		 * either their own uid, or a group they are a member of
+		 */
+		if (!capable(CAP_SYS_ADMIN)) {
+			if (!(eofb.eof_flags & (XFS_EOF_FLAGS_UID | XFS_EOF_FLAGS_GID)))
+				return -XFS_ERROR(EPERM);
+
+			if ((eofb.eof_flags & XFS_EOF_FLAGS_UID) &&
+			    !uid_eq(current_fsuid(), keofb.eof_uid))
+				return -XFS_ERROR(EPERM);
+
+			if ((eofb.eof_flags & XFS_EOF_FLAGS_GID) &&
+			    !in_group_p(keofb.eof_gid))
+				return -XFS_ERROR(EPERM);
+		}
+
 		error = xfs_icache_free_eofblocks(mp, &keofb);
 		return -error;
 	}
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
