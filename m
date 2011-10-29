Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9T0mU9d175060 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 19:48:30 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6987CFD534D
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 17:48:28 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id lrySMoqVaZzCob4h
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 17:48:28 -0700 (PDT)
Received: by bkbzs8 with SMTP id zs8so1327051bkb.26
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 17:48:27 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/8] xfstests: Bunch of new stress tests -v3
Date: Sat, 29 Oct 2011 04:48:09 +0400
Message-Id: <1319849297-3506-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org
Cc: Dmitry Monakhov <dmonakhov@openvz.org>, aelder@sgi.com, hch@lst.de, xfs@oss.sgi.com

Changes from v2 ( in request to  Christoph's comments)
 - rearange patch sequance
 - codestyle cleanups
 - give better description
 - add tunable mask for FS_IOC_SETFLAGS test.

LOG:
# Following patches improves fsstress logging
 xfstests: fsstress dump inode info when possible
 xfstests: add different logging option to fsstress
# Following patch makes fsstress more manageable
 xfstests: fsstress should kill children tasks before exit
# Following patches add new tests
 xfstests: add fallocate support to fsstress
 xfstests: fsstress add FS_IOC_{SET,GET}FLAGS operations v2
 xfstests: add fiemap operation to fsstress
# Following testcase may fail on recent kernel in case of ext4
# Some fixes are already available here:
# http://www.spinics.net/lists/linux-ext4/msg27857.html
# http://www.spinics.net/lists/linux-ext4/msg28552.html
 xfstests: add a new test that runs fsstress under ENOSPC conditions

# Following testcase may fail on recent kernel in case of ext3/4 
# Fixes available here:
#  http://patchwork.ozlabs.org/patch/120581/
#  http://patchwork.ozlabs.org/patch/120582/
xfstests: add a new quota test that runs fsstress under ENOSPC conditions

P.S: ext4 still contains bugs caused by ordered_mode=>journal_mode
switch for didicated inode (chattr +j ./afile), so one can temproraly
disable jdata switch test by adding FSSTRESS_AVOID="-M 0xffffbfff"

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
