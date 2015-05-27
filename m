Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C66F47F50
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 10:55:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 92F5F8F8096
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 08:55:50 -0700 (PDT)
Received: from mail-la0-f49.google.com (mail-la0-f49.google.com
	[209.85.215.49]) by cuda.sgi.com with ESMTP id JWvIHXai20kGiaHE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 27 May 2015 08:55:48 -0700 (PDT)
Received: by laat2 with SMTP id t2so10790170laa.1
	for <xfs@oss.sgi.com>; Wed, 27 May 2015 08:55:47 -0700 (PDT)
Message-ID: <5565EB29.4080200@gmail.com>
Date: Wed, 27 May 2015 18:04:57 +0200
From: Fanael Linithien <fanael4@gmail.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/5] xfs_repair: refuse to run if we don't recognize
	version or feature flags
References: <20150526225126.26434.69010.stgit@birch.djwong.org>	<20150526225132.26434.82404.stgit@birch.djwong.org>	<20150527054536.GB10175@birch.djwong.org>	<5565DAA7.4040406@sandeen.net>	<5565DFEB.9040000@sandeen.net>
	<5565E265.5040202@sandeen.net>
In-Reply-To: <5565E265.5040202@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="windows-1252"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Eric Sandeen <sandeen@sandeen.net>, "Darrick J. Wong" <darrick.wong@oracle.com>, david@fromorbit.com
Cc: xfs@oss.sgi.com

On 2015-05-27 17:27, Eric Sandeen wrote:
>
> I wonder if something like:
>
> 	/* Look for V5 feature flags we don't know about */
> 	if (XFS_SB_VERSION_NUM(sb) >=3D XFS_SB_VERSION_5 &&
> 	    (xfs_sb_has_ro_compat_feature(sb, XFS_SB_FEAT_RO_COMPAT_UNKNOWN) ||
> 	     xfs_sb_has_incompat_feature(sb, XFS_SB_FEAT_INCOMPAT_UNKNOWN) ||
> 	     xfs_sb_has_compat_feature(sb, XFS_SB_FEAT_COMPAT_UNKNOWN))) {
> 		printf("unknown feature flags 0x%x/0x%x/0x%x\n",
> 			sb->sb_features_ro_compat & XFS_SB_FEAT_RO_COMPAT_UNKNOWN,
> 			sb->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_UNKNOWN,
> 			sb->sb_features_compat & XFS_SB_FEAT_COMPAT_UNKNOWN);
> 		...
>
> would suffice, given that the user will need to read code to unerstand th=
e hex
> values, anyway.
> 	=

> Hm, and as Fanael also pointed out, "compat" features ... should be ok, r=
ight,
> and can be removed from the exclusions?

I'm not entirely sure silently ignoring unknown compat features in =

xfs_repair is a good idea. Consider this ext2 example: xattr support is =

a compat flag. It's okay to rw mount a FS with xattrs on some ancient =

(or non-Linux) kernel without xattr support =97 everything will be fine, =

even though there's no way to access them =97 but if the fsck tool doesn't =

understand them, it wouldn't be able to diagnose xattr corruption.

I'd either warn the user about unknown compat features, telling them =

they're on their own if something in the FS is still broken; or barf =

outright.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
