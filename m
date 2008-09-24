Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Sep 2008 01:41:48 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8O8fjU0008904
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:41:46 -0700
Received: from mu-out-0910.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E7BCC966A11
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:43:18 -0700 (PDT)
Received: from mu-out-0910.google.com (mu-out-0910.google.com [209.85.134.190]) by cuda.sgi.com with ESMTP id TsuGiAlTiOTYkKNb for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:43:18 -0700 (PDT)
Received: by mu-out-0910.google.com with SMTP id w1so3906424mue.2
        for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 01:43:18 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by debian.localdomain (Postfix) with ESMTP id EF04FBEB31
	for <xfs@oss.sgi.com>; Wed, 24 Sep 2008 11:43:13 +0300 (EEST)
Message-ID: <48D9FDA1.8050701@gmail.com>
Date: Wed, 24 Sep 2008 11:43:13 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
MIME-Version: 1.0
Subject: Speed of rm compared to reiserfs (slow)
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

Hi,

I am happily using xfs for /var, /usr and /, and I am very pleased with
the read speed.
I've just recommended xfs to a friend, and he complained about the speed
of rm.

I did a test on my box, and indeed the speed of rm is order of magnitude
slower compared to reiserfs.
I already use lazy-count, and noatime/nodiratime. Write barriers are off
because I run on raid10.

Is there anything else I can tune to get faster rm speed?

Test:
1. svn co svn://gcc.gnu.org/svn/gcc/trunk gcc
2.
# sync; echo 3 >/proc/sys/vm/drop_caches; sync
3. time rm -rf gcc

Results for XFS:
real 1m30.100s
user 0m0.188s
sys 0m11.401s

Results for Reiserfs:
real 0m10.937s
user 0m0.140s
sys 0m6.616


# xfs_info /var
meta-data=/dev/mapper/vg--all-lv--var isize=256    agcount=4,
agsize=85196800 blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=340787200, imaxpct=5
         =                       sunit=16     swidth=96 blks
naming   =version 2              bsize=4096
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=16 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

# mount | grep var
/dev/mapper/vg--all-lv--var on /var type xfs (rw,noatime,nodiratime)

# mount | grep reiserfs
/dev/mapper/vg--all-lv--home on /home type reiserfs (rw,noatime,notail)

# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/md3              9.2G  5.1G  3.7G  58% /
tmpfs                 2.0G   12K  2.0G   1% /lib/init/rw
udev                   10M  188K  9.9M   2% /dev
tmpfs                 2.0G     0  2.0G   0% /dev/shm
/dev/mapper/vg--all-lv--usr
                      100G  5.3G   95G   6% /usr
/dev/mapper/vg--all-lv--var
                      1.3T  230G  1.1T  18% /var
/dev/mapper/vg--all-lv--home
                      600G   41G  560G   7% /home
tmpfs                 2.0G  1.9M  2.0G   1% /tmp

[   23.861497] Filesystem "dm-0": Disabling barriers, not supported by
the underlying device
[   23.863915] XFS mounting filesystem dm-0
[   24.050223] Ending clean XFS mount for filesystem: dm-0
[   24.056295] Filesystem "dm-1": Disabling barriers, not supported by
the underlying device
[   24.056295] XFS mounting filesystem dm-1
[   24.248025] Ending clean XFS mount for filesystem: dm-1
[   24.335968] ReiserFS: dm-2: found reiserfs format "3.6" with standard
journal
[   24.335968] ReiserFS: dm-2: using ordered data mode
[   24.359968] ReiserFS: dm-2: journal params: device dm-2, size 8192,
journal first block 18,
max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   24.359968] ReiserFS: dm-2: checking transaction log (dm-2)
[   24.426700] ReiserFS: dm-2: Using r5 hash to sort names


Best regards,
--Edwin
