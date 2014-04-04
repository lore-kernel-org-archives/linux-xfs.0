Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2A11E7FDA
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 13:15:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0F3BD8F8054
	for <xfs@oss.sgi.com>; Fri,  4 Apr 2014 11:15:25 -0700 (PDT)
Received: from mail-vc0-f169.google.com (mail-vc0-f169.google.com
	[209.85.220.169]) by cuda.sgi.com with ESMTP id
	AisVtTE6qQrJnW6Z (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Apr 2014 11:15:24 -0700 (PDT)
Received: by mail-vc0-f169.google.com with SMTP id ik5so3523362vcb.28
	for <xfs@oss.sgi.com>; Fri, 04 Apr 2014 11:15:23 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 4 Apr 2014 12:15:23 -0600
Message-ID: <CALjwKZAJ-R8dS13Rsj3+K3hM9p0z08qvi4ZVTYbDWKT1Biu=-Q@mail.gmail.com>
Subject: xfs umount with i/o error hang/memory corruption
From: Bob Mastors <bob.mastors@solidfire.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7415202437080686219=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7415202437080686219==
Content-Type: multipart/alternative; boundary=001a11c20232530cc004f63b809f

--001a11c20232530cc004f63b809f
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Greetings,

I am new to xfs and am running into a problem
and would appreciate any guidance on how to proceed.

After an i/o error from the block device that xfs is using,
an umount results in a message like:
[  370.636473] XFS (sdx): Log I/O Error Detected.  Shutting down filesystem
[  370.644073] XFS (h           =EF=BF=BD=EF=BF=BD=EF=BF=BDh"h          =EF=
=BF=BD=EF=BF=BD=EF=BF=BDH#h          =EF=BF=BD=EF=BF=BD=EF=BF=BDbsg):
Please umount the filesystem and rectify the problem(s)
Note the garbage on the previous line which suggests memory corruption.
About half the time I get the garbled log message. About half the time
umount hangs.

And then I get this kind of error and the system is unresponsive:
Message from syslogd@debian at Apr  4 09:27:40 ...
 kernel:[  680.080022] BUG: soft lockup - CPU#2 stuck for 22s! [umount:2849=
]

The problem appears to be similar to this issue:
http://www.spinics.net/lists/linux-xfs/msg00061.html

I can reproduce the problem easily using open-iscsi to create
the block device with an iscsi initiator.
I use lio to create an iscsi target.

The problem is triggered by doing an iscsi logout which causes
the block device to return i/o errors to xfs.
Steps to reproduce the problem are below.

Using VirtualBox, I can reproduce it with two processors but not one.
I first saw this on a 3.8 kernel and most recently reproduced it with 3.14+=
.

Thanks,
Bob

virtual box setup
-----------------
1 GB ram
8 GB disk
2 processors
Operating System: Linux
Version: Debian (64 bit)
Bridged networking
iso: debian-7.4.0-amd64-netinst.iso
Software selection
    select SSH server
    select Standard system utilities
    deselect everything else

dhcp ip address: 172.17.5.129

upgrade linux to 3.14.0+
------------------------
ssh 172.17.5.129
su
cd /mnt/ksrc/linux
make modules_install
make install
reboot

install tools
-------------
ssh 172.17.5.129
su
apt-get install xfsprogs
apt-get install open-iscsi
apt-get install --no-install-recommends targetcli python-urwid
reboot

reproduce bug
-------------
ssh 172.17.5.129
su
targetcli
    cd backstores
    fileio/ create name=3Dfile_backend file_or_dev=3Dmy_disk size=3D100M
    /iscsi create
    portals/ create 172.17.5.129
    cd <
    luns/ create /backstores/fileio/file_backend
    cd <
    set attribute authentication=3D0 demo_mode_write_protect=3D0
generate_node_acls=3D1 cache_dynamic_acls=3D1
    exit

iscsiadm -m discovery -t sendtargets -p 172.17.5.129
iscsiadm -m node --login --target iqn.from_previous_iscsiadm_cmd_output
fdisk -l
mkfs -t xfs -f /dev/sdXX
mkdir /mnt/vola
mount -t xfs /dev/sdXX /mnt/vola
iscsiadm -m node -U all
umount /mnt/vola

--001a11c20232530cc004f63b809f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Greetings,</div><div><br></div><div>I am new to xfs a=
nd am running into a problem</div><div>and would appreciate any guidance on=
 how to proceed.</div><div><br></div><div>After an i/o error from the block=
 device that xfs is using,</div>
<div>an umount results in a message like:</div><div>[ =C2=A0370.636473] XFS=
 (sdx): Log I/O Error Detected. =C2=A0Shutting down filesystem</div><div>[ =
=C2=A0370.644073] XFS (h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =EF=BF=BD=EF=BF=
=BD=EF=BF=BDh&quot;h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=EF=BF=BD=EF=BF=BD=
=EF=BF=BDH#h =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=EF=BF=BD=EF=BF=BD=EF=BF=BDb=
sg): Please umount the filesystem and rectify the problem(s)</div>
<div>Note the garbage on the previous line which suggests memory corruption=
.</div><div>About half the time I get the garbled log message. About half t=
he time umount hangs.</div><div><br></div><div>And then I get this kind of =
error and the system is unresponsive:</div>
<div>Message from syslogd@debian at Apr =C2=A04 09:27:40 ...</div><div>=C2=
=A0kernel:[ =C2=A0680.080022] BUG: soft lockup - CPU#2 stuck for 22s! [umou=
nt:2849]</div><div><br></div><div>The problem appears to be similar to this=
 issue:</div>
