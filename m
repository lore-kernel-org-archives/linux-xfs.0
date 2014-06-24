Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A72007F50
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 10:43:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8114330408B
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2014 08:43:38 -0700 (PDT)
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19]) by cuda.sgi.com
	with ESMTP id X20MQ7NV5avXpjc0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 24 Jun 2014 08:43:37 -0700 (PDT)
MIME-Version: 1.0
Message-ID: <trinity-a2065951-9261-435a-896b-4766fb281781-1403624615402@3capp-gmx-bs44>
From: Dragon <Sunghost@gmx.de>
Subject: Re: XFS Repair hangs at inode repair in phase3
Date: Tue, 24 Jun 2014 17:43:35 +0200
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============5360091137837615530=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============5360091137837615530==
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div style=3D"font-family: Verdana;font-size: 12.0=
px;"><div>
<div>Hi,</div>

<div>ok will try. So what could be the problem of this? Maybe the lost of =
one disk out of raid6? I think not, or? Maybe a controller failure? Before =
i used ext4 and never had problems with this hardware...</div>

<div>thx</div>

<div>&nbsp;</div>

<div>You can always try: # git clone git://oss.sgi.com/xfs/cmds/xfsprogs.g=
it # cd xfsprogs # git checkout v3.2.0 # make # repair/xfs_repair -n /dev/m=
d2 -Eric On 6/24/14, 9:24 AM, Dragon wrote:</div>

<blockquote>Hello Eric, ok will never use xfs_check ;). Yes i saw option -=
P but i though if i desabled that test, i will never get fix those problems=
. The Version is from Debian Wheezy stable, so why it is such old, when it =
is that important :do not understand this from debianmaintainer...: So what=
 could i do to use latest Version under Debian Wheezy? Normaly i use the pa=
ckage system.. Any risk to loos all my data? Where came the Problem from? I=
f the version is such old, was the md2 created out of that, or are there on=
ly the tools in it?</blockquote>

<blockquote>Thx On 6/24/14, 8:01 AM, Dragon wrote: Hello, i have a fresh i=
nstall Debian Wheezy with software raid as md2 for my files. MD2 is nealry =
full of 8TB and i wanted to migrate the data to a newier system. While copy=
 files i got an message that i have to run xfs_repair. I first run xfs_chec=
k but it eats up all my 11GB memory and the system stalls. Yep, xfs_check d=
oesn&#39;t scale and is on the way to deprecation. Then i run xfs_repair -n=
 /dev/md2 but it hangs each time add: problem with directory contens in ino=
de 2147997719 - would have cleared inode 2147997719. If i break this and re=
start, it hangs at the same position. System seems to do nothing over hours=
. You might try the -P option to repair. -P Disable prefetching of inode an=
d directory blocks. Use this option if you find xfs_repair gets stuck and s=
tops proceeding. If that works, it likely indicates a bug, but it might get=
 you going. Some Infos: xfsprogs in Version 3.1.7+b1 And that&#39;s a 3-yea=
r old xfsprogs, so an upgrade might help, too. -Eric</blockquote>
</div></div></body></html>


--===============5360091137837615530==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============5360091137837615530==--
