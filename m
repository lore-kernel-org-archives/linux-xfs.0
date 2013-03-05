Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D7C798053
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 16:41:55 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C1049304066
	for <xfs@oss.sgi.com>; Tue,  5 Mar 2013 14:41:55 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id prCuE6ikuIoLlOOR for <xfs@oss.sgi.com>;
	Tue, 05 Mar 2013 14:41:54 -0800 (PST)
Message-ID: <513674B2.9030900@sandeen.net>
Date: Tue, 05 Mar 2013 16:41:54 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Fix hang when mkfs.btrfs isn't present
References: <512D1E3E.9050907@redhat.com>
In-Reply-To: <512D1E3E.9050907@redhat.com>
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
Cc: Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

My earlier patch (xfstests: handle new mkfs.btrfs -f option cleanly)
had a flaw in that if set_prog_path mkfs.btrfs returns nothing,
the grep will hang.

Test for that case to avoid it, and just return the empty string
in that case.

Reported-by: Rich Johnston <rjohnston@sgi.com>
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common.config b/common.config
index c10163a..a0b017d 100644
--- a/common.config
+++ b/common.config
@@ -108,7 +108,7 @@ set_prog_path()
 set_btrfs_mkfs_prog_path_with_opts()
 {
 	p=`set_prog_path mkfs.btrfs`
-	if grep -q 'force overwrite' $p; then
+	if [ "$p" != "" ] && grep -q 'force overwrite' $p; then
 		echo "$p -f"
 	else
 		echo $p


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
