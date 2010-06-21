Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L2rE5R097179 for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 21:53:15 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A92171E11B48
	for <xfs@oss.sgi.com>; Sun, 20 Jun 2010 19:55:53 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id nByTQobZRqHCAvtC for
	<xfs@oss.sgi.com>; Sun, 20 Jun 2010 19:55:53 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.2) with ESMTP id
	o5L2tpd7013431
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 02:55:52 GMT
Received: from acsmt355.oracle.com (acsmt355.oracle.com [141.146.40.155])
	by rcsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o5L2tkFM024706 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 02:55:46 GMT
Subject: segment fault when running xfs_check -s
From: xiaowei hu <xiaowei.hu@oracle.com>
Date: Mon, 21 Jun 2010 10:55:18 +0800
Message-ID: <1277088918.20616.81.camel@redfuture-desktop>
Mime-Version: 1.0
Reply-To: xiaowei.hu@oracle.com
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
Cc: wen.gang.wang@oracle.com

Hi,

Recently I was playing with xfsprogs, and did some test on xfs_check
tools in this mothod:
1.make a xfs fs on one partition.
mkfs.xfs -f /dev/sda2
2.randomly modify some blocks on this volume using xfs_db.
xfs_db -x -c blockget -c "blocktrash -3 -s 36 -n 81" /dev/sda2
3.run xfs_check -s
xfs_check -s /dev/sda2

the output saying:
[root@test1 ~]# xfs_check -s /dev/sda2
bad version number 0x78 for inode 135
bad magic number 0xa855 for inode 154
bad magic number 0x5024 for inode 165
/usr/local/bin/xfs_check: line 28:   769 Segmentation fault      xfs_db
$DBOPTS -F -i -p xfs_check -c "blockget$OPTS" $1

if I run xfs_check without -s option, don't have this fault.

Is this a known problem?

I tried the latest code ,also have this problem.


thanks,
Xiaowei



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
