Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D5CBD7CBE
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 14:13:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 898FF8F8166
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 12:13:42 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id O8CrrbXRITkRiXEY for
	<xfs@oss.sgi.com>; Sat, 15 Aug 2015 12:13:39 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: XFS File system in trouble
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <55CF8C4F.1080906@sandeen.net>
Date: Sat, 15 Aug 2015 20:13:22 +0100
Message-Id: <9C6B4EAF-42A1-4952-AB4E-2FFCA35D0973@filmlight.ltd.uk>
References: <20150720111747.GA53450@bfoster.bfoster>	<55B73365.1050908@mygrande.net>	<20150728123307.GC38784@bfoster.bfoster>	<55B79BFD.6020509@mygrande.net>	<20150728221150.GA26604@bfoster.bfoster>	<55BE7C75.4060604@mygrande.net>	<55C06F41.4030502@mygrande.net>	<20150804224240.GU16638@dastard>	<55C8006C.8070807@mygrande.net>	<55CC375C.10902@mygrande.net>	<20150814012635.GT3902@dastard>	<55CE75CA.5070506@mygrande.net>	<74DC7EBF-0029-4E5E-9D96-DF193E2BE83F@filmlight.ltd.uk>
	<55CF8972.8020306@sandeen.net> <55CF8C4F.1080906@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Brian Foster <bfoster@redhat.com>, Kris Rusocki <kszysiu@braxis.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Roger Willcocks <roger@filmlight.ltd.uk>, "Rhorer,
	Leslie" <Leslie.Rhorer@level3.com>, Leslie Rhorer <lrhorer@mygrande.net>


On 15 Aug 2015, at 20:00, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 8/15/15 1:48 PM, Eric Sandeen wrote:
>> On 8/15/15 7:28 AM, Roger Willcocks wrote:
>>> xfs_repair 3.2.1 runs cleanly.
>>> =

>>> xfs_repair 3.1.1 complains about a load of stuff, including:
>> =

>> I wouldn't expect v3.1.1 to work at all, because:
>> ...
> =

> I take that back, a bit:  "errors vs. no errors" was for xfs_repair -n.
> =

> a "full" repair with v3.1.4 shows only:
> =

> # repair/xfs_repair /mnt/test2/leslie/md0.img =

> Phase 1 - find and verify superblock...
> Phase 2 - using internal log
>        - zero log...
>        - scan filesystem freespace and inode maps...
> non-null user quota inode field in superblock 5
> reset bad sb for ag 5
> non-null user quota inode field in superblock 10
> reset bad sb for ag 10
> non-null user quota inode field in superblock 18
> reset bad sb for ag 18
> non-null user quota inode field in superblock 23
> reset bad sb for ag 23
>        - found root inode chunk
> Phase 3 - for each AG...
>        - scan and clear agi unlinked lists...
>        - process known inodes and perform inode discovery...
>        - agno =3D 0
> ...
>        - agno =3D 29
> bad version number 0x3 on inode 124656869424
> bad version number 0x3 on inode 124656869424, resetting version number
> =


Yes, 3.1.1 without =91-n=92 reports fewer errors; I should have mentioned t=
hat. =



> latest git does indeed find no errors; I'll re-check with full repairs to=
 see when the detection stopped, and see if it's a false positive or not.
> =

> -Eric
> =


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
