Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4OKSFiU200770 for <xfs@oss.sgi.com>; Mon, 24 May 2010 15:28:18 -0500
Received: from exchange.blackducksoftware.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B488F1DF6A18
	for <xfs@oss.sgi.com>; Mon, 24 May 2010 13:30:32 -0700 (PDT)
Received: from exchange.blackducksoftware.com
	(68.233.172.16.static.rev.colospace.com [68.233.172.16]) by
	cuda.sgi.com with ESMTP id y5gARTdEvuULQ784 for
	<xfs@oss.sgi.com>; Mon, 24 May 2010 13:30:32 -0700 (PDT)
From: Colin Wilson <cwilson@blackducksoftware.com>
Date: Mon, 24 May 2010 16:30:30 -0400
Subject: Re: xfs_repair memory usage and stopping on "Traversing filesystem..."
Message-ID: <7A6C2FF2-7776-4417-9153-E6CE1265CC04@blackducksoftware.com>
References: <00FB97ED-C684-4B81-B623-AB7EBD7B7091@blackducksoftware.com>
	<20100519001911.GJ2150@dastard> <4BF349D1.6050408@sandeen.net>
In-Reply-To: <4BF349D1.6050408@sandeen.net>
Content-Language: en-US
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============2641766912450348093=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

--===============2641766912450348093==
Content-Language: en-US
Content-Type: multipart/alternative;
	boundary="_000_7A6C2FF2777644179153E6CE1265CC04blackducksoftwarecom_"

--_000_7A6C2FF2777644179153E6CE1265CC04blackducksoftwarecom_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I got some down time this weekend and tried to run another xfs_repair with =
the latest(3.1.2) version of XFS tools.  This time the check ran much slowe=
r than it had before and used much more swap.  My system has 12GB of ram in=
 it right now and 16GB of swap space, do you guys have any rule of thumb to=
 use to figure out how much memory the system should need?  I am thinking a=
dding more memory is the only way to fix my problem as it is now since its =
just slowness.  I don't remember how much swap it ended up using but the pr=
ocess ran until I killed it to bring the file system back on line without r=
unning out of total memory.

This may not be the biggest problem in the world but I tried to take a meta=
data dump just incase that was helpful and the process ran till a certain p=
oint and then hung with xfs_db using 100% of one of my cores.  I've confirm=
ed the same outcome three runs in a row.  The output of xfs_metadump was:

:~# xfs_metadump -gw /dev/mapper/sangroup-sandisk ./metadata.dump
Copied 8192 of 1732067904 inodes (0 of 821 AGs)
xfs_metadump: suspicious count 1152 in bmap extent 89 in dir2 ino 12743
xfs_metadump: suspicious count 1455 in bmap extent 135 in dir2 ino 12743
xfs_metadump: suspicious count 1074 in bmap extent 2 in dir2 ino 12743
Copied 8151232 of 1732067904 inodes (0 of 821 AGs)

/usr/sbin/xfs_metadump: line 31:  5363 Terminated              xfs_db$DBOPT=
S -F -i -p xfs_metadump -c "metadump$OPTS $2" $1

The process would hang at "Copied 8151232 of 1732067904 inodes (0 of 821 AG=
s)" and the rest of the output was me killing the xfs_db process.  Thanks f=
or all the help.

--Colin

Colin Wilson
Linux Systems Administrator
T +1.781.810.1331
F +1.781.891.5145
cwilson@blackducksoftware.com<mailto:cwilson@blackducksoftware.com>
http://www.blackducksoftware.com<http://www.blackducksoftware.com/>




On May 18, 2010, at 10:15 PM, Eric Sandeen wrote:

Dave Chinner wrote:


Hence I'd start by upgrading to 3.1.2 and running with the default
options first to see whether it is faster and whether it hangs or
not before going any further.

If it still hangs, collecting an xfs_metadump of the fs would be
useful for investigating the problem.

But, I think I fixed that (the options you mentioned were workarounds
for the bug I eventually fixed, IIRC)

Thanks,
-Eric

Cheers,

Dave.



--_000_7A6C2FF2777644179153E6CE1265CC04blackducksoftwarecom_
Content-Type: text/html; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

<html><head></head><body style=3D"word-wrap: break-word; -webkit-nbsp-mode:=
 space; -webkit-line-break: after-white-space; "><span class=3D"Apple-tab-s=
