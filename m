Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1MFkCHX235241 for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 09:46:12 -0600
Received: from mail-pz0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 27E729E73AA
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 07:48:55 -0800 (PST)
Received: from mail-pz0-f53.google.com (mail-pz0-f53.google.com
	[209.85.210.53]) by cuda.sgi.com with ESMTP id alZUkAlFilURZkoe
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 07:48:55 -0800 (PST)
Received: by pzk37 with SMTP id 37so488428pzk.26
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 07:48:55 -0800 (PST)
Message-ID: <4D63D9D8.3060204@storegrid.com>
Date: Tue, 22 Feb 2011 21:14:24 +0530
From: Srinivasan T <srinivasan@storegrid.com>
MIME-Version: 1.0
Subject: Input/Output error
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8639672672213615132=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============8639672672213615132==
Content-Type: multipart/alternative;
 boundary="------------090703010302030602050200"

This is a multi-part message in MIME format.
--------------090703010302030602050200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

We are running an C++ application in AWS EC2 instance (CentOS 5.4) 
mounted with an EBS Volume (say /mymountpoint). We do more simultaneous 
writes to the EBS Volume from our application. But at some point we get 
'ERROR: Input/output error'. After this, 'ls -l /mymountpoint' command 
itself fails with the i/o error. The filesystem which we use for the EBS 
Volume is xfs.

I unmounted the drive and done xfs_check and again mounted the drive. 
Now, everything seems to be working fine. But the issue still persists 
everytime when we do simultaneous writes.

I believe the following details will be useful,

[root@domU-12-31-39-07-81-36 StoreGrid]# cat /etc/redhat-release
CentOS release 5.4 (Final)

[root@domU-12-31-39-07-81-36 StoreGrid]# df -lTi
Filesystem    Type    Inodes   IUsed   IFree IUse% Mounted on
/dev/sda1     ext3   1310720  107566 1203154    9% /
/dev/sdb      ext3   19546112      11 19546101    1% /mnt
none         tmpfs    186059       1  186058    1% /dev/shm
/dev/sdh       xfs   1934272  495857 1438415   26% /mymountpoint

[root@domU-12-31-39-07-81-36 StoreGrid]# uname -a
Linux domU-12-31-39-07-81-36 2.6.21.7-2.fc8xen #1 SMP Fri Feb 15 
12:39:36 EST 2008 i686 i686 i386 GNU/Linux

Output of dmesg :

SGI XFS with ACLs, security attributes, large block numbers, no debug 
enabled
SGI XFS Quota Management subsystem
Filesystem "sdh": Disabling barriers, not supported by the underlying device
XFS mounting filesystem sdh
Ending clean XFS mount for filesystem: sdh
Filesystem "sdh": XFS internal error xfs_trans_cancel at line 1138 of 
file fs/xfs/xfs_trans.c.  Caller 0xee201944
  [<ee2032fe>] xfs_trans_cancel+0x59/0xe3 [xfs]
  [<ee201944>] xfs_rename+0x8f8/0x954 [xfs]
  [<ee201944>] xfs_rename+0x8f8/0x954 [xfs]
  [<ee21458c>] xfs_vn_rename+0x30/0x70 [xfs]
  [<c10bb5e3>] selinux_inode_rename+0x11f/0x16d
  [<c1078d88>] vfs_rename+0x2c3/0x441
  [<c107a77f>] sys_renameat+0x15a/0x1b4
  [<c1074b7f>] sys_stat64+0xf/0x23
  [<c1072d3b>] __fput+0x140/0x16a
  [<c10841ee>] mntput_no_expire+0x11/0x6a
  [<c107a800>] sys_rename+0x27/0x2b
  [<c1005688>] syscall_call+0x7/0xb
  =======================
xfs_force_shutdown(sdh,0x8) called from line 1139 of file 
fs/xfs/xfs_trans.c.  Return address = 0xee217778
Filesystem "sdh": Corruption of in-memory data detected.  Shutting down 
filesystem: sdh
Please umount the filesystem, and rectify the problem(s)
I/O error in filesystem ("sdh") meta-data dev sdh block 0x3c0001       
("xfs_trans_read_buf") error 5 buf count 512
I/O error in filesystem ("sdh") meta-data dev sdh block 0x780001       
("xfs_trans_read_buf") error 5 buf count 512
xfs_force_shutdown(sdh,0x1) called from line 423 of file 
fs/xfs/xfs_rw.c.  Return address = 0xee217778
xfs_force_shutdown(sdh,0x1) called from line 423 of file 
fs/xfs/xfs_rw.c.  Return address = 0xee217778
Filesystem "sdh": Disabling barriers, not supported by the underlying device
XFS mounting filesystem sdh
Starting XFS recovery on filesystem: sdh (logdev: internal)
Ending XFS recovery on filesystem: sdh (logdev: internal)

The XFS utilities are in v2.9.4

Any help would be appreciated.

Regards,
Srinivasan

