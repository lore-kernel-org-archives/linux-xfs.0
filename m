Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36258 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727992AbfFEN6O (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 5 Jun 2019 09:58:14 -0400
Date: Wed, 5 Jun 2019 09:57:59 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [bug report][stable] xfstests:generic/538 failed on xfs
Message-ID: <20190605135756.GA15671@bfoster>
References: <f9a7b0c4-178a-4a7c-8ac6-aec79b06b810.Alvin@linux.alibaba.com>
 <20190605124227.GC17558@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190605124227.GC17558@kroah.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: gregkh <gregkh@linuxfoundation.org>
Cc: Alvin Zheng <Alvin@linux.alibaba.com>, "darrick.wong" <darrick.wong@oracle.com>, axboe <axboe@kernel.dk>, linux-block <linux-block@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, caspar <caspar@linux.alibaba.com>, "joseph.qi" <joseph.qi@linux.alibaba.com>

On Wed, Jun 05, 2019 at 02:42:27PM +0200, gregkh wrote:
> On Wed, Jun 05, 2019 at 08:21:44PM +0800, Alvin Zheng wrote:
> > Hi,
> >   I was using kernel v4.19.48 and found that it cannot pass the generic/538 on xfs. The error output is as follows:
> 
> Has 4.19 ever been able to pass that test?  If not, I wouldn't worry
> about it :)
> 

FWIW, the fstests commit references the following kernel patches for
fixes in XFS and ext4:

  xfs: serialize unaligned dio writes against all other dio writes
  ext4: fix data corruption caused by unaligned direct AIO

It looks like both of those patches landed in 5.1.

Brian

> > 
> >   FSTYP         -- xfs (non-debug)
> >   PLATFORM      -- Linux/x86_64 alinux2-6 4.19.48
> >   MKFS_OPTIONS  -- -f -bsize=4096 /dev/vdc
> >   MOUNT_OPTIONS -- /dev/vdc /mnt/testarea/scra
> >   generic/538 0s ... - output mismatch (see /root/usr/local/src/xfstests/results//generic/538.out.bad)
> >       --- tests/generic/538.out   2019-05-27 13:57:06.505666465 +0800
> >       +++ /root/usr/local/src/xfstests/results//generic/538.out.bad       2019-06-05 16:43:14.702002326 +0800
> >       @@ -1,2 +1,10 @@
> >        QA output created by 538
> >       +Data verification fails
> >       +Find corruption
> >       +00000000  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >       +*
> >       +00000200  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a  ZZZZZZZZZZZZZZZZ
> >       +00002000
> >       ...
> >       (Run 'diff -u /root/usr/local/src/xfstests/tests/generic/538.out /root/usr/local/src/xfstests/results//generic/538.out.bad'  to see the entire diff)
> >   Ran: generic/538
> >   Failures: generic/538
> >   Failed 1 of 1 tests
> >   
> > I also found that the latest kernel (v5.2.0-rc2) of upstream can pass the generic/538 test. Therefore, I bisected and found the first good commit is 3110fc79606. This commit adds the hardware queue into the sort function. Besides, the sort function returns a negative value when the offset and queue (software and hardware) of two I/O requests are same. I think the second part of the change make senses. The kernel should not change the relative position of two I/O requests when their offset and queue are same. So I made the following changes and merged it into the kernel 4.19.48. After the modification, we can pass the generic/538 test on xfs. The same case can be passed on ext4, since ext4 has corresponding fix 0db24122bd7f ("ext4: fix data corruption caused by overlapping unaligned and aligned IO"). Though I think xfs should be responsible for this issue, the block layer code below is also problematic. Any ideas?
> > 
> > diff --git a/block/blk-mq.c b/block/blk-mq.c
> > index 4e563ee..a7309cd 100644
> > --- a/block/blk-mq.c
> > +++ b/block/blk-mq.c
> > @@ -1610,7 +1610,7 @@ static int plug_ctx_cmp(void *priv, struct list_head *a, struct list_head *b)
> > 
> >         return !(rqa->mq_ctx < rqb->mq_ctx ||
> >                  (rqa->mq_ctx == rqb->mq_ctx &&
> > -                 blk_rq_pos(rqa) < blk_rq_pos(rqb)));
> > +                 blk_rq_pos(rqa) <= blk_rq_pos(rqb)));
> >  }
> > 
> >  void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
> 
> I would not like to take a patch that is not upstream, but rather take
> the original commit.
> 
> Can 3110fc79606f ("blk-mq: improve plug list sorting") on its own
> resolve this issue for 4.19.y?
> 
> thanks,
> 
> greg k-h
