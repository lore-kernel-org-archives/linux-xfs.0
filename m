Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3U2D142121122 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 21:13:02 -0500
Received: from mail-iw0-f193.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 25EA71278FAB
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 19:15:06 -0700 (PDT)
Received: from mail-iw0-f193.google.com (mail-iw0-f193.google.com
	[209.85.223.193]) by cuda.sgi.com with ESMTP id
	OiVA9IBlyvbhb7ij for <xfs@oss.sgi.com>;
	Thu, 29 Apr 2010 19:15:06 -0700 (PDT)
Received: by iwn31 with SMTP id 31so9428037iwn.30
	for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 19:15:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <p2y25446eb91004291741k7e8e72cejc72093caf9cc99aa@mail.gmail.com>
References: <i2hdb2d1ee61004291707k9ffebed2k4ff6eb72354cbe63@mail.gmail.com>
	<p2y25446eb91004291741k7e8e72cejc72093caf9cc99aa@mail.gmail.com>
Date: Thu, 29 Apr 2010 19:15:05 -0700
Message-ID: <r2ndb2d1ee61004291915t1f7df28ci407380b3b1208f1@mail.gmail.com>
Subject: Re: xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Argument list too
	long
From: Benjamin Lau <benjamin.a.lau@gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Ah,,, okay well that's good to know... I guess it is time to upgrade then...

Thanks,

Ben

On Thu, Apr 29, 2010 at 5:41 PM, James Braid <jamesb@loreland.org> wrote:
> On Fri, Apr 30, 2010 at 01:07, Benjamin Lau <benjamin.a.lau@gmail.com> wr=
ote:
>> [2] Full output of xfs_growfs:
>> meta-data=3D/dev/mapper/vg00-lv_raid isize=3D256 =A0 =A0agcount=3D40, ag=
size=3D61047552 blks
>> =A0 =A0 =A0 =A0 =A0 =A0=3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 s=
ectsz=3D512 =A0 attr=3D2
>> data =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D409=
6 =A0 blocks=3D2441868288, imaxpct=3D25
>> =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sunit=3D=
0 =A0 =A0 =A0swidth=3D0 blks
>> naming =A0 =3Dversion 2 =A0 =A0 =A0 =A0 =A0 =A0 =A0bsize=3D4096
>> log =A0 =A0 =A0=3Dinternal =A0 =A0 =A0 =A0 =A0 =A0 =A0 bsize=3D4096 =A0 =
blocks=3D32768, version=3D2
>> =A0 =A0 =A0 =A0 =3D =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sectsz=
=3D512 =A0 sunit=3D0 blks, lazy-count=3D0
>> realtime =3Dnone =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 extsz=3D4096 =A0 bl=
ocks=3D0, rtextents=3D0
>> xfs_growfs: XFS_IOC_FSGROWFSDATA xfsctl failed: Argument list too long
>>
>> OS/Kernel Info:
>> Debian Lenny
>> Linux bigmama 2.6.30-2-686-bigmem #1 SMP Sat Sep 26 02:30:18 UTC 2009
>> i686 GNU/Linux
>
> Filesystems >16TB aren't supported on 32-bit machines - it looks like
> your growfs is going to exceed that limit. Time to upgrade! ;)
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
