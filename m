Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4E5C97CFD
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:11:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 049BE8F8037
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 16:11:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UNW6nPteApAbZzx7 for <xfs@oss.sgi.com>;
	Mon, 02 May 2016 16:11:02 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id EB2A6545
	for <xfs@oss.sgi.com>; Mon,  2 May 2016 18:11:01 -0500 (CDT)
Subject: Re: [PATCH 13/19] mkfs: encode conflicts into parsing table
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
	<1461231593-31294-14-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <220fc3b5-6c26-52c9-a56e-8fa717d92cde@sandeen.net>
Date: Mon, 2 May 2016 18:11:01 -0500
MIME-Version: 1.0
In-Reply-To: <1461231593-31294-14-git-send-email-jtulak@redhat.com>
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

Remove now-encoded conflict under case L_FILE

The .conflicts handle this now, no need to keep it around.

Eric Sandeen <sandeen@redhat.com>: remove explicit L_FILE conflict

---
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 03d3c06..cdc81a9 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1867,9 +1867,6 @@ main(
 				case L_FILE:
 					xi.lisfile = getnum(value, &lopts,
 							    L_FILE);
-					if (xi.lisfile && loginternal)
-						conflict('l', subopts, L_INTERNAL,
-							 L_FILE);
 					if (xi.lisfile)
 						xi.lcreat = 1;
 					break;


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
