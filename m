Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5D3157F37
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 03:51:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2E7D18F8037
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 01:51:32 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 9vRz11kxynmZGl5P (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Jun 2013 01:51:30 -0700 (PDT)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r5E8pQdX024206
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 08:51:27 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5E8pSV8015205
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 08:51:28 GMT
Received: from abhmt105.oracle.com (abhmt105.oracle.com [141.146.116.57])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r5E8pSAg026390 for <xfs@oss.sgi.com>; Fri, 14 Jun 2013 08:51:28 GMT
Message-ID: <51BAD98D.90808@oracle.com>
Date: Fri, 14 Jun 2013 12:51:25 +0400
From: alexander.tsvetkov@oracle.com
MIME-Version: 1.0
Subject: dmsetup arguments
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3449099299502042075=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============3449099299502042075==
Content-Type: multipart/alternative;
 boundary="------------040502080304000108040407"

This is a multi-part message in MIME format.
--------------040502080304000108040407
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

XFStests suite generic/311 test fails on command: "sbin/dmsetup load 
flakey-test --table "0 150000001 flakey /dev/sdc2 0 0 180 1 drop_writes" 
with error: "device-mapper: reload ioctl on flakey-test failed: Invalid 
argument", so as I understand the command format provided to ioctl is 
incorrect here. Kernel logs has message:

"Jun 13 16:47:15 tests kernel: device-mapper: table: 252:3: flakey: 
dm-flakey: Invalid argument count
Jun 13 16:47:15 tests kernel: device-mapper: ioctl: error adding target 
to table"

Looking into the source code of package LVM2.02.98 which devmapper 
library belongs to I find argument "drop_writes" used in the command 
only in documentation doc/kernel/flakey.txt:

"Optional feature parameters:
   If no feature parameters are present, during the periods of
   unreliability, all I/O returns errors.

   drop_writes:
         All write I/O is silently ignored.
         Read I/O is handled correctly."

This argument feature was added in the patch from "27 Jun 2011":

"[dm-devel] [PATCH 0/9] dm flakey: add features
------------------------------------------------------------------------

    * /From/: Mike Snitzer <snitzer redhat com>
    * /To/: <dm-devel redhat com>
    * /Cc/: Mike Snitzer <snitzer redhat com>
    * /Subject/: [dm-devel] [PATCH 0/9] dm flakey: add features
    * /Date/: Mon, 27 Jun 2011 15:53:34 -0400

------------------------------------------------------------------------

Add "drop_writes", "corrupt_bio_byte" and "debug" features to the
flakey target."

https://www.redhat.com/archives/dm-devel/2011-June/msg00081.html

but was patch modifications included in library of LVM2.02.98 package? 
Or may be it was already removed from it after?

Thanks,
Alexander Tsvetkov








--------------040502080304000108040407
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body bgcolor="#ffffff" text="#000000">
    Hi,<br>
    <br>
    XFStests suite generic/311 test fails on command: "sbin/dmsetup load
    flakey-test --table "0 150000001 flakey /dev/sdc2 0 0 180 1
    drop_writes" with error: "device-mapper: reload ioctl on flakey-test
    failed: Invalid argument", so as I understand the command format
    provided to ioctl is incorrect here. Kernel logs has message:<br>
    <br>
    "Jun 13 16:47:15 tests kernel: device-mapper: table: 252:3: flakey:
    dm-flakey: Invalid argument count<br>
    Jun 13 16:47:15 tests kernel: device-mapper: ioctl: error adding
    target to table"<br>
    <br>
    Looking into the source code of package LVM2.02.98 which devmapper
    library belongs to I find argument "drop_writes" used in the command
    only in documentation doc/kernel/flakey.txt:<br>
    <br>
    "Optional feature parameters:<br>
    &nbsp; If no feature parameters are present, during the periods of<br>
    &nbsp; unreliability, all I/O returns errors.<br>
    <br>
    &nbsp; drop_writes:<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; All write I/O is silently ignored.<br>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Read I/O is handled correctly."<br>
    <br>
    This argument feature was added in the patch from "27 Jun 2011":<br>
    <br>
    "[dm-devel] [PATCH 0/9] dm flakey: add features
    <hr>
    <ul>
      <li><em>From</em>: Mike Snitzer &lt;snitzer redhat com&gt;</li>
      <li><em>To</em>: &lt;dm-devel redhat com&gt;</li>
      <li><em>Cc</em>: Mike Snitzer &lt;snitzer redhat com&gt;</li>
      <li><em>Subject</em>: [dm-devel] [PATCH 0/9] dm flakey: add
        features</li>
      <li><em>Date</em>: Mon, 27 Jun 2011 15:53:34 -0400</li>
    </ul>
    <hr>
    <pre>Add "drop_writes", "corrupt_bio_byte" and "debug" features to the
flakey target."
</pre>
    <a
      href="https://www.redhat.com/archives/dm-devel/2011-June/msg00081.html">https://www.redhat.com/archives/dm-devel/2011-June/msg00081.html</a><br>
    <br>
    but was patch modifications included in library of LVM2.02.98
    package? Or may be it was already removed from it after?<br>
    <br>
    Thanks,<br>
    Alexander Tsvetkov<br>
    <br>
    <br>
    <br>
    <br>
    <br>
    <br>
    <br>
  </body>
</html>

--------------040502080304000108040407--


--===============3449099299502042075==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3449099299502042075==--
