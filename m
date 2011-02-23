Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1N6bIIk034176 for <xfs@oss.sgi.com>; Wed, 23 Feb 2011 00:37:19 -0600
Received: from mail-gw0-f46.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F08812D2993
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 22:40:01 -0800 (PST)
Received: from mail-gw0-f46.google.com (mail-gw0-f46.google.com
	[74.125.83.46]) by cuda.sgi.com with ESMTP id IElpsJrRx08RrALR
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 22:40:01 -0800 (PST)
Received: by gwj20 with SMTP id 20so1580495gwj.5
	for <xfs@oss.sgi.com>; Tue, 22 Feb 2011 22:40:01 -0800 (PST)
Message-ID: <4D64AA28.9050207@storegrid.com>
Date: Wed, 23 Feb 2011 12:03:12 +0530
From: Srinivasan T <srinivasan@storegrid.com>
MIME-Version: 1.0
Subject: Re: Input/Output error
References: <4D63D9D8.3060204@storegrid.com> <4D641AB1.7010101@sandeen.net>
In-Reply-To: <4D641AB1.7010101@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8306794552610292675=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--===============8306794552610292675==
Content-Type: multipart/alternative;
 boundary="------------050805030305040909030902"

This is a multi-part message in MIME format.
--------------050805030305040909030902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

There is enough disk space in the fs.

[root@domU-12-31-39-07-81-36 StoreGrid]# df -lh
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda1             9.9G  2.9G  6.6G  31% /
/dev/sdb              147G  188M  140G   1% /mnt
none                  854M     0  854M   0% /dev/shm
/dev/sdh              5.0G   25M  5.0G   1% /mymountpoint

Also, the output of modinfo is as follows,

[root@domU-12-31-39-07-81-36 StoreGrid]# modinfo xfs
filename:       /lib/modules/2.6.21.7-2.fc8xen/kernel/fs/xfs/xfs.ko
license:        GPL
description:    SGI XFS with ACLs, security attributes, large block 
numbers, no debug enabled
author:         Silicon Graphics, Inc.
srcversion:     C7114C18263E3067C64F2BC
depends:
vermagic:       2.6.21-2952.fc8xen SMP mod_unload 686 4KSTACKS

I have installed xfs with yum by using the following command,

yum install xfsprogs

I think I have installed the kernel rpm xfs ko. Can you confirm if this 
is correct.

Regards,
Srinivasan


