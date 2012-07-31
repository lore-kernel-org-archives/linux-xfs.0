Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6V0snxF114671 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 19:54:49 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id gQa0MuwVII7aKgEN
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 30 Jul 2012 17:54:48 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so13220620pbb.26
	for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 17:54:48 -0700 (PDT)
Date: Tue, 31 Jul 2012 08:55:59 +0800
From: majianpeng <majianpeng@gmail.com>
Subject: Re: Re: [PATCH 0/8] Set bi_rw when alloc bio before call bio_add_page.
References: <201207301514247032532@gmail.com>, <20120730214213.GF2877@dastard>
Mime-Version: 1.0
Message-ID: <201207310855556258267@gmail.com>
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
To: Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>
Cc: axboe <axboe@kernel.dk>, shaggy <shaggy@kernel.org>, "chris.mason" <chris.mason@fusionio.com>, elder <elder@kernel.org>, tytso <tytso@mit.edu>, "konrad.wilk" <konrad.wilk@oracle.com>, mfasheh <mfasheh@suse.com>, linux-ext4 <linux-ext4@vger.kernel.org>, jfs-discussion <jfs-discussion@lists.sourceforge.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, bpm <bpm@sgi.com>, "adilger.kernel" <adilger.kernel@dilger.ca>, viro <viro@ZenIV.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, jlbec <jlbec@evilplan.org>

On 2012-07-31 05:42 Dave Chinner <david@fromorbit.com> Wrote:
>On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:
>> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,
>> it will use bi_rw.
>> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().
>> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
>> >> if ((bvm->bi_rw & 1) == WRITE)
>> >> return biovec->bv_len; /* always allow writes to be mergeable */
>
>So if bio_add_page() requires bi_rw to be set, then shouldn't it be
>set up for every caller? I noticed there are about 50 call sites for
>bio_add_page(), and you've only touched about 10 of them. Indeed, I
>notice that the RAID0/1 code uses bio_add_page, and as that can be
>stacked on top of RAID456, it also needs to set bi_rw correctly.
>As a result, your patch set is nowhere near complete, not does it
>document that bio_add_page requires that bi_rw be set before calling
>(which is the new API requirement, AFAICT).
There are many place call bio_add_page and I send some of those. Because my abilty, so I only send 
some patchs which i understand clearly.
In __bio_add_page:
>>if (q->merge_bvec_fn) {
>>				struct bvec_merge_data bvm = {
>>					/* prev_bvec is already charged in
>>					   bi_size, discharge it in order to
>>					   simulate merging updated prev_bvec
>>					   as new bvec. */
>>					.bi_bdev = bio->bi_bdev,
>>					.bi_sector = bio->bi_sector,
>>					.bi_size = bio->bi_size - prev_bv_len,
>>					.bi_rw = bio->bi_rw,
>>				};
it used bio->bi_rw.
Before raid5_mergeable_bvec appearing, in kernel 'merge_bvec_fn' did not use bio->bi_rw.
But i think we shold not suppose bi_rw not meanless.
And I think we not need an new API to do.
Most used bio_alloc and bio_add_page, like this:
>>	bio = bio_alloc(gfp_mask, 1);
>>		if (!bio) 
>>			ret = -ENOMEM;
			
>>		bio->bi_sector = sector;
>>		bio->bi_end_io = bio_batch_end_io;
>>		bio->bi_bdev = bdev;
>>		bio->bi_private = &bb;
We only add bio->bi_rw = value;
But we shold modify Document for this.


>
>So, my question is whether the RAID456 code is doing something
>valid.  That write optimisation is clearly not enabled for a
>significant amount of code and filesystems, so the first thing to do
>is quantify the benefit of the optimisation. I can't evalute the
>merit of this change without data telling me it is worthwhile, and
>it's a lot of code to churn for no benefit....
>
Sorry, we do not think the 'merge_bvec_fn' did not use bi_rw.
>Cheers,
>
>Dave.
>-- 
>Dave Chinner
>david@fromorbit.com
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
