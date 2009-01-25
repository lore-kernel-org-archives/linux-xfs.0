Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0PELjY7131824 for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 08:21:45 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3FD441BAB734
	for <xfs@oss.sgi.com>; Sun, 25 Jan 2009 06:21:01 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id 6YqKaqJJdLEDwmfM for
	<xfs@oss.sgi.com>; Sun, 25 Jan 2009 06:21:01 -0800 (PST)
Message-ID: <497C754C.5090004@sandeen.net>
Date: Sun, 25 Jan 2009 08:21:00 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs spec file update
References: <1232777667.13684.20.camel@verge.scott.net.au>
In-Reply-To: <1232777667.13684.20.camel@verge.scott.net.au>
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
To: Nathan Scott <nscott@aconex.com>
Cc: xfs@oss.sgi.com

Nathan Scott wrote:
> Since binaries have moved between xfsprogs and xfsdump packages
> in version 3.0.0, we need to fix the dependencies in the rpm
> specfiles, else rpm will complain.
> 
> While in there, remove xfs-cmds Provides/Obsoletes lines, there
> is no way anyone is ever going to be requiring those anymore (no
> real-world upgrade path having such old skool SGI-released rpms).

Seems fine to me, though before I update Fedora to the next version I'll
probably pass the notion past the true RPM gurus to be sure :)

Reviewed-by: Eric Sandeen <sandeen@sandeen.net>

> diff --git a/build/rpm/xfsprogs.spec.in b/build/rpm/xfsprogs.spec.in
> index 2826a37..cf61225 100644
> --- a/build/rpm/xfsprogs.spec.in
> +++ b/build/rpm/xfsprogs.spec.in
> @@ -5,10 +5,8 @@ Release: @pkg_release@
>  Distribution: @pkg_distribution@
>  Packager: Silicon Graphics, Inc. <http://www.sgi.com/>
>  BuildRoot: @build_root@ 
> -Provides: xfs-cmds
> -Obsoletes: xfs-cmds
>  Prereq: /sbin/ldconfig
> -Conflicts: xfsdump < 2.0.0
> +Conflicts: xfsdump < 3.0.0
>  Source: @pkg_name@-@pkg_version@.src.tar.gz
>  License: GPL
>  Vendor: Silicon Graphics, Inc.
> @@ -32,8 +30,8 @@ with the IRIX version of XFS.
>  %package devel
>  Summary: XFS filesystem-specific static libraries and headers.
>  Group: Development/Libraries
> -Requires: @pkg_name@ >= 2.0.0
> -Conflicts: @pkg_name@ < 2.0.0
> +Requires: @pkg_name@ >= 3.0.0
> +Conflicts: @pkg_name@ < 3.0.0
>  
>  %description devel
>  xfsprogs-devel contains the libraries and header files needed to
> 
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
