Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0KCpVEX008515 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 06:51:33 -0600
Date: Wed, 20 Jan 2010 13:52:49 +0100
From: Christoph Egger <siccegge@stud.informatik.uni-erlangen.de>
Subject: Obsolete config in kernel build system (XFS_TRACE)
Message-ID: <20100120125249.GC3580@faui49.informatik.uni-erlangen.de>
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
To: linux-kernel@vger.kernel.org, hch@infradead.org, xfs@oss.sgi.com, xfs-masters@oss.sgi.com
Cc: Reinhard.Tartler@informatik.uni-erlangen.de, siccegge@stud.informatik.uni-erlangen.de

Hi all!

	As part of the VAMOS[0] research project at the University of
Erlangen we're checking referential integrity between kernel KConfig
options and in-code Conditional blocks.

	Git commit 0b1b213fcf3a8486ada99a2bab84ab8c6f51b264 by
Christoph Hellwig removed all References to CONFIG_XFS_TRACE, which is
unreferenced from KConfig side from the linux source code so there's
only a small bit of it left in KBuild. Mayee remove it as well?

./fs/xfs/Makefile:95
+++>

xfs-$(CONFIG_XFS_TRACE)         += xfs_btree_trace.o

<+++

	Please keep me informed of this patch getting confirmed /
merged so we can keep track of it.

Regards

	Christoph Egger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
