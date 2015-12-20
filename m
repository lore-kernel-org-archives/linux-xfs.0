Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D9BA67F37
	for <xfs@oss.sgi.com>; Sun, 20 Dec 2015 01:00:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BC566304032
	for <xfs@oss.sgi.com>; Sat, 19 Dec 2015 23:00:44 -0800 (PST)
Received: from mout.web.de (mout.web.de [212.227.17.11]) by cuda.sgi.com with
	ESMTP id 1xcKJkAFqua0jnJl (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 19 Dec 2015 23:00:41 -0800 (PST)
From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] XFS: Use a signed return type for suffix_kstrtoint()
Message-ID: <5676520D.2060806@users.sourceforge.net>
Date: Sun, 20 Dec 2015 08:00:29 +0100
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, Dave Chinner <david@fromorbit.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, kernel-janitors@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 20 Dec 2015 07:56:36 +0100

The return type "unsigned long" was used by the suffix_kstrtoint()
function even though it will eventually return a negative error code.
Improve this implementation detail by using the type "int" instead.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 436b6ef..59c9b7b 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -137,7 +137,7 @@ static const match_table_t tokens = {
 };
 
 
-STATIC unsigned long
+STATIC int
 suffix_kstrtoint(char *s, unsigned int base, int *res)
 {
 	int	last, shift_left_factor = 0, _res;
-- 
2.6.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
