Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 560937CB5
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 10:42:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 267248F8037
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 08:42:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id x2tvPwBHMky37wY5 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 08:42:53 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 1BFFE83F47
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 15:42:53 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 6/8] mkfs: add cross-section conflict checks
Date: Tue,  2 Aug 2016 17:42:17 +0200
Message-Id: <1470152539-18759-7-git-send-email-jtulak@redhat.com>
In-Reply-To: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
References: <1470152539-18759-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

Checks are modified to work with cross-section conflicts (data, metada, log, ...).

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 43 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 34 insertions(+), 9 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6f3f278..2eca989 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -728,6 +728,9 @@ struct opt_params {
 	},
 };
 
+static void conflict_struct(struct opt_params 	*opt, struct subopt_param *subopt,
+			struct subopt_conflict 	*conflict);
+
 #define TERABYTES(count, blog)	((__uint64_t)(count) << (40 - (blog)))
 #define GIGABYTES(count, blog)	((__uint64_t)(count) << (30 - (blog)))
 #define MEGABYTES(count, blog)	((__uint64_t)(count) << (20 - (blog)))
@@ -1329,10 +1332,9 @@ check_opt(
 			break;
 		if (conflict_opt.test_values)
 			break;
-		if (opt->subopt_params[conflict_opt.subopt].seen ||
-		    opt->subopt_params[conflict_opt.subopt].str_seen) {
-			conflict(opt->name, (char **)opt->subopts,
-				 conflict_opt.subopt, index);
+		if (opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||
+		    opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].str_seen) {
+			conflict_struct(opt, sp, &conflict_opt);
 		}
 	}
 }
@@ -1357,13 +1359,12 @@ check_opt_value(
 			break;
 		if (!conflict_opt.test_values)
 			break;
-		if ((opt->subopt_params[conflict_opt.subopt].seen ||
-				    opt->subopt_params[conflict_opt.subopt].str_seen) &&
-		    opt->subopt_params[conflict_opt.subopt].value
+		if ((opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].seen ||
+		     opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].str_seen) &&
+		    opts[conflict_opt.opt].subopt_params[conflict_opt.subopt].value
 				== conflict_opt.invalid_value &&
 		    value == conflict_opt.at_value) {
-			conflict(opt->name, (char **)opt->subopts,
-				 conflict_opt.subopt, index);
+			conflict_struct(opt, sp, &conflict_opt);
 		}
 	}
 }
@@ -3430,12 +3431,36 @@ conflict(
 	char		*tab[],
 	int		oldidx,
 	int		newidx)
+
 {
 	fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
 		opt, tab[oldidx], opt, tab[newidx]);
 	usage();
 }
 
+static void
+conflict_struct(
+	struct opt_params 	*opt,
+	struct subopt_param	*subopt,
+	struct subopt_conflict 	*conflict)
+{
+	if(conflict->message) {
+		fprintf(stderr, _("Cannot specify both -%c %s and -%c %s: %s\n"),
+			opt->name,
+			opt->subopts[subopt->index],
+			opts[conflict->opt].name,
+			opts[conflict->opt].subopts[conflict->subopt],
+			_(conflict->message));
+	} else {
+		fprintf(stderr, _("Cannot specify both -%c %s and -%c %s\n"),
+			opt->name,
+			opt->subopts[subopt->index],
+			opts[conflict->opt].name,
+			opts[conflict->opt].subopts[conflict->subopt]);
+	}
+	usage();
+}
+
 
 static void
 illegal(
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
