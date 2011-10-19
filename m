Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9JATtEe178046 for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 05:29:55 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DF41AF7DE10
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:37:53 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id R5twMqNC2NHnxCod
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:37:53 -0700 (PDT)
Received: by bke11 with SMTP id 11so2102048bke.26
	for <xfs@oss.sgi.com>; Wed, 19 Oct 2011 03:29:52 -0700 (PDT)
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: [PATCH 0/8] xfstests: Bunch of new tests
Date: Wed, 19 Oct 2011 14:29:41 +0400
Message-Id: <1319020189-13584-1-git-send-email-dmonakhov@openvz.org>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, jack@suse.cz, hch@infradead.org, aelder@sgi.com
Cc: Dmitry Monakhov <dmonakhov@openvz.org>

xfstests: fsstress should kill children tasks before exit
xfstests: add different logging option to fsstress
xfstests: add fallocate support to fsstress
xfstests: fsstress add FS_IOC_{SET,GET}FLAGS operations
xfstests: Dump inode info when possible
xfstests: add fiemap operation

# Following testcase will fail on recent kernel in case of ext4
# Some fixes are already available here:
# http://www.spinics.net/lists/linux-ext4/msg27857.html
xfstests: add new stress test

# Following testcase will fail on recent kernel in case of ext3/4 
# Fixes available here:
#  http://patchwork.ozlabs.org/patch/120581/
#  http://patchwork.ozlabs.org/patch/120582/
xfstests: add new quota stress test

P.S: ext4 still contains bugs caused by ordered_mode=>journal_mode
switch for didicated inode (chattr +j ./afile), so you temproraly
disable this test by adding "-f setattr=0" to $FSSTRESS_AVOID var.
     

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
