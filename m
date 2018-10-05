Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:48092 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727456AbeJELAM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Oct 2018 07:00:12 -0400
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 03/15] mkfs.xfs: include full parser prototype in subopts definition
Date: Thu,  4 Oct 2018 23:03:04 -0500
Message-Id: <1538712196-13625-4-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
References: <1538712196-13625-1-git-send-email-sandeen@sandeen.net>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Eric Sandeen <sandeen@redhat.com>

Fixes sparse warnings about this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 mkfs/xfs_mkfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 7c05c6f..2eec005 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1661,7 +1661,10 @@ sector_opts_parser(
 struct subopts {
 	char		opt;
 	struct opt_params *opts;
-	int		(*parser)();
+	int		(*parser)(struct opt_params	*opts,
+				  int			subopt,
+				  char			*value,
+				  struct cli_params	*cli);
 } subopt_tab[] = {
 	{ 'b', &bopts, block_opts_parser },
 	{ 'd', &dopts, data_opts_parser },
-- 
1.8.3.1
