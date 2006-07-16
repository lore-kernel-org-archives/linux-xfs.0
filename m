Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 16 Jul 2006 15:47:49 -0700 (PDT)
Received: from py-out-1112.google.com (py-out-1112.google.com [64.233.166.183])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6GMlZDW007659
	for <xfs@oss.sgi.com>; Sun, 16 Jul 2006 15:47:35 -0700
Received: by py-out-1112.google.com with SMTP id c39so1267188pyd
        for <xfs@oss.sgi.com>; Sun, 16 Jul 2006 15:47:10 -0700 (PDT)
Message-ID: <e692861c0607161423o552588a3yd603a423afc71004@mail.gmail.com>
Date: Sun, 16 Jul 2006 17:23:23 -0400
From: "Gregory Maxwell" <gmaxwell@gmail.com>
Subject: Stripe alignment with RAID volumes
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I have a 12 disk HW raid 5 with 128K stripe size. I built my 4k block
XFS volume with sunit=256,swidth=2816. Everything is peachy ... or is
it?

If I built my volume on a partitioned block device (i.e. /dev/sda2) it
is quite likely that my partition will not start on a 128K boundary,
so what XFS thinks is a single disk is actually two.. Worse, it's
possible that the partition won't start on a 4K boundary... so every
FS block read of a block on the 128K boundary will require hitting two
disks (and potentially take an extra disk rotation if the disks are
not spin aligned).

This problem wouldn't be limited to XFS, but as one of the few FSes
that pays a lot of attention to the underlying disk geometry I thought
someone here might have given though to this issue.

I' believe that I have avoided this problem on my own system by just
putting the FS on the raw device....  which isn't so bad because msdos
partition tables won't permit a 3TB partition in any case... but
surely there must be a more general solution.

Would it be possible to add a stripe start offset to XFS?   I expect
it would be fairly easy to make a disk benchmark tool which could
estimate sunit, swidth, and start offset..
