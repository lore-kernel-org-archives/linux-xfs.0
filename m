Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:40159 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbfFNG55 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Jun 2019 02:57:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id p11so1274509wre.7
        for <linux-xfs@vger.kernel.org>; Thu, 13 Jun 2019 23:57:55 -0700 (PDT)
Subject: Re: alternative take on the same page merging leak fix v2
References: <20190613095529.25005-1-hch@lst.de>
 <00c908ad-ca33-164d-3741-6c67813c1f0d@kernel.dk>
 <20190614011946.GB14436@ming.t460p> <20190614054514.GB6722@lst.de>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <3c6c6496-a053-d6bd-6878-3b1433d036fc@kernel.dk>
Date: Fri, 14 Jun 2019 00:57:51 -0600
MIME-Version: 1.0
In-Reply-To: <20190614054514.GB6722@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc: David Gibson <david@gibson.dropbear.id.au>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org

On 6/13/19 11:45 PM, Christoph Hellwig wrote:
> On Fri, Jun 14, 2019 at 09:19:47AM +0800, Ming Lei wrote:
>> On Thu, Jun 13, 2019 at 04:04:03AM -0600, Jens Axboe wrote:
>>> On 6/13/19 3:55 AM, Christoph Hellwig wrote:
>>>> Hi Jens, hi Ming,
>>>>
>>>> this is the tested and split version of what I think is the better
>>>> fix for the get_user_pages page leak, as it leaves the intelligence
>>>> in the callers instead of in bio_try_to_merge_page.
>>>>
>>>> Changes since v1:
>>>>    - drop patches not required for 5.2
>>>>    - added Reviewed-by tags
>>>
>>> Applied for 5.2, thanks.
>>
>> Hi Jens & Christoph,
>>
>> Looks the following change is missed in patch 1, otherwise kernel oops
>> is triggered during kernel booting:
> 
> Ok, true, sorry.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

I've dropped the two patches. Please send them again, when they are
tested. Not making -rc5 at this time.

-- 
Jens Axboe
