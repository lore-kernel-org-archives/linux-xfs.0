Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32A227F51
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 13:34:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10967304043
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 11:34:24 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id jnOufH1M2lUphHz8 for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 11:34:22 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 6CA5863C3C99
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 13:34:22 -0500 (CDT)
Message-ID: <55DCB52D.3030809@sandeen.net>
Date: Tue, 25 Aug 2015 13:34:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfs_repair: set args.geo in longform_dir2_entry_check_data
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

Here's another one where we miss setting da_args->geo:

longform_dir2_entry_check_data
        struct xfs_da_args      da = {
                .dp = ip,
		// .geo is unset
        };
...
	libxfs_dir2_data_make_free(&da ...)
		xfs_dir2_data_make_free
			endptr = (char *)hdr + args->geo->blksize;
				BOOM

Addresses-Coverity-Id: 1298008
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Have to wonder if there are more of these :(

diff --git a/repair/phase6.c b/repair/phase6.c
index 04638c2..951587e 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -1506,6 +1506,7 @@ longform_dir2_entry_check_data(
 	int			wantmagic;
 	struct xfs_da_args	da = {
 		.dp = ip,
+		.geo = mp->m_dir_geo,
 	};
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
