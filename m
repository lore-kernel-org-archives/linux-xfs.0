Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:34276 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751941AbeAKXTX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Jan 2018 18:19:23 -0500
Subject: Re: [PATCH 10/27] xfs_scrub: add file space map iteration functions
References: <151520348769.2027.9860697266310422360.stgit@magnolia>
 <151520354940.2027.10483445005054005807.stgit@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <149cf293-b65f-f013-50d8-964f072b8ae2@sandeen.net>
Date: Thu, 11 Jan 2018 17:19:22 -0600
MIME-Version: 1.0
In-Reply-To: <151520354940.2027.10483445005054005807.stgit@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

On 1/5/18 7:52 PM, Darrick J. Wong wrote:


> + * These routines provide a simple interface to query the block
> + * mappings of the fork of a given inode via GETBMAPX and call a
> + * function to iterate each mapping result.
> + */
> +
> +#define BMAP_NR		2048
> +
> +/* Iterate all the extent block mappings between the key and fork end. */
> +bool
> +xfs_iterate_filemaps(
> +	struct scrub_ctx	*ctx,
> +	const char		*descr,
> +	int			fd,
> +	int			whichfork,
> +	struct xfs_bmap		*key,

<coverity pass>

Ok key is an xfs_bmap:

/* inode fork block mapping */
struct xfs_bmap {
        uint64_t        bm_offset;      /* file offset of segment in bytes */
        uint64_t        bm_physical;    /* physical starting byte  */
        uint64_t        bm_length;      /* length of segment, bytes */
        uint32_t        bm_flags;       /* output flags */
};

> +	xfs_bmap_iter_fn	fn,
> +	void			*arg)
> +{
> +	struct fsxattr		fsx;
> +	struct getbmapx		*map
map is a getbmapx ...

struct getbmapx {
        __s64           bmv_offset;     /* file offset of segment in blocks */
        __s64           bmv_block;      /* starting block (64-bit daddr_t)  */
        __s64           bmv_length;     /* length of segment, blocks        */
        __s32           bmv_count;      /* # of entries in array incl. 1st  */
        __s32           bmv_entries;    /* # of entries filled in (output). */
        __s32           bmv_iflags;     /* input flags (1st structure)      */
        __s32           bmv_oflags;     /* output flags (after 1st structure)*/
        __s32           bmv_unused1;    /* future use                       */
        __s32           bmv_unused2;    /* future use                       */
};

...

> +out:
> +	memcpy(key, map, sizeof(struct getbmapx));

so I don't think that fits, right?


-Eric
