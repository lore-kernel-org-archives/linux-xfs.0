Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6V1F3pk116593 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 20:15:03 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Q6H8beXHDg6Pk66F for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 18:15:01 -0700 (PDT)
Date: Tue, 31 Jul 2012 11:14:57 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Re: [PATCH 0/8] Set bi_rw when alloc bio before call bio_add_page.
Message-ID: <20120731011457.GO2877@dastard>
References: <201207301514247032532@gmail.com> <20120730214213.GF2877@dastard>
	<201207310855556258267@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201207310855556258267@gmail.com>
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
To: majianpeng <majianpeng@gmail.com>
Cc: axboe <axboe@kernel.dk>, shaggy <shaggy@kernel.org>, "chris.mason" <chris.mason@fusionio.com>, elder <elder@kernel.org>, tytso <tytso@mit.edu>, "konrad.wilk" <konrad.wilk@oracle.com>, Neil Brown <neilb@suse.de>, mfasheh <mfasheh@suse.com>, linux-ext4 <linux-ext4@vger.kernel.org>, jfs-discussion <jfs-discussion@lists.sourceforge.net>, linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, bpm <bpm@sgi.com>, "adilger.kernel" <adilger.kernel@dilger.ca>, viro <viro@ZenIV.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, jlbec <jlbec@evilplan.org>

On Tue, Jul 31, 2012 at 08:55:59AM +0800, majianpeng wrote:
> On 2012-07-31 05:42 Dave Chinner <david@fromorbit.com> Wrote:
> >On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:
> >> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,
> >> it will use bi_rw.
> >> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().
> >> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
> >> >> if ((bvm->bi_rw & 1) == WRITE)
> >> >> return biovec->bv_len; /* always allow writes to be mergeable */
> >
> >So if bio_add_page() requires bi_rw to be set, then shouldn't it be
> >set up for every caller? I noticed there are about 50 call sites for
> >bio_add_page(), and you've only touched about 10 of them. Indeed, I
> >notice that the RAID0/1 code uses bio_add_page, and as that can be
> >stacked on top of RAID456, it also needs to set bi_rw correctly.
> >As a result, your patch set is nowhere near complete, not does it
> >document that bio_add_page requires that bi_rw be set before calling
> >(which is the new API requirement, AFAICT).
> There are many place call bio_add_page and I send some of those. Because my abilty, so I only send 
> some patchs which i understand clearly.

Sure, but my point is that there is no point changing only a few and
ignoring the great majority of callers. Either fix them all, fix it
some other way (e.g. API change), or remove the code from the RAID5
function that requires it.

> In __bio_add_page:
> >>if (q->merge_bvec_fn) {
> >>				struct bvec_merge_data bvm = {
> >>					/* prev_bvec is already charged in
> >>					   bi_size, discharge it in order to
> >>					   simulate merging updated prev_bvec
> >>					   as new bvec. */
> >>					.bi_bdev = bio->bi_bdev,
> >>					.bi_sector = bio->bi_sector,
> >>					.bi_size = bio->bi_size - prev_bv_len,
> >>					.bi_rw = bio->bi_rw,
> >>				};
> it used bio->bi_rw.
> Before raid5_mergeable_bvec appearing, in kernel 'merge_bvec_fn' did not use bio->bi_rw.

Right, but as things stand right now, the RAID5 code is a no-op
because nobody is setting bio->bi_rw correctly. it is effectively
dead code.

> But i think we shold not suppose bi_rw not meanless.

To decide whether we should take it to have meaning, data is
required to show that the RAID5 optimisation it enables is
worthwhile.  If the optimisation is not worthwhile, then the correct
thing to do is remove the optimisation in the RAID5 code and remove
the bi_rw field from the struct bvec_merge_data.

> >So, my question is whether the RAID456 code is doing something
> >valid.  That write optimisation is clearly not enabled for a
> >significant amount of code and filesystems, so the first thing to do
> >is quantify the benefit of the optimisation. I can't evalute the
> >merit of this change without data telling me it is worthwhile, and
> >it's a lot of code to churn for no benefit....
> >
> Sorry, we do not think the 'merge_bvec_fn' did not use bi_rw.

It's entirely possible that when bi_rw was added to struct
bvec_merge_data, the person who added it was mistaken that bi_rw was
set at this point in time when in fact it never has been. Hence it's
presence and reliance on it would be a bug.

That's what I'm asking - is this actually beneificial, or should it
simply be removed from struct bvec_merge_data? Data is needed to
answer that question....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
