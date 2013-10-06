Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DAFE07F52
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 15:09:56 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A6AD08F8039
	for <xfs@oss.sgi.com>; Sun,  6 Oct 2013 13:09:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xcWDbpeGJayaqpVI for
	<xfs@oss.sgi.com>; Sun, 06 Oct 2013 13:09:55 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r96K9tNh017488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 6 Oct 2013 16:09:55 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r96K9sgC015906
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sun, 6 Oct 2013 16:09:55 -0400
Message-ID: <5251C392.1020407@redhat.com>
Date: Sun, 06 Oct 2013 15:09:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: filter projid32bit info out of growfs & info output
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

commit 67e389c xfsprogs: support CRC enabled filesystem detection

changed xfs_growfs (and by extension xfs_info) to report
the projid32bit value.  This breaks at least xfstest xfs/206 due to
the changed output, so filter it as we do for mkfs in that test.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/tests/xfs/206 b/tests/xfs/206
index fcbdd9e..d2c2ade 100755
--- a/tests/xfs/206
+++ b/tests/xfs/206
@@ -86,6 +86,7 @@ echo "=== xfs_growfs ==="
 xfs_growfs $tmpdir \
 	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
 		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
+		-e "s/, projid32bit=[0-9]//" \
 		-e "/.*crc=/d"
 
 # and double-check the new geometry
@@ -93,6 +94,7 @@ echo "=== xfs_info ==="
 xfs_info $tmpdir \
 	| sed -e "s,^meta-data=.*isize,meta-data=FILE                   isize,g" \
 		-e "s/\(^log.*blocks=\)\([0-9]*,\)/\1XXXXX,/" \
+		-e "s/, projid32bit=[0-9]//" \
 		-e "/.*crc=/d"
 
 # _cleanup cleans up for us

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
