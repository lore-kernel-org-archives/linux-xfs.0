Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4NLe0mu024820 for <xfs@oss.sgi.com>; Mon, 23 May 2011 16:40:00 -0500
Received: from mail-pz0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D7D93162B515
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 14:39:59 -0700 (PDT)
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id XsO1SQKG3JZUzHdy
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 14:39:59 -0700 (PDT)
Received: by pzk6 with SMTP id 6so3195158pzk.26
	for <xfs@oss.sgi.com>; Mon, 23 May 2011 14:39:59 -0700 (PDT)
MIME-Version: 1.0
From: Nuno Subtil <subtil@gmail.com>
Date: Mon, 23 May 2011 14:39:39 -0700
Message-ID: <BANLkTikNMrFzxJF4a86ZM55r3D=ThPFmOw@mail.gmail.com>
Subject: XFS umount issue
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
To: xfs-oss <xfs@oss.sgi.com>

I have an MD RAID-1 array with two SATA drives, formatted as XFS.
Occasionally, doing an umount followed by a mount causes the mount to
fail with errors that strongly suggest some sort of filesystem
corruption (usually 'bad clientid' with a seemingly arbitrary ID, but
occasionally invalid log errors as well).

The one thing in common among all these failures is that they require
xfs_repair -L to recover from. This has already caused a few
lost+found entries (and data loss on recently written files). I
originally noticed this bug because of mount failures at boot, but
I've managed to repro it reliably with this script:

while true; do
	mount /store
	(cd /store && tar xf test.tar)
	umount /store
	mount /store
	rm -rf /store/test-data
	umount /store
done

test.tar contains around 100 files with various sizes inside
test-data/, ranging from a few hundred KB to around 5-6MB. The failure
triggers within minutes of starting this loop.

I'm not entirely sure that this is XFS-specific, but the same script
does run successfully overnight on the same MD array with ext3 on it.
This is on an ARM system running kernel 2.6.39.

Has something like this been seen before?

Thanks,
Nuno

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
