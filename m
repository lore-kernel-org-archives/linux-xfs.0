Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CFEE77CA0
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 09:55:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A32BB8F8037
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 07:55:43 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id WmEwPgbf27Cmoq7i for <xfs@oss.sgi.com>;
	Fri, 24 Jun 2016 07:55:37 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id CDCED541
	for <xfs@oss.sgi.com>; Fri, 24 Jun 2016 09:55:37 -0500 (CDT)
Subject: Re: [PATCH 3/3] xfs: remove __arch_pack
References: <1466754767-10657-1-git-send-email-hch@lst.de>
	<1466754767-10657-4-git-send-email-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <478743f8-774f-d363-2e3e-40cd0963d8a1@sandeen.net>
Date: Fri, 24 Jun 2016 09:55:37 -0500
MIME-Version: 1.0
In-Reply-To: <1466754767-10657-4-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com

On 6/24/16 2:52 AM, Christoph Hellwig wrote:
> Instead we always declare struct xfs_dir2_sf_hdr as packed.  That's
> the expected layout, and while most major architectures do the packing
> by default the new structure size and offset checker showed that not
> only the ARM old ABI got this wrong, but various minor embedded
> architectures did as well.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/libxfs/xfs_da_format.h | 2 +-
>  fs/xfs/xfs_linux.h            | 7 -------
>  2 files changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
> index f877bb1..685f23b 100644
> --- a/fs/xfs/libxfs/xfs_da_format.h
> +++ b/fs/xfs/libxfs/xfs_da_format.h
> @@ -229,7 +229,7 @@ typedef struct xfs_dir2_sf_hdr {
>  	__uint8_t		count;		/* count of entries */
>  	__uint8_t		i8count;	/* count of 8-byte inode #s */
>  	__uint8_t		parent[8];	/* parent dir inode number */
> -} __arch_pack xfs_dir2_sf_hdr_t;
> +} __packed xfs_dir2_sf_hdr_t;

The reason I did this in the first place was a vague notion that unconditional
packing was harmful.

http://digitalvampire.org/blog/index.php/2006/07/31/why-you-shouldnt-use-__attribute__packed/

"However, it's actively harmful to add the attribute to a structure that's
already going to be laid out with no padding."
...
"gcc gets scared about unaligned accesses and generates six times as much code
(96 bytes vs. 16 bytes)! sparc64 goes similarly crazy, bloating from 12 bytes
to 52 bytes"

I don't know if that's (still) correct or not, but that was the reason
for the selective __pack application way back when.  Might be worth
investigating?

-Eric

>  typedef struct xfs_dir2_sf_entry {
>  	__u8			namelen;	/* actual name length */
> diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
> index a8192dc..b8d64d5 100644
> --- a/fs/xfs/xfs_linux.h
> +++ b/fs/xfs/xfs_linux.h
> @@ -328,13 +328,6 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
>  	return x;
>  }
>  
> -/* ARM old ABI has some weird alignment/padding */
> -#if defined(__arm__) && !defined(__ARM_EABI__)
> -#define __arch_pack __attribute__((packed))
> -#else
> -#define __arch_pack
> -#endif
> -
>  #define ASSERT_ALWAYS(expr)	\
>  	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
>  
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
