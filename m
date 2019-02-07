Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44436 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726266AbfBGC1W (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 6 Feb 2019 21:27:22 -0500
Subject: Re: bcache on XFS: metadata I/O (dirent I/O?) not getting cached at
 all?
References: <87h8dgefee.fsf@esperi.org.uk> <20190206234328.GH14116@dastard>
 <20190207002425.GX24140@tuebingen.mpg.de>
From: Coly Li <colyli@suse.de>
Message-ID: <b982a23b-7225-d20a-2802-60bce314ccc2@suse.de>
Date: Thu, 7 Feb 2019 10:27:11 +0800
MIME-Version: 1.0
In-Reply-To: <20190207002425.GX24140@tuebingen.mpg.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andre Noll <maan@tuebingen.mpg.de>, Dave Chinner <david@fromorbit.com>
Cc: Nix <nix@esperi.org.uk>, linux-bcache@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, axboe@kernel.dk

On 2019/2/7 8:24 上午, Andre Noll wrote:
> On Thu, Feb 07, 10:43, Dave Chinner wrote
>> File data readahead: REQ_RAHEAD Metadata readahead: REQ_META |
>> REQ_RAHEAD
>> 
>> drivers/md/bcache/request.c::check_should_bypass():
>> 
>> /* * Flag for bypass if the IO is for read-ahead or background, *
>> unless the read-ahead request is for metadata (eg, for gfs2). */ 
>> if (bio->bi_opf & (REQ_RAHEAD|REQ_BACKGROUND) && !(bio->bi_opf &
>> REQ_PRIO)) goto skip;
>> 
>> bcache needs fixing - it thinks REQ_PRIO means metadata IO.
>> That's wrong - REQ_META means it's metadata IO, and so this is a
>> bcache bug.
> 
> Do you think 752f66a75abad is bad (ha!) and should be reverted?

Hi Dave and Andre,

Correct me if I am wrong: REQ_META is used for blktrace to tag
metadata IO, and REQ_PRIO is used for block layer to handle metadata IO.

I discussed with Christoph Hellwig about this topic quite long time
ago, and got the above conclusion.

If different file system handles metadata flags in unified ways, it is
OK to me to change the code to: !(bio->bi_opf & (REQ_META |REQ_PRIO)).

Thanks in advance.

-- 

Coly Li
