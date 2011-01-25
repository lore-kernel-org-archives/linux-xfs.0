Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0P9kJ31235027 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 03:46:20 -0600
Received: from opencube.bzctoons.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6AC9F8AD544
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 01:48:41 -0800 (PST)
Received: from opencube.bzctoons.net (opencube-2.bzctoons.net
	[88.191.104.187]) by cuda.sgi.com with ESMTP id
	R3A2GZabBvcQvO9h for <xfs@oss.sgi.com>;
	Tue, 25 Jan 2011 01:48:41 -0800 (PST)
Received: from localhost (opencube.bzctoons.net.local [127.0.0.1])
	by opencube.bzctoons.net (Postfix) with ESMTP id AE83490AD3
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 10:48:40 +0100 (CET)
Received: from opencube.bzctoons.net ([127.0.0.1])
	by localhost (opencube.bzctoons.net [127.0.0.1]) (amavisd-maia,
	port 10024) with ESMTP id 08476-08 for <xfs@oss.sgi.com>;
	Tue, 25 Jan 2011 10:48:39 +0100 (CET)
Received: from [192.168.16.148] (opencube03.pck.nerim.net [62.212.120.41])
	(Authenticated sender: mathieu.avila@opencubetech.com)
	by opencube.bzctoons.net (Postfix) with ESMTPA id E10B390AC5
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 10:48:37 +0100 (CET)
Message-ID: <4D3E9C73.6090508@opencubetech.com>
Date: Tue, 25 Jan 2011 10:48:35 +0100
From: Mathieu AVILA <mathieu.avila@opencubetech.com>
MIME-Version: 1.0
Subject: Re: extremely slow write performance plaintext
References: <3205_1294953756_4D2F6D1C_3205_1943_1_4D2F6D1C.2060409@davisvision.com>	<4D30C7F3.3040105@hardwarefreak.com>	<1779_1295360207_4D35A0CF_1779_747_1_4D35A0CF.9050503@davisvision.com>
	<201101250721.14716@zmi.at>
In-Reply-To: <201101250721.14716@zmi.at>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4388975937162609888=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============4388975937162609888==
Content-Type: multipart/alternative;
 boundary="------------040809080702070805000202"

This is a multi-part message in MIME format.
--------------040809080702070805000202
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Le 25/01/2011 07:21, Michael Monnerie a écrit :
> On Dienstag, 18. Januar 2011 Cory Coager wrote:
>> Also, I want to stress that I am only having performance issues with
>> one logical volume, the others seem fine.
> You're getting 40MB/s write speed and says that's fine? I get more
> performance from a single SATA desktop drive. Your setup seems to suck
> extremely somewhere.
>
> It already starts with your dd speed. I started it on a virtualized VM
> on an old, overloaded server and get:
>
> # dd if=/dev/zero of=test.dd bs=1k count=1M
> 1048576+0 Datensätze ein
> 1048576+0 Datensätze aus
> 1073741824 Bytes (1,1 GB) kopiert, 10,9992 s, 97,6 MB/s
>

I would say this is melted with cache hit, isn't it ? (although I agree 
it depends on the server's memory dedicated to FS cache)

A real cache hit on a real server would give me at least 500 MB/s 
(actually I get something around 1 GB/s)
When it starts to be disk-constrained, on a standard SATA disk, I get 
from 75 MB/s to 140 MB/s depending on the position of the AG I hit.


-- 
*Mathieu Avila*
IT & Integration Engineer
mathieu.avila@opencubetech.com

OpenCube Technologies http://www.opencubetech.com
Parc Technologique du Canal, 9 avenue de l'Europe
31520 Ramonville St Agne - FRANCE
Tel. : +33 (0) 561 285 606 - Fax : +33 (0) 561 285 635

--------------040809080702070805000202
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body bgcolor="#ffffff" text="#000000">
    Le 25/01/2011 07:21, Michael Monnerie a &eacute;crit&nbsp;:
    <blockquote cite="mid:201101250721.14716@zmi.at" type="cite">
      <pre wrap="">On Dienstag, 18. Januar 2011 Cory Coager wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">Also, I want to stress that I am only having performance issues with
one logical volume, the others seem fine.
</pre>
      </blockquote>
      <pre wrap="">
You're getting 40MB/s write speed and says that's fine? I get more 
performance from a single SATA desktop drive. Your setup seems to suck 
extremely somewhere.

It already starts with your dd speed. I started it on a virtualized VM 
on an old, overloaded server and get:

# dd if=/dev/zero of=test.dd bs=1k count=1M
1048576+0 Datens&auml;tze ein
1048576+0 Datens&auml;tze aus
1073741824 Bytes (1,1 GB) kopiert, 10,9992 s, 97,6 MB/s

</pre>
    </blockquote>
    <br>
    I would say this is melted with cache hit, isn't it ? (although I
    agree it depends on the server's memory dedicated to FS cache)<br>
    <br>
    A real cache hit on a real server would give me at least 500 MB/s
    (actually I get something around 1 GB/s)<br>
    When it starts to be disk-constrained, on a standard SATA disk, I
    get from 75 MB/s to 140 MB/s depending on the position of the AG I
    hit.<br>
    <br>
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

--------------040809080702070805000202--


--===============4388975937162609888==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4388975937162609888==--
