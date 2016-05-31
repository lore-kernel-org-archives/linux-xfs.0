Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64B3F7CA2
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 10:35:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A129304051
	for <xfs@oss.sgi.com>; Tue, 31 May 2016 08:35:03 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id LbzBe0LJMn2949sp for <xfs@oss.sgi.com>;
	Tue, 31 May 2016 08:35:01 -0700 (PDT)
Subject: Re: [PATCH 3/3] xfs: optimize bio handling in the buffer writeback
	path
References: <1458128681-10869-1-git-send-email-hch@lst.de>
	<1458128681-10869-4-git-send-email-hch@lst.de>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <b8d49db2-131d-0735-c803-adec326f43bb@sandeen.net>
Date: Tue, 31 May 2016 10:35:01 -0500
MIME-Version: 1.0
In-Reply-To: <1458128681-10869-4-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

On 3/16/16 6:44 AM, Christoph Hellwig wrote:
> This patch implements two closely related changes:  First it embedds a
> bio the ioend structure so that we don't have to allocate one separately.
> Second it uses the block layer bio chaining mechanism to chain additional
> bios off this first one if needed instead of manually accouting for
> multiple bio completions in the ioend structure.  Together this removes a
> memory allocation per ioend and greatly simplifies the ioend setup and
> I/O completion path.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  fs/xfs/xfs_aops.c  | 247 ++++++++++++++++++++++++-----------------------------
>  fs/xfs/xfs_aops.h  |  15 ++--
>  fs/xfs/xfs_super.c |  26 ++----
>  3 files changed, 123 insertions(+), 165 deletions(-)
> 
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 5928770..42e7368 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -124,18 +124,25 @@ next_bh:
>   */
>  STATIC void
>  xfs_destroy_ioend(
> -	struct xfs_ioend	*ioend)
> +	struct xfs_ioend	*ioend,
> +	int			error)
>  {
>  	struct inode		*inode = ioend->io_inode;
> -	int			error = ioend->io_error;
> +	struct bio		*last = ioend->io_bio;
>  	struct bio		*bio, *next;
>  
> -	for (bio = ioend->io_bio_done; bio; bio = next) {
> +	for (bio = &ioend->io_inline_bio; bio; bio = next) {
>  		struct bio_vec	*bvec;
>  		int		i;
>  
> -		next = bio->bi_private;
> -		bio->bi_private = NULL;
> +		/*
> +		 * For the last bio, bi_private points to the ioend, so we
> +		 * need to explicitly end the iteration here.
> +		 */
> +		if (bio == last)
> +			next = NULL;
> +		else
> +			next = bio->bi_private;
>  
>  		/* walk each page on bio, ending page IO on them */
>  		bio_for_each_segment_all(bvec, bio, i)
> @@ -143,8 +150,6 @@ xfs_destroy_ioend(
>  
>  		bio_put(bio);

Coverity thinks this is problematic, calling it a
"Free of address-of expression (BAD_FREE)"

CID 1362192

The issue is that if bio still == io_inline_bio, we are freeing
memory which was not allocated.  Maybe this needs a:

if (bio != &ioend->io_inline_bio)
	bio_put(bio);

or is there a better way?

thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
