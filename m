Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7764D7CB2
	for <xfs@oss.sgi.com>; Sat, 28 May 2016 04:25:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 49BF0304053
	for <xfs@oss.sgi.com>; Sat, 28 May 2016 02:25:40 -0700 (PDT)
Received: from gourmet8.spamgourmet.com (gourmet.spamgourmet.com
	[216.75.62.102]) by cuda.sgi.com with ESMTP id IJvTvrhyE0Qoh81D
	(version=TLSv1.2 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 28 May 2016 02:25:35 -0700 (PDT)
Received: from spamgourmet by gourmet7.spamgourmet.com with local (Exim 4.80)
	(envelope-from <xfs.pkoch@dfgh.net>) id 1b6aUw-0006UY-EE
	for xfs@oss.sgi.com; Sat, 28 May 2016 09:25:34 +0000
MIME-Version: 1.0
In-Reply-To: <CAPhCz3S7dvrOCqEJFvYvTQ89nUJwFxieQ5A1rShaxUb71rrNew@mail.gmail.com>
References: <CAPhCz3S7dvrOCqEJFvYvTQ89nUJwFxieQ5A1rShaxUb71rrNew@mail.gmail.com>
Date: Sat, 28 May 2016 11:25:32 +0200
Message-ID: <CAPhCz3SPomfAn68TknFW-KyEB4WXvPzXU8UVhXWqyXztNbQG+Q@mail.gmail.com>
Subject: Re: xfsrestore performance
From: xfs.pkoch@dfgh.net
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0753888840415442142=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

--===============0753888840415442142==
Content-Type: multipart/alternative; boundary=001a114d3ceedef6ca0533e39a1f

--001a114d3ceedef6ca0533e39a1f
Content-Type: text/plain; charset=UTF-8

Dear XFS experts,

I checked the situation this morning:

....
xfsdump: status at 10:25:53: 473543/7886560 files dumped, 1.3% data dumped,
76211 seconds elapsed
xfsdump: status at 10:35:46: 478508/7886560 files dumped, 1.3% data dumped,
76804 seconds elapsed

and decided to stop the process. With this kind of speed xfsdump |
xfsrestore
will need more than one month. Something must be seriously wrong here.

I see two options: Use rsync again to copy the data from the 14TB xfs
filesystem to the new 20TB xfs filesystem. This won't be finished
this weekend.

Or use dd to copy the 14TB XFS filesystem into the 20TB volume and
then grow the filesystem.

dd runs at 300MB/sec that's approx 1TB per hour, so I decided to go this
way.

So here's another question: The new filesystem will run on a 20 disk raid10
volume and was copied from a 16 disk raid5 volume. So swidth will be wrong.
Also all the data will be within the first 15TB.

What should I do to fix this? Or will xfs_growfs fix it automatically?

Regards

Peter Koch

--001a114d3ceedef6ca0533e39a1f
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div><div><div><div>Dear XFS experts,<br><br></div>I check=
ed the situation this morning:<br><br>....<br>xfsdump: status at 10:25:53: =
473543/7886560 files dumped, 1.3% data dumped, 76211 seconds elapsed<br>xfs=
dump: status at 10:35:46: 478508/7886560 files dumped, 1.3% data dumped, 76=
804 seconds elapsed<br><br></div>and decided to stop the process. With this=
 kind of speed xfsdump | xfsrestore<br></div>will need more than one month.=
 Something must be seriously wrong here.<br><br></div><div>I see two option=
s: Use rsync again to copy the data from the 14TB xfs<br>filesystem to the =
new 20TB xfs filesystem. This won&#39;t be finished<br></div><div>this week=
end.<br></div><div><br>Or use dd to copy the 14TB XFS filesystem into the 2=
0TB volume and<br>then grow the filesystem.<br><br>dd runs at 300MB/sec tha=
t&#39;s approx 1TB per hour, so I decided to go this<br>way.<br><br>So here=
&#39;s another question: The new filesystem will run on a 20 disk raid10<br=
>volume and was copied from a 16 disk raid5 volume. So swidth will be wrong=
.<br>Also all the data will be within the first 15TB.<br><br>What should I =
do to fix this? Or will xfs_growfs fix it automatically?<br><br>Regards<br>=
<br>Peter Koch</div></div>

--001a114d3ceedef6ca0533e39a1f--


--===============0753888840415442142==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0753888840415442142==--
