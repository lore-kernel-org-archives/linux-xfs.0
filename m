Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA91Aj2L042848 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 19:10:45 -0600
Received: from m50-210.qiye.163.com (m50-210.qiye.163.com [123.125.50.210]) by
	cuda.sgi.com with ESMTP id EkzleEqQMKGWhWPw for
	<xfs@oss.sgi.com>; Thu, 08 Nov 2012 17:12:41 -0800 (PST)
Message-ID: <509C5885.5060300@eisoo.com>
Date: Fri, 09 Nov 2012 09:12:37 +0800
From: "yyq@eisoo.com" <yyq@eisoo.com>
MIME-Version: 1.0
Subject: xfs_quota -x -c 'report -u /dev/sde5' shows the duplicate result.
References: <20121108222315.505370321@sgi.com>
	<20121108222315.709683665@sgi.com>
In-Reply-To: <20121108222315.709683665@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8386977312597534641=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============8386977312597534641==
Content-Type: multipart/alternative;
 boundary="------------010406080208090502050800"

This is a multi-part message in MIME format.
--------------010406080208090502050800
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

     When I use "xfs_quota -x -c 'report -u /dev/sde5'" to show 
/dev/sde5's quotas, and the result have two same block as below:

        [root@localhost ~]# xfs_quota -x -c 'report -u /dev/sde5'
        User quota on /root/mntpath2 (/dev/sde5)
                                        Blocks
        User ID          Used       Soft       Hard    Warn/Grace
        ---------- --------------------------------------------------
        root                0          0          0     00 [--------]
        user2               0     102400     409600     00 [--------]
        user3               0     204800     512000     00 [--------]

        User quota on /root/mntpath2 (/dev/sde5)
                                        Blocks
        User ID          Used       Soft       Hard    Warn/Grace
        ---------- --------------------------------------------------
        root                0          0          0     00 [--------]
        user2               0     102400     409600     00 [--------]
        user3               0     204800     512000     00 [--------]

     Is this correct or what does this output mean?


     My kernel is 3.4.4 and xfs filesystem version is just in the 
version of this kernel.

--------------010406080208090502050800
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Hi,<br>
    <br>
        When I use "xfs_quota -x -c 'report -u /dev/sde5'" to show
    /dev/sde5's quotas, and the result have two same block as below:<br>
    <br>
    <blockquote>
      <blockquote><font color="#660000">[root@localhost ~]# xfs_quota -x
          -c 'report -u /dev/sde5'<br>
          User quota on /root/mntpath2 (/dev/sde5)<br>
                                         Blocks                     <br>
          User ID          Used       Soft       Hard    Warn/Grace    
          <br>
          ---------- --------------------------------------------------
          <br>
          root                0          0          0     00 [--------]<br>
          user2               0     102400     409600     00 [--------]<br>
          user3               0     204800     512000     00 [--------]<br>
          <br>
          User quota on /root/mntpath2 (/dev/sde5)<br>
                                         Blocks                     <br>
          User ID          Used       Soft       Hard    Warn/Grace    
          <br>
          ---------- --------------------------------------------------
          <br>
          root                0          0          0     00 [--------]<br>
          user2               0     102400     409600     00 [--------]<br>
          user3               0     204800     512000     00 [--------]</font><br>
        <br>
      </blockquote>
    </blockquote>
        Is this correct or what does this output mean?<br>
    <br>
    <br>
        My kernel is 3.4.4 and xfs filesystem version is just in the
    version of this kernel.
  </body>
</html>

--------------010406080208090502050800--


--===============8386977312597534641==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8386977312597534641==--
