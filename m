Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q5CDSTOg242982 for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 08:28:29 -0500
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id p6J8FdhoGNfUVdtz
	for <xfs@oss.sgi.com>; Tue, 12 Jun 2012 06:28:28 -0700 (PDT)
Message-ID: <4FD74406.7000602@canonical.com>
Date: Tue, 12 Jun 2012 08:28:38 -0500
From: Chris J Arges <chris.j.arges@canonical.com>
MIME-Version: 1.0
Subject: Re: Still seeing hangs in xlog_grant_log_space
References: <CADLDEKsP4DsXf_G07ub+a-ODbrJbsiprRJUX1fJdaQ41TB7+Xg@mail.gmail.com>
	<CAH4wwdGWHSZoveLJMxu5pjr22NEEeW7oG8TS+snoM8RY=ZeRmg@mail.gmail.com>
	<CADLDEKsGtsw-rrSOE7gY4T81u+p41b34ixv0B7Dh07afJ73n2w@mail.gmail.com>
	<CAH4wwdFu7DEkHFZ5Bf7_PtLPsG0hUyUDoov03q=82R6t+QkERg@mail.gmail.com>
	<20120605235447.GF22848@dastard> <4FCF5DB9.2000808@redhat.com>
	<4FCF9655.3070300@sgi.com> <33996217.post@talk.nabble.com>
	<20120611235337.GE22848@dastard>
In-Reply-To: <20120611235337.GE22848@dastard>
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
Cc: xfs@oss.sgi.com

On 06/11/2012 06:53 PM, Dave Chinner wrote:
> On Mon, Jun 11, 2012 at 01:42:31PM -0700, Chris J Arges wrote:
>> Mark Tinguely-3 wrote:
>>>
>>> The perl script to recreate this problem is very similar to xfstest 273.
>>> I use that because it avoids all the filesystem mount/unmount that
>>> happen between the test 273 loops. You can build the log size that you
>>> want to test, create the directories and let it run until it hangs.
>>>
>>
>> I tested xfstest 273, and it looks like it exhibits a different issue than
>> the OP in this thread.
>> For example, if I run this test in a while [1] loop, I get the following
>> backtrace:
>>
>> [16413.073946] XFS (sda5): Invalid block length (0xfffff48b) for buffer
> 
> That looks bad. How big is the log on this filesystem?
> 
The test and scratch partitions were created with the following commands:
mkfs.xfs -b size=1024 -l size=576b /dev/sda5
mkfs.xfs -b size=1024 -l size=576b /dev/sda6

>> [16413.073963] BUG: unable to handle kernel NULL pointer dereference at
>> 0000000000000130
>> [16413.074274] IP: [<ffffffffa02bb870>] uuid_is_nil+0x10/0x50 [xfs]
> 
> I can't really see how this function can get a null pointer
> dereference. It checks the pointer passed in for being null before
> doing anything, and otherwise it just increments and dereferences
> the char pointer 16 times. I can't see how that results in a NULL
> being dereferenced - I might just be blind though.
> 
Yea, this is odd. What I'm really trying to accomplish is seeing if this
xfstest 273 produces a similar hang to Juerg's original bug. If you've
already run this test and it produced a hang can you post the backtrace
or let me know if it is similar?

Thanks,
--chris


> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
