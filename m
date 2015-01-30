Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 11DDA800A
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2015 08:38:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 00BFE8F808E
	for <xfs@oss.sgi.com>; Fri, 30 Jan 2015 06:38:36 -0800 (PST)
Received: from mailserver.inist.fr (mailserver.inist.fr [193.54.107.40]) by
	cuda.sgi.com with ESMTP id wxzWc2HrXtCgICsl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 30 Jan 2015 06:38:34 -0800 (PST)
From: "SCHEFFER, Philippe" <Philippe.SCHEFFER@inist.fr>
Date: Fri, 30 Jan 2015 15:37:11 +0100
Subject: RE : RE : xfs_repair fails with corrupt dinode
Message-ID: <587A9635632B174A943E53AF3B58A9082E3C81A6FD@vanda>
References: <587A9635632B174A943E53AF3B58A9082E3BE068CE@vanda>
	<20150129231538.GE6282@dastard>
	<587A9635632B174A943E53AF3B58A9082E3C81A6FB@vanda>,
	<20150130055232.GB4251@dastard>
In-Reply-To: <20150130055232.GB4251@dastard>
Content-Language: fr-FR
MIME-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Successful with xfs_repair 3.1.9. Thanks!
All data are in lost+found, But before the xfs_repair, it was already the c=
ase.
A probable consequence of the original problem.

Philippe
________________________________________
De : Dave Chinner [david@fromorbit.com]
Date d'envoi : vendredi 30 janvier 2015 06:52
=C0 : SCHEFFER, Philippe
Cc : xfs@oss.sgi.com
Objet : Re: RE : xfs_repair fails with corrupt dinode

On Fri, Jan 30, 2015 at 01:42:07AM +0100, SCHEFFER, Philippe wrote:
> xfs_repair -p log in attached file.
>
> Philippe
> ________________________________________
> De : Dave Chinner [david@fromorbit.com]
> Date d'envoi : vendredi 30 janvier 2015 00:15
> =C0 : SCHEFFER, Philippe
> Cc : xfs@oss.sgi.com
> Objet : Re: xfs_repair fails with corrupt dinode
>
> On Thu, Jan 29, 2015 at 04:48:15PM +0100, SCHEFFER, Philippe wrote:
> > Hi,
> >
> > I have a corrupted xfs filesytem. When I try to repair I get this error=
 :
> > disconnected inode 1427919, moving to lost+found
> > corrupt dinode 1427919, extent total =3D 1, nblocks =3D 0.  This is a b=
ug.
> > Please capture the filesystem metadata with xfs_metadump and
> > report it to xfs@oss.sgi.com.
> > cache_node_purge: refcount was 1, not zero (node=3D0x1f6c19620)
> >
> > fatal error -- 117 - couldn't iget disconnected inode
> >
> > I captured metada with xfs_metadump but the file is 1,4Gb long. I can't=
 send it to you.
> >
> > I printed inode1427919 :
> >
> > xfs_db> inode 1427919
> > xfs_db> print
> > core.magic =3D 0x494e
> ....
> > core.format =3D 2 (extents)
> ....
> > core.size =3D 2536
> > core.nblocks =3D 1
> > core.extsize =3D 0
> > core.nextents =3D 1
> ....
> > u.bmx[0] =3D [startoff,startblock,blockcount,extentflag] 0:[0,320660992=
,1,0]
>
> That's an inode with one extent of one block and looks perfectly
> valid. We'll need the entire output of the xfs_repair run to see if
> there were any prior actions taken on that inode by xfs_repair....

As i pointed out to Brian on IRC earlier:

data fork in regular inode 1427919 claims used block 320660992
correcting nblocks for inode 1427919, was 1 - counted 0

So it looks like the inode has a cross linked block, repair dropped
the block count by that one block, and then failed to remove the
extent from the inode. So, a repair bug, that was...

commit e1f43b4c701b24d9b5bc85df858a8c36f0f0723b
Author: Christoph Hellwig <hch@infradead.org>
Date:   Thu Feb 2 07:39:10 2012 -0500

    repair: update extent count after zapping duplicate blocks

    When we find a duplicate extent in an extern format inode we do not zap
    the whole inode, but just truncate it to the point where the duplicate
    extent was found.  But the current code only updates di_nblocks for the
    new size, but no di_nextents/di_anextents.  In most cases this isn't no=
ticed,
    but when moving such an inode to the lost+found directoy the consistency
    check in xfs_iformat trips over it.  Fix this by updating the on-disk
    extent count as part of the inode repair.

    Note that we zap btree format inodes with duplicate block completely
    at this point, so this fix doesn't apply to them.

    Reviewed-by: Mark Tinguely <tinguely@sgi.com>
    Reported-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
    Tested-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>
    Signed-off-by: Christoph Hellwig <hch@lst.de>

.... fixed the 3 years ago. Upgrade your xfsprogs package and the
problem should go away.

Cheers,

Dave.
--
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
