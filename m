Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3MCeHRU198113 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 07:40:17 -0500
Received: from rcsinet10.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2312A1054A01
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 05:42:17 -0700 (PDT)
Received: from rcsinet10.oracle.com (rcsinet10.oracle.com [148.87.113.121]) by
	cuda.sgi.com with ESMTP id COo4jqjbmmHmiHd8 for
	<xfs@oss.sgi.com>; Thu, 22 Apr 2010 05:42:17 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117])
	by rcsinet10.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3MCgBAa015895
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:42:13 GMT
Received: from acsmt353.oracle.com (acsmt353.oracle.com [141.146.40.153])
	by rcsinet15.oracle.com (Switch-3.4.2/Switch-3.4.1) with ESMTP id
	o3MCZdfe007603 for <xfs@oss.sgi.com>; Thu, 22 Apr 2010 12:42:10 GMT
Date: Thu, 22 Apr 2010 20:41:18 +0800
From: Wengang Wang <wen.gang.wang@oracle.com>
Subject: mkfs.xfs man page for -nsize
Message-ID: <20100422124118.GA3406@laptop.oracle.com>
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

When trying -nsize=128 and -n6144 option to mkfs.xfs respectively, I got
error message:
"Illegal value xxx for -n size option"

But checking the man page,

----------------
-n naming_options
	These  options  specify  the  version  and  size parameters  for the
naming (directory) area of the filesystem. The valid nam-ing_options are:

	        size=value | log=value
			The block size is specified either as a value in bytes
with size=, or as a base two logarithm value with log=.  The default size value
for version 2 directories is 4096 bytes (4 KiB), unless the filesystem block
size is larger than 4096, in which case the default value is the filesystem
block size.  For version 1 directories the  block  size  is the same as the
filesystem block size.
----------------

I got no idea why the value is illegal.

Checking the codes, I found it also must be larger or equal to block size and it
must be in powers of 2, 2^N. Should we add these two limitation to man page?

regards,
wengang.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
