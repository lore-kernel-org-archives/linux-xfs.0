Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8QNCmiV229334 for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 18:12:48 -0500
Received: from greer.hardwarefreak.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F360F141FFA4
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 16:18:40 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id b05iF8wBOipHlLn2
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 16:18:40 -0700 (PDT)
Received: from [192.168.100.53] (gffx.hardwarefreak.com [192.168.100.53])
	by greer.hardwarefreak.com (Postfix) with ESMTP id 423ED6C02C
	for <xfs@oss.sgi.com>; Mon, 26 Sep 2011 18:12:46 -0500 (CDT)
Message-ID: <4E8106ED.9040909@hardwarefreak.com>
Date: Mon, 26 Sep 2011 18:12:45 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: XFS binary code size
Reply-To: stan@hardwarefreak.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I'm curious about the footprint of the XFS binary code, specifically for 
32 bit systems, but knowing the 64 bit case would be educational as well 
for comparison.  I don't use kernel modules or I'd already have a rough 
answer.  My last build was 2.6.38.6 but I'm sure the size hasn't changed 
much in more recent kernels.  My XFS build options were:

$ grep -i xfs .config
CONFIG_XFS_FS=y
# CONFIG_XFS_QUOTA is not set
# CONFIG_XFS_POSIX_ACL is not set
# CONFIG_XFS_RT is not set

My resulting kernel image is:
$ la /boot/vmlinuz-2.6.38.6
-rw-r--r--  1 root root 1.6M May 17 23:55 vmlinuz-2.6.38.6

How much of that 1.6MB is XFS?  Also, what is the size of the hot path 
code that we want to stay in L1 during heavy IO?

-- 
Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
