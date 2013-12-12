Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 828E27F51
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 17:25:16 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0DA46AC00A
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 15:25:15 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	OAOPUWQYXWcirCBq for <xfs@oss.sgi.com>;
	Thu, 12 Dec 2013 15:25:09 -0800 (PST)
Date: Fri, 13 Dec 2013 10:24:43 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4 v3] fiemap: add EXTENT_DATA_COMPRESSED flag
Message-ID: <20131212232443.GL31386@dastard>
References: <cover.1386778302.git.dsterba@suse.cz>
	<4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4f8d5dc5b51a43efaf16c39398c23a6276e40a30.1386778303.git.dsterba@suse.cz>
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
To: David Sterba <dsterba@suse.cz>
Cc: adilger@dilger.ca, linux-nilfs@vger.kernel.org, mfasheh@suse.com, xfs@oss.sgi.com, hch@infradead.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org

On Thu, Dec 12, 2013 at 04:25:59PM +0100, David Sterba wrote:
> This flag was not accepted when fiemap was proposed [2] due to lack of
> in-kernel users. Btrfs has compression for a long time and we'd like to
> see that an extent is compressed in the output of 'filefrag' utility
> once it's taught about it.
> 
> For that purpose, a reserved field from fiemap_extent is used to let the
> filesystem store along the physcial extent length when the flag is set.
> This keeps compatibility with applications that use FIEMAP.

I'd prefer to just see the new physical length field always filled
out, regardless of whether it is a compressed extent or not. In
terms of backwards compatibility to userspace, it makes no
difference because the value of reserved/unused fields is undefined
by the API. Yes, the implementation zeros them, but there's nothing
in the documentation that says "reserved fields must be zero".
Hence I think we should just set it for every extent.

>From the point of view of the kernel API (fiemap_fill_next_extent),
passing the physical extent size in the "len" parameter for normal
extents, then passing 0 for the "physical length" makes absolutely
no sense.

IOWs, what you have created is a distinction between the extent's
"logical length" and it's "physical length". For uncompressed
extents, they are both equal and they should both be passed to
fiemap_fill_next_extent as the same value. Extents where they are
different (i.e.  encoded extents) is when they can be different.
Perhaps fiemap_fill_next_extent() should check and warn about
mismatches when they differ and the relevant flags are not set...

> diff --git a/include/uapi/linux/fiemap.h b/include/uapi/linux/fiemap.h
> index 93abfcd..0e32cae 100644
> --- a/include/uapi/linux/fiemap.h
> +++ b/include/uapi/linux/fiemap.h
> @@ -19,7 +19,9 @@ struct fiemap_extent {
>  	__u64 fe_physical; /* physical offset in bytes for the start
>  			    * of the extent from the beginning of the disk */
>  	__u64 fe_length;   /* length in bytes for this extent */
> -	__u64 fe_reserved64[2];
> +	__u64 fe_phys_length; /* physical length in bytes, undefined if
> +			       * DATA_COMPRESSED not set */
> +	__u64 fe_reserved64;
>  	__u32 fe_flags;    /* FIEMAP_EXTENT_* flags for this extent */
>  	__u32 fe_reserved[3];
>  };

The comment for fe_length needs to change, too, because it needs to
indicate that it is the logical extent length and that it may be
different to the fe_phys_length depending on the flags that are set
on the extent.

And, FWIW, I wouldn't mention specific flags in the comment here,
but do it at the definition of the flags that indicate there is
a difference between physical and logical extent lengths....

> @@ -50,6 +52,8 @@ struct fiemap {
>  						    * Sets EXTENT_UNKNOWN. */
>  #define FIEMAP_EXTENT_ENCODED		0x00000008 /* Data can not be read
>  						    * while fs is unmounted */
> +#define FIEMAP_EXTENT_DATA_COMPRESSED	0x00000040 /* Data is compressed by fs.
> +						    * Sets EXTENT_ENCODED */

i.e. here.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
