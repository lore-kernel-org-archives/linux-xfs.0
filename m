Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o858pP0c107280 for <xfs@oss.sgi.com>; Sun, 5 Sep 2010 03:51:25 -0500
Received: from mail-bw0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4853610A3CBE
	for <xfs@oss.sgi.com>; Sun,  5 Sep 2010 01:52:06 -0700 (PDT)
Received: from mail-bw0-f53.google.com (mail-bw0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id sfap3G8I7OP5Bywy
	for <xfs@oss.sgi.com>; Sun, 05 Sep 2010 01:52:06 -0700 (PDT)
Received: by bwz1 with SMTP id 1so2880925bwz.26
	for <xfs@oss.sgi.com>; Sun, 05 Sep 2010 01:52:05 -0700 (PDT)
Message-ID: <4C835A34.9080008@googlemail.com>
Date: Sun, 05 Sep 2010 10:52:04 +0200
From: Marcus Osdoba <marcus.osdoba@googlemail.com>
MIME-Version: 1.0
Subject: xfs on armv5 still with erroneous log in kernel 2.6.35.4
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3127333049731823935=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============3127333049731823935==
Content-Type: multipart/alternative;
 boundary="------------040804070001040105060903"

This is a multi-part message in MIME format.
--------------040804070001040105060903
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

  Hello XFS mailinglist,

On my armv5 device I like to use XFS for my simple home made nas, 
because I think it is ideal for low/medium performance CPUs.
I searched the mailing archive about the usage of XFS on arm 
architecture. I figured out, that the patchset of James Bottomley was 
applied to the main line. So I expected xfs to run properly on arm. 
Unfortunatly I still run into this (known) error after writing some data 
on an xfs partition and remounting it:
<mailto:xfs@oss.sgi.com>"
SGI XFS with ACLs, security attributes, large block/inode numbers, no 
debug enabled
SGI XFS Quota Management subsystem
XFS mounting filesystem sda1
Starting XFS recovery on filesystem: sda1 (logdev: internal)
XFS: xlog_recover_process_data: bad clientid
XFS: log mount/recovery failed: error 5
XFS: log mount failed
"

Am I still forced to use the "hammer" approach (flushing buffers in 
xfs_buf.c) which was proposed in January 2010? Or did I misinterpret the 
logfile of the xfs component in the kernel (so no arm fixing patches 
were applied)?

Is xfs NOW be known to work on arm (e.g. armv5)? If so I like to 
complain. If not, I'm willing to test patches which might solve this issue.

Thanks for reading and any comment,
Ossy

--------------040804070001040105060903
Content-Type: text/html; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-15">
  </head>
  <body bgcolor="#ffffff" text="#000000">
    Hello XFS mailinglist,<br>
    <br>
    On my armv5 device I like to use XFS for my simple home made nas,
    because I think it is ideal for low/medium performance CPUs.<br>
    I searched the mailing archive about the usage of XFS on arm
    architecture. I figured out, that the patchset of James Bottomley
    was applied to the main line. So I expected xfs to run properly on
    arm. Unfortunatly I still run into this (known) error after writing
    some data on an xfs partition and remounting it:<br>
    <a href="mailto:xfs@oss.sgi.com"></a>"<br>
    SGI XFS with ACLs, security attributes, large block/inode numbers,
    no debug enabled<br>
    SGI XFS Quota Management subsystem<br>
    XFS mounting filesystem sda1<br>
    Starting XFS recovery on filesystem: sda1 (logdev: internal)<br>
    XFS: xlog_recover_process_data: bad clientid<br>
    XFS: log mount/recovery failed: error 5<br>
    XFS: log mount failed<br>
    "<br>
    <br>
    Am I still forced to use the "hammer" approach (flushing buffers in
    xfs_buf.c) which was proposed in January 2010? Or did I misinterpret
    the logfile of the xfs component in the kernel (so no arm fixing
    patches were applied)?<br>
    <br>
    Is xfs NOW be known to work on arm (e.g. armv5)? If so I like to
    complain. If not, I'm willing to test patches which might solve this
    issue.<br>
    <br>
    Thanks for reading and any comment,<br>
    Ossy<br>
  </body>
</html>

--------------040804070001040105060903--


--===============3127333049731823935==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3127333049731823935==--
