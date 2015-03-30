Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6AA917F58
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 13:20:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 479218F804C
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 11:20:03 -0700 (PDT)
Received: from mail-qg0-f45.google.com (mail-qg0-f45.google.com
	[209.85.192.45]) by cuda.sgi.com with ESMTP id kX7oLldLUP4IjtEq
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Mar 2015 11:20:00 -0700 (PDT)
Received: by qgh3 with SMTP id 3so180795766qgh.2
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2015 11:20:00 -0700 (PDT)
Message-ID: <551993CF.4060908@binghamton.edu>
Date: Mon, 30 Mar 2015 14:19:59 -0400
From: Dave Hall <kdhall@binghamton.edu>
MIME-Version: 1.0
Subject: Slightly Urgent:  XFS No Space Left On Device
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8063043820410585139=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============8063043820410585139==
Content-Type: multipart/alternative;
 boundary="------------070403070501000802050607"

This is a multi-part message in MIME format.
--------------070403070501000802050607
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

I have an XFS file system that's getting 'No space left on device' 
errors.  xfs_fsr also complains of 'No space left'.  The XFS Info is:

    # xfs_info /data
    meta-data=/dev/sdb1              isize=256    agcount=19,
    agsize=268435440 blks
              =                       sectsz=512   attr=2
    data     =                       bsize=4096 blocks=4882431488, imaxpct=5
              =                       sunit=16     swidth=160 blks
    naming   =version 2              bsize=4096   ascii-ci=0
    log      =internal               bsize=4096   blocks=521728, version=2
              =                       sectsz=512   sunit=16 blks,
    lazy-count=1
    realtime =none                   extsz=4096   blocks=0, rtextents=0

    # df -h .
    Filesystem            Size  Used Avail Use% Mounted on
    /dev/sdb1              19T   12T  7.0T  62% /data
    # df -ih .
    Filesystem            Inodes   IUsed   IFree IUse% Mounted on
    /dev/sdb1               3.7G    4.7M    3.7G    1% /data


xfs_db freesp shows that AG 0 seems to be full.  I've included the 
freesp for the first few AGs, but the rest seem pretty consistent with 
AGs 1 - 4 that I've included below.

    xfs_db> freesp -s -e 1000000000 -a 0
        from      to extents  blocks    pct
           1 268435440    1930    3795 100.00
    total free extents 1930
    total free blocks 3795
    average free extent size 1.96632
    xfs_db> freesp -s -e 1000000000 -a 1
        from      to extents  blocks    pct
           1 268435440  287006 173832255 100.00
    total free extents 287006
    total free blocks 173832255
    average free extent size 605.675
    xfs_db> freesp -s -e 1000000000 -a 2
        from      to extents  blocks    pct
           1 268435440  272425 94291252 100.00
    total free extents 272425
    total free blocks 94291252
    average free extent size 346.118
    xfs_db> freesp -s -e 1000000000 -a 3
        from      to extents  blocks    pct
           1 268435440  286421 110208404 100.00
    total free extents 286421
    total free blocks 110208404
    average free extent size 384.778
    xfs_db> freesp -s -e 1000000000 -a 4
        from      to extents  blocks    pct
           1 268435440  277220 107118347 100.00
    total free extents 277220
    total free blocks 107118347
    average free extent size 386.402
    xfs_db>

Is there any way to figure out which files/directories are clogging up 
AG 0?  Any other ways to abate this issue?  Any way to assure 
proportional usage of AGs?

Thanks.

-Dave

--------------070403070501000802050607
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: 8bit

<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=utf-8">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    Hello,<br>
    <br>
    I have an XFS file system that's getting 'No space left on device'
    errors.  xfs_fsr also complains of 'No space left'.  The XFS Info
    is:<br>
    <br>
    <blockquote><tt># xfs_info /data</tt><br>
      <tt>meta-data=/dev/sdb1              isize=256    agcount=19,
        agsize=268435440 blks</tt><br>
      <tt>         =                       sectsz=512   attr=2</tt><br>
      <tt>data     =                       bsize=4096  
        blocks=4882431488, imaxpct=5</tt><br>
      <tt>         =                       sunit=16     swidth=160 blks</tt><br>
      <tt>naming   =version 2              bsize=4096   ascii-ci=0</tt><br>
      <tt>log      =internal               bsize=4096   blocks=521728,
        version=2</tt><br>
      <tt>         =                       sectsz=512   sunit=16 blks,
        lazy-count=1</tt><br>
      <tt>realtime =none                   extsz=4096   blocks=0,
        rtextents=0</tt><br>
      <br>
      # df -h .<br>
      Filesystem            Size  Used Avail Use% Mounted on<br>
      /dev/sdb1              19T   12T  7.0T  62% /data<br>
      # df -ih .<br>
      Filesystem            Inodes   IUsed   IFree IUse% Mounted on<br>
      /dev/sdb1               3.7G    4.7M    3.7G    1% /data<br>
    </blockquote>
    <br>
    xfs_db freesp shows that AG 0 seems to be full.  I've included the
    freesp for the first few AGs, but the rest seem pretty consistent
    with AGs 1 - 4 that I've included below.  <br>
    <blockquote><tt>xfs_db&gt; freesp -s -e 1000000000 -a 0</tt><br>
      <tt>   from      to extents  blocks    pct</tt><br>
      <tt>      1 268435440    1930    3795 100.00</tt><br>
      <tt>total free extents 1930</tt><br>
      <tt>total free blocks 3795</tt><br>
      <tt>average free extent size 1.96632</tt><br>
      <tt>xfs_db&gt; freesp -s -e 1000000000 -a 1</tt><br>
      <tt>   from      to extents  blocks    pct</tt><br>
      <tt>      1 268435440  287006 173832255 100.00</tt><br>
      <tt>total free extents 287006</tt><br>
      <tt>total free blocks 173832255</tt><br>
      <tt>average free extent size 605.675</tt><br>
      <tt>xfs_db&gt; freesp -s -e 1000000000 -a 2</tt><br>
      <tt>   from      to extents  blocks    pct</tt><br>
      <tt>      1 268435440  272425 94291252 100.00</tt><br>
      <tt>total free extents 272425</tt><br>
      <tt>total free blocks 94291252</tt><br>
      <tt>average free extent size 346.118</tt><br>
      <tt>xfs_db&gt; freesp -s -e 1000000000 -a 3</tt><br>
      <tt>   from      to extents  blocks    pct</tt><br>
      <tt>      1 268435440  286421 110208404 100.00</tt><br>
      <tt>total free extents 286421</tt><br>
      <tt>total free blocks 110208404</tt><br>
      <tt>average free extent size 384.778</tt><br>
      <tt>xfs_db&gt; freesp -s -e 1000000000 -a 4</tt><br>
      <tt>   from      to extents  blocks    pct</tt><br>
      <tt>      1 268435440  277220 107118347 100.00</tt><br>
      <tt>total free extents 277220</tt><br>
      <tt>total free blocks 107118347</tt><br>
      <tt>average free extent size 386.402</tt><br>
      <tt>xfs_db&gt;</tt><br>
    </blockquote>
    Is there any way to figure out which files/directories are clogging
    up AG 0?  Any other ways to abate this issue?  Any way to assure
    proportional usage of AGs?<br>
    <br>
    Thanks.<br>
    <br>
    -Dave<br>
  </body>
</html>

--------------070403070501000802050607--


--===============8063043820410585139==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8063043820410585139==--
