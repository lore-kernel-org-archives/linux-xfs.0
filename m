Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A70E47F47
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 18:45:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 429EEAC004
	for <xfs@oss.sgi.com>; Sat,  9 Jan 2016 16:45:00 -0800 (PST)
Received: from sabe.cs.wisc.edu (sabe.cs.wisc.edu [128.105.6.20]) by
	cuda.sgi.com with ESMTP id u4Z4JDCTKP4ZYdBs (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sat, 09 Jan 2016 16:44:55 -0800 (PST)
Message-ID: <5691A934.8020000@cs.wisc.edu>
Date: Sat, 09 Jan 2016 18:43:32 -0600
From: Mike Christie <michaelc@cs.wisc.edu>
MIME-Version: 1.0
Subject: Re: [PATCH 01/35] block/fs/drivers: remove rw argument from submit_bio
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
	<1452027218-32303-2-git-send-email-mchristi@redhat.com>
	<20160109133409.GA26660@infradead.org>
In-Reply-To: <20160109133409.GA26660@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>, mchristi@redhat.com
Cc: linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com, linux-scsi@vger.kernel.org, konrad.wilk@oracle.com, linux-kernel@vger.kernel.org, philipp.reisner@linbit.com, linux-f2fs-devel@lists.sourceforge.net, linux-raid@vger.kernel.org, dm-devel@redhat.com, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, osd-dev@open-osd.org, linux-fsdevel@vger.kernel.org, lars.ellenberg@linbit.com, linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org, drbd-dev@lists.linbit.com

On 01/09/2016 07:34 AM, Christoph Hellwig wrote:
>>  				count);
>> > diff --git a/block/blk-flush.c b/block/blk-flush.c
>> > index 9c423e5..e092e13 100644
>> > --- a/block/blk-flush.c
>> > +++ b/block/blk-flush.c
>> > @@ -484,8 +484,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
>> >  
>> >  	bio = bio_alloc(gfp_mask, 0);
>> >  	bio->bi_bdev = bdev;
>> > +	bio->bi_rw |= WRITE_FLUSH;
> Shouldn't the |= be a = here and in many other places?

Yeah, I was trying to merge bi_rw and bio_flags. I am not going to send
that. I will fix up the patchset.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
