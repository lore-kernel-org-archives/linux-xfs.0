Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA93PqBL061894 for <xfs@oss.sgi.com>; Thu, 8 Nov 2012 21:25:52 -0600
Received: from m50-210.qiye.163.com (m50-210.qiye.163.com [123.125.50.210]) by
	cuda.sgi.com with ESMTP id aLJwFy9U3FM5QHKc for
	<xfs@oss.sgi.com>; Thu, 08 Nov 2012 19:27:46 -0800 (PST)
Message-ID: <509C7825.1080401@eisoo.com>
Date: Fri, 09 Nov 2012 11:27:33 +0800
From: "yyq@eisoo.com" <yyq@eisoo.com>
MIME-Version: 1.0
Subject: Re: xfs_quota -x -c 'report -u /dev/sde5' shows the duplicate result.
References: <20121108222315.505370321@sgi.com>
	<20121108222315.709683665@sgi.com> <509C5885.5060300@eisoo.com>
	<20121109012405.GX6434@dastard>
In-Reply-To: <20121109012405.GX6434@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6256463987672579217=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============6256463987672579217==
Content-Type: multipart/alternative;
 boundary="------------060108040906070404030908"

This is a multi-part message in MIME format.
--------------060108040906070404030908
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


于 2012-11-9 9:24, Dave Chinner 写道:
> On Fri, Nov 09, 2012 at 09:12:37AM +0800, yyq@eisoo.com wrote:
>> Hi,
>>
>>      When I use "xfs_quota -x -c 'report -u /dev/sde5'" to show
>> /dev/sde5's quotas, and the result have two same block as below:
> What version of xfs_quota are you using? What is the output of
> /proc/mounts and /etc/mtab say?
xfs_quota's version is 3.1.1 and output of /proc/mounts like this:

.....
/dev/sde3 /root/mnt_path xfs rw,relatime,attr2,usrquota 0 0
/dev/sde5 /root/mntpath2 xfs rw,relatime,attr2,usrquota 0 0
/dev/sde7 /root/mntpath3 xfs rw,relatime,attr2,usrquota 0 0

/etc/mtab:

....
/dev/sde3 /root/mnt_path xfs rw,uquota 0 0
/dev/sde5 /root/mntpath2 xfs rw,uquota 0 0
/dev/sde7 /root/mntpath3 xfs rw,uquota 0 0

in the original post "/dev/sde5" was removed and try "/dev/sde7", the 
remain the same problem.
>
> And does the latest version of xfs_quota have the same problem?
version 3.1.8's output have the same problem,and even worse, there are 
three same blocks :

User quota on /root/mntpath3 (/dev/sde7)
                                Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
root                0          0          0     00 [--------]
user2               0     102400     409600     00 [--------]
user3               0     204800     512000     00 [--------]

User quota on /root/mntpath3 (/dev/sde7)
                                Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
root                0          0          0     00 [--------]
user2               0     102400     409600     00 [--------]
user3               0     204800     512000     00 [--------]

User quota on /root/mntpath3 (/dev/sde7)
                                Blocks
User ID          Used       Soft       Hard    Warn/Grace
---------- --------------------------------------------------
root                0          0          0     00 [--------]
user2               0     102400     409600     00 [--------]
user3               0     204800     512000     00 [--------]


>
> Cheers,
>
> Dave.


--------------060108040906070404030908
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta content="text/html; charset=UTF-8" http-equiv="Content-Type">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <br>
    于 2012-11-9 9:24, Dave Chinner 写道:
    <blockquote cite="mid:20121109012405.GX6434@dastard" type="cite">
      <pre wrap="">On Fri, Nov 09, 2012 at 09:12:37AM +0800, <a class="moz-txt-link-abbreviated" href="mailto:yyq@eisoo.com">yyq@eisoo.com</a> wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">Hi,

    When I use "xfs_quota -x -c 'report -u /dev/sde5'" to show
/dev/sde5's quotas, and the result have two same block as below:
</pre>
      </blockquote>
      <pre wrap="">
What version of xfs_quota are you using? What is the output of
/proc/mounts and /etc/mtab say?</pre>
    </blockquote>
    xfs_quota's version is 3.1.1 and output of /proc/mounts like this:<br>
    <br>
    .....<br>
    <font color="#990000">/dev/sde3 /root/mnt_path xfs
      rw,relatime,attr2,usrquota 0 0<br>
      /dev/sde5 /root/mntpath2 xfs rw,relatime,attr2,usrquota 0 0<br>
      /dev/sde7 /root/mntpath3 xfs rw,relatime,attr2,usrquota 0 0</font><br>
    <br>
    /etc/mtab:<br>
    <br>
    <font color="#990000">....<br>
      /dev/sde3 /root/mnt_path xfs rw,uquota 0 0<br>
      /dev/sde5 /root/mntpath2 xfs rw,uquota 0 0<br>
      /dev/sde7 /root/mntpath3 xfs rw,uquota 0 0</font><br>
    <br>
    in the original post "/dev/sde5" was removed and try "/dev/sde7",
    the remain the same problem.<br>
    <blockquote cite="mid:20121109012405.GX6434@dastard" type="cite">
      <pre wrap="">

And does the latest version of xfs_quota have the same problem?</pre>
    </blockquote>
    version 3.1.8's output have the same problem,and even worse, there
    are three same blocks :<br>
    <br>
    <font color="#990000">User quota on /root/mntpath3 (/dev/sde7)<br>
                                     Blocks                     <br>
      User ID          Used       Soft       Hard    Warn/Grace     <br>
      ---------- -------------------------------------------------- <br>
      root                0          0          0     00 [--------]<br>
      user2               0     102400     409600     00 [--------]<br>
      user3               0     204800     512000     00 [--------]<br>
      <br>
      User quota on /root/mntpath3 (/dev/sde7)<br>
                                     Blocks                     <br>
      User ID          Used       Soft       Hard    Warn/Grace     <br>
      ---------- -------------------------------------------------- <br>
      root                0          0          0     00 [--------]<br>
      user2               0     102400     409600     00 [--------]<br>
      user3               0     204800     512000     00 [--------]<br>
      <br>
      User quota on /root/mntpath3 (/dev/sde7)<br>
                                     Blocks                     <br>
      User ID          Used       Soft       Hard    Warn/Grace     <br>
      ---------- -------------------------------------------------- <br>
      root                0          0          0     00 [--------]<br>
      user2               0     102400     409600     00 [--------]<br>
      user3               0     204800     512000     00 [--------]</font><br>
    <br>
    <br>
    <blockquote cite="mid:20121109012405.GX6434@dastard" type="cite">
      <pre wrap="">

Cheers,

Dave.
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------060108040906070404030908--


--===============6256463987672579217==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6256463987672579217==--
