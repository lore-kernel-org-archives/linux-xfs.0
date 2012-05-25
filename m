Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4PFqfpk134530 for <xfs@oss.sgi.com>; Fri, 25 May 2012 10:52:41 -0500
Received: from seven.medozas.de (seven.medozas.de [188.40.89.202]) by
	cuda.sgi.com with ESMTP id g5nf8gb9LDWG2zVk (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 25 May 2012 08:52:39 -0700 (PDT)
From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: xfsprogs/build: use standard type intptr_t
Date: Fri, 25 May 2012 17:52:25 +0200
Message-Id: <1337961147-11668-1-git-send-email-jengelh@inai.de>
In-Reply-To: <20120525103758.GD1707@infradead.org>
References: <20120525103758.GD1707@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: hch@infradead.org, joe@perches.com


The following changes since commit 14c26c6a05de138a4fd9a0c05ff8e7435a618324:

  xfs: add trace points for log forces (2012-05-21 10:45:44 -0500)

are available in the git repository at:
  git://inai.de/linux xfs

Jan Engelhardt (2):
      types.h: implement intptr_t and uintptr_t
      xfs: use standard (u)intptr_t types

 arch/avr32/include/asm/posix_types.h    |    2 +
 arch/blackfin/include/asm/posix_types.h |    2 +
 arch/cris/include/asm/posix_types.h     |    2 +
 arch/mn10300/include/asm/posix_types.h  |    2 +
 arch/powerpc/include/asm/posix_types.h  |    2 +
 arch/s390/include/asm/posix_types.h     |    4 +++
 arch/sh/include/asm/posix_types_64.h    |    2 +
 arch/sparc/include/asm/posix_types.h    |    2 +
 arch/xtensa/include/asm/posix_types.h   |    2 +
 fs/xfs/xfs_extfree_item.c               |    2 +-
 fs/xfs/xfs_filestream.c                 |   34 +++++++++++++++---------------
 fs/xfs/xfs_log.c                        |   10 ++++----
 fs/xfs/xfs_trans_ail.c                  |    6 ++--
 fs/xfs/xfs_types.h                      |   11 ----------
 include/asm-generic/posix_types.h       |    4 +++
 include/linux/types.h                   |    5 ++-
 16 files changed, 53 insertions(+), 39 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
