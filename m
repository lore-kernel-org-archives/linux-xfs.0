Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5AFB77CA0
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 18:06:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D494AAC002
	for <xfs@oss.sgi.com>; Tue, 19 Jul 2016 16:06:14 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	0kNUtQi8QDllfe5v for <xfs@oss.sgi.com>;
	Tue, 19 Jul 2016 16:06:08 -0700 (PDT)
Date: Wed, 20 Jul 2016 09:05:41 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs_vm_releasepage() causing BUG at free_buffer_head()
Message-ID: <20160719230541.GG16044@dastard>
References: <143E2E5E912B4C348E8C62AA987F0506@alyakaslap>
	<578D399C.1010006@applied-asynchrony.com>
	<EBFD548A4E314321937A5966D9B00808@alyakaslap>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <EBFD548A4E314321937A5966D9B00808@alyakaslap>
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
To: Alex Lyakas <alex@zadarastorage.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>, xfs@oss.sgi.com

On Tue, Jul 19, 2016 at 11:43:52AM +0300, Alex Lyakas wrote:
> Hello Holger,
> 
> Thank you for your response. I see that xfs_finish_page_writeback()
> has been added very recently and is called from xfs_destroy_ioend().
> In my kernel (3.18.19), the xfs_destroy_ioend() is [1]. I think it
> doesn't suffer from the problem of xfs_finish_page_writeback().
> Looking at other usage of "b_this_page" in my kernel, they all seem
> valid, and similar to what Linus's tree has.
> 
> Looking at b_private usage to link buffer heads, the only suspicious
> code is in xfs_submit_ioend():
> 
>        for (bh = ioend->io_buffer_head; bh; bh = bh->b_private) {
> 
>            if (!bio) {
> retry:
>                bio = xfs_alloc_ioend_bio(bh);
>            } else if (bh->b_blocknr != lastblock + 1) {
>                xfs_submit_ioend_bio(wbc, ioend, bio);
>                goto retry;
>            }
> 
>            if (xfs_bio_add_buffer(bio, bh) != bh->b_size) {
>                xfs_submit_ioend_bio(wbc, ioend, bio);
>                goto retry;
>            }
> 
>            lastblock = bh->b_blocknr;
>        }
> 
> Can it happen that when the for loop does "bh = bh->b_private", the
> bh has already been completed and freed?
> With this in mind, the "goto retry" also seem suspicious for the
> same reason.
> 
> What do you think?

No, because the bh cannot run completion callbacks (via
xfs_destroy_ioend) while there is an active reference on the ioend.
The reference protecting submission is not dropped until after the
entire loop above is finished and xfs_finish_ioend() is called.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
