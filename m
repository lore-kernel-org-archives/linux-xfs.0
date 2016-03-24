Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 83B537CBB
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 06:16:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47CC3304062
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:16:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ZbS9JeMsmBwHEHhk (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 24 Mar 2016 04:15:58 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 5E4FDC00EB2E
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 11:15:56 +0000 (UTC)
Received: from localhost.localdomain (vpn1-7-36.ams2.redhat.com [10.36.7.36])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u2OBFbLP009274
	for <xfs@oss.sgi.com>; Thu, 24 Mar 2016 07:15:55 -0400
From: jtulak@redhat.com
Subject: [PATCH 19/19] mkfs: add optional 'reason' for illegal_option
Date: Thu, 24 Mar 2016 12:15:36 +0100
Message-Id: <1458818136-56043-20-git-send-email-jtulak@redhat.com>
In-Reply-To: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
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

From: Jan Tulak <jtulak@redhat.com>

Allow us to tell the user what exactly is wrong with his options.
For example, that the value is too small, instead of just generic
"bad option."

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 680c6c4..76e193d 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1550,11 +1550,18 @@ static __attribute__((noreturn)) void
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
+	if(reason == NULL){
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

@@ -1646,16 +1653,18 @@ getnum(

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
+		illegal_option(str, opts, index, "value is too small");
+	else if (c > sp->maxval)
+		illegal_option(str, opts, index, "value is too large");
 	if (sp->is_power_2 && !ispow2(c))
-		illegal_option(str, opts, index);
+		illegal_option(str, opts, index, "value has to be power of 2");
 	return c;
 }

--
2.6.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
