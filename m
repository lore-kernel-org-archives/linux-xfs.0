Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CFaHkh261413 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 10:36:17 -0500
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id nJrTb8tRyj4tlyMH
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jun 2012 08:36:16 -0700 (PDT)
Received: by dadg9 with SMTP id g9so8817054dad.26
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 08:36:15 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/2] Add FALLOC_FL_ZERO_RANGE to fallocate
Date: Tue, 12 Jun 2012 17:36:02 +0200
Message-Id: <1339515364-17374-1-git-send-email-pbonzini@redhat.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com

This patch adds the FALLOC_FL_ZERO_RANGE operation mode to fallocate,
resembling the similar XFS ioctl.  The new mode can be used with
or without FALLOC_FL_KEEP_SIZE, but of course not together with
FALLOC_FL_PUNCH_HOLE.

Other filesystems can then provide the same functionality with a
standard system call.

Paolo
---
 fs/open.c              |    8 +++++++-
 fs/xfs/xfs_file.c      |   34 +++++++++++++++++++++++-----------
 include/linux/falloc.h |    1 +
 3 files changed, 32 insertions(+), 13 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
