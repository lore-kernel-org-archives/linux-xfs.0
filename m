Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48336 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbeKUI2I (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 21 Nov 2018 03:28:08 -0500
Subject: [PATCH 01/10] fsx: shut up compiler warnings
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 20 Nov 2018 13:56:47 -0800
Message-ID: <154275100761.8611.14831629844790867009.stgit@magnolia>
In-Reply-To: <154275100143.8611.10235098565750994724.stgit@magnolia>
References: <154275100143.8611.10235098565750994724.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Fix unused variables and potential filename overflows in fsx.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 ltp/fsx.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/ltp/fsx.c b/ltp/fsx.c
index b0157ba3..5601c70c 100644
--- a/ltp/fsx.c
+++ b/ltp/fsx.c
@@ -121,7 +121,7 @@ char	*bname;				/* basename of our test file */
 char	*logdev;			/* -i flag */
 char	*logid;				/* -j flag */
 char	dname[1024];			/* -P flag */
-char	goodfile[1024];
+char	goodfile[PATH_MAX];
 int	dirpath = 0;			/* -P flag */
 int	fd;				/* fd for our test file */
 
@@ -185,7 +185,7 @@ const char *replayops = NULL;
 const char *recordops = NULL;
 FILE *	fsxlogf = NULL;
 FILE *	replayopsf = NULL;
-char opsfile[1024];
+char opsfile[PATH_MAX];
 int badoff = -1;
 int closeopen = 0;
 
@@ -541,13 +541,13 @@ mark_log(void)
 void
 dump_fsync_buffer(void)
 {
-	char fname_buffer[1024];
+	char fname_buffer[PATH_MAX];
 	int good_fd;
 
 	if (!good_buf)
 		return;
 
-	snprintf(fname_buffer, 1024, "%s%s.mark%d", dname,
+	snprintf(fname_buffer, sizeof(fname_buffer), "%s%s.mark%d", dname,
 		 bname, mark_nr);
 	good_fd = open(fname_buffer, O_WRONLY|O_CREAT|O_TRUNC, 0666);
 	if (good_fd < 0) {
@@ -1865,7 +1865,7 @@ main(int argc, char **argv)
 {
 	int	i, style, ch;
 	char	*endp, *tmp;
-	char logfile[1024];
+	char logfile[PATH_MAX];
 	struct stat statbuf;
 	int o_flags = O_RDWR|O_CREAT|O_TRUNC;
 
