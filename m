Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6796D7F9B
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 14:17:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 399CE30404E
	for <xfs@oss.sgi.com>; Fri, 23 Oct 2015 12:17:18 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id D6SVN8LeDOSTB6yb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Oct 2015 12:17:12 -0700 (PDT)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 0/4] Richacl support
Date: Fri, 23 Oct 2015 21:17:04 +0200
Message-Id: <1445627828-14661-1-git-send-email-agruenba@redhat.com>
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
To: xfs@oss.sgi.com, david@fromorbit.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Here are my xfsprogs changes for adding richacl support.

The richacl on-disk format should be the same across all filesystems, so it
makes sense to share the verification code.  I've added code for that to
librichacl.  To avoid an additional runtime dependency for xfs_repair,
librichacl is linked statically.

The changes are available in git form here:

  https://github.com/andreas-gruenbacher/xfsprogs-dev richacl

Thanks,
Andreas

Andreas Gruenbacher (4):
  libxfs: Add the richacl incompatible feature flag
  mkfs.xfs: Add support for the richacl feature flag
  xfs_repair: Improve warning for invalid attributes
  xfs_repair: Validate richacl attributes

 configure.ac         | 22 +++++++++++++++++++++
 include/builddefs.in |  5 +++++
 libxfs/xfs_format.h  |  4 +++-
 man/man8/mkfs.xfs.8  |  9 +++++++++
 mkfs/xfs_mkfs.c      | 20 +++++++++++++++++--
 po/de.po             | 18 +++--------------
 po/pl.po             | 14 +++----------
 repair/Makefile      |  2 +-
 repair/attr_repair.c | 55 +++++++++++++++++++++++++++++++++++++++++-----------
 9 files changed, 108 insertions(+), 41 deletions(-)

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
