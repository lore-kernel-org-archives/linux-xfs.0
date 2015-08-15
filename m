Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 84D8B7CBE
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 13:56:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id DC5C0AC062
	for <xfs@oss.sgi.com>; Sat, 15 Aug 2015 11:56:56 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id HvgbfRfD0YOFA76M for
	<xfs@oss.sgi.com>; Sat, 15 Aug 2015 11:56:53 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: XFS File system in trouble
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <55CF8972.8020306@sandeen.net>
Date: Sat, 15 Aug 2015 19:57:04 +0100
Message-Id: <03EB8070-A6DA-4E55-ACF9-6E0153E84DA0@filmlight.ltd.uk>
References: <20150720111747.GA53450@bfoster.bfoster>	<55B73365.1050908@mygrande.net>	<20150728123307.GC38784@bfoster.bfoster>	<55B79BFD.6020509@mygrande.net>	<20150728221150.GA26604@bfoster.bfoster>	<55BE7C75.4060604@mygrande.net>
	<55C06F41.4030502@mygrande.net>	<20150804224240.GU16638@dastard>	<55C8006C.8070807@mygrande.net>
	<55CC375C.10902@mygrande.net>	<20150814012635.GT3902@dastard>
	<55CE75CA.5070506@mygrande.net>
	<74DC7EBF-0029-4E5E-9D96-DF193E2BE83F@filmlight.ltd.uk>
	<55CF8972.8020306@sandeen.net>
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


On 15 Aug 2015, at 19:48, Eric Sandeen <sandeen@sandeen.net> wrote:

> On 8/15/15 7:28 AM, Roger Willcocks wrote:
>> xfs_repair 3.2.1 runs cleanly.
>> =

>> xfs_repair 3.1.1 complains about a load of stuff, including:
> =

> I wouldn't expect v3.1.1 to work at all, because:
> =

> # db/xfs_db -V
> xfs_db version 4.2.0-rc1
> # db/xfs_db /mnt/test2/leslie/md0.img -c version
> versionnum [0xbdb4+0x8a] =3D V4,NLINK,DIRV2,ATTR,ALIGN,DALIGN,LOGV2,EXTFL=
G,SECTOR,MOREBITS,ATTR2,LAZYSBCOUNT,PROJID32BIT
> =

> the filesystem has 32-bit project IDs, and:
> =

> # git log --oneline | grep -i "projid32bit"
> dd536e1 xfsprogs: Note projid32bit default change in mkfs.xfs manpage
> 22bc10e xfsprogs: projid32bit handling
> =

> # git describe --contains 22bc10e
> v3.1.4~2
> =

> that feature support didn't show up until v3.1.4.  Were you running a sto=
ck v3.1.1?
> =

> Anyway, in my testing, up to v3.2.0, repair finds a lot of errors (and sp=
ends some
> time looking for a proper superblock)
> =

> v3.2.1 finds no errors.
> =


And there=92s the problem, (since XFS_SB_VERSION2_CRCBIT is not set)
 xfs-repair-3.2.1 should spot and fix the v3 inode.

repair/dinode.c (tip) only checks for (line 2335 or so):

    (xfs_sb_version_hascrc(&mp->m_sb) && dino->di_version < 3)

not a non-crc filesystem with version >=3D 3.

Adding the missing check:

   || (! xfs_sb_version_hascrc(&mp->m_sb) && dino->di_version >=3D 3) =


allows 3.2.1 to spot and fix the broken inode.

=97
Roger


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
