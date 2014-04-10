Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A95CB29DF8
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 04:26:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BA23AC001
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 02:26:47 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id PPruGBCN1ljYdaqm (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 10 Apr 2014 02:26:45 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with
	ESMTP id s3A9Qi8Y018199
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:26:45 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s3A9QhJb027741
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:26:44 GMT
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	s3A9QhC5024527 for <xfs@oss.sgi.com>; Thu, 10 Apr 2014 09:26:43 GMT
Message-ID: <53467259.1080604@oracle.com>
Date: Thu, 10 Apr 2014 14:28:41 +0400
From: alexander.tsvetkov@oracle.com
MIME-Version: 1.0
Subject: generic/204: correct log size for XFS
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2257436625904422653=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============2257436625904422653==
Content-Type: multipart/alternative;
 boundary="------------010405090604020909000207"

This is a multi-part message in MIME format.
--------------010405090604020909000207
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

generic/204 fails on device with Advanced Format of 4096 bytes per
physical sector and when partition starts at the 4K boundary/./In this case
filesystem sector/block size will be of 4096 bytes size and 
_scratch_mkfs_sized
fails because mkfs reports that 5Mb log size is not enough to create a 
filesystem,
for example attempt to make filesystem on such partition:

mkfs.xfs -f -bsize=4096 -l size=5m -d size=109051904 /dev/sdb2"

results to:

"log size 1280 blocks too small, minimum size is 1605 blocks"

and generic/204fails with ENOSPC before it has finished creating the 
necessary files:

"QA output created by 204
./tests/generic/204: line 86: echo: write error: No space left on device
..."

Log size of 7Mbis enough to make filesytem and pass this test.

diff --git a/tests/generic/204 b/tests/generic/204
index 13a762a..4ebab26 100755
--- a/tests/generic/204
+++ b/tests/generic/204
@@ -53,9 +53,9 @@ _scratch_mkfs 2> /dev/null | _filter_mkfs 2> $tmp.mkfs 
 > /dev/null

  # For xfs, we need to handle the different default log sizes that 
different
  # versions of mkfs create. All should be valid with a 5MB log, so use 
that.
-[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=5m"
+[ $FSTYP = "xfs" ] && MKFS_OPTIONS="$MKFS_OPTIONS -l size=7m"

-SIZE=`expr 104 \* 1024 \* 1024`
+SIZE=`expr 106 \* 1024 \* 1024`
  _scratch_mkfs_sized $SIZE $dbsize 2> /dev/null \
                 | _filter_mkfs 2> $tmp.mkfs > /dev/null
  _scratch_mount

--------------010405090604020909000207
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    generic/204 fails on device with <span id="mainframespan">Advanced
      Format of 4096 bytes per <br>
      physical sector and when partition </span><span
      id="mainframespan"><span id="mainframespan"> starts at the 4K
        boundary<tt><i>.</i></tt>In this case <br>
      </span>filesystem </span><span id="mainframespan"><span
        id="mainframespan">sector/block size</span> will be of 4096
      bytes size and _scratch_mkfs_sized<br>
      fails because mkfs reports that 5Mb log size is not enough to
      create a filesystem, <br>
      for example attempt to make filesystem on such partition:&nbsp; <br>
      <br>
      mkfs.xfs -f -bsize=4096 -l size=5m -d size=109051904 /dev/sdb2"<br>
      <br>
    </span><span id="mainframespan"><span id="mainframespan">results to</span>:<br>
      <br>
      "log size 1280 blocks too small, minimum size is 1605 blocks"<br>
      <br>
      and generic/204</span><font face="sans-serif"> fails with
      ENOSPC before it has finished creating the necessary files:<br>
      <br>
      "QA output created by 204<br>
      ./tests/generic/204: line 86: echo: write error: No space left on
      device<br>
      ..."<br>
      <br>
      Log size of 7Mb</font><font face="sans-serif"> is enough to make
      filesytem </font><font face="sans-serif">and pass this test.<br>
      <br>
      diff --git a/tests/generic/204 b/tests/generic/204<br>
      index 13a762a..4ebab26 100755<br>
      --- a/tests/generic/204<br>
      +++ b/tests/generic/204<br>
      @@ -53,9 +53,9 @@ _scratch_mkfs 2&gt; /dev/null | _filter_mkfs
      2&gt; $tmp.mkfs &gt; /dev/null<br>
      <br>
      &nbsp;# For xfs, we need to handle the different default log sizes that
      different<br>
      &nbsp;# versions of mkfs create. All should be valid with a 5MB log, so
      use that.<br>
      -[ $FSTYP = "xfs" ] &amp;&amp; MKFS_OPTIONS="$MKFS_OPTIONS -l
      size=5m"<br>
      +[ $FSTYP = "xfs" ] &amp;&amp; MKFS_OPTIONS="$MKFS_OPTIONS -l
      size=7m"<br>
      <br>
      -SIZE=`expr 104 \* 1024 \* 1024`<br>
      +SIZE=`expr 106 \* 1024 \* 1024`<br>
      &nbsp;_scratch_mkfs_sized $SIZE $dbsize 2&gt; /dev/null \<br>
      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; | _filter_mkfs 2&gt; $tmp.mkfs &gt; /dev/null<br>
      &nbsp;_scratch_mount<br>
    </font>
  </body>
</html>

--------------010405090604020909000207--


--===============2257436625904422653==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2257436625904422653==--
