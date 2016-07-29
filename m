Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 54D9B7CA0
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 04:01:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 287B0304053
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 02:01:46 -0700 (PDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com
	[74.125.82.54]) by cuda.sgi.com with ESMTP id Kg9HhLLf6Ae8TtRR
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 29 Jul 2016 02:01:42 -0700 (PDT)
Received: by mail-wm0-f54.google.com with SMTP id o80so142120678wme.1
	for <xfs@oss.sgi.com>; Fri, 29 Jul 2016 02:01:42 -0700 (PDT)
Received: from dinulap (dev155.demoshop.ro. [5.2.129.155])
	by smtp.gmail.com with ESMTPSA id c16sm2011272wme.4.2016.07.29.02.01.39
	for <xfs@oss.sgi.com>
	(version=TLS1 cipher=DES-CBC3-SHA bits=112/168);
	Fri, 29 Jul 2016 02:01:39 -0700 (PDT)
Message-ID: <4278AB9734C1445A8E48635B155149F8@dinulap>
From: "Lista Unx" <lista.unx@gmail.com>
Subject: partition 100% full No space left on device. looks like xfs is
	corrupted or a bug
Date: Fri, 29 Jul 2016 12:01:42 +0300
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============8290931057717771753=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.

--===============8290931057717771753==
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_012F_01D1E990.F885B650"

This is a multi-part message in MIME format.

------=_NextPart_000_012F_01D1E990.F885B650
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hello xfs experts,

I am crawling in the dark from few days and I have no idea how to fix =
the following problem. On a centos 7 system:

# uname -a
Linux 1a 3.10.0-327.el7.x86_64 #1 SMP Thu Nov 19 22:10:57 UTC 2015 =
x86_64 x86_64 x86_64 GNU/Linux

df is reporting 100% full of / and du is reporting only 1.7G usage from =
50GB available (less than 4%). I want to mention that / is xfs. See =
below:

# df -a|grep ^/
/dev/mapper/centos-root  52403200 52400396      2804 100% /
                                     ^^^^^^^^^^   ^^^^^^^^^^
/dev/sda1                  503040   131876    371164  27% /boot
/dev/mapper/centos-home 210529792    35204 210494588   1% /home

du is estimating just 1.7G usage of /
# du -sch /* --exclude=3Dhome --exclude=3Dboot
0       /bin
0       /dev
25M     /etc
0       /lib
0       /lib64
744K    /luarocks-2.3.0
0       /media
0       /mnt
125M    /openresty-1.9.7.4
0       /opt
420K    /root
49M     /run
0       /sbin
0       /srv
0       /sys
0       /tmp
1.3G    /usr
227M    /var
1.7G    total
[root@localhost ~]#

df is also reporting 80% of inode usage:

# df -i
Filesystem                 Inodes IUsed     IFree IUse% Mounted on
/dev/mapper/centos-root     78160 66218     11942   85% /
                                       ^^^^^^^^
devtmpfs                  8218272   519   8217753    1% /dev
tmpfs                     8221010     1   8221009    1% /dev/shm
tmpfs                     8221010   648   8220362    1% /run
tmpfs                     8221010    13   8220997    1% /sys/fs/cgroup
/dev/sda1                  509952   330    509622    1% /boot
/dev/mapper/centos-home 210632704    99 210632605    1% /home
tmpfs                     8221010     1   8221009    1% /run/user/0
#

/ partition is created on top of a LVM having also 50GB size.

# lvdisplay /dev/centos/root
  --- Logical volume ---
  LV Path                /dev/centos/root
  LV Name                root
  VG Name                centos

  LV Status              available
  # open                 1
  LV Size                50.00 GiB
  Current LE             12800
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0

I've already checked against rootkit without finding anything wrong!

I have another system, identical with this one which is healthy. The =
only difference I found between those systems is regarding max number of =
inodes available on / (which has the same size, 50GB on booth servers). =
On the second one (healthy), max number of inodes are ~52 milions and =
not only just ~85.000 as are reported on "seek" server.

