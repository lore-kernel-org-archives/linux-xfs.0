Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1395LBs048513 for <xfs@oss.sgi.com>; Tue, 3 Feb 2009 03:05:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 13E52DDC28
	for <xfs@oss.sgi.com>; Tue,  3 Feb 2009 01:04:41 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id cLfDEYoWwng4hbFY for
	<xfs@oss.sgi.com>; Tue, 03 Feb 2009 01:04:41 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LUHCz-0000zJ-6E
	for xfs@oss.sgi.com; Tue, 03 Feb 2009 09:04:41 +0000
Date: Tue, 3 Feb 2009 04:04:41 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: a crude release script
Message-ID: <20090203090441.GA24337@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

This is a little script to cut xfsprogs/xfsdump/dmapi releases.  It's
first argument is the respoitory and the second one a temporary
directory.  It should be used on a pristine git repository, and the
version commit and tag need to be pushed out manually.

And yes, this is a hint that we should cut the 3.0.0 releases of
xfsprogs/xfsdump now :)



--cWoXeonUoKmBZSoM
Content-Type: application/x-sh
Content-Disposition: attachment; filename="release.sh"
Content-Transfer-Encoding: quoted-printable

#!/bin/sh=0A#=0A# Script to automate releasing xfsprogs/xfsdump/dmapi=0A#=
=0A# First argument is the git checked out repository of the module to be=
=0A# released. Second argument is a temporary directory.=0A#=0A=0Agitdir=3D=
$1=0Atmpdir=3D$2=0A=0Aif [ "$gitdir" =3D "xfsprogs" -o "$gitdir" =3D "xfspr=
ogs-dev" ]; then=0A    pkg=3D"xfsprogs"=0Aelif [ "$gitdir" =3D "xfsdump" -o=
 "$gitdir" =3D "xfsdump-dev" ]; then=0A    pkg=3D"xfsdump"=0Aelif [ "$gitdi=
r" =3D "dmapi" -o "$gitdir" =3D "dmapi-dev" ]; then=0A    pkg=3D"dmapi"=0Ae=
lse=0A    echo "Invalid package \"$gitdir\"" >&2=0A    exit 1=0Afi=0A=0Aif =
[ -z "$tmpdir" ]; then=0A    echo "usage: $0 module tmpdir" 2>&1=0A    exit=
 1=0Afi=0A=0A. ${gitdir}/VERSION=0A=0Aversion=3D${PKG_MAJOR}.${PKG_MINOR}.$=
{PKG_REVISION}=0Adistdir=3D${pkg}-${version}=0Atarfile=3D${pkg}-${version}.=
tar.gz=0A=0Adate=3D`date +"%-d %B %Y"`=0A=0Aif [ -e ${tmpdir}/${distdir} ];=
 then=0A    echo "${tmpdir}/${distdir} already exists" 2>&1=0A    exit 1=0A=
fi=0A=0Aif [ -e ${tmpdir}/${tarfile} ]; then=0A    echo "${tmpdir}/${tarfil=
e} already exists" 2>&1=0A    exit 1=0Afi=0A=0Aecho "Updating CHANGES"=0Acp=
 $gitdir/doc/CHANGES $tmpdir/CHANGES=0Acat $tmpdir/CHANGES | sed "s/${distd=
ir}.*/${distdir} (${date})/" > $gitdir/doc/CHANGES=0A=0Aecho "Creating ${tm=
pdir}/${distdir}"=0A=0Acp -a $gitdir $tmpdir/$distdir=0Arm -rf $tmpdir/$dis=
tdir/.git=0A=0Aecho "Creating ${tmpdir}/${tarfile}"=0A(cd ${tmpdir} && tar =
chozf ${tarfile} ${distdir})=0A=0Aecho "Removing ${tmpdir}/${distdir}"=0Arm=
 -rf $tmpdir/$distdir/=0A=0Aecho "Commit CHANGES update to git"=0A(cd $gitd=
ir && git-commit -a -m "${version} release")=0A=0Aecho "Tagging git reposit=
ory"=0A(cd $gitdir && git-tag v{$version})=0A
--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--cWoXeonUoKmBZSoM--
