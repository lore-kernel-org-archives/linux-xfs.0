Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B5D0D29DFB
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 12:28:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A500B8F8037
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 10:28:17 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id y8speHYcKUfqAfZa (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 06 Apr 2015 10:28:16 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id BB0DBBBF5A
	for <xfs@oss.sgi.com>; Mon,  6 Apr 2015 17:28:15 +0000 (UTC)
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t36HSE8r014337
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Mon, 6 Apr 2015 13:28:15 -0400
Message-ID: <5522C22E.4000107@redhat.com>
Date: Mon, 06 Apr 2015 12:28:14 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: remove unreachable code in libxfs_inode_alloc
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

This code does:

        if (!ialloc_context && !ip)
                return;

        // if !ip here, ialloc_context must be true

        if (ialloc_context) {
                ...
                if (!ip)
                        error = ENOSPC;
                if (error)
                        return error;
                // if !ip in this block we've returned
        }

        // so (!ip) cannot be true here
        if (!ip)
                error = ENOSPC;

(cherry picked this one out of Coverity reports)

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/util.c b/libxfs/util.c
index 6464a1b..49eb76d 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -700,8 +700,6 @@ libxfs_inode_alloc(
 		if (error)
 			return error;
 	}
-	if (!ip)
-		error = ENOSPC;
 
 	*ipp = ip;
 	return error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
