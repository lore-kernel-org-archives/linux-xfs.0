Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0L9FnHF063248 for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 03:15:49 -0600
Received: from mail-fx0-f209.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5C05617F6FA
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 01:16:49 -0800 (PST)
Received: from mail-fx0-f209.google.com (mail-fx0-f209.google.com
	[209.85.220.209]) by cuda.sgi.com with ESMTP id
	28gEXLthPMtALYZE for <xfs@oss.sgi.com>;
	Thu, 21 Jan 2010 01:16:49 -0800 (PST)
Received: by fxm1 with SMTP id 1so7546104fxm.36
	for <xfs@oss.sgi.com>; Thu, 21 Jan 2010 01:16:48 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 21 Jan 2010 10:16:45 +0100
Message-ID: <23d352591001210116s73926b58g97173d8a1b1e82c3@mail.gmail.com>
Subject: Badness in xfs_write at fs/xfs/linux-2.6/xfs_lrw.c:838
From: andutt <andreas.utterberg@gmail.com>
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

Hi Xfs foks

I have some problem with an XFS filesystem, im running Suse SLES 10
SP2, with 2.6.16.60-0.42.7-smp kernel untop of a veritas 1Tb volume, a
couple of times per day i get following in my kernel log.

Badness in xfs_write at fs/xfs/linux-2.6/xfs_lrw.c:838
Call Trace: <ffffffff88bcb550>{:xfs:xfs_write+1415}
<ffffffff8014ab93>{get_futex_key+71}
<ffffffff8014acff>{unqueue_me+134}
<ffffffff88bc7c5a>{:xfs:xfs_file_aio_write+103}
<ffffffff80185f15>{do_sync_write+199}
<ffffffff8012c6f7>{default_wake_function+0}
<ffffffff80171d1d>{find_extend_vma+22}
<ffffffff8014ba50>{do_futex+1869}
<ffffffff8014820e>{autoremove_wake_function+0}
<ffffffff802ea6c0>{thread_return+0} <ffffffff8018684e>{vfs_write+215}
<ffffffff80186f06>{sys_pwrite64+82} <ffffffff8010bced>{error_exit+0}
<ffffffff8010ae16>{system_call+126}
Badness in xfs_write at fs/xfs/linux-2.6/xfs_lrw.c:838

I have used xfs_check on the device, and it did not report any errors
and the filesystem is mounteble with no errors,  do you guys have any
idea:s on how to proceed?, or what could be the source of the problem?

Thanx in advance!

/Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
