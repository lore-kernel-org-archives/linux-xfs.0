Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3UHV8Zd176362 for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 12:31:08 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2573C1DE15D2
	for <xfs@oss.sgi.com>; Fri, 30 Apr 2010 10:33:13 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id 0ysneQe7W7Ncjw32 for
	<xfs@oss.sgi.com>; Fri, 30 Apr 2010 10:33:13 -0700 (PDT)
Message-ID: <4BDB1459.90505@sandeen.net>
Date: Fri, 30 Apr 2010 12:33:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: stripe unit/width, inode64, misc mkfs.xfs params
References: <133AD8A0-119B-4A41-9AF6-46F43111A941@facebook.com>
In-Reply-To: <133AD8A0-119B-4A41-9AF6-46F43111A941@facebook.com>
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
To: Peter Merelis <merelis@facebook.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Peter Merelis wrote:
> Hi,
>  =

> Apologies in advance as I imagine this issue is raised frequently, but ca=
n someone familiar with these sorts of things sanity check my stripe unit/w=
idth settings since the underlying storage controller is not exposing the d=
ata to mkfs.xfs apparently:
>  =

> 12 disk raid6
> 256k stripe
>  =

> su=3D256k
> sw=3D10

sounds right

> =85which I believe is equivalent to:
>  =

> sunit=3D512
> swidth=3D5120
>  =

> Is that correct?

probably, but FWIW su/sw might be easier since it deals in byte / multiplie=
r units.


> Also, does the inode64 option make sense for a filesystem with only a few=
 files, each around ~100G?

for a large filesystem, yes, if your userspace can cope.

> And finally, are 'allocsize=3D1GB,nobarrier,noatime,nodiratime' recommend=
ed mount options?

no mount options are recommended without more information about the load ;)

nobarrier is only recommended if the storage has a battery-backed cache (or=
 no cache)

allocsize=3D1GB is probably ok if you really are only writing large files a=
nd have
fragmentation problems

noatime,nodiratime probably don't matter much at all.

-Eric

> Thanks,
> Peter
>  =

> =

> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
