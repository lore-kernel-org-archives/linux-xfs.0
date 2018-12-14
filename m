Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:38036 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbeLNNs0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 08:48:26 -0500
Subject: Re: [PATCH 2/3] iomap: don't search past page end in
 iomap_is_partially_uptodate
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
 <1544739929-21651-3-git-send-email-sandeen@sandeen.net>
 <20181214025720.GJ6311@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c562b535-c94f-6da1-edbf-2c157b010602@sandeen.net>
Date: Fri, 14 Dec 2018 07:48:25 -0600
MIME-Version: 1.0
In-Reply-To: <20181214025720.GJ6311@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de

On 12/13/18 8:57 PM, Dave Chinner wrote:
> On Thu, Dec 13, 2018 at 04:25:28PM -0600, Eric Sandeen wrote:
>> From: Eric Sandeen <sandeen@redhat.com>
>>
>> iomap_is_partially_uptodate() is intended to check wither blocks within
>> the selected range of a not-uptodate page are uptodate; if the range we
>> care about is up to date, it's an optimization.
>>
>> However, the iomap implementation continues to check all blocks up to
>> from+count, which is beyond the page, and can even be well beyond the
>> iop->uptodate bitmap.
> 
> The issue is that the caller does not limit the range to the page it
> is checking to see if it is up to date. Hence we have to clamp it.

yes.

(It occurs to me that maybe we should fix/change this in the caller instead
so the implementations don't all have to do the same thing?)

>> I think the worst that will happen is that we may eventually find a zero
>> bit and return "not partially uptodate" when it would have otherwise
>> returned true, and skip the optimization.  Still, it's clearly an invalid
>> memory access that must be fixed.
> 
> It depends on how far beyond the page the count extends. :P
> 
>> So: fix this by limiting the search to within the page as is done in the
>> non-iomap variant, block_is_partially_uptodate().
>>
>> Zorro noticed thiswhen KASAN went off for 512 byte blocks on a 64k
>> page system:
>>
>>  BUG: KASAN: slab-out-of-bounds in iomap_is_partially_uptodate+0x1a0/0x1e0
>>  Read of size 8 at addr ffff800120c3a318 by task fsstress/22337
>>
>> Reported-by: Zorro Lang <zlang@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> 
> SOB issue. :)

yeah :/

thanks for the review,
-Eric

> But hte code is the same as the patch I wrote yesterday for this and
> tested overnight, so
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> 
> -Dave.
> 
