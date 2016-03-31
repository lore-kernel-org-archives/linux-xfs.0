Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E7C7C7CA3
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 20:03:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 81B3830405F
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 18:03:10 -0700 (PDT)
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id 5PzL7ObZ3QGcVQst
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2016 18:03:02 -0700 (PDT)
Received: from mail-yw0-f176.google.com ([209.85.161.176])
	by youngberry.canonical.com with esmtpsa
	(TLS1.0:RSA_AES_128_CBC_SHA1:16) (Exim 4.76)
	(envelope-from <ming.lei@canonical.com>) id 1alR0m-0002TE-FW
	for xfs@oss.sgi.com; Thu, 31 Mar 2016 01:03:00 +0000
Received: by mail-yw0-f176.google.com with SMTP id g3so79848616ywa.3
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2016 18:03:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160330171927.GA13320@infradead.org>
References: <1459354637-17415-1-git-send-email-ming.lei@canonical.com>
	<1459354637-17415-3-git-send-email-ming.lei@canonical.com>
	<20160330171927.GA13320@infradead.org>
Date: Thu, 31 Mar 2016 09:02:59 +0800
Message-ID: <CACVXFVNtphY8bWrdMKcR7jYn5hD=H5H6jXrY111K0kZ8jJQHWw@mail.gmail.com>
Subject: Re: [PATCH v1 2/8] block: make 'struct bvec_iter' not depend on
	CONFIG_BLOCK
From: Ming Lei <ming.lei@canonical.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-block@vger.kernel.org, Boaz Harrosh <boaz@plexistor.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Jens Axboe <axboe@fb.com>, Al Viro <viro@zeniv.linux.org.uk>, Lars Ellenberg <lars.ellenberg@linbit.com>, Philipp Reisner <philipp.reisner@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

On Thu, Mar 31, 2016 at 1:19 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Mar 31, 2016 at 12:17:11AM +0800, Ming Lei wrote:
>> We will use bvec iterator to implement iterate_bvec(): lib/iov_iter.c.
>>
>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>> ---
>>  include/linux/blk_types.h | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
>> index 86a38ea..fd8527b 100644
>> --- a/include/linux/blk_types.h
>> +++ b/include/linux/blk_types.h
>> @@ -26,8 +26,6 @@ struct bio_vec {
>>       unsigned int    bv_offset;
>>  };
>>
>> -#ifdef CONFIG_BLOCK
>> -
>>  struct bvec_iter {
>>       sector_t                bi_sector;      /* device address in 512 byte
>>                                                  sectors */
>> @@ -39,6 +37,8 @@ struct bvec_iter {
>>                                                  current bvec */
>>  };
>
> I didn't catch this earlier, but shouldn't this also move to
> bvec_iter.h? Or maybe just create a linux/bvec.h for the bvec, bvec_iter
> and bvec iter macros given that those are the types used outside the
> block layer as well.

That way may cause trouble to blk_type.h because it needs bvec_iter,
then looks not good to always include bvec_iter.h into blk_type.h.

Thanks,
Ming

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