<div><a href=3D"http://www.spinics.net/lists/linux-xfs/msg00061.html">http:=
//www.spinics.net/lists/linux-xfs/msg00061.html</a></div><div><br></div><di=
v>I can reproduce the problem easily using open-iscsi to create</div><div>
the block device with an iscsi initiator.</div><div>I use lio to create an =
iscsi target.</div><div><br></div><div>The problem is triggered by doing an=
 iscsi logout which causes</div><div>the block device to return i/o errors =
to xfs.</div>
<div>Steps to reproduce the problem are below.</div><div><br></div><div>Usi=
ng VirtualBox, I can reproduce it with two processors but not one.</div><di=
v>I first saw this on a 3.8 kernel and most recently reproduced it with 3.1=
4+.</div>
<div><br></div><div>Thanks,</div><div>Bob</div><div><br></div><div><div>vir=
tual box setup</div><div>-----------------</div><div>1 GB ram</div><div>8 G=
B disk</div><div>2 processors</div><div>Operating System: Linux</div><div>
Version: Debian (64 bit)</div><div>Bridged networking</div><div>iso: debian=
-7.4.0-amd64-netinst.iso</div><div>Software selection</div><div>=C2=A0 =C2=
=A0 select SSH server</div><div>=C2=A0 =C2=A0 select Standard system utilit=
ies</div><div>=C2=A0 =C2=A0 deselect everything else</div>
<div>=C2=A0 =C2=A0=C2=A0</div><div>dhcp ip address: 172.17.5.129</div><div>=
<br></div><div>upgrade linux to 3.14.0+</div><div>------------------------<=
/div><div>ssh 172.17.5.129</div><div>su</div><div>cd /mnt/ksrc/linux</div><=
div>make modules_install</div>
<div>make install</div><div>reboot</div><div><br></div><div>install tools</=
div><div>-------------</div><div>ssh 172.17.5.129</div><div>su</div><div>ap=
t-get install xfsprogs</div><div>apt-get install open-iscsi</div><div>apt-g=
et install --no-install-recommends targetcli python-urwid</div>
<div>reboot</div><div><br></div><div>reproduce bug</div><div>-------------<=
/div><div>ssh 172.17.5.129</div><div>su</div><div>targetcli</div><div>=C2=
=A0 =C2=A0 cd backstores</div><div>=C2=A0 =C2=A0 fileio/ create name=3Dfile=
_backend file_or_dev=3Dmy_disk size=3D100M</div>
<div>=C2=A0 =C2=A0 /iscsi create</div><div>=C2=A0 =C2=A0 portals/ create 17=
2.17.5.129</div><div>=C2=A0 =C2=A0 cd &lt;</div><div>=C2=A0 =C2=A0 luns/ cr=
eate /backstores/fileio/file_backend</div><div>=C2=A0 =C2=A0 cd &lt;</div><=
div>=C2=A0 =C2=A0 set attribute authentication=3D0 demo_mode_write_protect=
=3D0 generate_node_acls=3D1 cache_dynamic_acls=3D1</div>
<div>=C2=A0 =C2=A0 exit</div><div><br></div><div>iscsiadm -m discovery -t s=
endtargets -p 172.17.5.129</div><div>iscsiadm -m node --login --target iqn.=
from_previous_iscsiadm_cmd_output</div><div>fdisk -l</div><div>mkfs -t xfs =
-f /dev/sdXX</div>
<div>mkdir /mnt/vola</div><div>mount -t xfs /dev/sdXX /mnt/vola</div><div>i=
scsiadm -m node -U all</div><div>umount /mnt/vola</div></div></div>

--001a11c20232530cc004f63b809f--


--===============7415202437080686219==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7415202437080686219==--
