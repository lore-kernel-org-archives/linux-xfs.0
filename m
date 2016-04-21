Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 443A17CB3
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AA072AC005
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:12 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vJ6j0nUdZvH2E4ZV (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:11 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 16DE8C056819
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:40:11 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0V007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:40:10 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 18/19] mkfs: add optional 'reason' for illegal_option
Date: Thu, 21 Apr 2016 11:39:52 +0200
Message-Id: <1461231593-31294-19-git-send-email-jtulak@redhat.com>
In-Reply-To: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
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

Allow us to tell the user what exactly is wrong with the specified options.
For example, that the value is too small, instead of just generic "bad option."

Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
CHANGES:
* code format (space)
* add translation _() to strings
---
 mkfs/xfs_mkfs.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a35c4a5..c4cd5ba 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1546,11 +1546,18 @@ static __attribute__((noreturn)) void
 illegal_option(
 	const char	*value,
 	struct opt_params	*opts,
-	int		index)
+	int		index,
+	const char *reason)
 {
-	fprintf(stderr,
-		_("Illegal value %s for -%c %s option\n"),
-		value, opts->name, opts->subopts[index]);
+	if (reason == NULL){
+		fprintf(stderr,
+			_("Illegal value %s for -%c %s option\n"),
+			value, opts->name, opts->subopts[index]);
+	} else {
+		fprintf(stderr,
+			_("Illegal value %s for -%c %s option: %s\n"),
+			value, opts->name, opts->subopts[index], reason);
+	}
 	usage();
 }
 
@@ -1642,16 +1649,18 @@ getnum(
 
 		c = strtoll(str, &str_end, 0);
 		if (c == 0 && str_end == str)
-			illegal_option(str, opts, index);
+			illegal_option(str, opts, index, NULL);
 		if (*str_end != '\0')
-			illegal_option(str, opts, index);
+			illegal_option(str, opts, index, NULL);
 	}
 
 	/* Validity check the result. */
-	if (c < sp->minval || c > sp->maxval)
-		illegal_option(str, opts, index);
+	if (c < sp->minval)
+		illegal_option(str, opts, index, _("value is too small"));
+	else if (c > sp->maxval)
+		illegal_option(str, opts, index, _("value is too large"));
 	if (sp->is_power_2 && !ispow2(c))
-		illegal_option(str, opts, index);
+		illegal_option(str, opts, index, _("value must be a power of 2"));
 	return c;
 }
 
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
