Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 16 Oct 2006 04:34:58 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k9GBYiaG031608
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 04:34:45 -0700
Received: from nf-out-0910.google.com (nf-out-0910.google.com [64.233.182.187])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8DDB24AEFE8
	for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 03:34:16 -0700 (PDT)
Received: by nf-out-0910.google.com with SMTP id n29so1590073nfc
        for <xfs@oss.sgi.com>; Mon, 16 Oct 2006 03:34:15 -0700 (PDT)
Message-ID: <2117b660610160232p1ffb28e0necfeeb377b5d4ead@mail.gmail.com>
Date: Mon, 16 Oct 2006 11:32:19 +0200
From: "Honza Fikar" <j.fikar@gmail.com>
Subject: recover xfs with v1 dirs on linux?
MIME-Version: 1.0
Content-Type: text/plain
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi everybody,

I want to recover old SGI Irix xfs disks, but I don't have any more the old
hardware. I was able to copy the xfs partition in a file with dd and I could
run xfs_recover, xfs_check and xfs_ncheck, which gives me the filenames. But
I was not able to mount this file. Kernel 2.6.17 gives "Function not
implemented", while 2.6.5 mounts, but the disk looks empty.

I think the reason is "v1 dirs":

file img4.xfs
img4.xfs: SGI XFS filesystem data (blksz 4096, inosz 256, v1 dirs)

Is there a way to get the files? I have the innode numbers and filenames as
an output of xfs_ncheck:
....
947364 abc/MIXDUM/MD110/20K/step9/dynrt.out.gz
184821 aa/Monteal/fmd3kev-45K/cluster.I.076.gz
1286273 abc/MIXDUM/MD111/250K/step10/dyn5.f1.gz
...


Thank you,
Jan


[[HTML alternate version deleted]]
