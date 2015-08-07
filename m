Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 029737F4E
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 00:18:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C21E5304032
	for <xfs@oss.sgi.com>; Thu,  6 Aug 2015 22:18:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id oUYDoOl05821noA2 for <xfs@oss.sgi.com>;
	Thu, 06 Aug 2015 22:18:53 -0700 (PDT)
Received: from Liberator.local (unknown [64.146.202.138])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 58F3C63C6061
	for <xfs@oss.sgi.com>; Fri,  7 Aug 2015 00:18:52 -0500 (CDT)
Message-ID: <55C43FBA.1080408@sandeen.net>
Date: Thu, 06 Aug 2015 22:18:50 -0700
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] mkfs.xfs: fix ftype-vs-crc option combination testing
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
To: xfs-oss <xfs@oss.sgi.com>

mkfs.xfs got weird along the way; today it has different outcomes
depending on the order of option specification:

$ mkfs/mkfs.xfs -n ftype=1 -m crc=0 -dfile,name=fsfile,size=16g
cannot specify both crc and ftype
$ mkfs/mkfs.xfs -m crc=0 -n ftype=1 -dfile,name=fsfile,size=16g
<succeeds>

Somehow the tests got written as being constrained on what options
are specified - and in what order! - vs actually testing for
incompatible feature sets.

It's fine to specify both crc & ftype options, as long as it's an
allowed combination, so just test for the incompatible combination
(crc=1 and ftype=0) after all options have been processed.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 69d61c7..9042796 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1477,11 +1477,6 @@ main(
 					if (c < 0 || c > 1)
 						illegal(value, "m crc");
 					crcs_enabled = c;
-					if (nftype && crcs_enabled) {
-						fprintf(stderr,
-_("cannot specify both crc and ftype\n"));
-						usage();
-					}
 					break;
 				case M_FINOBT:
 					if (!value || *value == '\0')
@@ -1555,11 +1550,6 @@ _("cannot specify both crc and ftype\n"));
 					if (nftype)
 						respec('n', nopts, N_FTYPE);
 					dirftype = atoi(value);
-					if (crcs_enabled) {
-						fprintf(stderr,
-_("cannot specify both crc and ftype\n"));
-						usage();
-					}
 					nftype = 1;
 					break;
 				default:
@@ -1714,6 +1704,10 @@ _("Minimum block size for CRC enabled filesystems is %d bytes.\n"),
 			XFS_MIN_CRC_BLOCKSIZE);
 		usage();
 	}
+	if (crcs_enabled && !dirftype) {
+		fprintf(stderr, _("cannot disable ftype with crcs enabled\n"));
+		usage();
+	}
 
 	memset(&ft, 0, sizeof(ft));
 	get_topology(&xi, &ft, force_overwrite);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
