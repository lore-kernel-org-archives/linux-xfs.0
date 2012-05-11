Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4BEVNLC035922
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 09:31:24 -0500
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id 5gzpQEFIAGXj5imS
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<linux-xfs@oss.sgi.com>; Fri, 11 May 2012 07:31:22 -0700 (PDT)
Received: by eekc41 with SMTP id c41so1355857eek.26
	for <linux-xfs@oss.sgi.com>; Fri, 11 May 2012 07:31:21 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 11 May 2012 20:01:20 +0530
Message-ID: <CANBXnMnw7znBQ9AfbZZqD3Nd77=Jcy15Y2z_=j25WOR7rn0r+w@mail.gmail.com>
Subject: Blocks deallocation routine when file is deleted
From: Adil Mujeeb <mujeeb.adil@gmail.com>
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
To: linux-xfs@oss.sgi.com

Hi list,

I wanted to understand the routine of block deallocation when a file
is deleted from XFS.

Suppose initial state of the XFS partition is:

-----------------8<------------------------
localhost:/home/adil # df /mnt/test/
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/vg_lv_test
                      67055628      5280  67050348   1% /mnt/test
-----------------8<------------------------

The Used value is 5280. What it (5280) signifies? Number of FSB?

Now a 1MB size file is being created named xyz. After file creation
checked the filesystem usage:

-----------------8<------------------------
localhost:/home/adil # df /mnt/test/
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/vg_lv_test
                      67055628      6304  67049324   1% /mnt/test
localhost:/mnt/test # xfs_io xyz
xfs_io> stat
fd.path = "xyz"
fd.flags = non-sync,non-direct,read-write
stat.ino = 132
stat.type = regular file
stat.size = 1048576
stat.blocks = 2048
fsxattr.xflags = 0x0 [--------------]
fsxattr.projid = 0
fsxattr.extsize = 0
fsxattr.nextents = 1
fsxattr.naextents = 0
dioattr.mem = 0x200
dioattr.miniosz = 512
dioattr.maxiosz = 2147483136
-----------------8<------------------------

The used count has increased from 5280 to 6304 i.e. by 1024. What it
(1024) signifies?

Now deleted the file and checked the blocks and other information
whether the blocks allocated returned back or not:

-----------------8<------------------------
localhost:/mnt/test # rm xyz
localhost:/home/adil # df /mnt/test/
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/mapper/vg_lv_test
                      67055628      5280  67050348   1% /mnt/test
-----------------8<------------------------

So here we see that the used count is decreased to original value (5280).

I would like to know where this deallocation is being done in the
code. I appreciate if anyone can help me in giving the code flow hint.

Thanks and Best Regards,
Adil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
