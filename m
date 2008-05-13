Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 12 May 2008 17:57:29 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4D0vHW1003257
	for <xfs@oss.sgi.com>; Mon, 12 May 2008 17:57:21 -0700
Subject: Re: [patch] xfsqa - fix 17[5-7] "unmount" typo
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <20080513005436.GQ155679365@sgi.com>
Date: Tue, 13 May 2008 10:58:15 +1000
Message-ID: <op.ua2ibdp63jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <20080513005436.GQ155679365@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Tue, 13 May 2008 10:54:36 +1000, David Chinner <dgc@sgi.com> wrote:

> 177 fails because mkfs tries to run on a mounted filesystem.
> All 17[5-7] have the same problem - "unmount" is not the command
> to unmount a filesystem.

Looks fine (or looks fie).

> Signed-off-by: Dave Chinner <dgc@sgi.com>
> ---
>  xfstests/175 |    2 +-
>  xfstests/176 |    2 +-
>  xfstests/177 |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> Index: xfs-cmds/xfstests/175
> ===================================================================
> --- xfs-cmds.orig/xfstests/175	2008-05-08 09:59:28.000000000 +1000
> +++ xfs-cmds/xfstests/175	2008-05-13 10:50:01.581533095 +1000
> @@ -40,7 +40,7 @@ _require_scratch
> # test that we have DMAPI support
>  _dmapi_scratch_mount
> -unmount $SCRATCH_MNT > /dev/null 2>&1
> +umount $SCRATCH_MNT > /dev/null 2>&1
> # _test_punch args: blksize extsize_hint filesize "pp1 pp2 pp3" \
>  # 					"ps1 ps2 ps3" "pt1 pt2 pt3" "wp1 wp2" "ws1 ws2" \
> Index: xfs-cmds/xfstests/176
> ===================================================================
> --- xfs-cmds.orig/xfstests/176	2008-05-08 09:59:28.000000000 +1000
> +++ xfs-cmds/xfstests/176	2008-05-13 10:50:05.281061350 +1000
> @@ -38,7 +38,7 @@ _require_scratch
> # test that we have DMAPI support
>  _dmapi_scratch_mount
> -unmount $SCRATCH_MNT > /dev/null 2>&1
> +umount $SCRATCH_MNT > /dev/null 2>&1
> # _test_punch args: blksize extsize_hint filesize "pp1 pp2 pp3" \
>  # 					"ps1 ps2 ps3" "pt1 pt2 pt3" "wp1 wp2" "ws1 ws2" \
> Index: xfs-cmds/xfstests/177
> ===================================================================
> --- xfs-cmds.orig/xfstests/177	2008-05-08 09:59:28.000000000 +1000
> +++ xfs-cmds/xfstests/177	2008-05-13 10:49:58.181966589 +1000
> @@ -40,7 +40,7 @@ _require_scratch
> # test that we have DMAPI support
>  _dmapi_scratch_mount
> -unmount $SCRATCH_MNT > /dev/null 2>&1
> +umount $SCRATCH_MNT > /dev/null 2>&1
> _scratch_mkfs_xfs >/dev/null 2>&1 \
>          || _fail "mkfs failed"
