Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6ULgK0K093651 for <xfs@oss.sgi.com>; Mon, 30 Jul 2012 16:42:20 -0500
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	HbALTg8NQY3edKYS for <xfs@oss.sgi.com>;
	Mon, 30 Jul 2012 14:42:17 -0700 (PDT)
Date: Tue, 31 Jul 2012 07:42:13 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/8] Set bi_rw when alloc bio before call bio_add_page.
Message-ID: <20120730214213.GF2877@dastard>
References: <201207301514247032532@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201207301514247032532@gmail.com>
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
Cc: axboe <axboe@kernel.dk>, shaggy <shaggy@kernel.org>, "chris.mason" <chris.mason@fusionio.com>, elder <elder@kernel.org>, tytso <tytso@mit.edu>, "konrad.wilk" <konrad.wilk@oracle.com>, mfasheh <mfasheh@suse.com>, linux-ext4 <linux-ext4@vger.kernel.org>, jfs-discussion <jfs-discussion@lists.sourceforge.net>, linux-kernel <linux-kernel@vger.kernel.org>, ocfs2-devel <ocfs2-devel@oss.oracle.com>, bpm <bpm@sgi.com>, "adilger.kernel" <adilger.kernel@dilger.ca>, viro <viro@ZenIV.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <xfs@oss.sgi.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, jlbec <jlbec@evilplan.org>

On Mon, Jul 30, 2012 at 03:14:28PM +0800, majianpeng wrote:
> When exec bio_alloc, the bi_rw is zero.But after calling bio_add_page,
> it will use bi_rw.
> Fox example, in functiion __bio_add_page,it will call merge_bvec_fn().
> The merge_bvec_fn of raid456 will use the bi_rw to judge the merge.
> >> if ((bvm->bi_rw & 1) == WRITE)
> >> return biovec->bv_len; /* always allow writes to be mergeable */

So if bio_add_page() requires bi_rw to be set, then shouldn't it be
set up for every caller? I noticed there are about 50 call sites for
bio_add_page(), and you've only touched about 10 of them. Indeed, I
notice that the RAID0/1 code uses bio_add_page, and as that can be
stacked on top of RAID456, it also needs to set bi_rw correctly.
As a result, your patch set is nowhere near complete, not does it
document that bio_add_page requires that bi_rw be set before calling
(which is the new API requirement, AFAICT).

So, my question is whether the RAID456 code is doing something
valid.  That write optimisation is clearly not enabled for a
significant amount of code and filesystems, so the first thing to do
is quantify the benefit of the optimisation. I can't evalute the
merit of this change without data telling me it is worthwhile, and
it's a lot of code to churn for no benefit....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