On 02/23/2011 01:51 AM, Eric Sandeen wrote:
> On 2/22/11 9:44 AM, Srinivasan T wrote:
>> Hi,
>>
>> We are running an C++ application in AWS EC2 instance (CentOS 5.4)
>> mounted with an EBS Volume (say /mymountpoint). We do more
>> simultaneous writes to the EBS Volume from our application. But at
>> some point we get 'ERROR: Input/output error'. After this, 'ls -l
>> /mymountpoint' command itself fails with the i/o error. The
>> filesystem which we use for the EBS Volume is xfs.
>>
>> I unmounted the drive and done xfs_check and again mounted the drive.
> xfs_check is read-only, FWIW, a task best handled these days
> by xfs_repair -n.
>
>> Now, everything seems to be working fine. But the issue still
>> persists everytime when we do simultaneous writes.>
>> I believe the following details will be useful,
>>
>> [root@domU-12-31-39-07-81-36 StoreGrid]# cat /etc/redhat-release
>> CentOS release 5.4 (Final)
> is quota in use?  Might you be running out of space on the fs?
>
> Sadly I'm not even sure what xfs you might be running; there were centos kmod
> rpms of older xfs for a while, and then more recent kernels have xfs.ko
> built in, because RHEL5 started with official support for XFS later on.
>
> line 1138 of file fs/xfs/xfs_trans.c does not line up with current RHEL5.
>
> "modinfo xfs" might tell us at least where the xfs module was found,
> and from there know where it came from.
>
> But, xfs support on RHEL is best handled by Red Hat, I'm afraid.  And if this
> is an old xfs kmod (which *cough* I did for centos years ago) it's not going
> to be well supported by anyone.
>
> -if- you have xfs-kmod installed, and a kernel rpm which contains xfs.ko
> itself, I'd suggest trying again with the latter.
>
> Barring all that, perhaps this is a known problem more obvious to another
> person on this list ...
>
> -Eric
>
>> [root@domU-12-31-39-07-81-36 StoreGrid]# df -lTi
>> Filesystem    Type    Inodes   IUsed   IFree IUse% Mounted on
>> /dev/sda1     ext3   1310720  107566 1203154    9% /
>> /dev/sdb      ext3   19546112      11 19546101    1% /mnt
>> none         tmpfs    186059       1  186058    1% /dev/shm
>> /dev/sdh       xfs   1934272  495857 1438415   26% /mymountpoint
>>
>> [root@domU-12-31-39-07-81-36 StoreGrid]# uname -a
>> Linux domU-12-31-39-07-81-36 2.6.21.7-2.fc8xen #1 SMP Fri Feb 15 12:39:36 EST 2008 i686 i686 i386 GNU/Linux
>>
>> Output of dmesg :
>>
>> SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
>> SGI XFS Quota Management subsystem
>> Filesystem "sdh": Disabling barriers, not supported by the underlying device
>> XFS mounting filesystem sdh
>> Ending clean XFS mount for filesystem: sdh
>> Filesystem "sdh": XFS internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c.  Caller 0xee201944
>>   [<ee2032fe>] xfs_trans_cancel+0x59/0xe3 [xfs]
>>   [<ee201944>] xfs_rename+0x8f8/0x954 [xfs]
>>   [<ee201944>] xfs_rename+0x8f8/0x954 [xfs]
>>   [<ee21458c>] xfs_vn_rename+0x30/0x70 [xfs]
>>   [<c10bb5e3>] selinux_inode_rename+0x11f/0x16d
>>   [<c1078d88>] vfs_rename+0x2c3/0x441
>>   [<c107a77f>] sys_renameat+0x15a/0x1b4
>>   [<c1074b7f>] sys_stat64+0xf/0x23
>>   [<c1072d3b>] __fput+0x140/0x16a
>>   [<c10841ee>] mntput_no_expire+0x11/0x6a
>>   [<c107a800>] sys_rename+0x27/0x2b
>>   [<c1005688>] syscall_call+0x7/0xb
>>   =======================
>> xfs_force_shutdown(sdh,0x8) called from line 1139 of file fs/xfs/xfs_trans.c.  Return address = 0xee217778
>> Filesystem "sdh": Corruption of in-memory data detected.  Shutting down filesystem: sdh
>> Please umount the filesystem, and rectify the problem(s)
>> I/O error in filesystem ("sdh") meta-data dev sdh block 0x3c0001       ("xfs_trans_read_buf") error 5 buf count 512
>> I/O error in filesystem ("sdh") meta-data dev sdh block 0x780001       ("xfs_trans_read_buf") error 5 buf count 512
>> xfs_force_shutdown(sdh,0x1) called from line 423 of file fs/xfs/xfs_rw.c.  Return address = 0xee217778
>> xfs_force_shutdown(sdh,0x1) called from line 423 of file fs/xfs/xfs_rw.c.  Return address = 0xee217778
>> Filesystem "sdh": Disabling barriers, not supported by the underlying device
>> XFS mounting filesystem sdh
>> Starting XFS recovery on filesystem: sdh (logdev: internal)
>> Ending XFS recovery on filesystem: sdh (logdev: internal)
>>
>> The XFS utilities are in v2.9.4
>>
>> Any help would be appreciated.
>>
>> Regards,
>> Srinivasan
>>
>>
>>
>> _______________________________________________
>> xfs mailing list
>> xfs@oss.sgi.com
>> http://oss.sgi.com/mailman/listinfo/xfs


