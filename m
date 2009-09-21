Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8LIDTsL117934 for <xfs@oss.sgi.com>; Mon, 21 Sep 2009 13:13:29 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9AFF916ABEA4
	for <xfs@oss.sgi.com>; Mon, 21 Sep 2009 11:14:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id o9vB02HjE9RaBOBl for
	<xfs@oss.sgi.com>; Mon, 21 Sep 2009 11:14:45 -0700 (PDT)
Message-ID: <4AB7C293.8050600@sandeen.net>
Date: Mon, 21 Sep 2009 13:14:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: "XFS: Invalid block length (0x%x) given for buffer" log level
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs mailing list <xfs@oss.sgi.com>, David Chinner <dgc@sgi.com>

Hey, commit:

commit 3228149ceb8b045e324cd268be9182bb26e6488b
Author: Dave Chinner <david@fromorbit.com>
Date:   Thu Jan 22 15:37:47 2009 +1100

    xfs: Check buffer lengths in log recovery

    Before trying to obtain, read or write a buffer,
    check that the buffer length is actually valid. If
    it is not valid, then something read in the recovery
    process has been corrupted and we should abort
    recovery.

    Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
    Tested-by: Eric Sesterhenn <snakebyte@gmx.de>
    Reviewed-by: Christoph Hellwig <hch@infradead.org>
    Reviewed-by: Felix Blyakher <felixb@sgi.com>
    Signed-off-by: Dave Chinner <david@fromorbit.com>
    Signed-off-by: Felix Blyakher <felixb@sgi.com>

added some XFS_ERROR_REPORTs, but at _HIGH:

+       if (nbblks <= 0 || nbblks > log->l_logBBsize) {
+               xlog_warn("XFS: Invalid block length (0x%x) given for
buffer", nbblks);
+               XFS_ERROR_REPORT("xlog_get_bp(1)",
+                                XFS_ERRLEVEL_HIGH, log->l_mp);
+               return NULL;
+       }

which means unless logging is turned up HIGH (higher than default), we
won't see it.  Should this be HIGH?  Not sure what the original intent was.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
