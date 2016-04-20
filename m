Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C51F77CA0
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 15:13:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 700758F8035
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 13:13:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id ggSFFdVQ29AkzyY4 for <xfs@oss.sgi.com>;
	Wed, 20 Apr 2016 13:13:37 -0700 (PDT)
Received: from Liberator.local (unknown [74.203.127.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 55FC92A60
	for <xfs@oss.sgi.com>; Wed, 20 Apr 2016 15:13:37 -0500 (CDT)
Subject: Re: xfs_repair couldn't verify primary superblock
References: <d738a94784a0426e97752f92f38325a0@ul-exc-pr-mbx11.ulaval.ca>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5717E2EF.1080902@sandeen.net>
Date: Wed, 20 Apr 2016 16:13:35 -0400
MIME-Version: 1.0
In-Reply-To: <d738a94784a0426e97752f92f38325a0@ul-exc-pr-mbx11.ulaval.ca>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

On 4/20/16 1:50 PM, St=E9phane Larose wrote:
> Hello,
> =

>  =

> =

> When I try to mount a cleany unmounted XFS filesystem, I get those errors=
 in the log :
> =

> =

> [1650856.121229] XFS (dm-24): Mounting V4 Filesystem
> [1650856.135455] XFS (dm-24): Log inconsistent or not a log (last=3D=3D0,=
 first!=3D1)
> [1650856.135461] XFS (dm-24): empty log check failed
> [1650856.135463] XFS (dm-24): log mount/recovery failed: error 22
> [1650856.135495] XFS (dm-24): log mount failed

You could maybe use xfs_logdump to see what's there, but...

> I have tried xfs_repair but=85
> =

> manitou:~ # xfs_repair /dev/dm-24
> =

> Phase 1 - find and verify superblock...
> couldn't verify primary superblock - not enough secondary superblocks wit=
h matching geometry !!!
> =

> attempting to find secondary superblock...
> ........................................

> After a lot of dots, xfs_repair can=92t find secondary superblocks.
> =

> This is where my knowledge of XFS filesystem stops. Looking at the superb=
lock information, I have a feeling that the primary superblock is fine but =
not the secondary superblocks (strange blocksize and dblocks numbers). Is t=
here any way to copy the primary superblock to the secondary superblocks? M=
aybe this is not a good idea?
> =

> Thank you for any help!
> =


... the stated locations of the backup supers certainly don't contain good =
data:

> xfs_db> sb 1
> xfs_db> p
> magicnum =3D 0xf6b89fbf
> blocksize =3D 1483932129
> dblocks =3D 15694009933101722137
> rblocks =3D 11068626756016902811
> rextents =3D 1593063622148300128
...
> xfs_db> sb 2
> xfs_db> p
> magicnum =3D 0x41474341
> blocksize =3D 1195590471
> dblocks =3D 4847921951085253716
> rblocks =3D 4846789398308864835
> rextents =3D 4702132125296707412
...

which is why it couldn't find any valid/matching backups.  The stated AG si=
ze
does look correct, though, for the overall size of the filesystem as stated
in SB 0.

Is there more to this story?  Did something "interesting" happen with the
underlying storage?  Or with the filesystem prior to this problem?

does "blkid /dev/dm-24" say anything other than "xfs filesystem?"

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
