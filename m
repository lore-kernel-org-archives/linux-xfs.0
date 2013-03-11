Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 60D027F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 16:45:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4E88C8F8040
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 14:45:44 -0700 (PDT)
Received: from mail.lichtvoll.de (mondschein.lichtvoll.de [194.150.191.11]) by
	cuda.sgi.com with ESMTP id 5QanBbY79Sxs1vOW for
	<xfs@oss.sgi.com>; Mon, 11 Mar 2013 14:45:42 -0700 (PDT)
From: Martin Steigerwald <Martin@lichtvoll.de>
Subject: Re: Maximum file system size of XFS?
Date: Mon, 11 Mar 2013 22:45:40 +0100
References: <20130309215121.0e614ef8@thinky>
	(sfid-20130310_104346_965248_A63DAA41)
In-Reply-To: <20130309215121.0e614ef8@thinky>
MIME-Version: 1.0
Message-Id: <201303112245.40522.Martin@lichtvoll.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Pascal <pa5ca1@gmx.de>

Am Samstag, 9. M=E4rz 2013 schrieb Pascal:
> Hello,

Hi Pascal,

> I am asking you because I am insecure about the correct answer and
> different sources give me different numbers.
> =

> =

> My question is: What is the maximum file system size of XFS?
> =

> The official page says: 2^63 =3D 9 x 10^18 =3D 9 exabytes
> Source: http://oss.sgi.com/projects/xfs/
> =

> Wikipedia says 16 exabytes.
> Source: https://en.wikipedia.org/wiki/XFS
> =

> Another reference books says 8 exabytes (2^63).
> =

> =

> Can anyone tell me and explain what is the maximum file system size for
> XFS?

You can test it. The theoretical limit. Whether such a filesystem will work =

nicely with a real workload is, as pointed out, a different question.

1) Use a big enough XFS filesystem (yes, it has to be XFS for anything else =

that can carry a exabyte big sparse file)

merkaba:~> LANG=3DC mkfs.xfs -L justcrazy /dev/merkaba/zeit
meta-data=3D/dev/merkaba/zeit      isize=3D256    agcount=3D4, agsize=3D131=
0720 blks
         =3D                       sectsz=3D512   attr=3D2, projid32bit=3D0
data     =3D                       bsize=3D4096   blocks=3D5242880, imaxpct=
=3D25
         =3D                       sunit=3D0      swidth=3D0 blks
naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
log      =3Dinternal log           bsize=3D4096   blocks=3D2560, version=3D2
         =3D                       sectsz=3D512   sunit=3D0 blks, lazy-coun=
t=3D1
realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0


2) Create a insanely big sparse file

merkaba:~> truncate -s1E /mnt/zeit/evenmorecrazy.img
merkaba:~> ls -lh /mnt/zeit/evenmorecrazy.img
-rw-r--r-- 1 root root 1,0E M=E4r 11 22:37 /mnt/zeit/evenmorecrazy.img

(No, this won=B4t work with Ext4.)


3) Make a XFS file system into it:

merkaba:~> mkfs.xfs -L /mnt/zeit/evenmorecrazy.img

I won=B4t today. I tried that for gag during a linux performance and analys=
is =

training I held on a ThinkPad T520 with Sandybridge i5 2,50 GhZ, Intel SSD =

320 on an about 20 GiB XFS filesystem.

The mkfs command run for something like one or two hours. It was using quit=
e =

some CPU and quite some SSD, but did not max out one of it.

The host XFS filesystem was almost full, so the image took just about those =

20 GiB.


4) Mount it and enjoy the output of df -hT.


5) Write to if it you dare. I did it, until the Linux kernel told something =

about "lost buffer writes". What I found strange is, that the dd writing to =

the 1E filesystem did not quit then with input/output error. It just ran on.


I didn=B4t test this with any larger size, but if size and time usage scale=
s =

linearily it might be possible to create a 10EiB filesystem within 200 GiB =

host XFS and hum about a day of waiting :).

No, I do not suggest to use anything even just remotely like this in =

production.

And no, my test didn=B4t show that an 1EiB filesystem will work nicely with =

any real life workload.

Am I crazy for trying this? I might be :)

Thanks,
-- =

Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
