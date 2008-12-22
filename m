Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBMGi1wg006469 for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 10:44:01 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A25F3F8D5
	for <xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:00 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 3OcnwtP3qMJLy60F for
	<xfs@oss.sgi.com>; Mon, 22 Dec 2008 08:44:00 -0800 (PST)
Message-Id: <20081222164359.022639000@bombadil.infradead.org>
References: <20081222163831.755809000@bombadil.infradead.org>
Date: Mon, 22 Dec 2008 11:38:39 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/20] xfs_quota: Add missing options to --help
Content-Disposition: inline; filename=xfsprogs-quota-update-help
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: xfs@oss.sgi.com

From: Arkadiusz Miskiewicz <arekm@maven.pl>                                        


Reviewed-by: Eric Sandeen <sandeen@sandeen.net>
Reviewed-by: Christoph Hellwig <hch@lst.de>

---
 xfsprogs/quota/report.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/xfsprogs/quota/report.c b/xfsprogs/quota/report.c
index 7902dbd..21b4edb 100644
--- a/xfsprogs/quota/report.c
+++ b/xfsprogs/quota/report.c
@@ -45,7 +45,7 @@ dump_help(void)
 static void
 report_help(void)
 {
-	report_cmd.args = _("[-bir] [-gpu] [-ahnt] [-f file]");
+	report_cmd.args = _("[-bir] [-gpu] [-ahntLNU] [-f file]");
 	report_cmd.oneline = _("report filesystem quota information");
 	printf(_(
 "\n"
@@ -61,6 +61,8 @@ report_help(void)
 " -n -- skip identifier-to-name translations, just report IDs\n"
 " -N -- suppress the header from the output\n"
 " -t -- terse output format, hides rows which are all zero\n"
+" -L -- lower ID bound to report on\n"
+" -U -- upder ID bound to report on\n"
 " -g -- report group usage and quota information\n"
 " -p -- report project usage and quota information\n"
 " -u -- report user usage and quota information\n"
-- 
1.6.0.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
