Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:33948 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726140AbeLHOuS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 8 Dec 2018 09:50:18 -0500
Subject: Re: [RFC PATCH v1 0/7] Block/XFS: Support alternative mirror device
 retry
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
 <20181128053303.GL6311@dastard> <20181128074544.GA20702@infradead.org>
From: Bob Liu <bob.liu@oracle.com>
Message-ID: <f7bf5329-e756-1edb-af3f-41aca02691fe@oracle.com>
Date: Sat, 8 Dec 2018 22:49:44 +0800
MIME-Version: 1.0
In-Reply-To: <20181128074544.GA20702@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
Cc: Allison Henderson <allison.henderson@oracle.com>, linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, martin.petersen@oracle.com, shirley.ma@oracle.com

On 11/28/18 3:45 PM, Christoph Hellwig wrote:
> On Wed, Nov 28, 2018 at 04:33:03PM +1100, Dave Chinner wrote:
>> 	- how does propagation through stacked layers work?
> 
> The only way it works is by each layering driving it.  Thus my
> recommendation above bilding on your earlier one to use an index
> that is filled by the driver at I/O completion time.
> 
> E.g.
> 
> 	bio_init:		bi_leg = -1
> 
> 	raid1:			submit bio to lower driver
> 	raid 1 completion:	set bi_leg to 0 or 1
> 
> Now if we want to allow stacking we need to save/restore bi_leg
> before submitting to the underlying device.  Which is possible,
> but quite a bit of work in the drivers.
> 

I found it's still very challenge while writing the code.
save/restore bi_leg may not enough because the drivers don't know how to do fs-metadata verify.

E.g two layer raid1 stacking

fs:                  md0(copies:2)
                     /          \
layer1/raid1   md1(copies:2)    md2(copies:2)
                  /    \          /     \
layer2/raid1   dev0   dev1      dev2    dev3

Assume dev2 is corrupted
 => md2: don't know how to do fs-metadata verify. 
   => md0: fs verify fail, retry md1(preserve md2).
Then md2 will never be retried even dev3 may also has the right copy.
Unless the upper layer device(md0) can know the amount of copy is 4 instead of 2? 
And need a way to handle the mapping.
Did I miss something? Thanks!

-Bob

>> 	- is it generic/abstract enough to be able to work with
>> 	  RAID5/6 to trigger verification/recovery from the parity
>> 	  information in the stripe?
> 
> If we get the non -1 bi_leg for paritity raid this is an inidicator
> that parity rebuild needs to happen.  For multi-parity setups we could
> also use different levels there.
> 
