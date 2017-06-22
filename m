Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47707 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbdFVTrb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Jun 2017 15:47:31 -0400
Date: Thu, 22 Jun 2017 12:47:23 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_db: update sector size when type is set
Message-ID: <20170622194723.GV4733@birch.djwong.org>
References: <20170622193352.22346-1-billodo@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170622193352.22346-1-billodo@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>
Cc: linux-xfs@vger.kernel.org, sandeen@sandeen.net

On Thu, Jun 22, 2017 at 02:33:52PM -0500, Bill O'Donnell wrote:
> xfs_db doesn't take sector size into account when setting type.
> This can result in an errant crc. For example, with a sector size
> of 4096:
> 
> xfs_db> agi 0
> xfs_db> p crc
> crc = 0xab85043e (correct)
> xfs_db> daddr
> current daddr is 16
> xfs_db> daddr 42
> xfs_db> daddr 16
> xfs_db> type agi
> Metadata CRC error detected at xfs_agi block 0x10/0x200
> xfs_db> p crc
> crc = 0xab85043e (bad)
> 
> When xfs_db sets the new daddr in daddr_f, it does so with one
> BBSIZE sector (512). Changing the type doesn't change the size
> of the current buffer in iocur_top, so the checksum is calculated
> on the wrong length for the type (when the actual sector size > BBSIZE (512).
> 
> For types with fields, reread the buffer to pick up the correct size for
> the new type when it gets set. Facilitate the reread by setting the cursor
> with set_cur().
> 
> Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> ---
>  db/io.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/db/io.c b/db/io.c
> index 9918a51..7e6d330 100644
> --- a/db/io.c
> +++ b/db/io.c
> @@ -616,6 +616,12 @@ set_iocur_type(
>  {
>  	struct xfs_buf	*bp = iocur_top->bp;
>  
> +	if (t->fields)
> +		set_cur(t,
> +			iocur_top->bb,
> +			fsize(t->fields, iocur_top->data,
> +			      0, 0) / mp->m_sb.sb_blocksize,

I thought the third parameter to set_cur (which is fed as the third
parameter to libxfs_readbuf) was expressed in units of basic blocks
(i.e. 512 bytes)?  fsize returns the size of the field in bytes (I
think?), so dividing by sb_blocksize renders units of fs blocks, not
basic blocks.

<shrug> the naming isn't helpful at all:

void
set_cur(
	const typ_t	*t,
	int64_t		d,
	int		c,
...
	iocur_top->len = BBTOB(c);

<codeconfused>

--D

> +			DB_RING_IGN, NULL);
>  	iocur_top->typ = t;
>  
>  	/* verify the buffer if the type has one. */
> -- 
> 2.9.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
