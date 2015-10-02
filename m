Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 375AA29DF6
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 13:19:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 346578F8049
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 11:19:59 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4QqWmDUuWLeGtTMG (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 02 Oct 2015 11:19:58 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (Postfix) with ESMTPS id C40C92C76FC
	for <xfs@oss.sgi.com>; Fri,  2 Oct 2015 18:19:57 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-128.bos.redhat.com [10.18.41.128])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t92IJvFg004541
	for <xfs@oss.sgi.com>; Fri, 2 Oct 2015 14:19:57 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 16/18] xfs_copy: store data buf alignment in buf data
	structure
Date: Fri,  2 Oct 2015 14:19:53 -0400
Message-Id: <1443809995-20395-17-git-send-email-bfoster@redhat.com>
In-Reply-To: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
References: <1443809995-20395-1-git-send-email-bfoster@redhat.com>
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

The write buffer data structure stores various characteristics of the
write buffer, such as I/O alignment requirements, etc., but does not
include the required data buffer alignment.

Data buffer alignment is a required buffer initialization parameter and
the v5 log format support code would like to initialize an independent
log buffer based on the predetermined alignment constraints encoded into
the global write buffer. Update the write buffer data structure to store
the provided data alignment value such that it can be accessed
throughout the codebase. This patch does not change existing behavior.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 copy/xfs_copy.c | 1 +
 copy/xfs_copy.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 0481ece..e03796a 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -352,6 +352,7 @@ wbuf_init(wbuf *buf, int data_size, int data_align, int min_io_size, int id)
 			return NULL;
 	}
 	ASSERT(min_io_size % BBSIZE == 0);
+	buf->data_align = data_align;
 	buf->min_io_size = min_io_size;
 	buf->size = data_size;
 	buf->id = id;
diff --git a/copy/xfs_copy.h b/copy/xfs_copy.h
index e76b937..6b94130 100644
--- a/copy/xfs_copy.h
+++ b/copy/xfs_copy.h
@@ -54,6 +54,7 @@ typedef struct {
 	int		id;		/* buffer ID */
 	size_t		size;		/* size of buffer -- fixed */
 	size_t		min_io_size;	/* for direct I/O */
+	int		data_align;	/* data buffer alignment */
 	xfs_off_t	position;	/* requested position (bytes) */
 	size_t		length;		/* requested length (bytes) */
 	char		*data;		/* pointer to data buffer */
-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
