Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 35FF37CF8
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:09:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A0BDBAC003
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 16:09:42 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Hy7oiU8omTKT4o48 for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 16:09:40 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id A52A1545
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:09:40 -0500 (CDT)
Subject: Re: [PATCH 11/19] mkfs: table based parsing for converted parameters
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-12-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <40f1a322-bbd4-5da3-dc02-ac68122d404a@sandeen.net>
Date: Mon, 2 May 2016 18:09:40 -0500
MIME-Version: 1.0
In-Reply-To: <1461231593-31294-12-git-send-email-jtulak@redhat.com>
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
To: xfs@oss.sgi.com

The kernel enforces a max of XLOG_MAX_RECORD_BSIZE,
and it should match the limits in L_SUNIT after all ...

Eric Sandeen <sandeen@redhat.com>: fix min/max for "-l su"
---

su and sunit are ultimately setting the same parameter; their
limits should be the same.
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 0d28a84..3ffae42 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -395,8 +395,8 @@ struct opt_params lopts = {
 		},
 		{ .index = L_SU,
 		  .convert = true,
-		  .minval = 0,
-		  .maxval = UINT_MAX,
+		  .minval = XLOG_MIN_RECORD_BSIZE,
+		  .maxval = XLOG_MAX_RECORD_BSIZE,
 		  .defaultval = SUBOPT_NEEDS_VAL,
 		},
 		{ .index = L_DEV,


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
