Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Apr 2007 23:21:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l3J6LQfB018388
	for <xfs@oss.sgi.com>; Wed, 18 Apr 2007 23:21:28 -0700
Date: Thu, 19 Apr 2007 16:23:16 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: [RFC] add FIEMAP ioctl to efficiently map file allocation
Message-ID: <60F23AB8D50382586C1E0BFC@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070419002139.GK5967@schatzie.adilger.int>
References: <20070412110550.GM5967@schatzie.adilger.int>
 <20070416112252.GJ48531920@melbourne.sgi.com> <20070419002139.GK5967@schatzie.adilger.int>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andreas Dilger <adilger@clusterfs.com>, David Chinner <dgc@sgi.com>
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org

--On 18 April 2007 6:21:39 PM -0600 Andreas Dilger <adilger@clusterfs.com> wrote:

> Below is an aggregation of the comments in this thread:
>
> struct fiemap_extent {
> 	__u64 fe_start;		/* starting offset in bytes */
> 	__u64 fe_len;		/* length in bytes */
> 	__u32 fe_flags;		/* FIEMAP_EXTENT_* flags for this extent */
> 	__u32 fe_lun;		/* logical storage device number in array */
> }
>
> struct fiemap {
> 	__u64 fm_start;		/* logical start offset of mapping (in/out) */
> 	__u64 fm_len;		/* logical length of mapping (in/out) */
> 	__u32 fm_flags;		/* FIEMAP_FLAG_* flags for request (in/out) */
> 	__u32 fm_extent_count;	/* number of extents in fm_extents (in/out) */
> 	__u64 fm_unused;
> 	struct fiemap_extent fm_extents[0];
> }
>
> /* flags for the fiemap request */
># define FIEMAP_FLAG_SYNC	0x00000001	/* flush delalloc data to disk*/
># define FIEMAP_FLAG_HSM_READ	0x00000002	/* retrieve data from HSM */
># define FIEMAP_FLAG_INCOMPAT    0xff000000	/* must understand these flags*/
>
> /* flags for the returned extents */
># define FIEMAP_EXTENT_HOLE	0x00000001	/* no space allocated */
># define FIEMAP_EXTENT_UNWRITTEN	0x00000002	/* uninitialized space */
># define FIEMAP_EXTENT_UNKNOWN	0x00000004	/* in use, location unknown */
># define FIEMAP_EXTENT_ERROR	0x00000008	/* error mapping space */
># define FIEMAP_EXTENT_NO_DIRECT	0x00000010	/* no direct data access */
>
>
>
> SUMMARY OF CHANGES
> ==================
> - use fm_* fields directly in request instead of making it a fiemap_extent
>   (though they are layed out identically)

I much prefer that - it makes it a lot clearer to me to have fiemap_extent
just for fm_extents (no different meanings now).
(Don't like the word "offset" in comment without "physical" or some such but whatever;-)
I also prefer the flags as separate fields too :)

--Tim
