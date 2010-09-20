Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8KH3gsF228004 for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 12:03:42 -0500
Received: from opencube.bzctoons.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B85061820792
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 10:04:33 -0700 (PDT)
Received: from opencube.bzctoons.net (opencube-2.bzctoons.net
	[88.191.104.187]) by cuda.sgi.com with ESMTP id
	uDvGmLGqLxSa2aiH for <xfs@oss.sgi.com>;
	Mon, 20 Sep 2010 10:04:33 -0700 (PDT)
Received: from localhost (opencube.bzctoons.net.local [127.0.0.1])
	by opencube.bzctoons.net (Postfix) with ESMTP id D1C18909F5
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 19:04:32 +0200 (CEST)
Received: from opencube.bzctoons.net ([127.0.0.1])
	by localhost (opencube.bzctoons.net [127.0.0.1]) (amavisd-maia,
	port 10024) with ESMTP id 26303-02 for <xfs@oss.sgi.com>;
	Mon, 20 Sep 2010 19:04:32 +0200 (CEST)
Received: from [192.168.16.148] (opencube03.pck.nerim.net [62.212.120.41])
	(Authenticated sender: mathieu.avila@opencubetech.com)
	by opencube.bzctoons.net (Postfix) with ESMTPA id 4C85490A7D
	for <xfs@oss.sgi.com>; Mon, 20 Sep 2010 19:04:31 +0200 (CEST)
Message-ID: <4C979439.7070906@opencubetech.com>
Date: Mon, 20 Sep 2010 19:04:57 +0200
From: Mathieu AVILA <mathieu.avila@opencubetech.com>
MIME-Version: 1.0
Subject: Question regarding performance on big files.
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4946455851690389721=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============4946455851690389721==
Content-Type: multipart/alternative;
 boundary="------------060408080804000902080404"

This is a multi-part message in MIME format.
--------------060408080804000902080404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

  Hello XFS team,

I have run into trouble with XFS, but excuse me if this question has 
been asked a dozens times.

I'm am filling a very big file on a XFS filesystem on Linux that stands 
on a software RAID 0. Performance are very good until I get 2 "holes" 
during which my write stalls for a few seconds.
Mkfs parameters:
mkxfs.xfs -b size 4096 -s size 4096 -d agcount=2 -i size=2048
The RAID0 is done a 2 SATA disks of 500 GB each.

My test is just running "dd" with 8M blocks:
dd if=/dev/zero of=/DATA/big
(/DATA is the XFS file system)

The system is basically a RHEL5 with a 2.6.18 kernel and XFS packages 
from CentOS.

The problem happens 2 times: one time around 210 GB and the second time 
around 688 GB (hole in performance and response time is bigger the 
second time -- around 20 seconds)

Do you have any clue ? Do my mkfs parameters make sense ? The goal here 
is really to have something that is able to store big files at a 
constant throughput -- the test is done on purpose.

-- 
*Mathieu Avila*
IT & Integration Engineer
mathieu.avila@opencubetech.com

OpenCube Technologies http://www.opencubetech.com
Parc Technologique du Canal, 9 avenue de l'Europe
31520 Ramonville St Agne - FRANCE
Tel. : +33 (0) 561 285 606 - Fax : +33 (0) 561 285 635

--------------060408080804000902080404
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body bgcolor="#ffffff" text="#000000">
    Hello XFS team,<br>
    <br>
    I have run into trouble with XFS, but excuse me if this question has
    been asked a dozens times.<br>
    <br>
    I'm am filling a very big file on a XFS filesystem on Linux that
    stands on a software RAID 0. Performance are very good until I get 2
    "holes" during which my write stalls for a few seconds.<br>
    Mkfs parameters:<br>
    mkxfs.xfs -b size 4096 -s size 4096 -d agcount=2 -i size=2048<br>
    The RAID0 is done a 2 SATA disks of 500 GB each.<br>
    <br>
    My test is just running "dd" with 8M blocks:<br>
    dd if=/dev/zero of=/DATA/big<br>
    (/DATA is the XFS file system)<br>
    <br>
    The system is basically a RHEL5 with a 2.6.18 kernel and XFS
    packages from CentOS.<br>
    <br>
    The problem happens 2 times: one time around 210 GB and the second
    time around 688 GB (hole in performance and response time is bigger
    the second time -- around 20 seconds)<br>
    <br>
    Do you have any clue ? Do my mkfs parameters make sense ? The goal
    here is really to have something that is able to store big files at
    a constant throughput -- the test is done on purpose.<br>
    <br>
    <div class="moz-signature">-- <br>
      <font color="blue"><b>Mathieu Avila</b><br>
        IT &amp; Integration Engineer<br>
      </font>
      <a class="moz-txt-link-abbreviated" href="mailto:mathieu.avila@opencubetech.com">mathieu.avila@opencubetech.com</a><br>
      <br>
      OpenCube Technologies <a href="http://www.opencubetech.com">http://www.opencubetech.com</a><br>
      Parc Technologique du Canal, 9 avenue de l'Europe<br>
      31520 Ramonville St Agne - FRANCE<br>
      Tel. : +33 (0) 561 285 606 - Fax : +33 (0) 561 285 635<br>
    </div>
  </body>
</html>

--------------060408080804000902080404--


--===============4946455851690389721==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4946455851690389721==--
