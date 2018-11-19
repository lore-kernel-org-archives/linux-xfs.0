Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:39543 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbeKSNc3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Nov 2018 08:32:29 -0500
Received: by mail-pg1-f194.google.com with SMTP id w6so898839pgl.6
        for <linux-xfs@vger.kernel.org>; Sun, 18 Nov 2018 19:10:18 -0800 (PST)
Subject: Re: [PATCH V10 01/19] block: introduce multi-page page bvec helpers
References: <20181115085306.9910-1-ming.lei@redhat.com>
 <20181115085306.9910-2-ming.lei@redhat.com> <20181116131305.GA3165@lst.de>
 <20181119022327.GC10838@ming.t460p>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <83fb4102-bffe-41f1-c8d0-3bdf61fe0ba8@kernel.dk>
Date: Sun, 18 Nov 2018 20:10:14 -0700
MIME-Version: 1.0
In-Reply-To: <20181119022327.GC10838@ming.t460p>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Dave Chinner <dchinner@redhat.com>, Kent Overstreet <kent.overstreet@gmail.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, linux-erofs@lists.ozlabs.org, David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Gao Xiang <gaoxiang25@huawei.com>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org, Boaz Harrosh <ooo@electrozaur.com>, Bob Peterson <rpeterso@redhat.com>, cluster-devel@redhat.com

On 11/18/18 7:23 PM, Ming Lei wrote:
> On Fri, Nov 16, 2018 at 02:13:05PM +0100, Christoph Hellwig wrote:
>>> -#define bvec_iter_page(bvec, iter)				\
>>> +#define mp_bvec_iter_page(bvec, iter)				\
>>>  	(__bvec_iter_bvec((bvec), (iter))->bv_page)
>>>  
>>> -#define bvec_iter_len(bvec, iter)				\
>>> +#define mp_bvec_iter_len(bvec, iter)				\
>>
>> I'd much prefer if we would stick to the segment naming that
>> we also use in the higher level helper.
>>
>> So segment_iter_page, segment_iter_len, etc.
> 
> We discussed the naming problem before, one big problem is that the 'segment'
> in bio_for_each_segment*() means one single page segment actually.
> 
> If we use segment_iter_page() here for multi-page segment, it may
> confuse people.
> 
> Of course, I prefer to the naming of segment/page, 
> 
> And Jens didn't agree to rename bio_for_each_segment*() before.

I didn't like frivolous renaming (and I still don't), but mp_
is horrible imho. Don't name these after the fact that they
are done in conjunction with supporting multipage bvecs. That
very fact will be irrelevant very soon

-- 
Jens Axboe