--------------050805030305040909030902
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <meta content="text/html; charset=ISO-8859-1"
      http-equiv="Content-Type">
  </head>
  <body text="#000099" bgcolor="#ffffff">
    Hi Eric,<br>
    <br>
    There is enough disk space in the fs.<br>
    <br>
    [root@domU-12-31-39-07-81-36 StoreGrid]# df -lh<br>
    Filesystem&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size&nbsp; Used Avail Use% Mounted on<br>
    /dev/sda1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 9.9G&nbsp; 2.9G&nbsp; 6.6G&nbsp; 31% /<br>
    /dev/sdb&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 147G&nbsp; 188M&nbsp; 140G&nbsp;&nbsp; 1% /mnt<br>
    none&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 854M&nbsp;&nbsp;&nbsp;&nbsp; 0&nbsp; 854M&nbsp;&nbsp; 0% /dev/shm<br>
    /dev/sdh&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 5.0G&nbsp;&nbsp; 25M&nbsp; 5.0G&nbsp;&nbsp; 1% /mymountpoint<br>
    <br>
    Also, the output of modinfo is as follows,<br>
    <br>
    [root@domU-12-31-39-07-81-36 StoreGrid]# modinfo xfs<br>
    filename:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /lib/modules/2.6.21.7-2.fc8xen/kernel/fs/xfs/xfs.ko<br>
    license:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; GPL<br>
    description:&nbsp;&nbsp;&nbsp; SGI XFS with ACLs, security attributes, large block
    numbers, no debug enabled<br>
    author:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Silicon Graphics, Inc.<br>
    srcversion:&nbsp;&nbsp;&nbsp;&nbsp; C7114C18263E3067C64F2BC<br>
    depends:<br>
    vermagic:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2.6.21-2952.fc8xen SMP mod_unload 686 4KSTACKS<br>
    <br>
    I have installed xfs with yum by using the following command,<br>
    <br>
    yum install xfsprogs<br>
    <br>
    I think I have installed the kernel rpm xfs ko. Can you confirm if
    this is correct.<br>
    <br>
    Regards,<br>
    Srinivasan<br>
    <br>
    <br>
    On 02/23/2011 01:51 AM, Eric Sandeen wrote:
    <blockquote cite="mid:4D641AB1.7010101@sandeen.net" type="cite">
      <pre wrap="">On 2/22/11 9:44 AM, Srinivasan T wrote:
</pre>
      <blockquote type="cite">
        <pre wrap="">Hi,

We are running an C++ application in AWS EC2 instance (CentOS 5.4)
mounted with an EBS Volume (say /mymountpoint). We do more
simultaneous writes to the EBS Volume from our application. But at
some point we get 'ERROR: Input/output error'. After this, 'ls -l
/mymountpoint' command itself fails with the i/o error. The
filesystem which we use for the EBS Volume is xfs.

I unmounted the drive and done xfs_check and again mounted the drive.
</pre>
      </blockquote>
      <pre wrap="">
xfs_check is read-only, FWIW, a task best handled these days
by xfs_repair -n.

</pre>
      <blockquote type="cite">
        <pre wrap="">Now, everything seems to be working fine. But the issue still
persists everytime when we do simultaneous writes.&gt; 
I believe the following details will be useful,

[root@domU-12-31-39-07-81-36 StoreGrid]# cat /etc/redhat-release
CentOS release 5.4 (Final)
</pre>
      </blockquote>
      <pre wrap="">
is quota in use?  Might you be running out of space on the fs?

Sadly I'm not even sure what xfs you might be running; there were centos kmod
rpms of older xfs for a while, and then more recent kernels have xfs.ko
built in, because RHEL5 started with official support for XFS later on.

line 1138 of file fs/xfs/xfs_trans.c does not line up with current RHEL5.

"modinfo xfs" might tell us at least where the xfs module was found,
and from there know where it came from.

But, xfs support on RHEL is best handled by Red Hat, I'm afraid.  And if this
is an old xfs kmod (which *cough* I did for centos years ago) it's not going
to be well supported by anyone.

-if- you have xfs-kmod installed, and a kernel rpm which contains xfs.ko
itself, I'd suggest trying again with the latter.

