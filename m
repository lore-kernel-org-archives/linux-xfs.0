Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8B3luME006180 for <xfs@oss.sgi.com>; Mon, 10 Sep 2012 22:47:56 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id NwiaiWtSY16kT2qh for <xfs@oss.sgi.com>;
	Mon, 10 Sep 2012 20:49:00 -0700 (PDT)
Message-ID: <504EB4AB.4050100@sandeen.net>
Date: Mon, 10 Sep 2012 22:48:59 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH v3] Add test case to test xfs projid32bit functionality
	a bit more extensively.
References: <CAFZPdfjKfZP85f8zCLxCOf__ZyBd=tKsvqRGS-_bcaR0P_JuWA@mail.gmail.com>
	<504EA627.2050906@sandeen.net> <20120911034510.GA11511@dastard>
In-Reply-To: <20120911034510.GA11511@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Boris Ranto <ranto.boris@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On 9/10/12 10:45 PM, Dave Chinner wrote:
> On Mon, Sep 10, 2012 at 09:47:03PM -0500, Eric Sandeen wrote:
>> On 9/6/12 10:23 AM, Boris Ranto wrote:
>>>    The test covers several areas including enabling projid32bit
>>> functionality dynamically by xfs_admin, dumping, restoring, quota
>>> reporting and xfs_db projid values reporting.
>>>   This test case hits a bug with xfsdump/xfsrestore process on a
>>> projid32bit enabled filesystem.
>>>
>>> Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
>>
>> there are just a couple things below, but I think we can get it
>> checked in unless Dave has further concerns - please see below.
> ....
>>> +dir=$SCRATCH_MNT/pquota
>>> +
>>> +status=1
>>> +
>>> +mkdir -p $dir
>>> +touch $dir/{16,32}less
>>
>> Although I understand it ok, I might add a comment here saying:
>>
>> # create files to hold 16 and 32-bit project IDs
>>
>> In retrospect I might use 16bit and 32bit to make more sense.
>> Sorry, should have suggested that earlier.
>>
>> I could just change the names on checkin with a note if that's ok with you.
> 
> With that change to 16bit/32bit, it's fine by me.
> 
>>> @@ -403,3 +403,4 @@ deprecated
>>>  282 dump ioctl auto quick
>>>  283 dump ioctl auto quick
>>>  284 auto
>>> +285 auto dump quota
> 
> Like I mentione dfirst time around, it needs to be added to the
> quick group as well.

oops missed that.

> If you make those changes, Eric, then consider it:
> 
> Reviewed-by: Dave Chinner <dchinner@redhat.com>

I'll fix those up & commit.

thanks,
-Eric

> Cheers,
> 
> Dave.
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
