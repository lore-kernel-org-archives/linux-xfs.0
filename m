Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 99EC57F47
	for <xfs@oss.sgi.com>; Sun, 20 Sep 2015 02:03:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23CB8AC003
	for <xfs@oss.sgi.com>; Sun, 20 Sep 2015 00:03:37 -0700 (PDT)
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72]) by
	cuda.sgi.com with ESMTP id S27eRWFKsEjLEIEB (version=TLSv1
	cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 20 Sep 2015 00:03:35 -0700 (PDT)
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: [PATCH 1/2] xfs: Add __GFP_NORETRY and __GFP_NOWARN to open-coded
	__GFP_NOFAIL allocations
Date: Sun, 20 Sep 2015 16:03:13 +0900
Message-Id: <1442732594-4205-1-git-send-email-penguin-kernel@I-love.SAKURA.ne.jp>
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
To: david@fromorbit.com
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>, xfs@oss.sgi.com

kmem_alloc(), kmem_zone_alloc() and xfs_buf_allocate_memory() are doing
open-coded __GFP_NOFAIL allocations with warning messages as a canary.
But since small !__GFP_NOFAIL allocations retry forever inside memory
allocator unless TIF_MEMDIE is set, the canary does not help even if
allocations are stalling. Thus, this patch adds __GFP_NORETRY so that
we can know possibility of allocation deadlock.

If a patchset which makes small !__GFP_NOFAIL !__GFP_FS allocations not
retry inside memory allocator is merged, warning messages by
warn_alloc_failed() will dominate warning messages by the canary
because each thread calls warn_alloc_failed() for approximately
every 2 milliseconds. Thus, this patch also adds __GFP_NOWARN so that
we won't flood kernel logs by these open-coded __GFP_NOFAIL allocations.
Next patch compensates for lack of comm name and pid by addding them to
the canary.

Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: Michal Hocko <mhocko@suse.com>
---
 fs/xfs/kmem.c    | 4 ++--
 fs/xfs/xfs_buf.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/kmem.c b/fs/xfs/kmem.c
index a7a3a63..1fcf90d 100644
--- a/fs/xfs/kmem.c
+++ b/fs/xfs/kmem.c
@@ -46,7 +46,7 @@ void *
 kmem_alloc(size_t size, xfs_km_flags_t flags)
 {
 	int	retries = 0;
-	gfp_t	lflags = kmem_flags_convert(flags);
+	gfp_t	lflags = kmem_flags_convert(flags) | __GFP_NORETRY | __GFP_NOWARN;
 	void	*ptr;
 
 	do {
@@ -111,7 +111,7 @@ void *
 kmem_zone_alloc(kmem_zone_t *zone, xfs_km_flags_t flags)
 {
 	int	retries = 0;
-	gfp_t	lflags = kmem_flags_convert(flags);
+	gfp_t	lflags = kmem_flags_convert(flags) | __GFP_NORETRY | __GFP_NOWARN;
 	void	*ptr;
 
 	do {
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 8ecffb3..cbd4f91 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -289,7 +289,7 @@ xfs_buf_allocate_memory(
 {
 	size_t			size;
 	size_t			nbytes, offset;
-	gfp_t			gfp_mask = xb_to_gfp(flags);
+	gfp_t			gfp_mask = xb_to_gfp(flags) | __GFP_NORETRY | __GFP_NOWARN;
 	unsigned short		page_count, i;
 	xfs_off_t		start, end;
 	int			error;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
