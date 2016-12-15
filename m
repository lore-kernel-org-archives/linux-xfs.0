Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.webx.cz ([109.123.222.201]:54713 "EHLO mail.webx.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752067AbcLOUvu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Dec 2016 15:51:50 -0500
From: Libor =?utf-8?B?S2xlcMOhxI0=?= <libor.klepac@bcom.cz>
Subject: Re: [PATCH 3/4] xfs: adjust allocation length in xfs_alloc_space_available
Date: Thu, 15 Dec 2016 21:41:39 +0100
Message-ID: <4769689.jYzaBPWb0Z@libor-nb>
In-Reply-To: <1481644767-9098-4-git-send-email-hch@lst.de>
References: <1481644767-9098-1-git-send-email-hch@lst.de> <1481644767-9098-4-git-send-email-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org

Hello,

On úterý 13. prosince 2016 16:59:26 CET Christoph Hellwig wrote:
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 78 ++++++++
+--------------------------------------
>  fs/xfs/libxfs/xfs_alloc.h |  2 +-
>  2 files changed, 16 insertions(+), 64 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index 91a6c17..87328a8 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -1149,11 +1104,6 @@ xfs_alloc_ag_vextent_near(
>  		XFS_WANT_CORRUPTED_GOTO(args->mp, i == 1, error0);
>  		ASSERT(ltbno + ltlen <= be32_to_cpu(XFS_BUF_TO_AGF(args->agbp)-
>agf_length));
>  		args->len = blen;
> -		if (!xfs_alloc_fix_minleft(args)) {
> -			xfs_btree_del_cursor(cnt_cur, XFS_BTREE_NOERROR);
> -			trace_xfs_alloc_near_nominleft(args);
> -			return 0;
> -		}
>  		blen = args->len;
>  		/*
>  		 * We are allocating starting at bnew for blen blocks.

Doesn't this produce this code?

  		args->len = blen;
  		blen = args->len;


Libor

