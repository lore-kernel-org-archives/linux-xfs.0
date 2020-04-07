Return-Path: <SRS0=E2x8=5X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25946C2D0EC
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 23:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0809C206BE
	for <linux-xfs@archiver.kernel.org>; Tue,  7 Apr 2020 23:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgDGX1z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 7 Apr 2020 19:27:55 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:49130 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgDGX1z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 7 Apr 2020 19:27:55 -0400
Received: from dread.disaster.area (pa49-180-164-3.pa.nsw.optusnet.com.au [49.180.164.3])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 784FF7EBDA0;
        Wed,  8 Apr 2020 09:27:50 +1000 (AEST)
Received: from dave by dread.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jLxdF-0005Tl-A3; Wed, 08 Apr 2020 09:27:49 +1000
Date:   Wed, 8 Apr 2020 09:27:49 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
        "hch@lst.de" <hch@lst.de>,
        "danil.kipnis@cloud.ionos.com" <danil.kipnis@cloud.ionos.com>,
        "jinpu.wang@cloud.ionos.com" <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH 2/2] xfs: use block layer helper for rw
Message-ID: <20200407232749.GC24067@dread.disaster.area>
References: <20200406232440.4027-1-chaitanya.kulkarni@wdc.com>
 <20200406232440.4027-3-chaitanya.kulkarni@wdc.com>
 <BY5PR04MB690075C16A97151A6216948CE7C30@BY5PR04MB6900.namprd04.prod.outlook.com>
 <BYAPR04MB4965A3A58D804CCE9892266686C30@BYAPR04MB4965.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB4965A3A58D804CCE9892266686C30@BYAPR04MB4965.namprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=K0+o7W9luyMo1Ua2eXjR1w==:117 a=K0+o7W9luyMo1Ua2eXjR1w==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=kj9zAlcOel0A:10 a=cl8xLZFz6L8A:10
        a=7-415B0cAAAA:8 a=deSlaM45Gs4b21hfZ6IA:9 a=CjuIK1q_8ugA:10
        a=biEYGPWJfzWAr4FL6Ov7:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Apr 07, 2020 at 08:06:35PM +0000, Chaitanya Kulkarni wrote:
> On 04/06/2020 05:32 PM, Damien Le Moal wrote:
> >> -
> >> >-	do {
> >> >-		struct page	*page = kmem_to_page(data);
> >> >-		unsigned int	off = offset_in_page(data);
> >> >-		unsigned int	len = min_t(unsigned, left, PAGE_SIZE - off);
> >> >-
> >> >-		while (bio_add_page(bio, page, len, off) != len) {
> >> >-			struct bio	*prev = bio;
> >> >-
> >> >-			bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
> >> >-			bio_copy_dev(bio, prev);
> >> >-			bio->bi_iter.bi_sector = bio_end_sector(prev);
> >> >-			bio->bi_opf = prev->bi_opf;
> >> >-			bio_chain(prev, bio);
> >> >-
> >> >-			submit_bio(prev);
> >> >-		}
> >> >-
> >> >-		data += len;
> >> >-		left -= len;
> >> >-	} while (left > 0);
> > Your helper could use a similar loop structure. This is very easy to read.
> >
> If I understand correctly this pattern is used since it is not a part of 
> block layer.

It's because it was simple and easy to understandi, not because of
the fact it is outside the core block layer.

Us XFS folks are simple people who like simple things that are easy to
understand because there is so much of XFS that is so horrifically
complex that we want to implement simple stuff once and just not
have to care about it again.

> The helpers in blk-lib.c are not accessible so this :-

So export the helpers?

> All above breaks the existing pattern and code reuse in blk-lib.c, since 
> blk-lib.c:-
> 1. Already provides blk_next_bio() why repeat the bio allocation
>     and bio chaining code ?

So export the helper?

> 2. Instead of adding a new helper bio_max_vecs() why not use existing
>      __blkdev_sectors_to_bio_pages() ?

That's not an improvement. The XFS code is _much_ easier to read
and understand.

> 3. Why use two bios when it can be done with one bio with the helpers
>     in blk-lib.c ?

That helper is blk_next_bio(), which hides the second bio inside it.
So you aren't actually getting rid of the need for two bio pointers.

> 4. Allows async version.

Which is not used by XFS, so just adds complexity to this XFS path
for no good reason.

Seriously, this 20 lines of code in XFS turns into 50-60 lines
of code in the block layer to do the same thing. How is that an
improvement?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
