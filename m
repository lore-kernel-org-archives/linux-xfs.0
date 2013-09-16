Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D84627F3F
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 17:04:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 344908F80DE
	for <xfs@oss.sgi.com>; Mon, 16 Sep 2013 15:04:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id GNZvHhg6vqxjKZur for <xfs@oss.sgi.com>;
	Mon, 16 Sep 2013 15:03:57 -0700 (PDT)
Message-ID: <5237804C.3090502@sandeen.net>
Date: Mon, 16 Sep 2013 17:03:56 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfsprogs: update version for 3.2.0-alpha1
References: <20130916205637.GD1935@sgi.com>
In-Reply-To: <20130916205637.GD1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: rjohnston@sgi.com, xfs@oss.sgi.com

On 9/16/13 3:56 PM, Ben Myers wrote:
> xfsprogs: update version for 3.2.0-alpha1
> 
> Update the VERSION and doc/CHANGES file for alpha release, 3.2.0-alpha1
> 
> Signed-off-by: Ben Myers <bpm@sgi.com>
> Reviewed-by: Rich Johnston <rjohnston@sgi.com>

Seems fine to me - let's give Dave a chance to chime in too.

Thanks,
-Eric

> ---
>  VERSION      |    4 ++--
>  configure.ac |    2 +-
>  doc/CHANGES  |    4 ++++
>  3 files changed, 7 insertions(+), 3 deletions(-)
> 
> Index: b/VERSION
> ===================================================================
> --- a/VERSION	2013-09-16 15:50:29.544368912 -0500
> +++ b/VERSION	2013-09-16 15:50:37.993732514 -0500
> @@ -2,6 +2,6 @@
>  # This file is used by configure to get version information
>  #
>  PKG_MAJOR=3
> -PKG_MINOR=1
> -PKG_REVISION=11
> +PKG_MINOR=2
> +PKG_REVISION=0-alpha1
>  PKG_BUILD=1
> Index: b/configure.ac
> ===================================================================
> --- a/configure.ac	2013-09-16 15:54:14.394338104 -0500
> +++ b/configure.ac	2013-09-16 15:54:37.154377546 -0500
> @@ -1,4 +1,4 @@
> -AC_INIT([xfsprogs], [3.1.11])
> +AC_INIT([xfsprogs], [3.2.0-alpha1])
>  AC_PREREQ(2.50)
>  AC_CONFIG_AUX_DIR([.])
>  AC_CONFIG_MACRO_DIR([m4])
> Index: b/doc/CHANGES
> ===================================================================
> --- a/doc/CHANGES	2013-09-16 15:50:13.683773140 -0500
> +++ b/doc/CHANGES	2013-09-16 15:55:58.379446313 -0500
> @@ -1,3 +1,7 @@
> +xfsprogs-3.2.0-alpha1 (16 Sep 2013)
> +	- Alpha release for the purpose of testing the CRC feature during the
> +	  v3.12 kernel -rc series.
> +
>  xfsprogs-3.1.11 (8 May 2013)
>  	- Support for relative paths in xfs_quota thanks to Satoru Takeuchi.
>  	- mkfs.xfs will always go into multidisk mode when filesystem
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
