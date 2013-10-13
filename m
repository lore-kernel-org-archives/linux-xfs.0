Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 95C6E29DFB
	for <xfs@oss.sgi.com>; Sun, 13 Oct 2013 16:57:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9F7248F8035
	for <xfs@oss.sgi.com>; Sun, 13 Oct 2013 14:57:12 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	QEnOZxXvN0xjcJLO for <xfs@oss.sgi.com>;
	Sun, 13 Oct 2013 14:57:11 -0700 (PDT)
Date: Mon, 14 Oct 2013 08:57:08 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH RESEND] xfstests: Incorrect check for gdbm/ndbm.h
Message-ID: <20131013215708.GF5663@dastard>
References: <1381312905-22322-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<1381473751-31534-1-git-send-email-stanislav.kholmanskikh@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1381473751-31534-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Cc: vasily.isaenko@oracle.com, xfs@oss.sgi.com

On Fri, Oct 11, 2013 at 10:42:31AM +0400, Stanislav Kholmanskikh wrote:
> Current version of AC_PACKAGE_WANT_NDBM has following bugs:
> * a typo (',') next to 'gdbm/ndbm.h', so C compiler fails
>   with a syntax error when trying to compile
>   "#include <gdbm/ndbm.h,>"
> 
> * autoconf never defines HAVE_GDBM_NDBM_H_ because it
>   converts both header names (gdbm/ndbm.h, gdbm-ndbm.h)
>   to GDBM_NDBM_H
> 
> Because of these bugs 'dbtest' can't be compiled on systems where
> 'gdbm-ndbm.h' header is absent but 'gdbm/ndbm.h' is present.
> 
> Fixed this.
> 
> Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> ---
>  m4/package_gdbmdev.m4 |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/m4/package_gdbmdev.m4 b/m4/package_gdbmdev.m4
> index c07f75d..a57e3a2 100644
> --- a/m4/package_gdbmdev.m4
> +++ b/m4/package_gdbmdev.m4
> @@ -19,7 +19,18 @@ AC_DEFUN([AC_PACKAGE_WANT_NDBM],
>    ])
>  
>  AC_DEFUN([AC_PACKAGE_WANT_GDBM],
> -  [ AC_CHECK_HEADERS([gdbm/ndbm.h, gdbm-ndbm.h], [ have_db=true ], [ have_db=false ])
> +  [ AC_CHECK_HEADER(gdbm-ndbm.h, [ gdbm_ndbm=true; have_db=true ], [ gdbm_ndbm=false; have_db=false ])
> +
> +    if test $gdbm_ndbm = true; then
> +        AC_DEFINE(HAVE_GDBM_NDBM_H, [1], [Define to 1 if you have the <gdbm-ndbm.h> header file.])
> +    else
> +	AS_UNSET([ac_cv_header_gdbm_ndbm_h])

Whitespace problem here.

Otherwise it looks fine.

Acked-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
