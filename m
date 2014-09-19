Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8A0577F3F
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 15:58:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 58F988F8064
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 13:58:52 -0700 (PDT)
Received: from mail-vc0-f178.google.com (mail-vc0-f178.google.com
	[209.85.220.178]) by cuda.sgi.com with ESMTP id
	pbgMnjlByCiSDBCx (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 19 Sep 2014 13:58:50 -0700 (PDT)
Received: by mail-vc0-f178.google.com with SMTP id lf12so84858vcb.23
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2014 13:58:49 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 19 Sep 2014 22:58:49 +0200
Message-ID: <CAJiJ=8+1P1odzJGpWRvPQh84KQMx5ukzFS9pACjRr7aHGiTpXQ@mail.gmail.com>
Subject: Repair XFS from 1/3 of the table
From: Alessio Di Maria <alessio.dimaria@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3388390152296173605=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============3388390152296173605==
Content-Type: multipart/alternative; boundary=001a1136211e272da90503715ef9

--001a1136211e272da90503715ef9
Content-Type: text/plain; charset=UTF-8

Hi, for fist i'm sorry for my bad English..
so,
I'm trying to do a recovery from my NAS,
After it stopped, 3 disk of 4 was reinitialized so, raid partition was
deleted on disk 1 2 and 3, and first about 5m was zero filled..
I'm actually work on a copy of that...
in my luck, the XFS superblock was on 4th disk..
I was able to rebuild RAID5 with the original configuration and now i can
read RAW files up to few kb... i was able to read a 15Mb zip file, and some
big jpeg, so i can say that RAID it's working fine

At sector 384 of the raid volume start the xfs superblock, i made a
loopback at this offset,
mounting it.. but obviusly it said that was not clean.
making xfs_repair i get anything, but with xfs_repair -L i had infinite
list of lost inode, and than i was able to mount the partition,
but with any file, only the lost + found directory with few but complete
files...

On the NAS there were Big Files of ISCSI, in the lost + found i find one of
this, big 100Gb.. now i don't know how i can recovery the rest..

Is it possible to find lost inode?

i tryied with many programs to get back the original Filesystem but
anything up the Lost + Found directory after the repair...
I know that XFS is based on sparse file, and so i can't find my file and
hope to copy it contigusly (about 5Gb) cose the fs reidirect zero filled
zone... in addiction i can't do a RAW recovery cose in the deep of 2.7Tb i
find MFT entryies and system files inner ISCSI units...
So what chache?
Wha can i do myself?

I know that a DIY approach it this case is hard
Many Thaks in advance of any reponse!

--001a1136211e272da90503715ef9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi, for fist i&#39;m sorry for my bad English..<div>so,=C2=
=A0</div><div>I&#39;m trying to do a recovery from my NAS,=C2=A0</div><div>=
After it stopped, 3 disk of 4 was reinitialized so, raid partition was dele=
ted on disk 1 2 and 3, and first about 5m was zero filled..=C2=A0</div><div=
>I&#39;m actually work on a copy of that...</div><div>in my luck, the XFS s=
uperblock was on 4th disk..=C2=A0</div><div>I was able to rebuild RAID5 wit=
h the original configuration and now i can read RAW files up to few kb... i=
 was able to read a 15Mb zip file, and some big jpeg, so i can say that RAI=
D it&#39;s working fine</div><div><br></div><div>At sector 384 of the raid =
volume start the xfs superblock, i made a loopback at this offset,</div><di=
v>mounting it.. but obviusly it said that was not clean.=C2=A0</div><div>ma=
king xfs_repair i get anything, but with xfs_repair -L i had infinite list =
of lost inode, and than i was able to mount the partition,=C2=A0</div><div>=
but with any file, only the lost + found directory with few but complete fi=
les...</div><div><br></div><div>On the NAS there were Big Files of ISCSI, i=
n the lost + found i find one of this, big 100Gb.. now i don&#39;t know how=
 i can recovery the rest..</div><div><br></div><div>Is it possible to find =
lost inode?</div><div><br></div><div>i tryied with many programs to get bac=
k the original Filesystem but anything up the Lost + Found directory after =
the repair...</div><div>I know that XFS is based on sparse file, and so i c=
an&#39;t find my file and hope to copy it contigusly (about 5Gb) cose the f=
s reidirect zero filled zone... in addiction i can&#39;t do a RAW recovery =
cose in the deep of 2.7Tb i find MFT entryies and system files inner ISCSI =
units...=C2=A0<br></div><div>So what chache?=C2=A0<br></div><div>Wha can i =
do myself?</div><div><br></div><div>I know that a DIY approach it this case=
 is hard</div><div>Many Thaks in advance of any reponse!</div></div>

--001a1136211e272da90503715ef9--


--===============3388390152296173605==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3388390152296173605==--
