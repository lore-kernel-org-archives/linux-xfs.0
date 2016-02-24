Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC7A77CAE
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 21:37:51 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3DC7AAC002
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 19:37:45 -0800 (PST)
Received: from mail-yw0-f177.google.com (mail-yw0-f177.google.com
	[209.85.161.177]) by cuda.sgi.com with ESMTP id
	WnPwWwCy9TFv0oLA (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Feb 2016 19:37:36 -0800 (PST)
Received: by mail-yw0-f177.google.com with SMTP id g127so5483878ywf.2
	for <xfs@oss.sgi.com>; Tue, 23 Feb 2016 19:37:36 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 23 Feb 2016 22:37:36 -0500
Message-ID: <CADUjHbXfFEVVk661XMEoAOUM+pQs0LdQh3xFVx6_5tsLZP+P2g@mail.gmail.com>
Subject: Accidental FS corruption: Mapping files to blocks
From: Paul Cannon <paul.cannon3128@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============6761782896691395046=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============6761782896691395046==
Content-Type: multipart/alternative; boundary=94eb2c092a407983a0052c7bc9b6

--94eb2c092a407983a0052c7bc9b6
Content-Type: text/plain; charset=UTF-8

I have accidentally damaged my XFS, and need help (and a little prayer).
The way it happened will provide your daily amusement dose (and hopefully a
lesson).

* What happened?
I have two file systems xfsA (18 TBs on /dev/sdc1) and xfsB (36 TBs on
/dev/sdd1). They were mounted and working fine. I accidentally executed an
old script that effectively ran the following command:
>ddrescue /dev/sdc /dev/sdd sdc_sdd.log
For those unfamiliar with the ddrescue command, it claims to rescue/image
data from a drive A to B. It does multiple passes to rescue data with
maximum efficiency.

* Why did I do it?
I am careless or dumb or may be a combination of both. But the fact that
drives got remapped (sdc/sdd became sde/sdf and otherway around) might also
be part of it.

* What happened to XFS on sdd (xfsB)?
Luckily, the imaging started with an offset of about 2.7 TBs. Why? Because
this was a restart of ddrescue and it started from past point. IT WROTE a
total of 6.1 GBs of data on sdd/xfsB

So I quickly stopped as I realized my mistake. I ran xfs_repair on xfsB.
Due to the offset of 2.7 TBs, metadata seemed fine. The xfs_repair shows
everything is fine. But if I extract out data using (dd skip=2.7TB) into a
file -- I can see things are different! I recognize the abrupt change in a
text file, exactly where the data overwritten.

* Luckily I have old copy of the original data!
So I did a rsync -rvn /olddata/ /xfsB
Nothing! No difference in any data files. I even tried mirrordir, same
thing -- nothing, no difference!

* Here is what I think is going on, and I need help.
I suspect that the access time of the file/files stored at this location
are perhaps in another location in inode (does this sound correct? I am a
newbie to XFS). But the data itself has changed at the location.

* QUESTION: How do I find what files were stored at the location? I have an
EXACT location of the range affected. Once I find the affected files, I can
perhaps do further surgery.

Any help (and prayers) will be highly appreciated.

--94eb2c092a407983a0052c7bc9b6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I have accidentally damaged my XFS, and need help (and a l=
ittle prayer). The way it happened will provide your daily amusement dose (=
and hopefully a lesson).<div><br></div><div>* What happened?</div><div>I ha=
ve two file systems xfsA (18 TBs on /dev/sdc1) and xfsB (36 TBs on /dev/sdd=
1). They were mounted and working fine. I accidentally executed an old scri=
pt that effectively ran the following command:</div><div>&gt;ddrescue /dev/=
sdc /dev/sdd sdc_sdd.log</div><div>For those unfamiliar with the ddrescue c=
ommand, it claims to rescue/image data from a drive A to B. It does multipl=
e passes to rescue data with maximum efficiency.</div><div><br></div><div>*=
 Why did I do it?</div><div>I am careless or dumb or may be a combination o=
f both. But the fact that drives got remapped (sdc/sdd became sde/sdf and o=
therway around) might also be part of it.</div><div><br></div><div>* What h=
appened to XFS on sdd (xfsB)?</div><div>Luckily, the imaging started with a=
n offset of about 2.7 TBs. Why? Because this was a restart of ddrescue and =
it started from past point. IT WROTE a total of 6.1 GBs of data on sdd/xfsB=
</div><div><br></div><div>So I quickly stopped as I realized my mistake. I =
ran xfs_repair on xfsB. Due to the offset of 2.7 TBs, metadata seemed fine.=
 The xfs_repair shows everything is fine. But if I extract out data using (=
dd skip=3D2.7TB) into a file -- I can see things are different! I recognize=
 the abrupt change in a text file, exactly where the data overwritten.</div=
><div><br></div><div>* Luckily I have old copy of the original data!</div><=
div>So I did a rsync -rvn /olddata/ /xfsB</div><div>Nothing! No difference =
in any data files. I even tried mirrordir, same thing -- nothing, no differ=
ence!</div><div><br></div><div>* Here is what I think is going on, and I ne=
ed help.</div><div>I suspect that the access time of the file/files stored =
at this location are perhaps in another location in inode (does this sound =
correct? I am a newbie to XFS). But the data itself has changed at the loca=
tion.</div><div><br></div><div>* QUESTION: How do I find what files were st=
ored at the location? I have an EXACT location of the range affected. Once =
I find the affected files, I can perhaps do further surgery.</div><div><br>=
</div><div>Any help (and prayers) will be highly appreciated.</div><div><br=
></div><div>=C2=A0=C2=A0</div><div><br></div><div>=C2=A0=C2=A0=C2=A0<br></d=
iv></div>

--94eb2c092a407983a0052c7bc9b6--


--===============6761782896691395046==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============6761782896691395046==--
