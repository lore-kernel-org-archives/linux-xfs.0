Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:62488 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751685AbdAYOIs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 25 Jan 2017 09:08:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] [RFC] xfs: work around unlikely() profiler glitch
Date: Wed, 25 Jan 2017 15:08:10 +0100
Message-Id: <20170125140821.2677725-1-arnd@arndb.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>, Nicolas Pitre <nico@linaro.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>

After a patch from Steven Rostedt to rework the profiling of
unlikely(), we get a couple of link errors in XFS on ARM:

fs/xfs/libxfs/xfs_bmap.o: In function `xfs_bmap_btalloc':
xfs_bmap.c:(.text.xfs_bmap_btalloc+0x8cc): undefined reference to `____ilog2_NaN'
xfs_bmap.c:(.text.xfs_bmap_btalloc+0xb34): undefined reference to `__aeabi_uldivmod'
xfs_bmap.c:(.text.xfs_bmap_btalloc+0xb7c): undefined reference to `__aeabi_uldivmod'

As I understand the problem, this is a result of the combination
of __builtin_constant_p() usage in three places: unlikely(),
xfs_bmap_btalloc(), and __div64_32(), where the latter attempts to use
__builtin_constant_p() to decide whether to either call an out-of-line
function for variable divisors or an optimized version for constant
divisors.

As I understand it, here we end up with a case where gcc has determined
that the argument is constant in some cases but variable in other cases,
and tries to split up the handling by implementing both paths and deciding
at runtime.

This seems to be related to the problem fixed in commit b33c8ff4431a
("tracing: Fix freak link error caused by branch tracer").

I don't know why exactly it goes wrong now, but we end up getting object
code emitted for the case that should have been eliminated after the
__builtin_constant_p() check. I don't think we'd ever run into the branches
to ____ilog2_NaN or __aeabi_uldivmod, but we get a link error anyway.

Fixes: d45ae1f7041a ("tracing: Process constants for (un)likely() profiler")i
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Nicolas Pitre <nico@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index d22f7930eb75..dca3ddd737d4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3629,7 +3629,7 @@ xfs_bmap_btalloc(
 		align = xfs_get_cowextsz_hint(ap->ip);
 	else if (xfs_alloc_is_userdata(ap->datatype))
 		align = xfs_get_extsz_hint(ap->ip);
-	if (unlikely(align)) {
+	if (unlikely_notrace(align)) {
 		error = xfs_bmap_extsize_align(mp, &ap->got, &ap->prev,
 						align, 0, ap->eof, 0, ap->conv,
 						&ap->offset, &ap->length);
-- 
2.9.0

