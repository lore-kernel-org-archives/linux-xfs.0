Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1D2CB7F52
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 14:49:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9CAEEAC013
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 12:49:01 -0700 (PDT)
Received: from greer.hardwarefreak.com (mo-65-41-216-221.sta.embarqhsd.net
	[65.41.216.221]) by cuda.sgi.com with ESMTP id mFdo0QmQP1y1dU3q
	for <xfs@oss.sgi.com>; Thu, 08 May 2014 12:49:00 -0700 (PDT)
Message-ID: <536BDFAD.1090700@hardwarefreak.com>
Date: Thu, 08 May 2014 14:49:01 -0500
From: Stan Hoeppner <stan@hardwarefreak.com>
MIME-Version: 1.0
Subject: Re: Alignment: XFS + LVM2
References: <CAPrERe02bfrW6+5c+oZPgd9c_7AUx=BEUcAOAj2dT_iYn=P_1w@mail.gmail.com>	<536AEBB9.3020807@hardwarefreak.com>	<CAPrERe3v_1mPy6ABAKj4TxTmy1FB2=ipi6Vn3N6dZ7w8B9DeZA@mail.gmail.com>	<536B80E0.9000406@hardwarefreak.com>
	<CAPrERe2K=DhR2frozaranf3JWgrFi81o5bhBF-BhmWcrW=4L=g@mail.gmail.com>
In-Reply-To: <CAPrERe2K=DhR2frozaranf3JWgrFi81o5bhBF-BhmWcrW=4L=g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Marc Caubet <mcaubet@pic.es>
Cc: xfs@oss.sgi.com

On 5/8/2014 8:52 AM, Marc Caubet wrote:
> Hi Stan,
> 
> once again, thanks for your answer.

You bet.

...
>  Actually all LSI controllers have batteries so I hope it will not happen.
> This problems is good to have this in mind when we purchase new storage
> machines so thanks :)

Battery or flash backed cache on the controller does not prevent this
problem.  This read-modify-write operation is internal to the drive and
transparent to the controller.

...
> Great thanks, this is exactly what I needed and I think I am starting to
> understand then :) So a RAID6 of 16+2 disks, stripe width of 256KB will
> have a stripe width of 256*16=4096 which is a power of 2. Then in this case
> LVM2 can be used. Am I correct? Then seems clear to me that new purchases
> will go in this way (we have planned a new purchase in the next month and I
> am trying to understand this)

Use md for the outer stripe so you have no hardware and no stripe unit
limitations.  If you need features of LVM such as snapshots simply layer
a PV and LV atop the md RAID0 device.

...
>> It must be aligned to the outer stripe in the nest, which would be the
>> LVM geometry if it could work.  However, as stated, it appears you
>> cannot use lvcreate to make the outer stripe because it does not allow a
>> 2560 KiB StripeSize.  Destroy the LVM volume and create an md RAID0
>> device of the 3 RAID6 devices, eg:
>>
>> $ mdadm -C /dev/md0 --raid_devices=3 --chunk=2560 --level=0 /dev/sd[abc]
>>
>> For making the filesystem and aligning it to the md nested stripe
>> RAID60, this is all that is required:
>>
>> $ mkfs.xfs -d su=2560k,sw=3 /dev/md0
>>
> 
> Perfect! I'll try this with the current server having 3xRAID6(10+2). You
> really helped me with that.
> 
> Just one final question, if I had 3*RAID6(16+2) the Stripe Width should be
> 4096 (256KB*16) and when applying this to LVM2 should be:

Again, do not use LVM for the outer stripe.

$ mdadm -C /dev/md0 --raid_devices=3 --chunk=4096 --level=0 /dev/sd[abc]

> And then the XFS format should be:

$ mkfs.xfs -d su=4096k,sw=3 /dev/md0

> Is it correct?

It is now.

> Thanks a lot for your help,

Sure thing.

Cheers,

Stan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