pan" style=3D"white-space:pre">	</span>I got some down time this weekend an=
d tried to run another xfs_repair with the latest(3.1.2) version of XFS too=
ls. &nbsp;This time the check ran much slower than it had before and used m=
uch more swap. &nbsp;My system has 12GB of ram in it right now and 16GB of =
swap space, do you guys have any rule of thumb to use to figure out how muc=
h memory the system should need? &nbsp;I am thinking adding more memory is =
the only way to fix my problem as it is now since its just slowness. &nbsp;=
I don't remember how much swap it ended up using but the process ran until =
I killed it to bring the file system back on line without running out of to=
tal memory. &nbsp;<div><br></div><div><span class=3D"Apple-tab-span" style=
=3D"white-space:pre">	</span>This may not be the biggest problem in the wor=
ld but I tried to take a metadata dump just incase that was helpful and the=
 process ran till a certain point and then hung with xfs_db using 100% of o=
ne of my cores. &nbsp;I've confirmed the same outcome three runs in a row. =
&nbsp;The output of xfs_metadump was:<div><div><div><br></div><div>:~# xfs_=
metadump -gw /dev/mapper/sangroup-sandisk ./metadata.dump</div><div>Copied =
8192 of 1732067904 inodes (0 of 821 AGs)</div><div>xfs_metadump: suspicious=
 count 1152 in bmap extent 89 in dir2 ino 12743</div><div>xfs_metadump: sus=
picious count 1455 in bmap extent 135 in dir2 ino 12743</div><div>xfs_metad=
ump: suspicious count 1074 in bmap extent 2 in dir2 ino 12743</div><div>Cop=
ied 8151232 of 1732067904 inodes (0 of 821 AGs)</div><div><br></div><div>/u=
sr/sbin/xfs_metadump: line 31: &nbsp;5363 Terminated &nbsp; &nbsp; &nbsp; &=
nbsp; &nbsp; &nbsp; &nbsp;xfs_db$DBOPTS -F -i -p xfs_metadump -c "metadump$=
OPTS $2" $1</div><div><br></div><div>The process would hang at "Copied 8151=
232 of 1732067904 inodes (0 of 821 AGs)" and the rest of the output was me =
killing the xfs_db process. &nbsp;Thanks for all the help.</div><div><br></=
div><div>--Colin</div><div><br></div><div>
<span class=3D"Apple-style-span" style=3D"font-size: 12px; "><div style=3D"=
word-wrap: break-word; -webkit-nbsp-mode: space; -webkit-line-break: after-=
white-space; "><div>Colin Wilson</div><div>Linux Systems Administrator</div=
><div><div>T +1.781.810.1331</div><div>F +1.781.891.5145</div><div><a href=
=3D"mailto:cwilson@blackducksoftware.com">cwilson@blackducksoftware.com</a>=
</div><div><a href=3D"http://www.blackducksoftware.com/">http://www.blackdu=
cksoftware.com</a></div><div><br></div></div></div></span><br class=3D"Appl=
e-interchange-newline"><br class=3D"Apple-interchange-newline">
</div>
<br><div><div>On May 18, 2010, at 10:15 PM, Eric Sandeen wrote:</div><br cl=
ass=3D"Apple-interchange-newline"><blockquote type=3D"cite"><div>Dave Chinn=
er wrote:<br><br><br><blockquote type=3D"cite">Hence I'd start by upgrading=
 to 3.1.2 and running with the default<br></blockquote><blockquote type=3D"=
cite">options first to see whether it is faster and whether it hangs or<br>=
</blockquote><blockquote type=3D"cite">not before going any further.<br></b=
lockquote><br>If it still hangs, collecting an xfs_metadump of the fs would=
 be <br>useful for investigating the problem.<br><br>But, I think I fixed t=
hat (the options you mentioned were workarounds<br>for the bug I eventually=
 fixed, IIRC)<br><br>Thanks,<br>-Eric<br><br><blockquote type=3D"cite">Chee=
rs,<br></blockquote><blockquote type=3D"cite"><br></blockquote><blockquote =
type=3D"cite">Dave.<br></blockquote><br></div></blockquote></div><br></div>=
</div></div></body></html>=

--_000_7A6C2FF2777644179153E6CE1265CC04blackducksoftwarecom_--


--===============2641766912450348093==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============2641766912450348093==--
