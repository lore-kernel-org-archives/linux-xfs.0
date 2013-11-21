Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 00F9829DF9
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 12:08:34 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8B508AC00D
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 10:08:30 -0800 (PST)
Received: from mailgw1.uni-kl.de (mailgw1.uni-kl.de [131.246.120.220]) by
	cuda.sgi.com with ESMTP id C8tfYBKOosBzzxxb (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 21 Nov 2013 10:08:29 -0800 (PST)
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id
	rALI8Qcm025665
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <xfs@oss.sgi.com>; Thu, 21 Nov 2013 19:08:26 +0100
Message-ID: <528E4C19.70507@itwm.fraunhofer.de>
Date: Thu, 21 Nov 2013 19:08:25 +0100
From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
MIME-Version: 1.0
Subject: Re: bio_add_page rw mode check by merge_bvec_fn
References: <528E4A50.7040609@itwm.fraunhofer.de>
In-Reply-To: <528E4A50.7040609@itwm.fraunhofer.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, xfs@oss.sgi.com, linux-ext4@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>

[CCing linux-fsdevel instead of accidental fhgfs cc]

On 11/21/2013 07:00 PM, Bernd Schubert wrote:
> Hi all,
>
> raid5_mergeable_bvec() (q->merge_bvec_fn) checks for the rw-type and
> makes decisions based on that if the bio is mergable or not. But so far
> this value is only initialized on calling submit_bio(),
> at least not by ext4 and xfs. I have not checked other file system so far.
>
> Question 1: merge_bvec_fn is supposed to be removed, is is
> still worth to fix the usage of merge_bvec_fn?
>
> Question 2: If it is still supposed to be fixed, how do want to have
> it? So far I have two patches for xfs and ext4 to set the rw type
> directly there, but maybe bio_add_page should get an int rw_type
> parameter and set bio->bi_rw itself?
>
>
>
> diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
> index d488f80..4cddc15 100644
> --- a/fs/ext4/page-io.c
> +++ b/fs/ext4/page-io.c
> @@ -370,6 +370,7 @@ static int io_submit_init_bio(struct ext4_io_submit *io,
>          bio->bi_bdev = bh->b_bdev;
>          bio->bi_end_io = ext4_end_bio;
>          bio->bi_private = ext4_get_io_end(io->io_end);
> +       bio->bi_rw |= io->io_op;
>          io->io_bio = bio;
>          io->io_next_block = bh->b_blocknr;
>          return 0;
>
> diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
> index 71c8c9d..b48048f 100644
> --- a/fs/xfs/xfs_aops.c
> +++ b/fs/xfs/xfs_aops.c
> @@ -401,7 +401,8 @@ xfs_submit_ioend_bio(
>
>   STATIC struct bio *
>   xfs_alloc_ioend_bio(
> -       struct buffer_head      *bh)
> +       struct buffer_head      *bh,
> +       struct writeback_control *wbc)
>   {
>          int                     nvecs = bio_get_nr_vecs(bh->b_bdev);
>          struct bio              *bio = bio_alloc(GFP_NOIO, nvecs);
> @@ -409,6 +410,7 @@ xfs_alloc_ioend_bio(
>          ASSERT(bio->bi_private == NULL);
>          bio->bi_sector = bh->b_blocknr * (bh->b_size >> 9);
>          bio->bi_bdev = bh->b_bdev;
> +       bio->bi_rw |= (wbc->sync_mode == WB_SYNC_ALL) ? WRITE_SYNC : WRITE;
>          return bio;
>   }
>
> @@ -511,7 +513,8 @@ xfs_submit_ioend(
>
>                          if (!bio) {
>    retry:
> -                               bio = xfs_alloc_ioend_bio(bh);
> +                               bio = xfs_alloc_ioend_bio(bh, wbc);
> +
>                          } else if (bh->b_blocknr != lastblock + 1) {
>                                  xfs_submit_ioend_bio(wbc, ioend, bio);
>                                  goto retry;
>
>
>
> Thanks,
> Bernd
>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