Barring all that, perhaps this is a known problem more obvious to another
person on this list ...

-Eric

</pre>
      <blockquote type="cite">
        <pre wrap="">[root@domU-12-31-39-07-81-36 StoreGrid]# df -lTi
Filesystem    Type    Inodes   IUsed   IFree IUse% Mounted on
/dev/sda1     ext3   1310720  107566 1203154    9% /
/dev/sdb      ext3   19546112      11 19546101    1% /mnt
none         tmpfs    186059       1  186058    1% /dev/shm
/dev/sdh       xfs   1934272  495857 1438415   26% /mymountpoint

[root@domU-12-31-39-07-81-36 StoreGrid]# uname -a
Linux domU-12-31-39-07-81-36 2.6.21.7-2.fc8xen #1 SMP Fri Feb 15 12:39:36 EST 2008 i686 i686 i386 GNU/Linux

Output of dmesg :

SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
Filesystem "sdh": Disabling barriers, not supported by the underlying device
XFS mounting filesystem sdh
Ending clean XFS mount for filesystem: sdh
Filesystem "sdh": XFS internal error xfs_trans_cancel at line 1138 of file fs/xfs/xfs_trans.c.  Caller 0xee201944
 [&lt;ee2032fe&gt;] xfs_trans_cancel+0x59/0xe3 [xfs]
 [&lt;ee201944&gt;] xfs_rename+0x8f8/0x954 [xfs]
 [&lt;ee201944&gt;] xfs_rename+0x8f8/0x954 [xfs]
 [&lt;ee21458c&gt;] xfs_vn_rename+0x30/0x70 [xfs]
 [&lt;c10bb5e3&gt;] selinux_inode_rename+0x11f/0x16d
 [&lt;c1078d88&gt;] vfs_rename+0x2c3/0x441
 [&lt;c107a77f&gt;] sys_renameat+0x15a/0x1b4
 [&lt;c1074b7f&gt;] sys_stat64+0xf/0x23
 [&lt;c1072d3b&gt;] __fput+0x140/0x16a
 [&lt;c10841ee&gt;] mntput_no_expire+0x11/0x6a
 [&lt;c107a800&gt;] sys_rename+0x27/0x2b
 [&lt;c1005688&gt;] syscall_call+0x7/0xb
 =======================
xfs_force_shutdown(sdh,0x8) called from line 1139 of file fs/xfs/xfs_trans.c.  Return address = 0xee217778
Filesystem "sdh": Corruption of in-memory data detected.  Shutting down filesystem: sdh
Please umount the filesystem, and rectify the problem(s)
I/O error in filesystem ("sdh") meta-data dev sdh block 0x3c0001       ("xfs_trans_read_buf") error 5 buf count 512
I/O error in filesystem ("sdh") meta-data dev sdh block 0x780001       ("xfs_trans_read_buf") error 5 buf count 512
xfs_force_shutdown(sdh,0x1) called from line 423 of file fs/xfs/xfs_rw.c.  Return address = 0xee217778
xfs_force_shutdown(sdh,0x1) called from line 423 of file fs/xfs/xfs_rw.c.  Return address = 0xee217778
Filesystem "sdh": Disabling barriers, not supported by the underlying device
XFS mounting filesystem sdh
Starting XFS recovery on filesystem: sdh (logdev: internal)
Ending XFS recovery on filesystem: sdh (logdev: internal)

The XFS utilities are in v2.9.4

Any help would be appreciated.

Regards,
Srinivasan



_______________________________________________
xfs mailing list
<a class="moz-txt-link-abbreviated" href="mailto:xfs@oss.sgi.com">xfs@oss.sgi.com</a>
<a class="moz-txt-link-freetext" href="http://oss.sgi.com/mailman/listinfo/xfs">http://oss.sgi.com/mailman/listinfo/xfs</a>
</pre>
      </blockquote>
      <pre wrap="">
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------050805030305040909030902--


--===============8306794552610292675==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8306794552610292675==--