# df -i|grep ^/
/dev/mapper/centos-root  52424704 66137  52358567    1% /
                                   ^^^^^^^^^^^^^
/dev/sda1                                  509952   330    509622    1% =
/boot
/dev/mapper/centos-home 210632704    26 210632678    1% /home
[root@localhost ~]#

Suspected also large number of files on /. Counted total number of files =
and or booth servers are the same: ~180K. So no difference here.

Look to find also files larger than 100M and on booth servers and found =
just 1 (104M size):

find / -type f -size +100000k -exec ls -lh {} \;
#
/usr/lib/locale/locale-archive
#

Looking to find files larger than 10M, I found just ~20 on booth =
servers.

# find / -type f -size +10000k -exec ls -lh {} \; |wc -l
16
#

So for sure, there are NO files exhausting free space.

On booth servers, number of used inodes are identical: ~66K. Also =
xfs_info report is identical for booth. What is different is number of =
AVAILABLE inodes: 85K (on seek node) vs 52 milion (on healthy node)!!! =
How is possible that!!! Booth servers has the same size (50GB) for /!

#lsof -nP |grep -i delete|wc -l
0
#find /proc/*/fd -ls | grep -i dele|wc -l
0

so lsof and find does not report anything wrong (any file deleted and =
still open)!

reboot does not fix the problem, / remain 100% full

After reboot, on 25th July:

# df -ah|grep centos-root
/dev/mapper/centos-root   50G   50G  4.0M 100% /
#

Also max number of inodes =3D 67k:
# df -i
Filesystem                 Inodes IUsed     IFree IUse% Mounted on
/dev/mapper/centos-root     66960 66165       795   99% /
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
devtmpfs                  8218272   519   8217753    1% /dev
tmpfs                     8221010     1   8221009    1% /dev/shm
tmpfs                     8221010   630   8220380    1% /run
tmpfs                     8221010    13   8220997    1% /sys/fs/cgroup
/dev/sda1                  509952   330    509622    1% /boot
/dev/mapper/centos-home 210632704    28 210632676    1% /home
tmpfs                     8221010     1   8221009    1% /run/user/0
#

Lets try to run intentionally xfs_grow (which normally should not =
produce any change)

# xfs_growfs /dev/mapper/centos-root
meta-data=3D/dev/mapper/centos-root isize=3D256    agcount=3D16, =
agsize=3D819136 blks
         =3D                       sectsz=3D512   attr=3D2, =
projid32bit=3D1
         =3D                       crc=3D0        finobt=3D0
data     =3D                       bsize=3D4096   blocks=3D13106176, =
imaxpct=3D25
         =3D                       sunit=3D64     swidth=3D64 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D0
log      =3Dinternal               bsize=3D4096   blocks=3D6400, =
version=3D2
         =3D                       sectsz=3D512   sunit=3D64 blks, =
lazy-count=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, =
rtextents=3D0
data blocks changed from 13106176 to 13107200
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#

Partition remain the same, 50GB size:
[root@nl-hvs-ov001a ~]# df -ah|grep centos-root
/dev/mapper/centos-root   50G   50G  4.0M 100% /

But number of inodes INCREASED with more tha 20%!!!
# df -i
Filesystem                 Inodes IUsed     IFree IUse% Mounted on
/dev/mapper/centos-root     83200 66165     17035   80% /
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
devtmpfs                  8218272   519   8217753    1% /dev
tmpfs                     8221010     1   8221009    1% /dev/shm
tmpfs                     8221010   630   8220380    1% /run
tmpfs                     8221010    13   8220997    1% /sys/fs/cgroup
/dev/sda1                  509952   330    509622    1% /boot
/dev/mapper/centos-home 210632704    28 210632676    1% /home
tmpfs                     8221010     1   8221009    1% /run/user/0
#