--------------090703010302030602050200
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>

    <meta http-equiv="content-type" content="text/html; charset=ISO-8859-1">
  </head>
  <body text="#000099" bgcolor="#ffffff">
    <font face="sans-serif">Hi,<br>
      <br>
      We are running an C++ application in AWS EC2 instance (CentOS 5.4)
      mounted with an EBS Volume (say /mymountpoint). We do more
      simultaneous writes to the EBS Volume from our application. But at
      some point we get 'ERROR: Input/output error'. After this, 'ls -l
      /mymountpoint' command itself fails with the i/o error. The
      filesystem which we use for the EBS Volume is xfs.<br>
      <br>
      I unmounted the drive and done xfs_check and again mounted the
      drive. Now, everything seems to be working fine. But the issue
      still persists everytime when we do simultaneous writes.<br>
      <br>
      I believe the following details will be useful,<br>
      <br>
      <font color="#660000">[root@domU-12-31-39-07-81-36 StoreGrid]# cat
        /etc/redhat-release<br>
        CentOS release 5.4 (Final)<br>
      </font><br>
      <font color="#660000">[root@domU-12-31-39-07-81-36 StoreGrid]# df
        -lTi<br>
        Filesystem&nbsp;&nbsp;&nbsp; Type&nbsp;&nbsp;&nbsp; Inodes&nbsp;&nbsp; IUsed&nbsp;&nbsp; IFree IUse% Mounted on<br>
        /dev/sda1&nbsp;&nbsp;&nbsp;&nbsp; ext3&nbsp;&nbsp; 1310720&nbsp; 107566 1203154&nbsp;&nbsp;&nbsp; 9% /<br>
        /dev/sdb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ext3&nbsp;&nbsp; 19546112&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 11 19546101&nbsp;&nbsp;&nbsp; 1% /mnt<br>
        none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; tmpfs&nbsp;&nbsp;&nbsp; 186059&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp; 186058&nbsp;&nbsp;&nbsp; 1% /dev/shm<br>
        /dev/sdh&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; xfs&nbsp;&nbsp; 1934272&nbsp; 495857 1438415&nbsp;&nbsp; 26% /mymountpoint<br>
      </font><br>
      <font color="#660000">[root@domU-12-31-39-07-81-36 StoreGrid]#
        uname -a<br>
        Linux domU-12-31-39-07-81-36 2.6.21.7-2.fc8xen #1 SMP Fri Feb 15
        12:39:36 EST 2008 i686 i686 i386 GNU/Linux<br>
      </font><br>
      Output of dmesg :<br>
      <br>
      <font color="#660000">SGI XFS with ACLs, security attributes,
        large block numbers, no debug enabled<br>
        SGI XFS Quota Management subsystem<br>
        Filesystem "sdh": Disabling barriers, not supported by the
        underlying device<br>
        XFS mounting filesystem sdh<br>
        Ending clean XFS mount for filesystem: sdh<br>
        Filesystem "sdh": XFS internal error xfs_trans_cancel at line
        1138 of file fs/xfs/xfs_trans.c.&nbsp; Caller 0xee201944<br>
        &nbsp;[&lt;ee2032fe&gt;] xfs_trans_cancel+0x59/0xe3 [xfs]<br>
        &nbsp;[&lt;ee201944&gt;] xfs_rename+0x8f8/0x954 [xfs]<br>
        &nbsp;[&lt;ee201944&gt;] xfs_rename+0x8f8/0x954 [xfs]<br>
        &nbsp;[&lt;ee21458c&gt;] xfs_vn_rename+0x30/0x70 [xfs]<br>
        &nbsp;[&lt;c10bb5e3&gt;] selinux_inode_rename+0x11f/0x16d<br>
        &nbsp;[&lt;c1078d88&gt;] vfs_rename+0x2c3/0x441<br>
        &nbsp;[&lt;c107a77f&gt;] sys_renameat+0x15a/0x1b4<br>
        &nbsp;[&lt;c1074b7f&gt;] sys_stat64+0xf/0x23<br>
        &nbsp;[&lt;c1072d3b&gt;] __fput+0x140/0x16a<br>
        &nbsp;[&lt;c10841ee&gt;] mntput_no_expire+0x11/0x6a<br>
        &nbsp;[&lt;c107a800&gt;] sys_rename+0x27/0x2b<br>
        &nbsp;[&lt;c1005688&gt;] syscall_call+0x7/0xb<br>
        &nbsp;=======================<br>
        xfs_force_shutdown(sdh,0x8) called from line 1139 of file
        fs/xfs/xfs_trans.c.&nbsp; Return address = 0xee217778<br>
        Filesystem "sdh": Corruption of in-memory data detected.&nbsp;
        Shutting down filesystem: sdh<br>
        Please umount the filesystem, and rectify the problem(s)<br>
        I/O error in filesystem ("sdh") meta-data dev sdh block
        0x3c0001&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ("xfs_trans_read_buf") error 5 buf count 512<br>
        I/O error in filesystem ("sdh") meta-data dev sdh block
        0x780001&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ("xfs_trans_read_buf") error 5 buf count 512<br>
        xfs_force_shutdown(sdh,0x1) called from line 423 of file
        fs/xfs/xfs_rw.c.&nbsp; Return address = 0xee217778<br>
        xfs_force_shutdown(sdh,0x1) called from line 423 of file
        fs/xfs/xfs_rw.c.&nbsp; Return address = 0xee217778<br>
        Filesystem "sdh": Disabling barriers, not supported by the
        underlying device<br>
        XFS mounting filesystem sdh<br>
        Starting XFS recovery on filesystem: sdh (logdev: internal)<br>
        Ending XFS recovery on filesystem: sdh (logdev: internal)</font><br>
      <br>
      The XFS utilities are in v2.9.4<br>
      <br>
      Any help would be appreciated.<br>
      <br>
      Regards,<br>
      Srinivasan<br>
    </font>
  </body>
</html>

--------------090703010302030602050200--


--===============8639672672213615132==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8639672672213615132==--
