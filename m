Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7FFE329DF8
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 17:29:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 538108F8040
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 15:29:10 -0700 (PDT)
Received: from mail-ve0-f173.google.com (mail-ve0-f173.google.com
	[209.85.128.173]) by cuda.sgi.com with ESMTP id
	gFqsZeHh4nbpxxBg (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 28 Apr 2014 15:29:03 -0700 (PDT)
Received: by mail-ve0-f173.google.com with SMTP id oy12so8783774veb.18
	for <xfs@oss.sgi.com>; Mon, 28 Apr 2014 15:29:02 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 28 Apr 2014 16:29:02 -0600
Message-ID: <CALjwKZDsGBxTDLvy7-W76FRpHRuki_ZjOXLWZ70fut4hmDkTSQ@mail.gmail.com>
Subject: xfs umount hang in xfs_ail_push_all_sync on i/o error
From: Bob Mastors <bob.mastors@solidfire.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7425346111187870488=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============7425346111187870488==
Content-Type: multipart/alternative; boundary=047d7bacbedca64ec404f821d726

--047d7bacbedca64ec404f821d726
Content-Type: text/plain; charset=ISO-8859-1

Greetings,

I have an xfs umount hang caused by forcing the block device to return
i/o errors while copying files to the filesystem.
Detailed steps to reproduce the problem on virtualbox are below.

The linux version is a recent pull and reports as 3.15.0-rc3.

[ 2040.248096] INFO: task umount:10303 blocked for more than 120 seconds.
[ 2040.323947]       Not tainted 3.15.0-rc3 #4
[ 2040.343423] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[ 2040.352665] umount          D ffffffff8180fe40     0 10303   8691
0x00000000
[ 2040.404918]  ffff88001e33dd58 0000000000000086 ffff88001e33dd48
ffffffff81080f82
[ 2040.489901]  ffff88001b311900 0000000000013180 ffff88001e33dfd8
0000000000013180
[ 2040.534772]  ffff88003daa3200 ffff88001b311900 ffff88002421aec0
ffff88002421ae80
[ 2040.587450] Call Trace:
[ 2040.592176]  [<ffffffff81080f82>] ? try_to_wake_up+0x232/0x2b0
[ 2040.620212]  [<ffffffff816c54d9>] schedule+0x29/0x70
[ 2040.627685]  [<ffffffffa04c4cd6>] xfs_ail_push_all_sync+0x96/0xd0 [xfs]
[ 2040.632236]  [<ffffffff81092230>] ? __wake_up_sync+0x20/0x20
[ 2040.659105]  [<ffffffffa04731a3>] xfs_unmountfs+0x63/0x160 [xfs]
[ 2040.691774]  [<ffffffffa0478f65>] ? kmem_free+0x35/0x40 [xfs]
[ 2040.698610]  [<ffffffffa0474cf5>] xfs_fs_put_super+0x25/0x60 [xfs]
[ 2040.706838]  [<ffffffff8119561e>] generic_shutdown_super+0x7e/0x100
[ 2040.723958]  [<ffffffff811956d0>] kill_block_super+0x30/0x80
[ 2040.734963]  [<ffffffff8119591d>] deactivate_locked_super+0x4d/0x80
[ 2040.745485]  [<ffffffff8119652e>] deactivate_super+0x4e/0x70
[ 2040.751274]  [<ffffffff811b1d42>] mntput_no_expire+0xd2/0x160
[ 2040.755894]  [<ffffffff811b2fff>] SyS_umount+0xaf/0x3b0
[ 2040.761032]  [<ffffffff816d1592>] system_call_fastpath+0x16/0x1b
[ .060058] XFS (sdb): xfs_log_force: error 5 returned.
[ 268059] XFS (sdb): xfs_log_force: error 5 returned.

I took a look at xfs_ail_push_all_sync and it is pretty easy to see
the hang. But it is not obvious to me how to fix it.
Any ideas would be appreciated.

I am available to run additional tests or capture more logging
or whatever if that would help.

Thanks,
Bob

virtual box setup
-----------------
1 GB ram
8 GB disk
4 processors
Operating System: Linux
Version: Debian (64 bit)
Bridged networking
iso: debian-7.4.0-amd64-netinst.iso
Software selection
    select SSH server
    select Standard system utilities
    deselect everything else

dhcp ip address: 172.17.5.129

upgrade linux to 3.15.0-rc3
---------------------------
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
    fileio/ create name=file_backend2 file_or_dev=my_disk2 size=1G
    /iscsi create
    portals/ create 172.17.5.129
    cd <
    luns/ create /backstores/fileio/file_backend2
    cd <
    set attribute authentication=0 demo_mode_write_protect=0
generate_node_acls=1 cache_dynamic_acls=1
    exit

iscsiadm -m discovery -t sendtargets -p 172.17.5.129
iscsiadm -m node --login --target iqn.from_previous_iscsiadm_cmd_output
fdisk -l
mkfs -t xfs -f /dev/sdXX
mkdir /mnt/vola

put following lines in a shell script "foo.sh", fix up target and block
device
    set -x
    iscsiadm -m node --target
iqn.2003-01.org.linux-iscsi.debian.x8664:sn.51ab79ac3ce2 --login
    sleep 1
    mount -t xfs /dev/sdb /mnt/vola
    sleep 10
    iscsiadm -m node -U all
    sleep 1
    umount /mnt/vola

run the shell script in a loop like:
    while true; do ./foo.sh; done

in another terminal run the following:
    while true; do cp -r /usr/lib /mnt/vola; done

The hang seems to take from two to ten minutes to occur.

--047d7bacbedca64ec404f821d726
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Greetings,</div><div><br></div><div>I have an xfs umo=
unt hang caused by forcing the block device to return</div><div>i/o errors =
while copying files to the filesystem.</div><div>Detailed steps to reproduc=
e the problem on virtualbox are below.</div>
<div><br></div><div>The linux version is a recent pull and reports as 3.15.=
0-rc3.</div><div><br></div><div>[ 2040.248096] INFO: task umount:10303 bloc=
ked for more than 120 seconds.</div><div>[ 2040.323947] =A0 =A0 =A0 Not tai=
nted 3.15.0-rc3 #4</div>
<div>[ 2040.343423] &quot;echo 0 &gt; /proc/sys/kernel/hung_task_timeout_se=
cs&quot; disables this message.</div><div>[ 2040.352665] umount =A0 =A0 =A0=
 =A0 =A0D ffffffff8180fe40 =A0 =A0 0 10303 =A0 8691 0x00000000</div><div>[ =
2040.404918] =A0ffff88001e33dd58 0000000000000086 ffff88001e33dd48 ffffffff=
81080f82</div>
<div>[ 2040.489901] =A0ffff88001b311900 0000000000013180 ffff88001e33dfd8 0=
000000000013180</div><div>[ 2040.534772] =A0ffff88003daa3200 ffff88001b3119=
00 ffff88002421aec0 ffff88002421ae80</div><div>[ 2040.587450] Call Trace:</=
div>
<div>[ 2040.592176] =A0[&lt;ffffffff81080f82&gt;] ? try_to_wake_up+0x232/0x=
2b0</div><div>[ 2040.620212] =A0[&lt;ffffffff816c54d9&gt;] schedule+0x29/0x=
70</div><div>[ 2040.627685] =A0[&lt;ffffffffa04c4cd6&gt;] xfs_ail_push_all_=
sync+0x96/0xd0 [xfs]</div>
<div>[ 2040.632236] =A0[&lt;ffffffff81092230&gt;] ? __wake_up_sync+0x20/0x2=
0</div><div>[ 2040.659105] =A0[&lt;ffffffffa04731a3&gt;] xfs_unmountfs+0x63=
/0x160 [xfs]</div><div>[ 2040.691774] =A0[&lt;ffffffffa0478f65&gt;] ? kmem_=
free+0x35/0x40 [xfs]</div>
<div>[ 2040.698610] =A0[&lt;ffffffffa0474cf5&gt;] xfs_fs_put_super+0x25/0x6=
0 [xfs]</div><div>[ 2040.706838] =A0[&lt;ffffffff8119561e&gt;] generic_shut=
down_super+0x7e/0x100</div><div>[ 2040.723958] =A0[&lt;ffffffff811956d0&gt;=
] kill_block_super+0x30/0x80</div>
<div>[ 2040.734963] =A0[&lt;ffffffff8119591d&gt;] deactivate_locked_super+0=
x4d/0x80</div><div>[ 2040.745485] =A0[&lt;ffffffff8119652e&gt;] deactivate_=
super+0x4e/0x70</div><div>[ 2040.751274] =A0[&lt;ffffffff811b1d42&gt;] mntp=
ut_no_expire+0xd2/0x160</div>
<div>[ 2040.755894] =A0[&lt;ffffffff811b2fff&gt;] SyS_umount+0xaf/0x3b0</di=
v><div>[ 2040.761032] =A0[&lt;ffffffff816d1592&gt;] system_call_fastpath+0x=
16/0x1b</div><div>[ .060058] XFS (sdb): xfs_log_force: error 5 returned.</d=
iv>
<div>[ 268059] XFS (sdb): xfs_log_force: error 5 returned.</div><div><br></=
div><div>I took a look at xfs_ail_push_all_sync and it is pretty easy to se=
e</div><div>the hang. But it is not obvious to me how to fix it.</div><div>
Any ideas would be appreciated.</div><div><br></div><div>I am available to =
run additional tests or capture more logging</div><div>or whatever if that =
would help.</div><div><br></div><div>Thanks,</div><div>Bob</div><div><br>
</div><div><div>virtual box setup</div><div>-----------------</div><div>1 G=
B ram</div><div>8 GB disk</div><div>4 processors</div><div>Operating System=
: Linux</div><div>Version: Debian (64 bit)</div><div>Bridged networking</di=
v>
<div>iso: debian-7.4.0-amd64-netinst.iso</div><div>Software selection</div>=
<div>=A0 =A0 select SSH server</div><div>=A0 =A0 select Standard system uti=
lities</div><div>=A0 =A0 deselect everything else</div><div>=A0 =A0=A0</div=
><div>dhcp ip address: 172.17.5.129</div>
<div><br></div><div>upgrade linux to 3.15.0-rc3</div><div>-----------------=
----------</div><div>ssh 172.17.5.129</div><div>su</div><div>cd /mnt/ksrc/l=
inux</div><div>make modules_install</div><div>make install</div><div>reboot=
</div>
<div><br></div><div>install tools</div><div>-------------</div><div>ssh 172=
.17.5.129</div><div>su</div><div>apt-get install xfsprogs</div><div>apt-get=
 install open-iscsi</div><div>apt-get install --no-install-recommends targe=
tcli python-urwid</div>
<div>reboot</div><div><br></div><div>reproduce bug</div><div>-------------<=
/div><div>ssh 172.17.5.129</div><div>su</div><div>targetcli</div><div>=A0 =
=A0 cd backstores</div><div>=A0 =A0 fileio/ create name=3Dfile_backend2 fil=
e_or_dev=3Dmy_disk2 size=3D1G</div>
<div>=A0 =A0 /iscsi create</div><div>=A0 =A0 portals/ create 172.17.5.129</=
div><div>=A0 =A0 cd &lt;</div><div>=A0 =A0 luns/ create /backstores/fileio/=
file_backend2</div><div>=A0 =A0 cd &lt;</div><div>=A0 =A0 set attribute aut=
hentication=3D0 demo_mode_write_protect=3D0 generate_node_acls=3D1 cache_dy=
namic_acls=3D1</div>
<div>=A0 =A0 exit</div><div><br></div><div>iscsiadm -m discovery -t sendtar=
gets -p 172.17.5.129</div><div>iscsiadm -m node --login --target iqn.from_p=
revious_iscsiadm_cmd_output</div><div>fdisk -l</div><div>mkfs -t xfs -f /de=
v/sdXX</div>
<div>mkdir /mnt/vola</div><div><br></div><div>put following lines in a shel=
l script &quot;foo.sh&quot;, fix up target and block device</div><div>=A0 =
=A0 set -x</div><div>=A0 =A0 iscsiadm -m node --target iqn.2003-01.org.linu=
x-iscsi.debian.x8664:sn.51ab79ac3ce2 --login</div>
<div>=A0 =A0 sleep 1</div><div>=A0 =A0 mount -t xfs /dev/sdb /mnt/vola</div=
><div>=A0 =A0 sleep 10</div><div>=A0 =A0 iscsiadm -m node -U all</div><div>=
=A0 =A0 sleep 1</div><div>=A0 =A0 umount /mnt/vola</div><div><br></div><div=
>run the shell script in a loop like:</div>
<div>=A0 =A0 while true; do ./foo.sh; done</div><div><br></div><div>in anot=
her terminal run the following:</div><div>=A0 =A0 while true; do cp -r /usr=
/lib /mnt/vola; done</div><div><br></div><div>The hang seems to take from t=
wo to ten minutes to occur.</div>
</div><div><br></div></div>

--047d7bacbedca64ec404f821d726--


--===============7425346111187870488==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7425346111187870488==--
