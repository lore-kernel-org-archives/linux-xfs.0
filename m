Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5F9C07CA6
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 23:45:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1F22F8F8033
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 21:45:17 -0700 (PDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com
	[74.125.82.52]) by cuda.sgi.com with ESMTP id Bj933P09xdUBgKAh
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 29 May 2016 21:45:15 -0700 (PDT)
Received: by mail-wm0-f52.google.com with SMTP id n129so68220333wmn.1
	for <xfs@oss.sgi.com>; Sun, 29 May 2016 21:45:15 -0700 (PDT)
Received: from [10.18.60.107] ([104.192.110.250])
	by smtp.gmail.com with ESMTPSA id
	az2sm32318285wjc.6.2016.05.29.21.45.11 for <xfs@oss.sgi.com>
	(version=TLSv1/SSLv3 cipher=OTHER);
	Sun, 29 May 2016 21:45:13 -0700 (PDT)
From: baotiao <baotiao@gmail.com>
Subject: XFS: possible memory allocation deadlock in kmem_alloc
Message-Id: <AD1240BA-DB24-44F2-893D-28A824063F99@gmail.com>
Date: Mon, 30 May 2016 12:45:07 +0800
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5505445922209900009=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============5505445922209900009==
Content-Type: multipart/alternative; boundary="Apple-Mail=_CF74D2CB-62D5-475C-ACB9-592B65E5E97B"


--Apple-Mail=_CF74D2CB-62D5-475C-ACB9-592B65E5E97B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hello.=20

we have experience this problem many time, and we try many ways to solve =
this problem, but always failed.

such as sync && echo 3 > /proc/sys/vm/drop_caches to free more memory, =
however, after a while, the message come again.

the dmesg show:
May 30 12:35:51 w-openstack21 kernel: XFS: possible memory allocation =
deadlock in kmem_alloc (mode:0x250)
May 30 12:35:53 w-openstack21 kernel: XFS: possible memory allocation =
deadlock in kmem_alloc (mode:0x250)
May 30 12:35:55 w-openstack21 kernel: XFS: possible memory allocation =
deadlock in kmem_alloc (mode:0x250)
May 30 12:35:57 w-openstack21 kernel: XFS: possible memory allocation =
deadlock in kmem_alloc (mode:0x250)
May 30 12:35:59 w-openstack21 kernel: XFS: possible memory allocation =
deadlock in kmem_alloc (mode:0x250)

our kernel version is 3.10.0-327.4.5.el7.x86_64

we think this is the kernel memory fragmentation problem, when dmesg =
show the error message, we check the buddyinfo

[root@w-openstack21 /home/xusiliang]# cat /proc/buddyinfo
Node 0, zone      DMA      1      0      1      0      2      1      1   =
   0      1      1      3
Node 0, zone    DMA32   2190   1898   1367    583    284     81     21   =
   8      5      0      4
Node 0, zone   Normal  85195  90572  56688  32379  16793   5568    930   =
 230    184     11      0
Node 1, zone   Normal  95799 127034  94363  49321  21555   5239    225   =
   2      2      0      0

and I think the kernel have enough free memory
[root@w-openstack21 /home/xusiliang]# free -m
              total        used        free      shared  buff/cache   =
available
Mem:          64269       50357       11802          65        2109      =
 11757
Swap:         32255         347       31908

This machine is running for qemu,  the file is qemu qcow file type

[root@w-openstack20 =
/data/nova/instances/7898b630-c4ef-49ab-9ce9-3735e090c282]# file disk
disk: QEMU QCOW Image (v3), has backing file (path =
/data/nova/instances/_base/3f27393376152ac352b2d85703011e38517e), =
429496729600 bytes

we also use xfs_db to check the fragmentation

[root@w-openstack20 /home/xusiliang]# xfs_db -r =
/dev/mapper/VolGroup00-LogVol04
xfs_db> frag

actual 48421430, ideal 20716, fragmentation factor 99.96%


How can I solve this problem, what do you suggest me to do?

thank you


----------------------------------------
=20
Github: https://github.com/baotiao
Blog: http://baotiao.github.io
Stackoverflow: http://stackoverflow.com/users/634415/baotiao=20
Linkedin: http://www.linkedin.com/profile/view?id=3D145231990


