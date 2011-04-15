Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3FGjmKs078176 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 11:45:48 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7B94DBD905A
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 09:49:11 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id 8AqVlOynp1NLiE6d for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 09:49:11 -0700 (PDT)
Message-ID: <4DA876C2.8050606@oracle.com>
Date: Fri, 15 Apr 2011 09:48:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
MIME-Version: 1.0
Subject: xfs build warning
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>

on i386, when CONFIG_LBDAF is not enabled:

fs/xfs/linux-2.6/./xfs_trace.h:1354: warning: format '%llx' expects type 'long long unsigned int', but argument 22 has type 'xfs_fsblock_t'


-- 
~Randy

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
