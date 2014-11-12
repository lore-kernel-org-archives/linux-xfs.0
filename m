Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BCC3C7F47
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:57:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id AB4F8304043
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:57:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1Pw35NChj245xujq for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:57:22 -0800 (PST)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 9/9] xfsdump: fix uninit ackstr in content_mediachange_query()
Date: Wed, 12 Nov 2014 12:57:18 -0600
Message-Id: <1415818638-32700-10-git-send-email-sandeen@redhat.com>
In-Reply-To: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
References: <1415818638-32700-1-git-send-email-sandeen@redhat.com>
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

Today, this sends an uninitialized ackstr[0] to be mlog'd -
who knows what we get out of it.  Other places follow this
"count = 0, string = "\n"" pattern which seemsa bit odd, but
better than printing uninitialized memory.

To be completely honest, I have no test for this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 restore/content.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/restore/content.c b/restore/content.c
index c99aed7..bc5b398 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -2915,6 +2915,7 @@ content_mediachange_query( void )
 			bagp = 0;
 		}
 		ackcnt = 0;
+		ackstr[ ackcnt++ ] = "\n";
 		dlog_multi_ack( ackstr,
 				ackcnt );
 		querycnt = 0;
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
