Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 238E87F4E
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 15:18:00 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E4AE3304048
	for <xfs@oss.sgi.com>; Mon, 23 Mar 2015 13:17:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 7G4bXsc1fWHQxC9w for <xfs@oss.sgi.com>;
	Mon, 23 Mar 2015 13:17:58 -0700 (PDT)
Message-ID: <551074F6.80706@sandeen.net>
Date: Mon, 23 Mar 2015 15:17:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 12/13 V2] xfs_repair: don't clear . or .. in process_dir2_data
References: <1426624395-8258-1-git-send-email-sandeen@redhat.com>
	<1426624395-8258-13-git-send-email-sandeen@redhat.com>
In-Reply-To: <1426624395-8258-13-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>, xfs@oss.sgi.com

process_dir2_data() has special . and .. processing; it is able
to correct these inodes, so there is no reason to clear them.

Do this before we adjust a length 0 filename to length 1, so
that we don't take this action on an accidentally created "."
name from a hidden dotfile.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: Move the new hunk up, before we possibly reset the namelen to 1; 
a 0-length ".hidden" file could turn in a length-1 "." and not get
cleared.

diff --git a/repair/dir2.c b/repair/dir2.c
index 9e6c67d..8ecc29b 100644
--- a/repair/dir2.c
+++ b/repair/dir2.c
@@ -1318,6 +1318,18 @@ _("entry \"%*.*s\" at block %d offset %" PRIdPTR " in directory inode %" PRIu64
 				dep->namelen, dep->namelen, dep->name,
 				da_bno, (intptr_t)ptr - (intptr_t)d, ino,
 				clearreason, ent_ino);
+
+		/*
+		 * We have a special dot & dotdot fixer-upper below which can
+		 * sort out the proper inode number, so don't clear it.
+		 */
+		if ((dep->namelen == 1 && dep->name[0] == '.') ||
+		    (dep->namelen == 2 &&
+		     dep->name[0] == '.' && dep->name[1] == '.')) {
+			clearino = 0;
+			clearreason = NULL;
+		}
+
 		/*
 		 * If the name length is 0 (illegal) make it 1 and blast
 		 * the entry.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
