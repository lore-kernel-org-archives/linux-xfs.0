Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MFamaF210331 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 10:36:48 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 099E81DDA6BC
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 08:38:48 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id q51vZm6flJqebuh9 for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 08:38:48 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3MFcRii022623
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 15:38:32 GMT
Received: from acsmt354.oracle.com (acsmt354.oracle.com [141.146.40.154])
	by acsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3MELRZI031178 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 15:38:25 GMT
Date: Thu, 22 Apr 2010 23:36:36 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: different error messages for mkfs.xfs -ssize
Message-ID: <20100422153636.GB3822@laptop.oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
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
Cc: greg.marsden@oracle.com, joe.jin@oracle.com

Hi experts,

I got different error messages when provide different value for -ssize.
Why the error messages are different? They are different but no one is
containing more info than the other.

[root@desk test-xfsprogs]# mkfs.xfs -ssize=256 /dev/sda10 -f 2>&1 |head -n 1
illegal sector size 256
[root@desk test-xfsprogs]# mkfs.xfs -ssize=3072 /dev/sda10 -f 2>&1 |head -n 1
Illegal value 3072 for -s sectsize option

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
