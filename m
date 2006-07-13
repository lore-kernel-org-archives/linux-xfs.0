Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Jul 2006 10:58:41 -0700 (PDT)
Received: from nz-out-0102.google.com (nz-out-0102.google.com [64.233.162.203])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6DHwHDW021038
	for <xfs@oss.sgi.com>; Thu, 13 Jul 2006 10:58:19 -0700
Received: by nz-out-0102.google.com with SMTP id 13so103624nzn
        for <xfs@oss.sgi.com>; Thu, 13 Jul 2006 10:57:56 -0700 (PDT)
Message-ID: <44B689AC.8030408@gmail.com>
Date: Fri, 14 Jul 2006 01:58:04 +0800
From: "Michael Li (gmail)" <mikore.li@gmail.com>
MIME-Version: 1.0
Subject: XFS bmap to disk lba question.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: nathans@sgi.com, xfs@oss.sgi.com

Hi, Nathans and all,

I am looking for the way to map bmap of file extent to disk physical LBA 
on IRIX/CXFS. Since here is the BEST place to get help about XFS, I send 
my confusion to you.

We know that the command xfs_bmap can show us the file's extent range, 
for example [20 - 100], but how can we know the real physical secoter ID 
(or
named as LBA) of file's first block(512Bytes) on a raw disk? I've read 
XVM admin for IRIX,  it show us less clue for this mapping.
We can get this mapping method on linux, as linux/xfs is open sourced, 
but IRIX is not, we don't know how to do it on IRIX, although the 
filesystem is the in the same name XFS.

Furthermore, is it the same way to mapping the bmap/LBA in a striped 
volume. For example: a file on striped volume is in bmap range[20, 1000].
there are 3 physical disks(disk1/disk2/disk3)  in the stripe, stripe 
unit is 128. each stripe unit has 32 512B-blocks. How can we map the 
first block in the file to one of disk's X sector?
After read XVM document. the stripe chunksize should be 128*32 blocks, 
the stripe width is 3. In the special case, the file's first block must 
belong to disk1.
But how can we know the real LBA on disk1? assume it is a very simple 
stripe group, not for log subvolume/realtime subvolume.

Could you help me?

Thanks very much!

Michael

BTW: If we should not talk about IRIX here, I will stop posting such a 
topic here. Sorry for the noise.
