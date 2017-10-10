Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:35097 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755688AbdJJJnT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Oct 2017 05:43:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAOi1vP8e=jPSbhPSUBZ58g-n8rFmjkUvNy3fYxiQDf9kard4jw@mail.gmail.com>
References: <CAOQ4uxixLMRU2YT-3csTr_684vNUZ=2CazKKD-ojO68fC4f6tA@mail.gmail.com>
 <20170926042421.GP10955@dastard> <CAOQ4uxhybgUmfk_voNxgx+NVT2JabKdcgtmKxSSGRF5LS+_C+g@mail.gmail.com>
 <20171005163328.GA3562@infradead.org> <CAOi1vP8e=jPSbhPSUBZ58g-n8rFmjkUvNy3fYxiQDf9kard4jw@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 10 Oct 2017 11:43:18 +0200
Message-ID: <CAOi1vP8wQZfJZRCPSmT2Jnky=JfGHikfFvRfVmG7HvaC2-9xGw@mail.gmail.com>
Subject: Re: false positive lockdep splat with loop device
Content-Type: text/plain; charset="UTF-8"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs <linux-xfs@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Byungchul Park <byungchul.park@lge.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>

On Tue, Oct 10, 2017 at 11:16 AM, Ilya Dryomov <idryomov@gmail.com> wrote:
> On Thu, Oct 5, 2017 at 6:33 PM, Christoph Hellwig <hch@infradead.org> wrote:
>> Does the patch below fix the warning for you?
>>
>> --
>> From 28aae7104425433d39e6142adcd5b88dc5b0ad5f Mon Sep 17 00:00:00 2001
>> From: Christoph Hellwig <hch@lst.de>
>> Date: Thu, 5 Oct 2017 18:31:02 +0200
>> Subject: block: use DECLARE_COMPLETION_ONSTACK in submit_bio_wait
>>
>> This way we get our lockdep annotations right in case multiple layers
>> in the stack use submit_bio_wait.
>>
>> It also happens to simplify the code by getting rid of the submit_bio_ret
>> structure.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  block/bio.c | 19 +++++--------------
>>  1 file changed, 5 insertions(+), 14 deletions(-)
>>
>> diff --git a/block/bio.c b/block/bio.c
>> index 8338304ea256..4e18e959fc0a 100644
>> --- a/block/bio.c
>> +++ b/block/bio.c
>> @@ -917,17 +917,9 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
>>  }
>>  EXPORT_SYMBOL_GPL(bio_iov_iter_get_pages);
>>
>> -struct submit_bio_ret {
>> -       struct completion event;
>> -       int error;
>> -};
>> -
>>  static void submit_bio_wait_endio(struct bio *bio)
>>  {
>> -       struct submit_bio_ret *ret = bio->bi_private;
>> -
>> -       ret->error = blk_status_to_errno(bio->bi_status);
>> -       complete(&ret->event);
>> +       complete(bio->bi_private);
>>  }
>>
>>  /**
>> @@ -943,16 +935,15 @@ static void submit_bio_wait_endio(struct bio *bio)
>>   */
>>  int submit_bio_wait(struct bio *bio)
>>  {
>> -       struct submit_bio_ret ret;
>> +       DECLARE_COMPLETION_ONSTACK(done);
>>
>> -       init_completion(&ret.event);
>> -       bio->bi_private = &ret;
>> +       bio->bi_private = &done;
>>         bio->bi_end_io = submit_bio_wait_endio;
>>         bio->bi_opf |= REQ_SYNC;
>>         submit_bio(bio);
>> -       wait_for_completion_io(&ret.event);
>> +       wait_for_completion_io(&done);
>>
>> -       return ret.error;
>> +       return blk_status_to_errno(bio->bi_status);
>>  }
>>  EXPORT_SYMBOL(submit_bio_wait);
>
> No, it doesn't -- the splat is a little bit more complicated, but
> fundamentally the same thing.

Easily triggered with generic/361 too, BTW.

Thanks,

                Ilya
