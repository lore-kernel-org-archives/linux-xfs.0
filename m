Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A25AF7F63
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 14:20:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 83CAC8F8054
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 12:20:59 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Cd5pHm4oewCkin80 for <xfs@oss.sgi.com>;
	Wed, 09 Apr 2014 12:20:58 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 723AD6523F34
	for <xfs@oss.sgi.com>; Wed,  9 Apr 2014 14:20:58 -0500 (CDT)
Message-ID: <53459D9A.1040707@sandeen.net>
Date: Wed, 09 Apr 2014 14:20:58 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] libxfs: remove never-read "offset" assignment in readbufr_map
	& writebufr
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

libxfs_readbufr_map() & libxfs_writebufr() iterate
over bp->b_map[] and read each chunk.  The loops start
out correctly, getting the offset from bm_bn and the
length from bm_len.  After the IO it correctly
advances the target buffer pointer by len, but then
inexplicably advances "offset" by len as well.  The
whole point of this exercise is to handle discontiguous
ranges - marching offset along by length of IO done
is incorrect.

Thankfully offset is immediately reset to the proper
value again at the top of the loop for the next range,
so this is harmless, other than being confusing.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 9887423..7208a2f 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -758,7 +758,6 @@ libxfs_readbufr_map(struct xfs_buftarg *btp, struct xfs_buf *bp, int flags)
 			break;
 		}
 		buf += len;
-		offset += len;
 	}
 
 	if (!error)
@@ -878,7 +877,6 @@ libxfs_writebufr(xfs_buf_t *bp)
 				break;
 			}
 			buf += len;
-			offset += len;
 		}
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
