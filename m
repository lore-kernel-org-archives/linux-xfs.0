Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 81C6F7F37
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 11:37:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F06EAC001
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 09:37:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id YryMqVY4WS7sChUo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 06 Dec 2015 09:37:38 -0800 (PST)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id 2133AC0B7A0E
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 17:37:38 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS v2 1/6] check: Don't complain about missing
	tests/$FSTYP/group
Date: Sun,  6 Dec 2015 18:37:26 +0100
Message-Id: <1449423451-29845-2-git-send-email-agruenba@redhat.com>
In-Reply-To: <1449423451-29845-1-git-send-email-agruenba@redhat.com>
References: <1449423451-29845-1-git-send-email-agruenba@redhat.com>
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
To: xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

When filesystems don't have filesystem specific tests, those nonexistent
tests also won't have a group file.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 check | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/check b/check
index 8281322..4a9b332 100755
--- a/check
+++ b/check
@@ -95,6 +95,8 @@ get_group_list()
 	grp=$1
 
 	for d in $SRC_GROUPS $FSTYP; do
+		[ -e "$SRC_DIR/$d/group" ] || continue
+
 		l=$(sed -n < $SRC_DIR/$d/group \
 			-e 's/#.*//' \
 			-e 's/$/ /' \
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
