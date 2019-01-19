Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from hqemgate15.nvidia.com ([216.228.121.64]:19385 "EHLO
        hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728770AbfASTBH (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 19 Jan 2019 14:01:07 -0500
Subject: Re: [PATCH] iomap: get/put the page in iomap_page_create/release()
References: <20190115211028.15742-1-hch@lst.de>
 <20190115230744.GM4205@dastard> <20190117075145.GA29509@lst.de>
 <5777f872-49a9-2717-a0c1-664908aeb8e1@nvidia.com>
 <20190119094533.GA21729@lst.de>
From: Piotr Jaroszynski <pjaroszynski@nvidia.com>
Message-ID: <ef7e3ffd-2665-5924-79a8-18a31f02e264@nvidia.com>
Date: Sat, 19 Jan 2019 11:01:05 -0800
MIME-Version: 1.0
In-Reply-To: <20190119094533.GA21729@lst.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org

On 1/19/19 1:45 AM, Christoph Hellwig wrote:
> On Thu, Jan 17, 2019 at 09:32:32AM -0800, Piotr Jaroszynski wrote:
>> On 1/16/19 11:51 PM, Christoph Hellwig wrote:
>>> On Wed, Jan 16, 2019 at 10:07:45AM +1100, Dave Chinner wrote:
>>>> Missing a SOB.
>>>>
>>>> But apart from that, I've been running an identical patch in my test
>>>> tree, so:
>>>
>>> Piotr: do you still want to claim authorship for this fixed up patch,
>>> in which case I'll need your sob.  Otherwise I can submit it under my
>>> name.
>>
>> Sorry for the delay and thank you for handling the revert while I was
>> out on paternity leave. I'm fine with whatever is easiest for you,
>> and thanks for fixing up the patch!
> 
> In that case I'll happily keep you as the author.  Can you re-cofirm
> your signoff for this modified variant so we pick it up?
> 

Sure:
Signed-off-by: Piotr Jaroszynski <pjaroszynski@nvidia.com>

Thanks,
Piotr
