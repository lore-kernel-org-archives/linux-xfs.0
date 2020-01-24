Return-Path: <SRS0=JklA=3N=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 481E6C35240
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A61B214AF
	for <linux-xfs@archiver.kernel.org>; Fri, 24 Jan 2020 00:17:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Qf6wgEpj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgAXARL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jan 2020 19:17:11 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:34122 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727056AbgAXARL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jan 2020 19:17:11 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0935v024877;
        Fri, 24 Jan 2020 00:17:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=vQYVkEaYryusdXge9Qv1MuafSuAS/FAZpkViHXYIrl4=;
 b=Qf6wgEpjuwq/U12ozPsSpbs+OpHKXPRVG0eHoMr/wTXaLRBCeUxPjNY553nIDgZOCSLO
 k12A3J+fL3ptbAc2e0fyfYiBA0hDD0DtSQ2bZScPlm0Yqacu0JjzUytEkhwEWLgrHZ6U
 ij/Mb9EvUMw9pE9iIWNbu3B/n4wv3o8j7JU9sjHgW2fgIQYCJuewkKipo57H0DbAzx56
 onGXMeLAspPqrhwSJRqVhhTfGKp+QlunoLe0h71P51uHt4rwfBOiXFoL7IxpdszulpoL
 abMb7PsRyRqnJDTsUum0KA9h38U3fbY3FWE3ggMAMS3sAvR/6HHngblUUqL3Rhj0Ob8E GQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2xkseuwvv8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00O0Eafv156543;
        Fri, 24 Jan 2020 00:17:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userp3020.oracle.com with ESMTP id 2xqnrs0avq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Jan 2020 00:17:08 +0000
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00O0H7XH007678;
        Fri, 24 Jan 2020 00:17:07 GMT
Received: from localhost (/10.145.179.16)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 23 Jan 2020 16:17:07 -0800
Subject: [PATCH 5/8] xfs_db: dump per-AG reservations
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 23 Jan 2020 16:17:05 -0800
Message-ID: <157982502518.2765410.15232492114026905479.stgit@magnolia>
In-Reply-To: <157982499185.2765410.18206322669640988643.stgit@magnolia>
References: <157982499185.2765410.18206322669640988643.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001240000
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9509 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001240000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Add a new 'agresv' command to print the size and free blocks count of an
AG along with the size and usage of the per-AG reservation.  This
command can be used to aid in diagnosing why a particular filesystem
fails the mount time per-AG space reservation, and to figure out how
much space needs to be freed from a given AG to fix the problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/info.c                |  104 ++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/libxfs_api_defs.h |    5 ++
 man/man8/xfs_db.8        |    5 ++
 3 files changed, 114 insertions(+)


diff --git a/db/info.c b/db/info.c
index e5f1c2dd..fc5ccfe7 100644
--- a/db/info.c
+++ b/db/info.c
@@ -8,6 +8,7 @@
 #include "init.h"
 #include "output.h"
 #include "libfrog/fsgeom.h"
+#include "libfrog/logging.h"
 
 static void
 info_help(void)
@@ -45,8 +46,111 @@ static const struct cmdinfo info_cmd = {
 	.help =		info_help,
 };
 
+static void
+agresv_help(void)
+{
+	dbprintf(_(
+"\n"
+" Print the size and per-AG reservation information some allocation groups.\n"
+"\n"
+" Specific allocation group numbers can be provided as command line arguments.\n"
+" If no arguments are provided, all allocation groups are iterated.\n"
+"\n"
+));
+
+}
+
+static void
+print_agresv_info(
+	xfs_agnumber_t	agno)
+{
+	struct xfs_buf	*bp;
+	struct xfs_agf	*agf;
+	xfs_extlen_t	ask = 0;
+	xfs_extlen_t	used = 0;
+	xfs_extlen_t	free = 0;
+	xfs_extlen_t	length = 0;
+	int		error;
+
+	error = -libxfs_refcountbt_calc_reserves(mp, NULL, agno, &ask, &used);
+	if (error)
+		xfrog_perror(error, "refcountbt");
+	error = -libxfs_finobt_calc_reserves(mp, NULL, agno, &ask, &used);
+	if (error)
+		xfrog_perror(error, "finobt");
+	error = -libxfs_rmapbt_calc_reserves(mp, NULL, agno, &ask, &used);
+	if (error)
+		xfrog_perror(error, "rmapbt");
+
+	error = -libxfs_read_agf(mp, NULL, agno, 0, &bp);
+	if (error)
+		xfrog_perror(error, "AGF");
+	agf = XFS_BUF_TO_AGF(bp);
+	length = be32_to_cpu(agf->agf_length);
+	free = be32_to_cpu(agf->agf_freeblks) +
+	       be32_to_cpu(agf->agf_flcount);
+	libxfs_putbuf(bp);
+
+	printf("AG %d: length: %u free: %u reserved: %u used: %u",
+			agno, length, free, ask, used);
+	if (ask - used > free)
+		printf(" <not enough space>");
+	printf("\n");
+}
+
+static int
+agresv_f(
+	int			argc,
+	char			**argv)
+{
+	xfs_agnumber_t		agno;
+	int			i;
+
+	if (argc > 1) {
+		for (i = 1; i < argc; i++) {
+			long	a;
+			char	*p;
+
+			errno = 0;
+			a = strtol(argv[i], &p, 0);
+			if (p == argv[i])
+				errno = ERANGE;
+			if (errno) {
+				perror(argv[i]);
+				continue;
+			}
+
+			if (a < 0 || a >= mp->m_sb.sb_agcount) {
+				fprintf(stderr, "%ld: Not a AG.\n", a);
+				continue;
+			}
+
+			print_agresv_info(a);
+		}
+		return 0;
+	}
+
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++)
+		print_agresv_info(agno);
+
+	return 0;
+}
+
+static const struct cmdinfo agresv_cmd = {
+	.name =		"agresv",
+	.altname =	NULL,
+	.cfunc =	agresv_f,
+	.argmin =	0,
+	.argmax =	-1,
+	.canpush =	0,
+	.args =		NULL,
+	.oneline =	N_("print AG reservation stats"),
+	.help =		agresv_help,
+};
+
 void
 info_init(void)
 {
 	add_command(&info_cmd);
+	add_command(&agresv_cmd);
 }
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index eed63ace..cc7304ad 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -173,4 +173,9 @@
 #define xfs_ag_init_headers		libxfs_ag_init_headers
 #define xfs_buf_delwri_submit		libxfs_buf_delwri_submit
 
+#define xfs_refcountbt_calc_reserves	libxfs_refcountbt_calc_reserves
+#define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
+#define xfs_rmapbt_calc_reserves	libxfs_rmapbt_calc_reserves
+#define xfs_read_agf			libxfs_read_agf
+
 #endif /* __LIBXFS_API_DEFS_H__ */
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 9f1ff761..7f73d458 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -179,6 +179,11 @@ Set current address to the AGI block for allocation group
 .IR agno .
 If no argument is given, use the current allocation group.
 .TP
+.BI "agresv [" agno ]
+Displays the length, free block count, per-AG reservation size, and per-AG
+reservation usage for a given AG.
+If no argument is given, display information for all AGs.
+.TP
 .BI "attr_remove [\-r|\-u|\-s] [\-n] " name
 Remove the specified extended attribute from the current file.
 .RS 1.0i

