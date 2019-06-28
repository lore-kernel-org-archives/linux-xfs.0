Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56516 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725783AbfF1Vfl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jun 2019 17:35:41 -0400
Date: Fri, 28 Jun 2019 17:35:30 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: mysterious test failure when running xfstests on XFS
Message-ID: <20190628213530.GA19489@mit.edu>
References: <20190628202117.GA15307@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190628202117.GA15307@mit.edu>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, sandeen@sandeen.net
Cc: linux-xfs@vger.kernel.org

On Fri, Jun 28, 2019 at 04:21:17PM -0400, Theodore Ts'o wrote:
> 
> rm -f $IMAGE
> + rm -f /tmp/10216.img
> touch $IMAGE
> + touch /tmp/10216.img
> ./xfsprogs-dev/mkfs/mkfs.xfs  -d file,name=$IMAGE,size=512m
> + ./xfsprogs-dev/mkfs/mkfs.xfs -d file,name=/tmp/10216.img,size=512m
> mkfs.xfs: Use the -f option to force overwrite.

I figured out.  The problem is I'm building xfsprogs with
--disable-blkid.  This was for historical reasons, back when I was
trying to use a fully hermetic build, since the cross compiler I was
using would not include anything in /usr/include.  I'm no longer
trying to use the Android Native Development Kit (NDK), so maybe I'll
give up on this goal and use the system-proivded blkid.  (Or I'll
build util-linux in xfstests-bld and solve the problem that way.)

In any case, here's a patch to fix this.

						- Ted


>From 4767f770ff5d60635164410e7834e5aece505424 Mon Sep 17 00:00:00 2001
From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 28 Jun 2019 17:21:50 -0400
Subject: [PATCH] libfrog: fix check_overwrite() when blkid is not available

A return value of 0 means "nothing found"; the code was incorrectly
returning 1 instead.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 libfrog/topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libfrog/topology.c b/libfrog/topology.c
index cac164f3..c2e93e65 100644
--- a/libfrog/topology.c
+++ b/libfrog/topology.c
@@ -264,7 +264,7 @@ int
 check_overwrite(
 	const char	*device)
 {
-	return 1;
+	return 0;
 }
 
 static void blkid_get_topology(
-- 
2.22.0
