Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA88g2iK101451 for <xfs@oss.sgi.com>; Tue, 8 Nov 2011 02:42:02 -0600
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 972451DBA4B0
	for <xfs@oss.sgi.com>; Tue,  8 Nov 2011 00:42:01 -0800 (PST)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id WjCA7erIMvGb25Q6
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 00:42:01 -0800 (PST)
Received: by bkaq10 with SMTP id q10so218577bka.26
	for <xfs@oss.sgi.com>; Tue, 08 Nov 2011 00:42:00 -0800 (PST)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 1/3] xfstests: fix argument typo
Date: Tue,  8 Nov 2011 12:41:53 +0400
Message-Id: <1320741715-32692-1-git-send-email-dmonakhov@openvz.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, hch@lst.de


Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
---
 ltp/fsstress.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/ltp/fsstress.c b/ltp/fsstress.c
index 09c9529..9b3af17 100644
--- a/ltp/fsstress.c
+++ b/ltp/fsstress.c
@@ -385,7 +385,7 @@ int main(int argc, char **argv)
 			i = 0;
 			if (optarg[0] == 'c')
 				i = 1;
-			show_ops(1, NULL);
+			show_ops(i, NULL);
 			printf("\n");
                         nousage=1;
 			break;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
