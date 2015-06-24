Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6635F7F60
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 08:00:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 02BBAAC002
	for <xfs@oss.sgi.com>; Wed, 24 Jun 2015 06:00:38 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ORjkGpWr2AZXsQkI (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jun 2015 06:00:38 -0700 (PDT)
Date: Wed, 24 Jun 2015 09:00:36 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [PATCH] libxfs: add xfs_bit.c
Message-ID: <20150624130035.GA1888@bfoster.bfoster>
References: <1434932648-19120-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1434932648-19120-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jun 22, 2015 at 10:24:08AM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The header side of xfs_bit.c is already in libxfs, and the sparse
> inode code requires the xfs_next_bit() function so pull in the
> xfs_bit.c file so that a sparse inode enabled libxfs compiles
> cleanly in userspace.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/Makefile         |   2 +-
>  fs/xfs/libxfs/xfs_bit.c | 118 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/xfs/xfs_bit.c        | 118 ------------------------------------------------
>  3 files changed, 119 insertions(+), 119 deletions(-)
>  create mode 100644 fs/xfs/libxfs/xfs_bit.c
>  delete mode 100644 fs/xfs/xfs_bit.c
> 
> diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
> index b346326..2fbf910 100644
> --- a/fs/xfs/Makefile
> +++ b/fs/xfs/Makefile
> @@ -33,6 +33,7 @@ xfs-y				+= $(addprefix libxfs/, \
>  				   xfs_attr.o \
>  				   xfs_attr_leaf.o \
>  				   xfs_attr_remote.o \
> +				   xfs_bit.o \
>  				   xfs_bmap.o \
>  				   xfs_bmap_btree.o \
>  				   xfs_btree.o \
> @@ -63,7 +64,6 @@ xfs-$(CONFIG_XFS_RT)		+= $(addprefix libxfs/, \
>  xfs-y				+= xfs_aops.o \
>  				   xfs_attr_inactive.o \
>  				   xfs_attr_list.o \
> -				   xfs_bit.o \
>  				   xfs_bmap_util.o \
>  				   xfs_buf.o \
>  				   xfs_dir2_readdir.o \
> diff --git a/fs/xfs/libxfs/xfs_bit.c b/fs/xfs/libxfs/xfs_bit.c
> new file mode 100644
> index 0000000..0e8885a
> --- /dev/null
> +++ b/fs/xfs/libxfs/xfs_bit.c
> @@ -0,0 +1,118 @@
> +/*
> + * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> + * All Rights Reserved.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it would be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write the Free Software Foundation,
> + * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> + */
> +#include "xfs.h"
> +#include "xfs_log_format.h"
> +#include "xfs_bit.h"
> +
> +/*
> + * XFS bit manipulation routines, used in non-realtime code.
> + */
> +
> +/*
> + * Return whether bitmap is empty.
> + * Size is number of words in the bitmap, which is padded to word boundary
> + * Returns 1 for empty, 0 for non-empty.
> + */
> +int
> +xfs_bitmap_empty(uint *map, uint size)
> +{
> +	uint i;
> +	uint ret = 0;
> +
> +	for (i = 0; i < size; i++) {
> +		ret |= map[i];
> +	}
> +
> +	return (ret == 0);
> +}
> +
> +/*
> + * Count the number of contiguous bits set in the bitmap starting with bit
> + * start_bit.  Size is the size of the bitmap in words.
> + */
> +int
> +xfs_contig_bits(uint *map, uint	size, uint start_bit)
> +{
> +	uint * p = ((unsigned int *) map) + (start_bit >> BIT_TO_WORD_SHIFT);
> +	uint result = 0;
> +	uint tmp;
> +
> +	size <<= BIT_TO_WORD_SHIFT;
> +
> +	ASSERT(start_bit < size);
> +	size -= start_bit & ~(NBWORD - 1);
> +	start_bit &= (NBWORD - 1);
> +	if (start_bit) {
> +		tmp = *p++;
> +		/* set to one first offset bits prior to start */
> +		tmp |= (~0U >> (NBWORD-start_bit));
> +		if (tmp != ~0U)
> +			goto found;
> +		result += NBWORD;
> +		size -= NBWORD;
> +	}
> +	while (size) {
> +		if ((tmp = *p++) != ~0U)
> +			goto found;
> +		result += NBWORD;
> +		size -= NBWORD;
> +	}
> +	return result - start_bit;
> +found:
> +	return result + ffz(tmp) - start_bit;
> +}
> +
> +/*
> + * This takes the bit number to start looking from and
> + * returns the next set bit from there.  It returns -1
> + * if there are no more bits set or the start bit is
> + * beyond the end of the bitmap.
> + *
> + * Size is the number of words, not bytes, in the bitmap.
> + */
> +int xfs_next_bit(uint *map, uint size, uint start_bit)
> +{
> +	uint * p = ((unsigned int *) map) + (start_bit >> BIT_TO_WORD_SHIFT);
> +	uint result = start_bit & ~(NBWORD - 1);
> +	uint tmp;
> +
> +	size <<= BIT_TO_WORD_SHIFT;
> +
> +	if (start_bit >= size)
> +		return -1;
> +	size -= result;
> +	start_bit &= (NBWORD - 1);
> +	if (start_bit) {
> +		tmp = *p++;
> +		/* set to zero first offset bits prior to start */
> +		tmp &= (~0U << start_bit);
> +		if (tmp != 0U)
> +			goto found;
> +		result += NBWORD;
> +		size -= NBWORD;
> +	}
> +	while (size) {
> +		if ((tmp = *p++) != 0U)
> +			goto found;
> +		result += NBWORD;
> +		size -= NBWORD;
> +	}
> +	return -1;
> +found:
> +	return result + ffs(tmp) - 1;
> +}
> diff --git a/fs/xfs/xfs_bit.c b/fs/xfs/xfs_bit.c
> deleted file mode 100644
> index 0e8885a..0000000
> --- a/fs/xfs/xfs_bit.c
> +++ /dev/null
> @@ -1,118 +0,0 @@
> -/*
> - * Copyright (c) 2000-2005 Silicon Graphics, Inc.
> - * All Rights Reserved.
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License as
> - * published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope that it would be useful,
> - * but WITHOUT ANY WARRANTY; without even the implied warranty of
> - * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> - * GNU General Public License for more details.
> - *
> - * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write the Free Software Foundation,
> - * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
> - */
> -#include "xfs.h"
> -#include "xfs_log_format.h"
> -#include "xfs_bit.h"
> -
> -/*
> - * XFS bit manipulation routines, used in non-realtime code.
> - */
> -
> -/*
> - * Return whether bitmap is empty.
> - * Size is number of words in the bitmap, which is padded to word boundary
> - * Returns 1 for empty, 0 for non-empty.
> - */
> -int
> -xfs_bitmap_empty(uint *map, uint size)
> -{
> -	uint i;
> -	uint ret = 0;
> -
> -	for (i = 0; i < size; i++) {
> -		ret |= map[i];
> -	}
> -
> -	return (ret == 0);
> -}
> -
> -/*
> - * Count the number of contiguous bits set in the bitmap starting with bit
> - * start_bit.  Size is the size of the bitmap in words.
> - */
> -int
> -xfs_contig_bits(uint *map, uint	size, uint start_bit)
> -{
> -	uint * p = ((unsigned int *) map) + (start_bit >> BIT_TO_WORD_SHIFT);
> -	uint result = 0;
> -	uint tmp;
> -
> -	size <<= BIT_TO_WORD_SHIFT;
> -
> -	ASSERT(start_bit < size);
> -	size -= start_bit & ~(NBWORD - 1);
> -	start_bit &= (NBWORD - 1);
> -	if (start_bit) {
> -		tmp = *p++;
> -		/* set to one first offset bits prior to start */
> -		tmp |= (~0U >> (NBWORD-start_bit));
> -		if (tmp != ~0U)
> -			goto found;
> -		result += NBWORD;
> -		size -= NBWORD;
> -	}
> -	while (size) {
> -		if ((tmp = *p++) != ~0U)
> -			goto found;
> -		result += NBWORD;
> -		size -= NBWORD;
> -	}
> -	return result - start_bit;
> -found:
> -	return result + ffz(tmp) - start_bit;
> -}
> -
> -/*
> - * This takes the bit number to start looking from and
> - * returns the next set bit from there.  It returns -1
> - * if there are no more bits set or the start bit is
> - * beyond the end of the bitmap.
> - *
> - * Size is the number of words, not bytes, in the bitmap.
> - */
> -int xfs_next_bit(uint *map, uint size, uint start_bit)
> -{
> -	uint * p = ((unsigned int *) map) + (start_bit >> BIT_TO_WORD_SHIFT);
> -	uint result = start_bit & ~(NBWORD - 1);
> -	uint tmp;
> -
> -	size <<= BIT_TO_WORD_SHIFT;
> -
> -	if (start_bit >= size)
> -		return -1;
> -	size -= result;
> -	start_bit &= (NBWORD - 1);
> -	if (start_bit) {
> -		tmp = *p++;
> -		/* set to zero first offset bits prior to start */
> -		tmp &= (~0U << start_bit);
> -		if (tmp != 0U)
> -			goto found;
> -		result += NBWORD;
> -		size -= NBWORD;
> -	}
> -	while (size) {
> -		if ((tmp = *p++) != 0U)
> -			goto found;
> -		result += NBWORD;
> -		size -= NBWORD;
> -	}
> -	return -1;
> -found:
> -	return result + ffs(tmp) - 1;
> -}
> -- 
> 2.0.0
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
