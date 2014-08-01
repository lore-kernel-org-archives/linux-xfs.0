Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36AC87F50
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 10:11:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 16A1F30405F
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2014 08:11:09 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id EubJ1rkM3EG72z7G (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 01 Aug 2014 08:11:09 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s71FB8Md022779
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Fri, 1 Aug 2014 11:11:08 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s71FB7GQ000950
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2014 11:11:07 -0400
Message-ID: <53DBAE0B.6020000@redhat.com>
Date: Fri, 01 Aug 2014 10:11:07 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs: avoid double free on xlog_recover_commit_trans error
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

xlog_recover_process_data() frees the transaction on
any error out of the oh_flags switch statement, but
in the XLOG_COMMIT_TRANS / xlog_recover_commit_trans() case,
the transaction has already been freed in 
xlog_recover_commit_trans() before the error is returned.

Avoid this by only freeing the transaction in
xlog_recover_commit_trans() if no error will be returned.

(Coverity spotted this)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 981af0f..e634ffd 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3514,9 +3514,11 @@ out:
 	if (!list_empty(&done_list))
 		list_splice_init(&done_list, &trans->r_itemq);
 
-	xlog_recover_free_trans(trans);
-
 	error2 = xfs_buf_delwri_submit(&buffer_list);
+	/* caller will free trans on error */
+	if (!error && !error2)
+		xlog_recover_free_trans(trans);
+
 	return error ? error : error2;
 }
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