--Apple-Mail=_CF74D2CB-62D5-475C-ACB9-592B65E5E97B
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html><head><meta http-equiv=3D"Content-Type" content=3D"text/html =
charset=3Dus-ascii"></head><body style=3D"word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D"">Hello.&nbsp;<div class=3D""><br class=3D""></div><div =
class=3D"">we have experience this problem many time, and we try many =
ways to solve this problem, but always failed.</div><div class=3D""><br =
class=3D""></div><div class=3D"">such as&nbsp;sync &amp;&amp; echo 3 =
&gt; /proc/sys/vm/drop_caches to free more memory, however, after a =
while, the message come again.</div><div class=3D""><br =
class=3D""></div><div class=3D"">the dmesg show:</div><div class=3D""><div=
 class=3D"">May 30 12:35:51 w-openstack21 kernel: XFS: possible memory =
allocation deadlock in kmem_alloc (mode:0x250)</div><div class=3D"">May =
30 12:35:53 w-openstack21 kernel: XFS: possible memory allocation =
deadlock in kmem_alloc (mode:0x250)</div><div class=3D"">May 30 12:35:55 =
w-openstack21 kernel: XFS: possible memory allocation deadlock in =
kmem_alloc (mode:0x250)</div><div class=3D"">May 30 12:35:57 =
w-openstack21 kernel: XFS: possible memory allocation deadlock in =
kmem_alloc (mode:0x250)</div><div class=3D"">May 30 12:35:59 =
w-openstack21 kernel: XFS: possible memory allocation deadlock in =
kmem_alloc (mode:0x250)</div></div><div class=3D""><br =
class=3D""></div><div class=3D"">our kernel version =
is&nbsp;3.10.0-327.4.5.el7.x86_64</div><div class=3D""><br =
class=3D""></div><div class=3D"">we think this is the kernel memory =
fragmentation problem, when dmesg show the error message, we check the =
buddyinfo</div><div class=3D""><br class=3D""></div><div class=3D""><div =
class=3D"">[root@w-openstack21 /home/xusiliang]# cat =
/proc/buddyinfo</div><div class=3D"">Node 0, zone &nbsp; &nbsp; =
&nbsp;DMA &nbsp; &nbsp; &nbsp;1 &nbsp; &nbsp; &nbsp;0 &nbsp; &nbsp; =
&nbsp;1 &nbsp; &nbsp; &nbsp;0 &nbsp; &nbsp; &nbsp;2 &nbsp; &nbsp; =
&nbsp;1 &nbsp; &nbsp; &nbsp;1 &nbsp; &nbsp; &nbsp;0 &nbsp; &nbsp; =
&nbsp;1 &nbsp; &nbsp; &nbsp;1 &nbsp; &nbsp; &nbsp;3</div><div =
class=3D"">Node 0, zone &nbsp; &nbsp;DMA32 &nbsp; 2190 &nbsp; 1898 =
&nbsp; 1367 &nbsp; &nbsp;583 &nbsp; &nbsp;284 &nbsp; &nbsp; 81 &nbsp; =
&nbsp; 21 &nbsp; &nbsp; &nbsp;8 &nbsp; &nbsp; &nbsp;5 &nbsp; &nbsp; =
&nbsp;0 &nbsp; &nbsp; &nbsp;4</div><div class=3D"">Node 0, zone &nbsp; =
Normal &nbsp;85195 &nbsp;90572 &nbsp;56688 &nbsp;32379 &nbsp;16793 =
&nbsp; 5568 &nbsp; &nbsp;930 &nbsp; &nbsp;230 &nbsp; &nbsp;184 &nbsp; =
&nbsp; 11 &nbsp; &nbsp; &nbsp;0</div><div class=3D"">Node 1, zone &nbsp; =
Normal &nbsp;95799 127034 &nbsp;94363 &nbsp;49321 &nbsp;21555 &nbsp; =
5239 &nbsp; &nbsp;225 &nbsp; &nbsp; &nbsp;2 &nbsp; &nbsp; &nbsp;2 &nbsp; =
&nbsp; &nbsp;0 &nbsp; &nbsp; &nbsp;0</div></div><div class=3D""><br =
class=3D""></div><div class=3D"">and I think the kernel have enough free =
memory</div><div class=3D""><div class=3D"">[root@w-openstack21 =
/home/xusiliang]# free -m</div><div class=3D"">&nbsp; &nbsp; &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp; total &nbsp; &nbsp; &nbsp; &nbsp;used &nbsp; =
&nbsp; &nbsp; &nbsp;free &nbsp; &nbsp; &nbsp;shared &nbsp;buff/cache =
&nbsp; available</div><div class=3D"">Mem: &nbsp; &nbsp; &nbsp; &nbsp; =
&nbsp;64269 &nbsp; &nbsp; &nbsp; 50357 &nbsp; &nbsp; &nbsp; 11802 &nbsp; =
&nbsp; &nbsp; &nbsp; &nbsp;65 &nbsp; &nbsp; &nbsp; &nbsp;2109 &nbsp; =
&nbsp; &nbsp; 11757</div><div class=3D"">Swap: &nbsp; &nbsp; &nbsp; =
&nbsp; 32255 &nbsp; &nbsp; &nbsp; &nbsp; 347 &nbsp; &nbsp; &nbsp; =
31908</div></div><div class=3D""><br class=3D""></div><div class=3D"">This=
 machine is running for qemu, &nbsp;the file is qemu qcow file =
