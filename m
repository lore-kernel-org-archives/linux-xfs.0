Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DC4707D06
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:11:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A2882304032
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 16:11:44 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id gwW5zSu9NoTvLA70 for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 16:11:42 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4D7C5545
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:11:42 -0500 (CDT)
Subject: Re: [PATCH 14/19] mkfs: add string options to generic parsing
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-15-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <8145c82c-400a-c6f6-ee16-eda073fe7c4f@sandeen.net>
Date: Mon, 2 May 2016 18:11:41 -0500
MIME-Version: 1.0
In-Reply-To: <1461231593-31294-15-git-send-email-jtulak@redhat.com>
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

fix alignment on two-line logic statement; align 2nd line
with first conditional, not tabbed in.

Eric Sandeen <sandeen@redaht.com>: whitespace fixup

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 4186e98..f14fdff 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1520,7 +1520,7 @@ check_opt(
 		if (conflict_opt == LAST_CONFLICT)
 			break;
 		if (opts->subopt_params[conflict_opt].seen ||
-			opts->subopt_params[conflict_opt].str_seen)
+		    opts->subopt_params[conflict_opt].str_seen)
 			conflict(opts->name, (char **)opts->subopts,
 				 conflict_opt, index);
 	}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
