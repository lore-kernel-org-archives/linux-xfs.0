Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45014 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbeHFGOG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 6 Aug 2018 02:14:06 -0400
Subject: Re: [PATCH V2] mkfs: avoid divide-by-zero when hardware reports
 optimal i/o size as 0
References: <c347c3d7-2181-d114-7547-2649bb2f1022@redhat.com>
 <20180805222044.GJ2234@dastard>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <eeb7bc2b-53ca-3f56-7551-6bc4ea9764bb@redhat.com>
Date: Sun, 5 Aug 2018 23:06:57 -0500
MIME-Version: 1.0
In-Reply-To: <20180805222044.GJ2234@dastard>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>

On 8/5/18 5:20 PM, Dave Chinner wrote:
> On Wed, Aug 01, 2018 at 03:49:45PM -0500, Eric Sandeen wrote:
>> From: Jeff Mahoney <jeffm@suse.com>
>>
>> Commit 051b4e37f5e (mkfs: factor AG alignment) factored out the
>> AG alignment code into a separate function.  It got rid of
>> redundant checks for dswidth != 0 since calc_stripe_factors was
>> supposed to guarantee that if dsunit is non-zero dswidth will be
>> as well.  Unfortunately, there's hardware out there that reports its
>> optimal i/o size as larger than the maximum i/o size, which the kernel
>> treats as broken and zeros out the optimal i/o size.
>>
>> To resolve this we can check the topology before consuming it, and
>> ignore the bad stripe geometry.
>>
>> [sandeen: remove guessing heuristic, just warn and ignore bad data.]
>>
>> Fixes: 051b4e37f5e (mkfs: factor AG alignment)
>> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
>> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
>> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
>> ---
>>
>> so, I rewrote this a bit.  I'm not a fan of guessing what the kernel
>> really must have meant, becaue next time the root cause may be differnt.
>> In other cases we ignore bad geometry, I think we should in this case as
>> well.  This will also let me go forward with a factored-out geometry checker,
>> and for user-specified badness we'll warn and exit, for kernel-provided
>> badness we'll warn and ignore.
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 1074886..2e53c1e 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -2281,11 +2281,20 @@ _("data stripe width (%d) must be a multiple of the data stripe unit (%d)\n"),
>>  
>>  	/* if no stripe config set, use the device default */
>>  	if (!dsunit) {
>> -		dsunit = ft->dsunit;
>> -		dswidth = ft->dswidth;
>> -		use_dev = true;
>> +		/* Ignore nonsense from device.  XXX add more validation */
>> +		if (ft->dsunit && ft->dswidth == 0) {
>> +			fprintf(stderr,
>> +_("%s: Volume reports stripe unit of %d bytes and stripe width of 0, ignoring.\n"),
>> +				progname, BBTOB(ft->dsunit));
>> +			ft->dsunit = 0;
>> +			ft->dswidth = 0;
> 
> Not sure this is the right thing to do. If a stripe unit has been
> given, then the device has an alignment requirement. If it hasn't
> given an "optimal IO size", then shouldn't we just set ft->dswidth =
> ft->dsunit to retain the alignment the device requested?

Yeah, I'm on the fence about that.  If it's giving us inconsistent information,
how can we know what's right and wrong?

-Eric
