Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7EHD3Q2248671 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 12:13:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7BB5253B66D
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 10:13:01 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2kireJ3EDMD5WJ4Q for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 10:13:01 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QseFA-0006kA-Q7
	for xfs@oss.sgi.com; Sun, 14 Aug 2011 17:13:00 +0000
Date: Sun, 14 Aug 2011 13:13:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: fix tracing builds inside the source tree
Message-ID: <20110814171300.GA25923@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

The code really requires the current source directory to be in the
header search path.  We already do this if building with an object
tree separate from the source, but it needs to be added manually
if building inside the source.  The cflags addition for it accidentally
got removed when collapsing the xfs directory structure.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/Makefile
===================================================================
--- xfs.orig/fs/xfs/Makefile	2011-08-13 06:41:29.586063467 -0700
+++ xfs/fs/xfs/Makefile	2011-08-13 06:41:58.245908204 -0700
@@ -16,6 +16,8 @@
 # Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 #
 
+ccflags-y += -I$(src)			# needed for trace events
+
 ccflags-$(CONFIG_XFS_DEBUG) += -g
 
 obj-$(CONFIG_XFS_FS)		+= xfs.o

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
