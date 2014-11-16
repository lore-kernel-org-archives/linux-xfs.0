Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ACE8A29DF7
	for <xfs@oss.sgi.com>; Sun, 16 Nov 2014 13:35:09 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 836D78F8037
	for <xfs@oss.sgi.com>; Sun, 16 Nov 2014 11:35:06 -0800 (PST)
Received: from mout.web.de (mout.web.de [212.227.17.11]) by cuda.sgi.com with
	ESMTP id vw53FhGlLhA7WXrG (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 16 Nov 2014 11:35:01 -0800 (PST)
Received: from [192.168.64.62] ([79.210.59.39]) by smtp.web.de (mrweb102) with
	ESMTPSA (Nemesis) id 0LuuS5-1XyvMx3ABd-0105JZ for <xfs@oss.sgi.com>;
	Sun, 16 Nov 2014 20:34:59 +0100
Message-ID: <5468FC60.10901@web.de>
Date: Sun, 16 Nov 2014 20:34:56 +0100
From: Markus Rhonheimer <markus.rhonheimer@web.de>
MIME-Version: 1.0
Subject: Virtual Block device resize corrupts XFS
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7554149956649655748=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============7554149956649655748==
Content-Type: multipart/alternative;
 boundary="------------060309030503090409030408"

This is a multi-part message in MIME format.
--------------060309030503090409030408
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I am running Centos 7 and have created a virtual block device with ZFS 
(ZVOL). I put XFS onto the block device without partitioning it.

This worked very well as storage disk for a VM.

A few days ago I wanted to increase the size of the block device, but 
accidently decreased it by 1 TB (from 7 to 6). I found out about it and 
immediately increased the size of the drive to 8 TB afterward.

The XFS partition can still be mounted and I can list the files on it, 
but xfs_repair -n says: "/Sorry/, /could not find valid secondary 
superblock"

/Is there the possibility to rescue some files?

kind regards

Markus

--------------060309030503090409030408
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=utf-8">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Hi,<br>
    <br>
    I am running Centos 7 and have created a virtual block device with
    ZFS (ZVOL). I put XFS onto the block device without partitioning it.<br>
    <br>
    This worked very well as storage disk for a VM.<br>
    <br>
    A few days ago I wanted to increase the size of the block device,
    but accidently decreased it by 1 TB (from 7 to 6). I found out about
    it and immediately increased the size of the drive to 8 TB
    afterward.<br>
    <br>
    The XFS partition can still be mounted and I can list the files on
    it, but xfs_repair -n says: "<span class="st"><em>Sorry</em>, <em>could
        not find valid secondary superblock"<br>
        <br>
      </em>Is there the possibility to rescue some files?<br>
      <br>
      kind regards<br>
      <br>
      Markus<br>
    </span>
  </body>
</html>

--------------060309030503090409030408--


--===============7554149956649655748==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7554149956649655748==--
