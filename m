Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Apr 2008 23:57:46 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3N6vY3U028763
	for <xfs@oss.sgi.com>; Tue, 22 Apr 2008 23:57:36 -0700
Message-ID: <480EDE04.5080003@sgi.com>
Date: Wed, 23 Apr 2008 16:58:12 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH, XFSQA] Don't run 175-177 if DMAPI is not supported
References: <20080423013802.GJ103491721@sgi.com>
In-Reply-To: <20080423013802.GJ103491721@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Hi,

_test_punch already does a umount $SCRATCH_MNT.
However, IMHO, it would probably be nicer if one could
use a _require_dmapi or really it may be simpler if
we could roll it into common.dmapi
so one just needs to include common.dmapi and
it would complain at that point if the kernel
didn't support it.

--Tim

David Chinner wrote:
> Don't run tests 175, 176 or 177 if dmapi is not supported by the
> underlying kernel.
> 
> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  xfstests/175 |    5 +++++
>  xfstests/176 |    5 +++++
>  xfstests/177 |    5 +++++
>  3 files changed, 15 insertions(+)
> 
> Index: xfs-cmds/xfstests/175
> ===================================================================
> --- xfs-cmds.orig/xfstests/175	2007-08-24 14:19:48.000000000 +1000
> +++ xfs-cmds/xfstests/175	2008-04-23 11:33:33.727631991 +1000
> @@ -29,6 +29,7 @@ _cleanup()
>  # get standard environment, filters and checks
>  . ./common.rc
>  . ./common.filter
> +. ./common.dmapi
>  . ./common.punch
>  
>  # real QA test starts here
> @@ -37,6 +38,10 @@ _supported_os Linux
>  
>  _require_scratch
>  
> +# test that we have DMAPI support
> +_dmapi_scratch_mount
> +unmount $SCRATCH_MNT > /dev/null 2>&1
> +
>  # _test_punch args: blksize extsize_hint filesize "pp1 pp2 pp3" \
>  # 					"ps1 ps2 ps3" "pt1 pt2 pt3" "wp1 wp2" "ws1 ws2" \
>  #					"w p p w p" resvsp
> Index: xfs-cmds/xfstests/176
> ===================================================================
> --- xfs-cmds.orig/xfstests/176	2007-08-24 14:19:48.000000000 +1000
> +++ xfs-cmds/xfstests/176	2008-04-23 11:33:57.780529656 +1000
> @@ -27,6 +27,7 @@ _cleanup()
>  # get standard environment, filters and checks
>  . ./common.rc
>  . ./common.filter
> +. ./common.dmapi
>  . ./common.punch
>  
>  # real QA test starts here
> @@ -35,6 +36,10 @@ _supported_os Linux
>  
>  _require_scratch
>  
> +# test that we have DMAPI support
> +_dmapi_scratch_mount
> +unmount $SCRATCH_MNT > /dev/null 2>&1
> +
>  # _test_punch args: blksize extsize_hint filesize "pp1 pp2 pp3" \
>  # 					"ps1 ps2 ps3" "pt1 pt2 pt3" "wp1 wp2" "ws1 ws2" \
>  #					"w p p w p" resvsp
> Index: xfs-cmds/xfstests/177
> ===================================================================
> --- xfs-cmds.orig/xfstests/177	2007-10-12 13:50:14.000000000 +1000
> +++ xfs-cmds/xfstests/177	2008-04-23 11:34:38.991214401 +1000
> @@ -27,6 +27,7 @@ _cleanup()
>  # get standard environment, filters and checks
>  . ./common.rc
>  . ./common.filter
> +. ./common.dmapi
>  
>  # real QA test starts here
>  
> @@ -39,6 +40,10 @@ _require_scratch
>  _scratch_mkfs_xfs >/dev/null 2>&1 \
>          || _fail "mkfs failed"
>  
> +# test that we have DMAPI support
> +_dmapi_scratch_mount
> +unmount $SCRATCH_MNT > /dev/null 2>&1
> +
>  _scratch_mount \
>          || _fail "mount failed"
>  
