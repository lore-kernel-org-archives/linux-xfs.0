Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA9DcLSt156465 for <xfs@oss.sgi.com>; Tue, 9 Nov 2010 07:38:21 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4D2481C280BE
	for <xfs@oss.sgi.com>; Tue,  9 Nov 2010 05:39:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id l7uHl1QfYauHHI5f for
	<xfs@oss.sgi.com>; Tue, 09 Nov 2010 05:39:49 -0800 (PST)
Date: Tue, 9 Nov 2010 08:39:48 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfsprogs: update deb package maintainer, bump version
Message-ID: <20101109133948.GB2066@infradead.org>
References: <318337928.18811289303806950.JavaMail.root@acxmail-au2.aconex.com>
	<247647061.18861289303840801.JavaMail.root@acxmail-au2.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <247647061.18861289303840801.JavaMail.root@acxmail-au2.aconex.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: nathans@aconex.com
Cc: Anibal Monsalve Salazar <anibal@debian.org>, xfs <xfs@oss.sgi.com>

On Tue, Nov 09, 2010 at 10:57:20PM +1100, nathans@aconex.com wrote:
> Update xfsprogs Debian maintainer annotation, bump version.
> ???? ??
> Signed-off-by: Nathan Scott <nathans@debian.org>

Looks good except for lots of weird chacaters which hopefully only
happen in the mail and not the actual patch.

Alex has various outstanding xfs_metadump updates, can you coordinate
the release with him, as it might be worth picking those up?

> diff --git a/VERSION b/VERSION
> index 58a77e2..e68ef43 100644
> --- a/VERSION
> +++ b/VERSION
> @@ -3,5 +3,5 @@
> ??#
> ??PKG_MAJOR=3
> ??PKG_MINOR=1
> -PKG_REVISION=3
> +PKG_REVISION=4
> ??PKG_BUILD=1
> diff --git a/debian/changelog b/debian/changelog
> index 24e5c20..1ce0b7e 100644
> --- a/debian/changelog
> +++ b/debian/changelog
> @@ -1,3 +1,11 @@
> +xfsprogs (3.1.4) unstable; urgency=low
> +
> + ??* New upstream release (32 projid resolution, fsr uses /proc/mounts)
> + ??* Annotate Debian packages as being team maintained now.
> + ??* Resolve Lenny upgrade issue with xfsdump (closes: #601988, #601710)
> +
> + -- Nathan Scott <nathans@debian.org> ??Tue, 09 Nov 2010 22:39:04 +1100
> +
> ??xfsprogs (3.1.3) unstable; urgency=low
> ??
> ???? * New upstream release
> diff --git a/debian/control b/debian/control
> index f429434..401cdab 100644
> --- a/debian/control
> +++ b/debian/control
> @@ -1,8 +1,8 @@
> ??Source: xfsprogs
> ??Section: admin
> ??Priority: optional
> -Maintainer: Nathan Scott <nathans@debian.org>
> -Uploaders: Anibal Monsalve Salazar <anibal@debian.org>
> +Maintainer: XFS Development Team <xfs@oss.sgi.com>
> +Uploaders: Nathan Scott <nathans@debian.org>, Anibal Monsalve Salazar <anibal@debian.org>
> ??Build-Depends: uuid-dev, autoconf, debhelper (>= 5), gettext, libtool, libreadline5-dev, libblkid-dev (>= 2.17)
> ??Standards-Version: 3.9.1
> ??Homepage: http://oss.sgi.com/projects/xfs/
> diff --git a/doc/CHANGES b/doc/CHANGES
> index 4ae94d6..fc42eba 100644
> --- a/doc/CHANGES
> +++ b/doc/CHANGES
> @@ -1,3 +1,10 @@
> +xfsprogs-3.1.4 (9 November 2010)
> +????????????????- Add projid32bit handling to userspace, resolving type
> +???????????????? ??sizing issues when dealing with 32 bit project ids.
> +????????????????- Make xfs_fsr use /proc/mounts if available.
> +????????????????- Annotate that Debian packages are group maintained.
> +????????????????- Fix a Debian packaging issue causing upgrade pain.
> +
> ??xfsprogs-3.1.3 (26 August 2010)
> ??????????????????- Add xfs_io support for XFS_IOC_ZERO_RANGE
> ??????????????????- Fix depend targets.
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
---end quoted text---

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
