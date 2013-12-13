Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 295B37F52
	for <xfs@oss.sgi.com>; Fri, 13 Dec 2013 15:37:11 -0600 (CST)
Date: Fri, 13 Dec 2013 15:37:01 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfs: require 64-bit sector_t
Message-ID: <20131213213701.GM1935@sgi.com>
References: <20131114164603.GA13628@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131114164603.GA13628@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Hi Christoph,

On Thu, Nov 14, 2013 at 08:46:03AM -0800, Christoph Hellwig wrote:
> Trying to support tiny disks only and saving a bit memory might have
> made sense on an SGI O2 15 years ago, but is pretty pointless today.
> 
> Remove the rarely tested codepath that uses various smaller in-memory
> types to reduce our test matrix and make the codebase a little bit
> smaller and less complicated.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
> index 399e8ce..5d47b4d 100644
> --- a/fs/xfs/Kconfig
> +++ b/fs/xfs/Kconfig
> @@ -1,6 +1,7 @@
>  config XFS_FS
>  	tristate "XFS filesystem support"
>  	depends on BLOCK
> +	depends on (64BIT || LBDAF)

There are quite a few 32 bit arches in use today.  We need to continue to
support them in XFS as long as they are supported by the kernel.  Unless I have
misunderstood what you are suggesting, I believe the answer to this patch must
be a firm 'no'.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
