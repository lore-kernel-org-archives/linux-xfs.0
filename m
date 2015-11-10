Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AE6A57F47
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 14:28:14 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3408BAC004
	for <xfs@oss.sgi.com>; Tue, 10 Nov 2015 12:28:11 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	b9Xn7N5h8Qz9BXJt for <xfs@oss.sgi.com>;
	Tue, 10 Nov 2015 12:28:08 -0800 (PST)
Date: Wed, 11 Nov 2015 07:28:06 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfsprogs: fix cut & paste error in xfs_fsr.c
Message-ID: <20151110202806.GG14311@dastard>
References: <56423596.3030300@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56423596.3030300@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: jtulak@redhat.com, xfs@oss.sgi.com

On Tue, Nov 10, 2015 at 12:21:10PM -0600, Eric Sandeen wrote:
> Commit:
> 
> 7141fc xfsprogs: make fsr use mntinfo when there is no mntent
> 
> added an inadvertent "break;" to initallfs() after the call
> to find_mountpoint_check(); this is likely a cut & paste error
> from the call in find_mountpoint(), where we really *do* want to
> stop after the first one we find.
> 
> Fix that by removing the break, and fix the declaration-after-code.

That's not the right fix - the find_mountpoint_check() shoul dnot be
there at all. Patch to clean it all up is below.

-Dave.
-- 
Dave Chinner
david@fromorbit.com

fsr: clean up mountpoint checks

From: Dave Chinner <dchinner@redhat.com>

Fix up a stray hunk of code from commit 7141fc5 ("xfsprogs: make fsr
use mntinfo when there is no mntent") that coverity reported. Also
clean up a couple of whitespace issues introduced with that  commit,
too.

Addresses-Coverity-Id: 1338431
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fsr/xfs_fsr.c | 18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index b902acc..2887ceb 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -176,7 +176,6 @@ aborter(int unused)
  * here - the code that handles defragmentation of invidual files takes care
  * of that.
  */
-
 static char *
 find_mountpoint_check(struct stat64 *sb, struct mntent *t, struct stat64 *ms)
 {
@@ -200,9 +199,9 @@ find_mountpoint_check(struct stat64 *sb, struct mntent *t, struct stat64 *ms)
 			return NULL;
 
 		/*
-			* Make sure the mountpoint given by mtab is accessible
-			* before using it.
-			*/
+		 * Make sure the mountpoint given by mtab is accessible
+		 * before using it.
+		 */
 		if (stat64(t->mnt_dir, &sb2) < 0)
 			return NULL;
 	}
@@ -224,7 +223,7 @@ find_mountpoint(char *mtab, char *argname, struct stat64 *sb)
 		exit(1);
 	}
 
-	while ( (t = platform_mntent_next(&cursor)) != NULL) {
+	while ((t = platform_mntent_next(&cursor)) != NULL) {
 		mntp = find_mountpoint_check(sb, t, &ms);
 		if (mntp == NULL)
 			continue;
@@ -409,12 +408,10 @@ static void
 initallfs(char *mtab)
 {
 	struct mntent_cursor cursor;
-	char *mntp = NULL;
 	struct mntent *mp = NULL;
 	int mi;
 	char *cp;
 	struct stat64 sb;
-	struct stat64 ms;
 
 	/* malloc a number of descriptors, increased later if needed */
 	if (!(fsbase = (fsdesc_t *)malloc(fsbufsize * sizeof(fsdesc_t)))) {
@@ -432,12 +429,7 @@ initallfs(char *mtab)
 		exit(1);
 	}
 
-	while ( (mp = platform_mntent_next(&cursor)) != NULL) {
-		mntp = find_mountpoint_check(&sb, mp, &ms);
-		if (mntp == NULL)
-			continue;
-		break;
-
+	while ((mp = platform_mntent_next(&cursor)) != NULL) {
 		int rw = 0;
 
 		if (strcmp(mp->mnt_type, MNTTYPE_XFS ) != 0 ||

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
