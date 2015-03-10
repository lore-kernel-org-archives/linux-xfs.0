Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B649D7F3F
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 15:56:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9496E8F8071
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 13:56:02 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id u9EWhdQQgugsr1HC for <xfs@oss.sgi.com>;
	Tue, 10 Mar 2015 13:56:01 -0700 (PDT)
Received: from Liberator.local (unknown [40.139.179.11])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id B871663C3A20
	for <xfs@oss.sgi.com>; Tue, 10 Mar 2015 15:56:00 -0500 (CDT)
Message-ID: <54FF5A5F.90201@sandeen.net>
Date: Tue, 10 Mar 2015 16:55:59 -0400
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/4] xfs_repair: dirty inode in process_sf_dir2 if we change
	namelen
References: <54FF59DA.60700@sandeen.net>
In-Reply-To: <54FF59DA.60700@sandeen.net>
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
To: xfs-oss <xfs@oss.sgi.com>

There are two "fix sfep->namelen" cases, but we only mark
*dino_dirty = 1 in one of them.  Add the other to ensure that
the change gets written out.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/dir2.c b/repair/dir2.c
index 6b8964d..25793e9 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -881,6 +881,7 @@ _("entry \"%*.*s\" in shortform directory %" PRIu64 " references %s inode %" PRI
 _("zero length entry in shortform dir %" PRIu64 ", resetting to %d\n"),
 						ino, namelen);
 					sfep->namelen = namelen;
+					*dino_dirty = 1;
 				} else  {
 					do_warn(
 _("zero length entry in shortform dir %" PRIu64 ", would set to %d\n"),

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
