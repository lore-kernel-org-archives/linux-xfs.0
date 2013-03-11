Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 36EC77F37
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 17:19:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 10DE1304059
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 15:19:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	29XdECiWGi6qccM2 for <xfs@oss.sgi.com>;
	Mon, 11 Mar 2013 15:19:38 -0700 (PDT)
Date: Tue, 12 Mar 2013 09:19:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Maximum file system size of XFS?
Message-ID: <20130311221936.GD21651@dastard>
References: <20130309215121.0e614ef8@thinky>
	<201303112245.40522.Martin@lichtvoll.de>
	<201303112257.00798.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201303112257.00798.Martin@lichtvoll.de>
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
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: Pascal <pa5ca1@gmx.de>, xfs@oss.sgi.com

On Mon, Mar 11, 2013 at 10:57:00PM +0100, Martin Steigerwald wrote:
> Am Montag, 11. M=E4rz 2013 schrieb Martin Steigerwald:
> > 2) Create a insanely big sparse file
> > =

> > merkaba:~> truncate -s1E /mnt/zeit/evenmorecrazy.img
> > merkaba:~> ls -lh /mnt/zeit/evenmorecrazy.img
> > -rw-r--r-- 1 root root 1,0E M=E4r 11 22:37 /mnt/zeit/evenmorecrazy.img
> > =

> > (No, this won=B4t work with Ext4.)
> =

> Okay, you can=B4t go beyond 8 EiB for a single file which is about what I=
 have =

> read somewhere:

Right - file size offsets max out at 2^63 bytes.

....

> merkaba:/mnt/zeit#5> vgcreate --physicalextentsize 4G  justinsane /dev/lo=
op0 =

> /dev/loop1
>   Volume group "justinsane" successfully created
> =

> merkaba:/mnt/zeit> vgs                                                   =
            =

>   VG         #PV #LV #SN Attr   VSize   VFree =

>   justinsane   2   0   0 wz--n-  14,00e 14,00e
>   merkaba      1   4   0 wz--n- 278,99g  4,85g
> merkaba:/mnt/zeit>
....
> Enough insanity for today :)
> =

> I won=B4t mkfs.xfs on it, the 20 GiB of the just filesystem wouldn=B4t be =

> enough.

Right - I did a mkfs.xfs on a (8EB - 1GB) file a couple of days ago
just to check it worked. I killed it after a short while, because I
didn't feel like needlessly subjecting the SSDs the file was
physically located on to the 25 million sparse sector sized writes
needed for mkfs to complete.

And you can double that number of writes needed for a 16EB
filesystem to be initialised by mkfs. So, theory be damned, even
mkfs.xfs doesn't scale to supporting exabyte filesystems...

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
