Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D82B7F4E
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 07:04:53 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A9FFAC001
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 05:04:49 -0800 (PST)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
	[209.85.220.46]) by cuda.sgi.com with ESMTP id 5bdHBOktuSXVsKam
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 23 Jan 2015 05:04:48 -0800 (PST)
Received: by mail-pa0-f46.google.com with SMTP id lj1so3957599pab.5
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2015 05:04:47 -0800 (PST)
Received: from galea.xtremenitro.org
	(static-ip-103.26.101.238.merahciptamedia.com. [103.26.101.238])
	by mx.google.com with ESMTPSA id pr2sm1877631pbb.88.2015.01.23.05.04.45
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Fri, 23 Jan 2015 05:04:46 -0800 (PST)
Message-ID: <54C246EC.90207@xtremenitro.org>
Date: Fri, 23 Jan 2015 20:04:44 +0700
From: Dewangga Bachrul Alam <dewanggaba@xtremenitro.org>
MIME-Version: 1.0
Subject: Change sector size on existing partition
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,

I'm new to XFS, I have RAID-10 array with 4 disk, when I check with
xfs_info, the information print like this.

$ xfs_info /var/lib/mysql
meta-data=/dev/mapper/vg_catalystdb01-lv_database isize=256
agcount=16, agsize=1600000 blks
         =                       sectsz=4096  attr=2, projid32bit=0
data     =                       bsize=4096   blocks=25600000, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=12500, version=2
         =                       sectsz=4096  sunit=1 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Is it possible to change `sectsz` value to 512 without re-format it? Or
any suggestion? I have issue with current sector size, my TokuDB
engines[1] can't start because of this.

[1] https://groups.google.com/forum/#!topic/tokudb-user/kvQFJLCmKwo

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
