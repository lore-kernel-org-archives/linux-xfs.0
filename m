Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1OALbYd021364 for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 04:21:38 -0600
Received: from mail-bk0-f53.google.com (mail-bk0-f53.google.com
	[209.85.214.53]) by cuda.sgi.com with ESMTP id 7g3vPUAZikFQNmvz
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 24 Feb 2012 02:21:35 -0800 (PST)
Received: by bkcit16 with SMTP id it16so2006257bkc.26
	for <xfs@oss.sgi.com>; Fri, 24 Feb 2012 02:21:34 -0800 (PST)
Message-ID: <4F4764A5.5080809@gmail.com>
Date: Fri, 24 Feb 2012 11:21:25 +0100
From: kadafax@gmail.com
MIME-Version: 1.0
Subject: Re: XFS, empty files after a crash
References: <4F4387A7.2070009@gmail.com>
	<20291.50554.414722.399249@tree.ty.sabi.co.UK>
	<4F445E9F.5030003@sandeen.net>
	<4F4695B1.4060202@houseofnate.net> <4F469C7F.9020208@gmail.com>
	<4F46BA7B.70600@houseofnate.net>
In-Reply-To: <4F46BA7B.70600@houseofnate.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Le 23/02/12 23:15, Nathaniel W. Turner a =E9crit :
> On 02/23/2012 03:07 PM, kadafax@gmail.com wrote:
>>
>>> kfx, try getting the inode number of the file (via stat or ls -i) =

>>> and then doing something like this:
>>>
>>> xfs_db -r $DEV -c "inode $INO" -c "bmap" =

>>
>>
>> # xfs_db -r /dev/sdc1 -c "inode 114748" -c "bmap"
>> data offset 0 startblock 1881705728 (7/2657536) count 6460 flag 0
>>
>> # xfs_db -r /dev/sdc1 -c "inode 114754" -c "bmap"
>> data offset 0 startblock 1077794560 (4/4052736) count 6582 flag 0
>
> If you want to see what's behind those data extents (which are =

> probably partially written), you could do something along these lines:
>
> # Determine the AG size
> agblocks=3D$(xfs_db -r /dev/sdc1 -c sb -c p | grep ^agblocks | sed 's/.* =

> =3D //')
>
> # Copy the extent in the first file, which consists of 6460 blocks =

> (~26MB)
> # in AG 7 starting at AG-relative block 2657536:
> dd if=3D/dev/sdc1 bs=3D4096 skip=3D$(($agblocks * 7 + 2657536)) count=3D6=
460 =

> of=3D./blob
> # examine ./blob

Awesome, it's working for each file with non-null data extents.

I guess that for inode for which the command "xfs_db -r $DEV -c "inode =

$INO" -c "bmap"" returns a null result there is no hope ?

Anyway, thanks a lot Nathaniel !

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