type</div><div class=3D""><br class=3D""></div><div class=3D""><div =
class=3D"">[root@w-openstack20 =
/data/nova/instances/7898b630-c4ef-49ab-9ce9-3735e090c282]# file =
disk</div><div class=3D"">disk: QEMU QCOW Image (v3), has backing file =
(path /data/nova/instances/_base/3f27393376152ac352b2d85703011e38517e), =
429496729600 bytes</div></div><div class=3D""><br class=3D""></div><div =
class=3D"">we also use xfs_db to check the fragmentation</div><div =
class=3D""><br class=3D""></div><div class=3D""><div =
class=3D"">[root@w-openstack20 /home/xusiliang]# xfs_db -r =
/dev/mapper/VolGroup00-LogVol04</div><div class=3D"">xfs_db&gt; =
frag</div><div class=3D""><br class=3D""></div><div class=3D"">actual =
48421430, ideal 20716, fragmentation factor 99.96%</div></div><div =
class=3D""><br class=3D""></div><div class=3D""><br class=3D""></div><div =
class=3D"">How can I solve this problem, what do you suggest me to =
do?</div><div class=3D""><br class=3D""></div><div class=3D"">thank =
you</div><div class=3D""><br class=3D""></div><div class=3D""><br =
class=3D""><div class=3D"">
<div style=3D"color: rgb(0, 0, 0); letter-spacing: normal; orphans: =
auto; text-align: start; text-indent: 0px; text-transform: none; =
white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div style=3D"color: rgb(0, 0, 0); letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div style=3D"color: rgb(0, 0, 0); letter-spacing: normal; =
orphans: auto; text-align: start; text-indent: 0px; text-transform: =
none; white-space: normal; widows: auto; word-spacing: 0px; =
-webkit-text-stroke-width: 0px; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space;" =
class=3D""><div style=3D"orphans: auto; text-align: start; text-indent: =
0px; widows: auto; word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space;" class=3D""><div style=3D"color: =
rgb(0, 0, 0); letter-spacing: normal; text-transform: none; white-space: =
normal; word-spacing: 0px; -webkit-text-stroke-width: 0px; orphans: =
auto; text-align: start; text-indent: 0px; widows: auto; word-wrap: =
break-word; -webkit-nbsp-mode: space; -webkit-line-break: =
after-white-space; font-size: 20px;" =
class=3D"">----------------------------------------<br =
class=3D"">&nbsp;</div><div style=3D"orphans: auto; text-align: start; =
text-indent: 0px; widows: auto; word-wrap: break-word; =
-webkit-nbsp-mode: space; -webkit-line-break: after-white-space; =
font-size: 20px;" class=3D"">Github:&nbsp;<a =
href=3D"https://github.com/baotiao" =
class=3D"">https://github.com/baotiao</a><br class=3D"">Blog: <a =
href=3D"http://baotiao.github.io" =
class=3D"">http://baotiao.github.io</a><br class=3D"">Stackoverflow: <a =
href=3D"http://stackoverflow.com/users/634415/baotiao" =
class=3D"">http://stackoverflow.com/users/634415/baotiao</a>&nbsp;</div><d=
iv style=3D"orphans: auto; text-align: start; text-indent: 0px; widows: =
auto; word-wrap: break-word; -webkit-nbsp-mode: space; =
-webkit-line-break: after-white-space; font-size: 20px;" =
class=3D"">Linkedin: <a =
href=3D"http://www.linkedin.com/profile/view?id=3D145231990" =
class=3D"">http://www.linkedin.com/profile/view?id=3D145231990</a></div></=
div></div></div></div>
</div>
<br class=3D""></div></body></html>=

--Apple-Mail=_CF74D2CB-62D5-475C-ACB9-592B65E5E97B--


--===============5505445922209900009==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5505445922209900009==--
