Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E82787F56
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2015 06:34:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D951F8F8040
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2015 04:34:01 -0700 (PDT)
Received: from c.mx.filmlight.ltd.uk (c.mx.filmlight.ltd.uk [54.76.112.217])
	by cuda.sgi.com with ESMTP id eoF1PUg1iLRRkxvq for
	<xfs@oss.sgi.com>; Sun, 16 Aug 2015 04:34:00 -0700 (PDT)
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Subject: Re: [PATCH] v3 inodes are only valid on crc-enabled filesystems.
From: Roger Willcocks <roger@filmlight.ltd.uk>
In-Reply-To: <20150816004242.GA3902@dastard>
Date: Sun, 16 Aug 2015 12:34:10 +0100
Message-Id: <8E58B8D8-39A6-486E-89E7-417A58C28BB4@filmlight.ltd.uk>
References: <C69467E1-642A-422A-8ECF-FDED92550B1B@filmlight.ltd.uk>
	<20150816004242.GA3902@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Roger Willcocks <roger@filmlight.ltd.uk>, xfs@oss.sgi.com


On 16 Aug 2015, at 01:42, Dave Chinner <david@fromorbit.com> wrote:

> On Sun, Aug 16, 2015 at 01:14:55AM +0100, Roger Willcocks wrote:
>> Fix an xfs_repair regression reported by Leslie Rhorer where a bad
>> (v3) inode version number was not reset.
>> =

>> Signed-off-by: Roger Willcocks <roger@filmlight.ltd.uk>
>> =

>> -#define XFS_DINODE_GOOD_VERSION(v)	((v) >=3D 1 && (v) <=3D 3)
>> +#define XFS_DINODE_GOOD_VERSION(sb, v) \
>> +	(xfs_sb_version_hascrc(sb) ? ((v) =3D=3D 3) : ((v) =3D=3D 1 || (v) =3D=
=3D 2))
> =

> I'd make this a static inline function so it gets type checking and
> it is easier to understand the logic at a glance. i.e. something
> like:
> =

> static inline bool
> xfs_dinode_good_version(struct xfs_mount *mp, __uint8_t version)
> {
> 	if (version < 1 || version > 3)
> 		return false;
> 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
> 		if (version !=3D 3)
> 			return false;
> 	} else if (version > 2)
> 		return false;
> =

> 	return true;
> }
> =


include of xfs_dinode.h has to be moved to after the definition of
xfs_mount in libxfs.h, but that=92s okay following the pattern set by
xfs_da_format.h.

Updated patch follows.

=97
Roger

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
