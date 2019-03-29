Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:46568 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728853AbfC2PBb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 29 Mar 2019 11:01:31 -0400
Subject: Re: [PATCH v3 2/3] block: verify data when endio
References: <20190329142346.1677-1-bob.liu@oracle.com>
 <20190329142346.1677-3-bob.liu@oracle.com>
 <41c8688a-65bd-96ac-9b23-4facd0ade4a7@kernel.dk> <yq1ftr5rbq1.fsf@oracle.com>
 <f65d6a7b-9e69-ae1e-b8b8-8769dc650311@kernel.dk> <yq1bm1trb4y.fsf@oracle.com>
 <feefa611-b744-326c-29d5-c64bcda45d9f@kernel.dk> <yq17echrax1.fsf@oracle.com>
 <1b638dc2-56fd-6ab4-dcca-ad2adb9931bb@kernel.dk>
From: Bob Liu <bob.liu@oracle.com>
Message-ID: <c9adb48c-7b6e-2017-9480-aa2342b3523b@oracle.com>
Date: Fri, 29 Mar 2019 23:00:58 +0800
MIME-Version: 1.0
In-Reply-To: <1b638dc2-56fd-6ab4-dcca-ad2adb9931bb@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, shirley.ma@oracle.com, allison.henderson@oracle.com, david@fromorbit.com, darrick.wong@oracle.com, hch@infradead.org, adilger@dilger.ca, tytso@mit.edu

On 3/29/19 10:52 PM, Jens Axboe wrote:
> On 3/29/19 8:51 AM, Martin K. Petersen wrote:
>>
>> Jens,
>>
>>> The integrity stuff still has that nasty pointer in there. It'd be
>>> nice to get rid of that as well, and hide it all in a parent container
>>> of the bio.
>>
>> That's fine with me. We really didn't have that option a decade ago.
> 
> Right, but now we do. Hence trying to nudge things in that direction,
> instead of adding another pointer to struct bio for a new use case. I'd
> much rather go that route, instead of unionizing with another pointer
> that should be going away instead.
> 

No problem, will update in next version.
Let me wait a while for feedback about the verify callback.
Thank you!
