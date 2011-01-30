Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0U0jkF7240281 for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 18:45:46 -0600
Received: from snt0-omc4-s20.snt0.hotmail.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 280F029BEBE
	for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 16:48:11 -0800 (PST)
Received: from snt0-omc4-s20.snt0.hotmail.com (snt0-omc4-s20.snt0.hotmail.com
	[65.55.90.223]) by cuda.sgi.com with ESMTP id 1ReOLu7KVJt3dv7B
	for <xfs@oss.sgi.com>; Sat, 29 Jan 2011 16:48:11 -0800 (PST)
Message-ID: <SNT130-w14C6D2EA98843C4F94D864DAE30@phx.gbl>
From: lord worm <cryptopsy@live.com>
Subject: FW: how to decode metadump info produced by xfs_db, and superblock
	error
Date: Sat, 29 Jan 2011 19:48:10 -0500
In-Reply-To: <SNT130-w5507ED619ADEE5A0761FA4DAE30@phx.gbl>
References: <SNT130-w5507ED619ADEE5A0761FA4DAE30@phx.gbl>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3761643062035553538=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3761643062035553538==
Content-Type: multipart/alternative;
	boundary="_2a2d273f-dd39-4d3e-a7f4-879ce07e819a_"

--_2a2d273f-dd39-4d3e-a7f4-879ce07e819a_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


I supposed I should have added the output of xfs_repair -n -o assume_xfs /m=
ybackupfile.bak (but I know you use the metadump file for real debugging ..=
.). It seems the superblock is correct=2C so either mount is wrong in sayin=
gs it incorrect (and something else is the problem)=2C or the superblock is=
 broken and xfs_repair cannot detect (also broken):

Phase 1 - find and verify superblock...
Phase 2 - using internal log
        - scan filesystem freespace and inode maps...
        - found root inode chunk
Phase 3 - for each AG...
        - scan (but don't clear) agi unlinked lists...
        - process known inodes and perform inode discovery...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
        - process newly discovered inodes...
Phase 4 - check for duplicate blocks...
        - setting up duplicate extent list...
        - check for inodes claiming duplicate blocks...
        - agno =3D 0
        - agno =3D 1
        - agno =3D 2
        - agno =3D 3
No modify flag set=2C skipping phase 5
Phase 6 - check inode connectivity...
        - traversing filesystem ...
        - traversal finished ...
        - moving disconnected inodes to lost+found ...
Phase 7 - verify link counts...
No modify flag set=2C skipping filesystem flush and exiting.

From: cryptopsy@live.com
To: xfs@oss.sgi.com
Subject: how to decode metadump info produced by xfs_db=2C and superblock e=
rror
Date: Sat=2C 29 Jan 2011 19:25:10 -0500








What kind of information is in this file produced by metadump=2C is it wort=
h reading it somehow?

I'm trying to first understand what's causing a 'superblock cannot be read'=
 error in my XFS after a succesfully dd of the partition (dd succeeds in co=
pying to a file=2C and also restoring=2C but after restoring it cannot moun=
t).

xfs_repair fails to fix it=2C how should I attach the 55M metadata file to =
this email (do we have an upload location for this?)=2C max size on hotmail=
 is 25M ...

Does the superblock error refer to primary or secondary superblocks? Does x=
fs_repair attempt to clone the broken superblock from the others?
 		 	   		  =

--_2a2d273f-dd39-4d3e-a7f4-879ce07e819a_
Content-Type: text/html; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<style><!--
.hmmessage P
{
margin:0px=3B
padding:0px
}
body.hmmessage
{
font-size: 10pt=3B
font-family:Tahoma
}
--></style>
</head>
<body class=3D'hmmessage'>
I supposed I should have added the output of xfs_repair -n -o assume_xfs /m=
ybackupfile.bak (but I know you use the metadump file for real debugging ..=
.). It seems the superblock is correct=2C so either mount is wrong in sayin=
gs it incorrect (and something else is the problem)=2C or the superblock is=
 broken and xfs_repair cannot detect (also broken):<br><br>Phase 1 - find a=
nd verify superblock...<br>Phase 2 - using internal log<br>&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B - scan filesystem freespace and in=
ode maps...<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B - f=
ound root inode chunk<br>Phase 3 - for each AG...<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B - scan (but don't clear) agi unlinked l=
ists...<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B - proce=
ss known inodes and perform inode discovery...<br>&nbsp=3B&nbsp=3B&nbsp=3B&=
nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B - agno =3D 0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nb=
sp=3B&nbsp=3B&nbsp=3B&nbsp=3B - agno =3D 1<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B - agno =3D 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B - agno =3D 3<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B - process newly discovered inodes...<br>Phase 4=
 - check for duplicate blocks...<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B - setting up duplicate extent list...<br>&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B - check for inodes claiming dup=
licate blocks...<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B - agno =3D 0<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B - agno =3D 1<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B - agno =3D 2<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B - agno =3D 3<br>No modify flag set=2C skipping phase 5<br>Phase 6 - che=
ck inode connectivity...<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B - traversing filesystem ...<br>&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B=
&nbsp=3B&nbsp=3B&nbsp=3B - traversal finished ...<br>&nbsp=3B&nbsp=3B&nbsp=
=3B&nbsp=3B&nbsp=3B&nbsp=3B&nbsp=3B - moving disconnected inodes to lost+fo=
und ...<br>Phase 7 - verify link counts...<br>No modify flag set=2C skippin=
g filesystem flush and exiting.<br><br><hr id=3D"stopSpelling">From: crypto=
psy@live.com<br>To: xfs@oss.sgi.com<br>Subject: how to decode metadump info=
 produced by xfs_db=2C and superblock error<br>Date: Sat=2C 29 Jan 2011 19:=
25:10 -0500<br><br>

<meta http-equiv=3D"Content-Type" content=3D"text/html=3B charset=3Dunicode=
">
<meta name=3D"Generator" content=3D"Microsoft SafeHTML">
<style>
.ExternalClass .ecxhmmessage P
{padding:0px=3B}
.ExternalClass body.ecxhmmessage
{font-size:10pt=3Bfont-family:Tahoma=3B}

</style>


What kind of information is in this file produced by metadump=2C is it wort=
h reading it somehow?<br><br>I'm trying to first understand what's causing =
a 'superblock cannot be read' error in my XFS after a succesfully dd of the=
 partition (dd succeeds in copying to a file=2C and also restoring=2C but a=
fter restoring it cannot mount).<br><br>xfs_repair fails to fix it=2C how s=
hould I attach the 55M metadata file to this email (do we have an upload lo=
cation for this?)=2C max size on hotmail is 25M ...<br><br>Does the superbl=
ock error refer to primary or secondary superblocks? Does xfs_repair attemp=
t to clone the broken superblock from the others?<br> 		 	   		  </body>
</html>=

--_2a2d273f-dd39-4d3e-a7f4-879ce07e819a_--


--===============3761643062035553538==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3761643062035553538==--
