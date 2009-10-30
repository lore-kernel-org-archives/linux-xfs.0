Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9U5go8j151916 for <xfs@oss.sgi.com>; Fri, 30 Oct 2009 00:42:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F175C8A1CF
	for <xfs@oss.sgi.com>; Thu, 29 Oct 2009 22:43:01 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 2mD16awTo6IZiRyH for
	<xfs@oss.sgi.com>; Thu, 29 Oct 2009 22:43:01 -0700 (PDT)
Date: Fri, 30 Oct 2009 01:43:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: fix up have_xlog_assign_lsn config test
Message-ID: <20091030054300.GA27680@infradead.org>
References: <4ADE80D1.7080408@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4ADE80D1.7080408@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, Oct 20, 2009 at 10:32:33PM -0500, Eric Sandeen wrote:
> Without this we weren't building src/loggen

Looks good to me,


Reviewed-by: Christoph Hellwig <hch@lst.de>

>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---
>
> diff --git a/aclocal.m4 b/aclocal.m4
> index 8a61e39..6e1e672 100644
> --- a/aclocal.m4
> +++ b/aclocal.m4
> @@ -422,10 +422,10 @@ AC_DEFUN([AC_PACKAGE_WANT_XFS_LIBXFS_H],
>   ])
>
> AC_DEFUN([AC_PACKAGE_WANT_XLOG_ASSIGN_LSN],
> -  [
> -    AC_CHECK_DECL(xlog_assign_lsn,
> +  [ AC_CHECK_DECL(xlog_assign_lsn,
>       [ have_xlog_assign_lsn=true ], [ have_xlog_assign_lsn=false ],
>       [[#include <xfs/libxfs.h>]])
> +    AC_SUBST(have_xlog_assign_lsn)
>   ])
>
> AC_DEFUN([AC_PACKAGE_NEED_XFS_XQM_H],
> diff --git a/m4/package_xfslibs.m4 b/m4/package_xfslibs.m4
> index 870882f..f5167a2 100644
> --- a/m4/package_xfslibs.m4
> +++ b/m4/package_xfslibs.m4
> @@ -14,11 +14,10 @@ AC_DEFUN([AC_PACKAGE_WANT_LIBXFS_H],
>   ])
>
> AC_DEFUN([AC_PACKAGE_WANT_XLOG_ASSIGN_LSN],
> -  [
> -    AC_CHECK_DECL(xlog_assign_lsn,
> +  [ AC_CHECK_DECL(xlog_assign_lsn,
>       [ have_xlog_assign_lsn=true ], [ have_xlog_assign_lsn=false ],
>       [[#include <xfs/libxfs.h>]])
> -    AC_SUBST(have_have_xlog_assign_lsn)
> +    AC_SUBST(have_xlog_assign_lsn)
>   ])
>
> AC_DEFUN([AC_PACKAGE_NEED_XFS_XQM_H],
>
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
