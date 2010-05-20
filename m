Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4KLjnSY229707 for <xfs@oss.sgi.com>; Thu, 20 May 2010 16:45:49 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CA34E141B788
	for <xfs@oss.sgi.com>; Thu, 20 May 2010 14:48:07 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id n0z3vgElil4fj9kC for
	<xfs@oss.sgi.com>; Thu, 20 May 2010 14:48:07 -0700 (PDT)
Message-ID: <4BF5AE16.6060403@sandeen.net>
Date: Thu, 20 May 2010 16:48:06 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: mkfs.xfs -n ci - error?
References: <4BF5AC35.7050909@tlinx.org>
In-Reply-To: <4BF5AC35.7050909@tlinx.org>
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
To: "Linda A. Walsh" <xfs@tlinx.org>
Cc: xfs-oss <xfs@oss.sgi.com>

On 05/20/2010 04:40 PM, Linda A. Walsh wrote:
> I'm trying to use the "-n ci" option on a volume, but get an error where =
it tells me
> the correct syntax is "-n ci".  Am I missing something?
> =

> mkfs.xfs -i maxpct=3D5 -n ci -l size=3D32704b,lazy-count=3D1 -d su=3D64k,=
sw=3D4 -L Backup -f /dev/Space/Backup =

> unknown option -n ci
> Usage: mkfs.xfs
> /* blocksize */         [-b log=3Dn|size=3Dnum]
> /* data subvol */       [-d agcount=3Dn,agsize=3Dn,file,name=3Dxxx,size=
=3Dnum,
>                             (sunit=3Dvalue,swidth=3Dvalue|su=3Dnum,sw=3Dn=
um),
>                             sectlog=3Dn|sectsize=3Dnum
> /* inode size */        [-i log=3Dn|perblock=3Dn|size=3Dnum,maxpct=3Dn,at=
tr=3D0|1|2]
> /* log subvol */        [-l agnum=3Dn,internal,size=3Dnum,logdev=3Dxxx,ve=
rsion=3Dn
>                             sunit=3Dvalue|su=3Dnum,sectlog=3Dn|sectsize=
=3Dnum,
>                             lazy-count=3D0|1]
> /* label */             [-L label (maximum 12 characters)]
> /* naming */            [-n log=3Dn|size=3Dnum,version=3D2|ci]
>                         ^^^^                        ^^^

-n version=3Dci

from the man page:

version=3Dvalue
        The  naming (directory) version value can be either 2 or =92ci=92,
        defaulting to 2 if unspecified.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
