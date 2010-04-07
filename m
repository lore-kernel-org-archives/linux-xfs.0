Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o37CYm3b188582 for <xfs@oss.sgi.com>; Wed, 7 Apr 2010 07:34:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 866FB2A335B
	for <xfs@oss.sgi.com>; Wed,  7 Apr 2010 05:36:39 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id QJmyxYXoJxI58QaW for
	<xfs@oss.sgi.com>; Wed, 07 Apr 2010 05:36:39 -0700 (PDT)
Date: Wed, 7 Apr 2010 08:36:38 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Oops in xfs_dir2_block_lookup_int from storage corruption [2.6.33]
Message-ID: <20100407123638.GA21797@infradead.org>
References: <20100404081657.GA24143@hostway.ca>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100404081657.GA24143@hostway.ca>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Simon Kirby <sim@hostway.ca>
Cc: xfs@oss.sgi.com

On Sun, Apr 04, 2010 at 01:16:57AM -0700, Simon Kirby wrote:
>         /*
>          * Loop doing a binary search for our hash value.
>          * Find our entry, ENOENT if it's not there.
>          */
>         for (low = 0, high = be32_to_cpu(btp->count) - 1; ; ) {
>                 ASSERT(low <= high);
>                 mid = (low + high) >> 1;
> ======>         if ((hash = be32_to_cpu(blp[mid].hashval)) == args->hashval)
>                         break;
> 
> blp is 8 bytes which matches the multiplication of the array index in the
> instruction.  So, this means that blp[mid] pointed to 0xffff8800f674bf00,
> and mid was 0x0000000015c6535e.  That sounds kind of high...?

Yes. Looks like btp->count was corrupted.  It counts the number of
xfs_dir2_leaf_entry in the directory block, which is 16 bytes larger.
So with 4k directory blocks that you're using we could only pack 256
entries in one block, and that's already disconting the head and tail
headers we have in the block format.

I'll add some more error checking to the directory code when I get
time for it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
