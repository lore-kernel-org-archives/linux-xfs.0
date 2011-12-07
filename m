Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pB7GMg73101051 for <xfs@oss.sgi.com>; Wed, 7 Dec 2011 10:22:42 -0600
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF988579381
	for <xfs@oss.sgi.com>; Wed,  7 Dec 2011 08:22:41 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id WFiBIrr6pvGXSyKY for <xfs@oss.sgi.com>;
	Wed, 07 Dec 2011 08:22:41 -0800 (PST)
Message-Id: <20111207161218.896811126@clark.kroah.org>
Date: Wed, 07 Dec 2011 08:11:52 -0800
From: Greg KH <gregkh@suse.de>
Subject: [050/104] xfs: Fix possible memory corruption in xfs_readlink
In-Reply-To: <20111207161246.GA10995@kroah.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org, greg@kroah.com
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com, bpm@sgi.com, Alex Elder <aelder@sgi.com>, akpm@linux-foundation.org, torvalds@linux-foundation.org, alan@lxorguk.ukuu.org.uk

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Carlos Maiolino <cmaiolino@redhat.com>

commit b52a360b2aa1c59ba9970fb0f52bbb093fcc7a24 upstream.

Fixes a possible memory corruption when the link is larger than
MAXPATHLEN and XFS_DEBUG is not enabled. This also remove the
S_ISLNK assert, since the inode mode is checked previously in
xfs_readlink_by_handle() and via VFS.

Updated to address concerns raised by Ben Hutchings about the loose
attention paid to 32- vs 64-bit values, and the lack of handling a
potentially negative pathlen value:
 - Changed type of "pathlen" to be xfs_fsize_t, to match that of
   ip->i_d.di_size
 - Added checking for a negative pathlen to the too-long pathlen
   test, and generalized the message that gets reported in that case
   to reflect the change
As a result, if a negative pathlen were encountered, this function
would return EFSCORRUPTED (and would fail an assertion for a debug
build)--just as would a too-long pathlen.

Signed-off-by: Alex Elder <aelder@sgi.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Ben Myers <bpm@sgi.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/xfs/xfs_vnodeops.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -113,7 +113,7 @@ xfs_readlink(
 	char		*link)
 {
 	xfs_mount_t	*mp = ip->i_mount;
-	int		pathlen;
+	xfs_fsize_t	pathlen;
 	int		error = 0;
 
 	trace_xfs_readlink(ip);
@@ -123,13 +123,19 @@ xfs_readlink(
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
-	ASSERT(S_ISLNK(ip->i_d.di_mode));
-	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
-
 	pathlen = ip->i_d.di_size;
 	if (!pathlen)
 		goto out;
 
+	if (pathlen < 0 || pathlen > MAXPATHLEN) {
+		xfs_alert(mp, "%s: inode (%llu) bad symlink length (%lld)",
+			 __func__, (unsigned long long) ip->i_ino,
+			 (long long) pathlen);
+		ASSERT(0);
+		return XFS_ERROR(EFSCORRUPTED);
+	}
+
+
 	if (ip->i_df.if_flags & XFS_IFINLINE) {
 		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
 		link[pathlen] = '\0';


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
