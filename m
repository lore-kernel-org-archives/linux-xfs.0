Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3AKiTVe207845 for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 15:44:29 -0500
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id hst4PSnHEhKd3IBd
	for <xfs@oss.sgi.com>; Tue, 10 Apr 2012 13:44:29 -0700 (PDT)
Message-ID: <4F849BAE.6070901@hardwarefreak.com>
Date: Tue, 10 Apr 2012 15:44:30 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: XFS: Abysmal write performance because of excessive seeking
	(allocation groups to blame?)
References: <CAAxjCEwBMbd0x7WQmFELM8JyFu6Kv_b+KDe3XFqJE6shfSAfyQ@mail.gmail.com>
	<20120405213740.GA22824@infradead.org>
	<CAAxjCExBcaB6J-u7ivZKWnKiF7oP10JRxzKzQNRuppHkTE2Tzw@mail.gmail.com>
	<201204072057.38286.Martin@lichtvoll.de>
	<CAAxjCEzRa7CpbA9iESEDjmWQMsJTjkWHJj69ADOXDa4CiRpx3w@mail.gmail.com>
In-Reply-To: <CAAxjCEzRa7CpbA9iESEDjmWQMsJTjkWHJj69ADOXDa4CiRpx3w@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Stefan Ring <stefanrin@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On 4/10/2012 9:02 AM, Stefan Ring wrote:
>> And is XFS aligned to the RAID 6?
>>
>> What does xfs_info display on it?
> =

> Yes, it=92s aligned.
> =

> meta-data=3D/dev/mapper/vg_data-lvhome =


Is the LVM volume aligned to the RAID stripe?  Is their a partition atop
the RAID LUN and under LVM?  Is the partition aligned?  Why LVM anyway?

>                                  isize=3D256    agcount=3D4, agsize=3D732=
33656 blks
>          =3D                       sectsz=3D512   attr=3D2
> data     =3D                       bsize=3D4096   blocks=3D292934624, ima=
xpct=3D5
>          =3D                       sunit=3D8      swidth=3D32 blks
> naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> log      =3Dinternal               bsize=3D4096   blocks=3D143040, versio=
n=3D2
>          =3D                       sectsz=3D512   sunit=3D8 blks, lazy-co=
unt=3D1
> realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> =

> I changed the stripe size to 32kb in the meantime. This way, it
> performs slightly better.

The devil is always in the details.  Were you using partitions and LVM
with the RAID1 concat tesing?  With the free space testing?

I assumed you were directly formatting the LUN with XFS.  With LVM and
possibly partitions involved here, that could explain some of the
mediocre performance across the board, with both EXT4 and XFS.  If one
wants maximum performance from their filesystem, one should typically
stay away from partitions and LVM, and any other layers that can slow IO
down.

-- =

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
