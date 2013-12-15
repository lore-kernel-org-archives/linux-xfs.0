Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1318F7F3F
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 16:47:35 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 01789304048
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 14:47:31 -0800 (PST)
Received: from mail-ve0-f172.google.com (mail-ve0-f172.google.com
	[209.85.128.172]) by cuda.sgi.com with ESMTP id
	RaX3hW3yajagG3Sr (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 Dec 2013 14:47:31 -0800 (PST)
Received: by mail-ve0-f172.google.com with SMTP id jw12so2839563veb.3
	for <xfs@oss.sgi.com>; Sun, 15 Dec 2013 14:47:30 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 15 Dec 2013 20:47:30 -0200
Message-ID: <CAG97raf61XGnTakrYjcfv9cjM6CTVdEEB3wQK+wOBvpowWO3Cw@mail.gmail.com>
Subject: XFS_REPAIR on LVM partition
From: Rafael Weingartner <rafaelweingartner@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4873002377962920341=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============4873002377962920341==
Content-Type: multipart/alternative; boundary=089e0141a440f2905204ed9a7a62

--089e0141a440f2905204ed9a7a62
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi folks,
I am having some troubles with a XFS over one LVM partition. After an
unexpected reboot, I am getting the following message when I try to mount
it:
*mount: Structure needs cleaning*


I tried "sudo xfs_check /dev/mapper/volume". Sadly, I got the message:
xfs_check: cannot init perag data (117)
*ERROR: The filesystem has valuable metadata changes in a log which needs
to*
*be replayed.  Mount the filesystem to replay the log, and unmount it
before*
*re-running xfs_check.  If you are unable to mount the filesystem, then use=
*
*the xfs_repair -L option to destroy the log and attempt a repair.*
*Note that destroying the log may cause corruption -- please attempt a
mount*
*of the filesystem before doing this*

So, I tried:
xfs_repair -L

The command is running for over 3 hours and still just dots on my screen, I
have no idea of what is happening. Any ideas how I can get it to work
again? Or at least some work around that would enable me to extract the
data that it contains.

The server is a Ubuntu server 12.04.
The XFS version is: xfs_info version 3.1.7
If you need I can provide you with more info.

Thanks,

--=20
Rafael Weing=E4rtner

--089e0141a440f2905204ed9a7a62
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi folks,=A0<div><span style=3D"color:rgb(0,0,0);font-fami=
ly:Verdana,Arial,Helvetica,sans-serif;font-size:14px;line-height:20.15625px=
">I am having some troubles with a XFS over one LVM partition. After an une=
xpected reboot, I am getting the following message when I try to mount it:<=
/span><br>
</div><div><i>mount: Structure needs cleaning</i><br></div><div><br></div><=
div><br></div><div><span style=3D"background-color:rgb(255,255,255)"><font =
color=3D"#000000"><span style=3D"font-family:Verdana,Arial,Helvetica,sans-s=
erif;font-size:14px;line-height:20.15625px">I tried &quot;</span><span clas=
s=3D"" title=3D"sudd, judo, ludo, suds, sumo" style=3D"padding:1px;margin:2=
px;font-style:italic;border-bottom-width:thin;border-bottom-style:dashed;bo=
rder-bottom-color:red;font-family:Verdana,Arial,Helvetica,sans-serif;font-s=
ize:14px;line-height:20.15625px">sudo</span><span style=3D"font-family:Verd=
ana,Arial,Helvetica,sans-serif;font-size:14px;line-height:20.15625px">=A0</=
span><span class=3D"" title=3D"" style=3D"padding:1px;margin:2px;font-style=
:italic;border-bottom-width:thin;border-bottom-style:dashed;border-bottom-c=
olor:red;font-family:Verdana,Arial,Helvetica,sans-serif;font-size:14px;line=
-height:20.15625px">xfs_check</span><span style=3D"font-family:Verdana,Aria=
l,Helvetica,sans-serif;font-size:14px;line-height:20.15625px">=A0/</span><s=
pan class=3D"" title=3D"def, deva, dv, derv, des, den, del, dec, deb, rev, =
nev" style=3D"padding:1px;margin:2px;font-style:italic;border-bottom-width:=
thin;border-bottom-style:dashed;border-bottom-color:red;font-family:Verdana=
,Arial,Helvetica,sans-serif;font-size:14px;line-height:20.15625px">dev/</sp=
an><span style=3D"font-family:Verdana,Arial,Helvetica,sans-serif;font-size:=
14px;line-height:20.15625px">mapper/volume&quot;. Sadly, I got the message:=
</span></font></span><br>
</div><div>xfs_check: cannot init perag data (117)<br></div><div><i>ERROR: =
The filesystem has valuable metadata changes in a log which needs to</i><br=
></div><div><div><i>be replayed. =A0Mount the filesystem to replay the log,=
 and unmount it before</i></div>
<div><i>re-running xfs_check. =A0If you are unable to mount the filesystem,=
 then use</i></div><div><i>the xfs_repair -L option to destroy the log and =
attempt a repair.</i></div><div><i>Note that destroying the log may cause c=
orruption -- please attempt a mount</i></div>
<div><i>of the filesystem before doing this</i></div></div><div><br></div><=
div><span style=3D"color:rgb(0,0,0);font-family:Verdana,Arial,Helvetica,san=
s-serif;font-size:14px;line-height:20.15625px">So, I tried:</span><br></div=
>
<div><div>xfs_repair -L=A0<br></div><div><br></div><div><span style=3D"colo=
r:rgb(0,0,0);font-family:Verdana,Arial,Helvetica,sans-serif;font-size:14px;=
line-height:20.15625px">The command is running for over 3 hours=A0</span><s=
pan style=3D"color:rgb(0,0,0);font-family:Verdana,Arial,Helvetica,sans-seri=
f;font-size:14px;line-height:20.15625px">and still just dots on my screen, =
I have no idea of what is happening. Any ideas how I can get it to work aga=
in? Or at least some work</span><span style=3D"color:rgb(0,0,0);font-family=
:Verdana,Arial,Helvetica,sans-serif;font-size:14px;line-height:20.15625px">=
=A0around that would enable me to extract the data that it contains.</span>=
<br>
</div><div><br></div><div>The server is a Ubuntu server 12.04.</div><div>Th=
e XFS version is: xfs_info version 3.1.7</div><div>If you need I can provid=
e you with more info.</div><div><br></div><div>Thanks,</div><div><br></div>
-- <br><div dir=3D"ltr">Rafael Weing=E4rtner</div>
</div></div>

--089e0141a440f2905204ed9a7a62--


--===============4873002377962920341==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4873002377962920341==--
