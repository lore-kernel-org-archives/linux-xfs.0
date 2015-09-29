Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 650637F37
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 08:33:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 450168F8040
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 06:33:02 -0700 (PDT)
Received: from mail.nomovok.com (mail.nomovok.com [83.150.122.238]) by
	cuda.sgi.com with ESMTP id TSYwy7j8EqDNDtNc (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Sep 2015 06:32:59 -0700 (PDT)
Received: from [192.168.0.2] (unknown [95.233.233.211])
	by mail.nomovok.com (Postfix) with ESMTPSA id F390BAE049
	for <xfs@oss.sgi.com>; Tue, 29 Sep 2015 16:32:56 +0300 (EEST)
Message-ID: <560A9307.6080600@nomovok.com>
Date: Tue, 29 Sep 2015 15:32:55 +0200
From: Angelo Dureghello <angelo.dureghello@nomovok.com>
MIME-Version: 1.0
Subject: xfstests, xfs test 080 fails on arm 32bit
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

executing this test on a 32bit arm. i get (i traced mmapping sizes):

# ./start_xfs_test.sh
QA output created by 080
[  161.827446] XFS (mmcblk0p5): Mounting V4 Filesystem
[  162.357952] XFS (mmcblk0p5): Ending clean mount

mmapping 512000000
mmapping 512000000
mmapping 512000000
mmapping 512000000
mmapping 512000000
mmapping 512000000

oio ( 3241) 15:18:17
---------------------
mmap() failed - 0xffffffff 12

doio ( 3241) 15:18:17
---------------------
mmap-read() request failed:  Cannot allocate memory (12)
Request number 15
           fd 4 is file /media/p5/rwtest.file - open flags are 0 O_RDONLY,
           read done at file offset 978498
           number of requests is 1, strides per request is 1
           i/o byte count = 119505
           memory alignment is unaligned

syscall:  mmap-read(NULL, 512000000, PROT_READ, MAP_SHARED, 4, 0)
     file is mmaped to: 0x0
     file-mem=0xeee42, length=119505, buffer=0x484a6


doio ( 3241) 15:18:17
---------------------
doio(): operation 120 returned != 0
rwtest.sh : iogen reported errors (r=141)


Is it possible the test was thought to pass on 64bit systems ?

Best regards
Angelo Dureghello

-- 
Best regards,
Angelo Dureghello

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
