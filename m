Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52264 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726317AbeHZGGa (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 26 Aug 2018 02:06:30 -0400
Subject: Re: Trying to write to read-only block-device from XFS
References: <20180824233756.kkvmkmm5mdlx77je@two.firstfloor.org>
 <a4d32107-abc0-60d3-8306-b091fbffefd8@sandeen.net>
 <20180825140951.a3dsz3efwnjsj2pz@two.firstfloor.org>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c6bcbef0-0c5b-a7a1-adb6-38085db98ce9@sandeen.net>
Date: Sat, 25 Aug 2018 21:25:33 -0500
MIME-Version: 1.0
In-Reply-To: <20180825140951.a3dsz3efwnjsj2pz@two.firstfloor.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-xfs@vger.kernel.org



On 8/25/18 9:09 AM, Andi Kleen wrote:
> On Fri, Aug 24, 2018 at 07:58:05PM -0500, Eric Sandeen wrote:
>> On 8/24/18 6:37 PM, Andi Kleen wrote:
>>>
>>> Seen this a few times now with recent kernels:
>>
>> Hi Andi -
>>
>> Dumb question maybe, but just to be clear -
>> Was this an RO mount on an RO device, or something else?
>> What type of mount was this?
> 
> Was just a normal RW partition on a normal SSD. I didn't do anything
> special to make it RO.

I don't know why it shows up as RO at this point, but maybe this fixes it:

commit b089cfd95d32638335c551651a8e00fd2c4edb0b
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Aug 14 10:52:40 2018 -0600

    block: don't warn for flush on read-only device
    
    Don't warn for a flush issued to a read-only device. It's not strictly
    a writable command, as it doesn't change any on-media data by itself.
    
    Reported-by: Stefan Agner <stefan@agner.ch>
    Fixes: 721c7fc701c7 ("block: fail op_is_write() requests to read-only partitions")
    Signed-off-by: Jens Axboe <axboe@kernel.dk>
