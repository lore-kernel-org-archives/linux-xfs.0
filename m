Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pAELpAKm246227 for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 15:51:11 -0600
Received: from busoni.debian.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A269E1E9C85B
	for <xfs@oss.sgi.com>; Mon, 14 Nov 2011 13:51:06 -0800 (PST)
Received: from busoni.debian.org (busoni.debian.org [140.211.15.34]) by
	cuda.sgi.com with ESMTP id o91SByNj6GgwQfGx for
	<xfs@oss.sgi.com>; Mon, 14 Nov 2011 13:51:06 -0800 (PST)
Subject: Bug#553875: fixed in xfsprogs 3.1.6
Resent-To: debian-bugs-dist@lists.debian.org
Resent-Message-ID: <handler.553875.B553875.132130733618844@bugs.debian.org>
Date: Mon, 14 Nov 2011 22:48:50 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
Message-ID: <20111114214850.GA16572@volta.aurel32.net>
References: <E1ROjxS-0007Tc-0c@franck.debian.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <E1ROjxS-0007Tc-0c@franck.debian.org>
Reply-To: Aurelien Jarno <aurelien@aurel32.net>, 553875@bugs.debian.org
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
To: Nathan Scott <nathans@debian.org>
Cc: 553875@bugs.debian.org

not-fixed 553875 3.1.6
found 553875 3.1.6
thanks

On Fri, Nov 11, 2011 at 05:47:22AM +0000, Nathan Scott wrote:
> Source: xfsprogs
> Source-Version: 3.1.6
> 
> We believe that the bug you reported is fixed in the latest version of
> xfsprogs, which is due to be installed in the Debian FTP archive:
> 
> xfslibs-dev_3.1.6_i386.deb
>   to main/x/xfsprogs/xfslibs-dev_3.1.6_i386.deb
> xfsprogs-udeb_3.1.6_i386.udeb
>   to main/x/xfsprogs/xfsprogs-udeb_3.1.6_i386.udeb
> xfsprogs_3.1.6.dsc
>   to main/x/xfsprogs/xfsprogs_3.1.6.dsc
> xfsprogs_3.1.6.tar.gz
>   to main/x/xfsprogs/xfsprogs_3.1.6.tar.gz
> xfsprogs_3.1.6_i386.deb
>   to main/x/xfsprogs/xfsprogs_3.1.6_i386.deb
> 
> 
> 
> A summary of the changes between this version and the previous one is
> attached.
> 
> Thank you for reporting the bug, which will now be closed.  If you
> have further comments please address them to 553875@bugs.debian.org,
> and the maintainer will reopen the bug report if appropriate.
> 
> Debian distribution maintenance software
> pp.
> Nathan Scott <nathans@debian.org> (supplier of updated xfsprogs package)
> 
> (This message was generated automatically at their request; if you
> believe that there is a problem with it please contact the archive
> administrators by mailing ftpmaster@debian.org)
> 
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Format: 1.8
> Date: Wed, 11 Oct 2011 16:47:10 +1100
> Source: xfsprogs
> Binary: xfsprogs xfslibs-dev xfsprogs-udeb
> Architecture: source i386
> Version: 3.1.6
> Distribution: unstable
> Urgency: low
> Maintainer: XFS Development Team <xfs@oss.sgi.com>
> Changed-By: Nathan Scott <nathans@debian.org>
> Description: 
>  xfslibs-dev - XFS filesystem-specific static libraries and headers
>  xfsprogs   - Utilities for managing the XFS filesystem
>  xfsprogs-udeb - A stripped-down version of xfsprogs, for debian-installer (udeb)
> Closes: 553875
> Changes: 
>  xfsprogs (3.1.6) unstable; urgency=low
>  .
>    * New upstream release
>    * Handle upcoming libreadline5-dev removal (closes: #553875)

This new version basically replaced the build-depends on
  libreadline-gplv2-dev
by a build-depends on 
  libreadline5-dev | libreadline-gplv2-dev

Given libreadline5-dev is not in the archive, the package can't be
built, and the bug is still there. Reopening it, marking 3.1.6 as
non-fixed.

-- 
Aurelien Jarno                          GPG: 1024D/F1BCDB73
aurelien@aurel32.net                 http://www.aurel32.net


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
