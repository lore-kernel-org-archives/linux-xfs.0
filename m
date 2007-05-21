Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 May 2007 01:10:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4L8A1fB031413
	for <xfs@oss.sgi.com>; Mon, 21 May 2007 01:10:03 -0700
Date: Mon, 21 May 2007 18:14:11 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [PATCH] fix up xfstests a bit for linux+udf
Message-ID: <F928335EB5A7F2983790993C@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <464C871B.3090402@sandeen.net>
References: <464C871B.3090402@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

Thanks, Eric.

We probably should make all ACL/EA tests load up common.attr
(update ones which aren't already - likely the non-acl tests
 as common.attr really has acl stuff at the moment)
and then do the udf/linux test in common.attr.

--Tim

--On 17 May 2007 11:47:23 AM -0500 Eric Sandeen <sandeen@sandeen.net> wrote:

> udf on linux doesn't support acls or attrs, so prevent those tests from running.
>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>
> Index: xfstests/020
> ===================================================================
> --- xfstests.orig/020
> +++ xfstests/020
> @@ -65,7 +65,7 @@ _attr_list()
>    # real QA test starts here
> -_supported_fs xfs udf
> +_supported_fs xfs
>  _supported_os Linux
>   [ -x /usr/bin/attr ] || _notrun "attr is not installed"
> Index: xfstests/051
> ===================================================================
> --- xfstests.orig/051
> +++ xfstests/051
> @@ -56,7 +56,7 @@ _cleanup()
>  #
>   # real QA test starts here
> -_supported_fs xfs udf
> +_supported_fs xfs
>  _supported_os Linux
>   [ -x /usr/bin/chacl ] || _notrun "chacl executable not found"
> Index: xfstests/062
> ===================================================================
> --- xfstests.orig/062
> +++ xfstests/062
> @@ -102,7 +102,7 @@ _create_test_bed()
>  }
>   # real QA test starts here
> -_supported_fs xfs udf nfs
> +_supported_fs xfs nfs
>  _supported_os Linux
>   _require_scratch
> Index: xfstests/070
> ===================================================================
> --- xfstests.orig/070
> +++ xfstests/070
> @@ -33,6 +33,7 @@ _cleanup()
>  _supported_fs xfs udf nfs
>  _supported_os IRIX Linux
>  +[ "$FSTYP" == udf -a "$HOSTOS" == Linux ] && _notrun "Linux UDF does not support extended
> attributes"
>  _setup_testdir
>   $FSSTRESS_PROG \
> Index: xfstests/105
> ===================================================================
> --- xfstests.orig/105
> +++ xfstests/105
> @@ -35,6 +35,8 @@ _cleanup()
>  _supported_fs xfs udf
>  _supported_os IRIX Linux
>  +[ "$FSTYP" == udf -a "$HOSTOS" == Linux ] && _notrun "Linux UDF does not support ACLS"
> +
>  # real QA test starts here
>   rm -f $seq.full
>
