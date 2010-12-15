Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBF1NRRO159513 for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 19:23:28 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 057BA1CC7780
	for <xfs@oss.sgi.com>; Tue, 14 Dec 2010 17:25:18 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	5cTGylSFUl60f1AT for <xfs@oss.sgi.com>;
	Tue, 14 Dec 2010 17:25:18 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	50125664-1927428
	for <xfs@oss.sgi.com>; Wed, 15 Dec 2010 11:55:17 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PSg7H-00064F-SC
	for xfs@oss.sgi.com; Wed, 15 Dec 2010 12:25:15 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PSg5d-0004H7-Hq
	for xfs@oss.sgi.com; Wed, 15 Dec 2010 12:23:33 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/7] xfs: serialise unaligned direct IOs
Date: Wed, 15 Dec 2010 12:23:21 +1100
Message-Id: <1292376208-16282-1-git-send-email-david@fromorbit.com>
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

Folks,

This series aims to serialise unaligned direct IOs to an inode to avoid
corruption causedby sub-block zeroing races. The previous approaches at the
direct IO layer fail because for !DIO_LOCKING filesystems like XFS, there is no
way we can track and serialise all the direct IOs to a given inode in a race
free manner. While we can track them, we cannot close the races between mapping
blocks and tracked IO completion occuring before subsequent tracking lookups
without adding some kind of locking to the DIO layer. Hence for !DIO_LOCKING
users, unaligned direct IO needs to be serialised at a higher layer.

Because the xfs_file_aio_write() path is so twisted and difficult to follow,
adding new locking cases to the code is difficult to verify that it is correct
in all cases. Hence the series starts by cleaning up the code and splitting
apart the direct IO and buffered IO paths before adding the unaligned direct IO
detection and serialisation.

The first patch fixes a sync write error handling bug - we should consider
pushing that to .38. The next patches factor code that is common to write and
splice into helpers. The direct and buffered IO paths are then separated out
and the common write checks and bounds limiting is factored out into a helper.

Finally, the serialisation of unaligned direct IOs is added by a big-hammer
approach. That is, we take the i_mutex and XFS_IOLOCK_EXCL and hold them across
the unaligned IO submission. This means that unaligned direct IO submission is
serialised, and non-AIO DIO is serialised completely.

For unaligned AIO DIO, this would only serialise the submission of the DIO,
leaving the sub-block zeroing races open for unaligned writes into unwritten
extents. To avoid this problem, we use xfs_ioend_wait() to ensure all AIO
writes have completed before we submit the unaligned write. We do this wait
holding the i_mutex so we serialise against other unaligned AIO as there is no
need to serialise against aligned DIO.

The following changes since commit cf7d7e5a1980d1116ee152d25dac382b112b9c17:

  Linux 2.6.37-rc5 (2010-12-06 20:09:04 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/dgc/xfsdev.git aio-unaligned

Dave Chinner (7):
      xfs: ensure sync write errors are returned
      xfs: factor common post-write isize handling code
      xfs: factor post-write newsize updates
      xfs: split direct IO write path from xfs_file_aio_write
      xfs: split buffered IO write path from xfs_file_aio_write
      xfs: factor common write setup code
      xfs: serialise unaligned direct IOs

 fs/xfs/linux-2.6/xfs_file.c |  440 ++++++++++++++++++++++++-------------------
 1 files changed, 248 insertions(+), 192 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