On 27July without changing anything there, max number inodes available =
for / decreased to ~67k (the same size like 2 days ago, before =
xfs_grow)!

# df -i
Filesystem                 Inodes IUsed     IFree IUse% Mounted on
/dev/mapper/centos-root     67024 66225       799   99% /
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
devtmpfs                  8218272   519   8217753    1% /dev
tmpfs                     8221010     1   8221009    1% /dev/shm
tmpfs                     8221010   632   8220378    1% /run
tmpfs                     8221010    13   8220997    1% /sys/fs/cgroup
/dev/mapper/centos-home 210632704    99 210632605    1% /home
/dev/sda1                  509952   330    509622    1% /boot
tmpfs                     8221010     1   8221009    1% /run/user/0
#

Please note that all that time, number of files remain unchanged ~180K, =
the same for inodes used, the number remain constant ~66K. Just max =
number of inodes available decreased which is an abnormal behavior.

How can be fixed? Looks like xfs is crrupted or like a bug.

Thanks in advance for help.
Alex

------=_NextPart_000_012F_01D1E990.F885B650
Content-Type: text/html;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META content=3D"text/html; charset=3Diso-8859-1" =
http-equiv=3DContent-Type>
<META name=3DGENERATOR content=3D"MSHTML 8.00.6001.23588">
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT size=3D2 face=3DArial>
<DIV><FONT size=3D2 face=3DArial>Hello xfs experts,</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>I am crawling in the dark from few days =
and I have=20
no idea how to fix the following problem. On a centos 7 =
system:</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial># uname -a<BR>Linux 1a =
3.10.0-327.el7.x86_64 #1 SMP=20
Thu Nov 19 22:10:57 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>df is reporting 100% full of / and du =
is reporting=20
only 1.7G usage from 50GB available (less than 4%). I want to mention =
that / is=20
xfs. See below:</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial># df -a|grep =
^/<BR>/dev/mapper/centos-root&nbsp;=20
52403200 52400396&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 2804 100%=20
/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;=20
^^^^^^^^^^&nbsp;&nbsp;=20
^^^^^^^^^^<BR>/dev/sda1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
503040&nbsp;&nbsp; 131876&nbsp;&nbsp;&nbsp; 371164&nbsp; 27%=20
/boot<BR>/dev/mapper/centos-home 210529792&nbsp;&nbsp;&nbsp; 35204=20
210494588&nbsp;&nbsp; 1% /home</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>du is estimating just 1.7G usage of =
/<BR># du -sch=20
/* --exclude=3Dhome =
--exclude=3Dboot<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/bin<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/dev<BR>25M&nbsp;&nbsp;&nbsp;&nbsp;=20
/etc<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/lib<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
/lib64<BR>744K&nbsp;&nbsp;&nbsp;=20
/luarocks-2.3.0<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/media<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
/mnt<BR>125M&nbsp;&nbsp;&nbsp;=20
/openresty-1.9.7.4<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/opt<BR>420K&nbsp;&nbsp;&nbsp; /root<BR>49M&nbsp;&nbsp;&nbsp;&nbsp;=20
/run<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/sbin<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/srv<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
/sys<BR>0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; =
/tmp<BR>1.3G&nbsp;&nbsp;&nbsp;=20
/usr<BR>227M&nbsp;&nbsp;&nbsp; /var<BR>1.7G&nbsp;&nbsp;&nbsp;=20
total<BR>[root@localhost ~]#</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>df is also reporting 80% of inode=20
usage:</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial># df=20
-i<BR>Filesystem&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
Inodes IUsed&nbsp;&nbsp;&nbsp;&nbsp; IFree IUse% Mounted=20
on<BR>/dev/mapper/centos-root&nbsp;&nbsp;&nbsp;&nbsp; 78160=20
66218&nbsp;&nbsp;&nbsp;&nbsp; 11942&nbsp;&nbsp; 85%=20
/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;=20
^^^^^^^^<BR>devtmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8218272&nbsp;&nbsp; 519&nbsp;&nbsp; 8217753&nbsp;&nbsp;&nbsp; 1%=20
/dev<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 8221009&nbsp;&nbsp;&nbsp; =
1%=20
/dev/shm<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp; 648&nbsp;&nbsp; 8220362&nbsp;&nbsp;&nbsp; 1%=20
/run<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp; 13&nbsp;&nbsp; 8220997&nbsp;&nbsp;&nbsp; 1%=20
/sys/fs/cgroup<BR>/dev/sda1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
509952&nbsp;&nbsp; 330&nbsp;&nbsp;&nbsp; 509622&nbsp;&nbsp;&nbsp; 1%=20
/boot<BR>/dev/mapper/centos-home 210632704&nbsp;&nbsp;&nbsp; 99=20
210632605&nbsp;&nbsp;&nbsp; 1%=20
/home<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 8221009&nbsp;&nbsp;&nbsp; =
1%=20
/run/user/0<BR>#</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>/ partition is created on top of a LVM =
having also=20
50GB size.</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial># lvdisplay /dev/centos/root<BR>&nbsp; =
--- Logical=20
volume ---<BR>&nbsp; LV=20
Path&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=20
/dev/centos/root<BR>&nbsp; LV=20
Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=20
root<BR>&nbsp; VG=20
Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=20
centos</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>&nbsp; LV=20
Status&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;=20
available<BR>&nbsp; #=20
open&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;=20
1<BR>&nbsp; LV=20
Size&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;=20
50.00 GiB<BR>&nbsp; Current=20
LE&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;=20
12800<BR>&nbsp;=20
Segments&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;=20
1<BR>&nbsp;=20
Allocation&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;=20
inherit<BR>&nbsp; Read ahead sectors&nbsp;&nbsp;&nbsp;&nbsp; =
auto<BR>&nbsp; -=20
currently set to&nbsp;&nbsp;&nbsp;&nbsp; 256<BR>&nbsp; Block=20
device&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
253:0</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>I've already checked against rootkit =
without=20
finding anything wrong!</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>I have another system, identical with =
this one=20
which is healthy. The only difference I found between those systems is =
regarding=20
max number of inodes available on / (which has the same size, 50GB on =
booth=20
servers). On the second one (healthy), max number of inodes are ~52 =
milions and=20
not only just ~85.000 as are reported on "seek" server.</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial># df -i|grep =
^/<BR>/dev/mapper/centos-root&nbsp;=20
52424704 66137&nbsp; 52358567&nbsp;&nbsp;&nbsp; 1%=20
/<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
^^^^^^^^^^^^^<BR>/dev/sda1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;=20
509952&nbsp;&nbsp; 330&nbsp;&nbsp;&nbsp; 509622&nbsp;&nbsp;&nbsp; 1%=20
/boot<BR>/dev/mapper/centos-home 210632704&nbsp;&nbsp;&nbsp; 26=20
210632678&nbsp;&nbsp;&nbsp; 1% /home<BR>[root@localhost ~]#</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>Suspected also large number of files on =
/. Counted=20
total number of files and or booth servers are the same: ~180K. So no =
difference=20
here.</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>Look to find also files larger than =
100M and on=20
booth servers and found just 1 (104M size):</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>find / -type f -size +100000k -exec ls =
-lh {}=20
\;<BR>#<BR>/usr/lib/locale/locale-archive<BR>#</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>Looking to find files larger than 10M, =
I found just=20
~20 on booth servers.</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial># find / -type f -size +10000k -exec ls =
-lh {} \;=20
|wc -l<BR>16<BR>#</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>So for sure, there are NO files =
exhausting free=20
space.</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>On booth servers, number of used inodes =
are=20
identical: ~66K. Also xfs_info report is identical for booth. What is =
different=20
is number of AVAILABLE inodes: 85K (on seek node) vs 52 milion (on =
healthy=20
node)!!! How is possible that!!! Booth servers has the same size (50GB) =
for=20
/!</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>#lsof -nP |grep -i delete|wc =
-l<BR>0<BR>#find=20
/proc/*/fd -ls | grep -i dele|wc -l<BR>0</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>so lsof and find does not report =
anything wrong=20
(any file deleted and still open)!</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>reboot does not fix the problem, / =
remain 100%=20
full</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>After reboot, on 25th =
July:</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial># df -ah|grep=20
centos-root<BR>/dev/mapper/centos-root&nbsp;&nbsp; 50G&nbsp;&nbsp; =
50G&nbsp;=20
4.0M 100% /<BR>#</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>Also max number of inodes =3D 67k:<BR># =
df=20
-i<BR>Filesystem&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
Inodes IUsed&nbsp;&nbsp;&nbsp;&nbsp; IFree IUse% Mounted=20
on<BR>/dev/mapper/centos-root&nbsp;&nbsp;&nbsp;&nbsp; 66960=20
66165&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 795&nbsp;&nbsp; 99%=20
/<BR>^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^<BR>devtmpfs=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8218272&nbsp;&nbsp; 519&nbsp;&nbsp; 8217753&nbsp;&nbsp;&nbsp; 1%=20
/dev<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 8221009&nbsp;&nbsp;&nbsp; =
1%=20
/dev/shm<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp; 630&nbsp;&nbsp; 8220380&nbsp;&nbsp;&nbsp; 1%=20
/run<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp; 13&nbsp;&nbsp; 8220997&nbsp;&nbsp;&nbsp; 1%=20
/sys/fs/cgroup<BR>/dev/sda1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
509952&nbsp;&nbsp; 330&nbsp;&nbsp;&nbsp; 509622&nbsp;&nbsp;&nbsp; 1%=20
/boot<BR>/dev/mapper/centos-home 210632704&nbsp;&nbsp;&nbsp; 28=20
210632676&nbsp;&nbsp;&nbsp; 1%=20
/home<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 8221009&nbsp;&nbsp;&nbsp; =
1%=20
/run/user/0<BR>#</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>Lets try to run intentionally xfs_grow =
(which=20
normally should not produce any change)</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial># xfs_growfs=20
/dev/mapper/centos-root<BR>meta-data=3D/dev/mapper/centos-root=20
isize=3D256&nbsp;&nbsp;&nbsp; agcount=3D16, agsize=3D819136=20
blks<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
sectsz=3D512&nbsp;&nbsp; attr=3D2,=20
projid32bit=3D1<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
crc=3D0&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
finobt=3D0<BR>data&nbsp;&nbsp;&nbsp;&nbsp;=20
=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
bsize=3D4096&nbsp;&nbsp; blocks=3D13106176,=20
imaxpct=3D25<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
sunit=3D64&nbsp;&nbsp;&nbsp;&nbsp; swidth=3D64 =
blks<BR>naming&nbsp;&nbsp; =3Dversion=20
2&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;=20
bsize=3D4096&nbsp;&nbsp; ascii-ci=3D0 =
ftype=3D0<BR>log&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
=3Dinternal&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;=20
bsize=3D4096&nbsp;&nbsp; blocks=3D6400,=20
version=3D2<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
=3D&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
sectsz=3D512&nbsp;&nbsp; sunit=3D64 blks, lazy-count=3D1<BR>realtime=20
=3Dnone&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
extsz=3D4096&nbsp;&nbsp; blocks=3D0, rtextents=3D0<BR>data blocks =
changed from=20
13106176 to=20
13107200<BR>^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^<BR>#</FONT></DI=
V>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>Partition remain the same, 50GB=20
size:<BR>[root@nl-hvs-ov001a ~]# df -ah|grep=20
centos-root<BR>/dev/mapper/centos-root&nbsp;&nbsp; 50G&nbsp;&nbsp; =
50G&nbsp;=20
4.0M 100% /</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>But number of inodes INCREASED with =
more tha=20
20%!!!<BR># df=20
-i<BR>Filesystem&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
Inodes IUsed&nbsp;&nbsp;&nbsp;&nbsp; IFree IUse% Mounted=20
on<BR>/dev/mapper/centos-root&nbsp;&nbsp;&nbsp;&nbsp; 83200=20
66165&nbsp;&nbsp;&nbsp;&nbsp; 17035&nbsp;&nbsp; 80%=20
/<BR>^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^<BR>devtmpf=
s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8218272&nbsp;&nbsp; 519&nbsp;&nbsp; 8217753&nbsp;&nbsp;&nbsp; 1%=20
/dev<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 8221009&nbsp;&nbsp;&nbsp; =
1%=20
/dev/shm<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp; 630&nbsp;&nbsp; 8220380&nbsp;&nbsp;&nbsp; 1%=20
/run<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp; 13&nbsp;&nbsp; 8220997&nbsp;&nbsp;&nbsp; 1%=20
/sys/fs/cgroup<BR>/dev/sda1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
509952&nbsp;&nbsp; 330&nbsp;&nbsp;&nbsp; 509622&nbsp;&nbsp;&nbsp; 1%=20
/boot<BR>/dev/mapper/centos-home 210632704&nbsp;&nbsp;&nbsp; 28=20
210632676&nbsp;&nbsp;&nbsp; 1%=20
/home<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 8221009&nbsp;&nbsp;&nbsp; =
1%=20
/run/user/0<BR>#</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>On 27July without changing anything =
there, max=20
number inodes available for / decreased to ~67k (the same size like 2 =
days ago,=20
before xfs_grow)!</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial># df=20
-i<BR>Filesystem&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
Inodes IUsed&nbsp;&nbsp;&nbsp;&nbsp; IFree IUse% Mounted=20
on<BR>/dev/mapper/centos-root&nbsp;&nbsp;&nbsp;&nbsp; 67024=20
66225&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 799&nbsp;&nbsp; 99%=20
/<BR>^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^<BR>devtmpf=
s&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8218272&nbsp;&nbsp; 519&nbsp;&nbsp; 8217753&nbsp;&nbsp;&nbsp; 1%=20
/dev<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 8221009&nbsp;&nbsp;&nbsp; =
1%=20
/dev/shm<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp; 632&nbsp;&nbsp; 8220378&nbsp;&nbsp;&nbsp; 1%=20
/run<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp; 13&nbsp;&nbsp; 8220997&nbsp;&nbsp;&nbsp; 1%=20
/sys/fs/cgroup<BR>/dev/mapper/centos-home 210632704&nbsp;&nbsp;&nbsp; 99 =

210632605&nbsp;&nbsp;&nbsp; 1%=20
/home<BR>/dev/sda1&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
509952&nbsp;&nbsp; 330&nbsp;&nbsp;&nbsp; 509622&nbsp;&nbsp;&nbsp; 1%=20
/boot<BR>tmpfs&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp=
;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=20
8221010&nbsp;&nbsp;&nbsp;&nbsp; 1&nbsp;&nbsp; 8221009&nbsp;&nbsp;&nbsp; =
1%=20
/run/user/0<BR>#</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>Please note that all that time, number =
of files=20
remain unchanged ~180K, the same for inodes used, the number remain =
constant=20
~66K. Just max number of inodes available decreased which is an abnormal =

behavior.</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>How can be fixed?&nbsp;Looks like xfs =
is crrupted=20
or like a bug.</FONT></DIV>
<DIV><FONT size=3D2 face=3DArial></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2 face=3DArial>Thanks in advance for =
help.<BR>Alex</FONT></DIV>
<DIV><FONT size=3D2 =
face=3DArial></FONT>&nbsp;</DIV></FONT></DIV></BODY></HTML>

------=_NextPart_000_012F_01D1E990.F885B650--


--===============8290931057717771753==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============8290931057717771753==--
