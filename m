Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2QFfl5a174588 for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 10:41:58 -0500
Received: from nuka.cjx.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5201E1C8B2C
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 08:41:21 -0700 (PDT)
Received: from nuka.cjx.com (37.233.187.81.in-addr.arpa [81.187.233.37]) by
	cuda.sgi.com with ESMTP id CjIf9Km8pHNpVyya for
	<xfs@oss.sgi.com>; Thu, 26 Mar 2009 08:41:21 -0700 (PDT)
Received: from chris-allens-imac-g5.local (mac.cjx.com [10.0.1.8])
	by nuka.cjx.com (8.14.3/8.14.3/Debian-4) with ESMTP id n2QFfJov012566
	for <xfs@oss.sgi.com>; Thu, 26 Mar 2009 15:41:19 GMT
Message-ID: <49CBA221.2090701@cjx.com>
Date: Thu, 26 Mar 2009 15:41:21 +0000
From: Chris Allen <chris@cjx.com>
MIME-Version: 1.0
Subject: accidentally deleted very large file (3.5TB) but still available
	through loop device
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5744361696087418719=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============5744361696087418719==
Content-Type: multipart/alternative;
 boundary="------------040103060906030107000105"

This is a multi-part message in MIME format.
--------------040103060906030107000105
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

In a nutshell, I did the following:

1. dd if=some_filesystem_dump of=some_file (where some_file resides on 
an XFS filesystem and is 3.5TB large)

2. losetup /dev/loop0 some_file

3. mount /dev/loop0 /recovered

[.... i can now access my recovered filesystem through /recovered ...]

4. rm some_file (remotely via an nfs export) (oops!)

So, I just removed my 3.5TB file even though it is attached to the loop 
device and mounted (XFS did this almost instantly).


Now it *appears* that the filesystem as attached to /dev/loop0 and 
mounted on /recovered is still OK. I
can cd around it and copy files off.

So I have these questions:


1. Is there any way I can get back the 1 file that I accidentally 
deleted (nothing else has been written to that partition since)

2. Am I safe in accessing my filesystem through /dev/loop0 and 
/recovered even though the underlying file has been zapped? If so
I can quickly copy everything off onto another partition.

3. Will this command: dd if=/dev/loop0 of=saved_file get my file back?


Many thanks for any advice!



--------------040103060906030107000105
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body bgcolor="#ffffff" text="#000000">
<font size="-1"><font face="Helvetica, Arial, sans-serif">Hi,<br>
<br>
In a nutshell, I did the following:<br>
<br>
1. dd if=some_filesystem_dump of=some_file (where some_file resides on
an XFS filesystem and is 3.5TB large)<br>
<br>
2. losetup /dev/loop0 some_file<br>
<br>
3. mount /dev/loop0 /recovered<br>
<br>
[.... i can now access my recovered filesystem through /recovered ...]<br>
<br>
4. rm some_file (remotely via an nfs export) (oops!)<br>
<br>
So, I just removed my 3.5TB file even though it is attached to the loop
device and mounted (XFS did this almost instantly).<br>
<br>
<br>
Now it *appears* that the filesystem as attached to /dev/loop0 and
mounted on /recovered is still OK. I<br>
can cd around it and copy files off.<br>
<br>
So I have these questions:<br>
<br>
<br>
1. Is there any way I can get back the 1 file that I accidentally
deleted (nothing else has been written to that partition since)<br>
<br>
2. Am I safe in accessing my filesystem through /dev/loop0 and
/recovered even though the underlying file has been zapped? If so<br>
I can quickly copy everything off onto another partition.<br>
<br>
3. Will this command: dd if=/dev/loop0 of=saved_file get my file back?<br>
<br>
<br>
Many thanks for any advice!<br>
<br>
<br>
</font></font>
</body>
</html>

--------------040103060906030107000105--


--===============5744361696087418719==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5744361696087418719==--
