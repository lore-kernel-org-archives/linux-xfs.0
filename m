Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:37108 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751366AbdIEORo (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 5 Sep 2017 10:17:44 -0400
Subject: Re: [PATCH] mkfs: Remove messages printed when blocksize < physical
 sectorsize
References: <20170905054442.28615-1-chandan@linux.vnet.ibm.com>
 <20170905063139.GA679@infradead.org> <20170905064412.GK17782@dastard>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <269c55df-eb46-0c9a-6f7f-72a1becd2499@sandeen.net>
Date: Tue, 5 Sep 2017 09:17:42 -0500
MIME-Version: 1.0
In-Reply-To: <20170905064412.GK17782@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-xfs@vger.kernel.org, Omar Sandoval <osandov@fb.com>, linux-block@vger.kernel.org



On 9/5/17 1:44 AM, Dave Chinner wrote:
> On Mon, Sep 04, 2017 at 11:31:39PM -0700, Christoph Hellwig wrote:
>> On Tue, Sep 05, 2017 at 11:14:42AM +0530, Chandan Rajendra wrote:
>>> Linux kernel commit 6c6b6f28b3335fd85ec833ee0005d9c9dca6c003 (loop: set
>>> physical block size to PAGE_SIZE) now sets PAGE_SIZE as the default
>>> physical sector size of loop devices. On ppc64, this causes loop devices
>>> to have 64k as the physical sector size.
>>
>> Eek.  We'll need to revert the loop change ASAP!
> 
> And, FWIW, making the warning go away if probably a bad idea,
> because XFS only supports devices with sector sizes up
> to 32k:

Well, TBH removing this warning was my suggestion, because it's
automatically fixing values that weren't specified by the user in
the first place.  First preference is physical sector size, then
fallback to logical but it doesn't need to be noisy about it.

> #define XFS_MIN_SECTORSIZE_LOG  9       /* i.e. 512 bytes */
> #define XFS_MAX_SECTORSIZE_LOG  15      /* i.e. 32768 bytes */
> 
> And so it should be warning about devices trying to tell it to use
> something larger....

As long as the logical sector size is small enough, it seems like a
silent adjustment is probably ok,  no?

-Eric

> Cheers,
> 
> Dave.
> 
