Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 505D48457
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 19:00:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 14C568F8035
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:50 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id JPXhFc0CQ73foZV3 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 17:00:48 -0700 (PDT)
Subject: [PATCH 20/29] xfs_io: scrub the realtime rmap
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 17:00:42 -0700
Message-ID: <147216964277.7022.404152059105249323.stgit@birch.djwong.org>
In-Reply-To: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
References: <147216950911.7022.438115723996286926.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/scrub.c |    1 +
 1 file changed, 1 insertion(+)


diff --git a/io/scrub.c b/io/scrub.c
index 8b93121..82825de 100644
--- a/io/scrub.c
+++ b/io/scrub.c
@@ -49,6 +49,7 @@ static const struct scrub_descr scrubbers[] = {
 	{"bmapbtc",	false},
 	{"rtbitmap",	false},
 	{"rtsummary",	false},
+	{"rtrmapbt",	false},
 	{NULL, false},
 };
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
