Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p04HiXgL021411 for <xfs@oss.sgi.com>; Tue, 4 Jan 2011 11:44:33 -0600
Received: from mail-gw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 039591D0B27A
	for <xfs@oss.sgi.com>; Tue,  4 Jan 2011 09:46:40 -0800 (PST)
Received: from mail-gw0-f53.google.com (mail-gw0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id dvLOiRcs6qJeRvf2
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 09:46:40 -0800 (PST)
Received: by gwb10 with SMTP id 10so4419169gwb.26
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 09:46:40 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 4 Jan 2011 09:46:39 -0800
Message-ID: <AANLkTi=B_zhQG9P22gXcb40JZT=VnEUedTW9xxcuN4cP@mail.gmail.com>
Subject: Simultaneously mounting one XFS partition on multiple machines
From: "Patrick J. LoPresti" <lopresti@gmail.com>
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

Hey, what's the worst that could happen?

I recently learned that some of my colleagues have configured two
Linux systems to simultaneously mount a single XFS partition residing
on shared storage.  Specifically, "system R" has the partition mounted
read-only while "system W" has it mounted read/write.

I told them that this sounds like a very bad idea because XFS is not a
clustered file system.  But they are skeptical because "it seems to be
working fine".  I need to know what the actual risks are and whether
they can be mitigated.

This partition holds large amounts of essentially archival data; that
is, it is read frequently but written rarely.  When they do want to
write to it, they do so via system W and then reboot system R.

I am no expert on XFS, but there are essentially two risks that I can see:

Risk 1: When making changes via system W, the view of the file system
from system R can become corrupted or inconsistent.  My colleagues are
aware of this and believe they can live with it, as long as the
underlying file system is not being damaged ("we can just reboot").

Risk 2: Any time the file system is mounted, even read-only, it will
replay the journal if it is non-empty.  (At least, I believe this is
true.  Could one of you please confirm or deny?)  So if machine R
should reboot while the journal is non-empty, it will replay it,
causing fairly unpredictable on-disk corruption.


Here are my questions.

1) When can a read-only XFS mount write to the disk, exactly?

2) If I do a "sync" on machine W (and perform no further writes), will
that truncate the journal?

3) What am I missing?


If your answer is "Please do not do this; get a clustered filesystem",
then trust me, you are preaching to the choir.  But these systems are
already in use and unlikely to be replaced soon, so at this point my
job is to find out what the exact risks are.  Any information will be
appreciated.

Thanks!

 - Pat

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
