Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0RB2RCq163898 for <xfs@oss.sgi.com>; Fri, 27 Jan 2012 05:02:28 -0600
Received: from moutng.kundenserver.de (moutng.kundenserver.de [212.227.17.8])
	by cuda.sgi.com with ESMTP id sryH9xsAkZR8mUsD for
	<xfs@oss.sgi.com>; Fri, 27 Jan 2012 03:02:25 -0800 (PST)
Message-ID: <4F22843E.4050804@open-e.com>
Date: Fri, 27 Jan 2012 12:02:22 +0100
From: =?UTF-8?B?xYF1a2FzeiBPbGXFmw==?= <lukasz.oles@open-e.com>
MIME-Version: 1.0
Subject: reserved blocks pool default size
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0862800732055693483=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============0862800732055693483==
Content-Type: multipart/alternative;
 boundary="------------070408090905010307030302"

This is a multi-part message in MIME format.
--------------070408090905010307030302
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi,

I updated kernel from 2.6.27 to 2.6.35 and noticed that free size on my 
xfs volume changed. Before update there was 7MB free space, now there is 
none.

After some investigation I found that default size for reserved block 
pool changed [1].
On this volume I have one very big file which is exported as iSCSI disk 
via SCST and one small configuration file. The big file size will never 
change. Small file size can change only by some KB.

With this assumptions, can I revert this change and set reserved blocks 
pool size to 1024 blocks?

[1]. http://kerneltrap.org/mailarchive/git-commits-head/2010/3/6/28671

Reagards,

--
Łukasz Oleś

--------------070408090905010307030302
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Hi,<br>
    <br>
    I updated kernel from 2.6.27 to 2.6.35 and noticed that free size on
    my xfs volume changed. Before update there was 7MB free space, now
    there is none.<br>
    <br>
    After some investigation I found that default size for reserved
    block pool changed [1]. <br>
    On this volume I have one very big file which is exported as iSCSI
    disk via SCST and one small configuration file. The big file size
    will never change. Small file size can change only by some KB.<br>
    <br>
    With this assumptions, can I revert this change and set reserved
    blocks pool size to 1024 blocks?<br>
    <br>
    [1].
    <meta http-equiv="content-type" content="text/html; charset=UTF-8">
    <a
      href="http://kerneltrap.org/mailarchive/git-commits-head/2010/3/6/28671">http://kerneltrap.org/mailarchive/git-commits-head/2010/3/6/28671</a><br>
    <br>
    Reagards,<br>
    <br>
    --<br>
    Łukasz Oleś<br>
  </body>
</html>

--------------070408090905010307030302--


--===============0862800732055693483==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0862800732055693483==--
