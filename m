Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A5CB67F6A
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 07:00:17 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4FB24AC002
	for <xfs@oss.sgi.com>; Tue,  9 Apr 2013 05:00:14 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	5WF2LcvYcGbLEvKx for <xfs@oss.sgi.com>;
	Tue, 09 Apr 2013 05:00:09 -0700 (PDT)
Date: Tue, 9 Apr 2013 22:00:06 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] xfstests generic 310: fix common file path and other
	cleanups
Message-ID: <20130409120006.GK17758@dastard>
References: <5163B257.4080809@gmail.com> <20130409064030.GF17758@dastard>
	<5163C27D.8000101@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5163C27D.8000101@gmail.com>
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
To: Zhao Hongjiang <zhaohongjiang37@gmail.com>
Cc: rjohnston@sgi.com, eguan@redhat.com, xfs@oss.sgi.com

On Tue, Apr 09, 2013 at 03:25:49PM +0800, Zhao Hongjiang wrote:
> On 2013-4-9 14:40, Dave Chinner wrote:
> > On Tue, Apr 09, 2013 at 02:16:55PM +0800, Zhao Hongjiang wrote:
> >> On 2013/4/8 22:05, Rich Johnston wrote:
> >>> Hi Eryu,
> >>>
> >>> Thanks for this cleanup patch. I was going to revert patch "bbaf78c0" which introduced test generic/310 but will wait and see if Zhao will provide more information which could be added to this patch.
> >>>
> >>>
> >>> On 04/07/2013 05:39 AM, Eryu Guan wrote:
> >>>> 1. add one space between # and test description
> >>>
> >>> The rest of the changes look good, sorry I missed them when I reviewed .
> >>>
> >>>> 2. remove creator/owner info
> >>>> 3. fix common/rc and common/filter path so they can be sourced correctly
> >>>> 4. no need to remove $seq.full cause it's not used(or if verbose output
> >>>>     is needed, $seqres.full should be used)
> >>>>
> >>>> Signed-off-by: Eryu Guan <eguan@redhat.com>
> >>>> ---
> >>>>   tests/generic/310 | 12 +++++-------
> >>>>   1 file changed, 5 insertions(+), 7 deletions(-)
> >>>>
> >>>> diff --git a/tests/generic/310 b/tests/generic/310
> >>>> index ef51422..35baa23 100644
> >>>> --- a/tests/generic/310
> >>>> +++ b/tests/generic/310
> >>>> @@ -1,8 +1,8 @@
> >>>>   #! /bin/bash
> >>>>   # FS QA Test No. 310
> >>>>   #
> >>>> -#Check if there are two threads,one keeps calling read() or lseek(), and
> >>>> -#the other calling readdir(), both on the same directory fd.
> >>>> +# Check if there are two threads,one keeps calling read() or lseek(), and
> >>>> +# the other calling readdir(), both on the same directory fd.
> >>>>   #
> >>>
> >>> Hi Zhao,
> >>>
> >>> I did see both threads running at the same time, but the more I
> >>> look at this, the more I am a loss as to what this test is
> >>> doing.
> >>>
> >>> Will you expand this a little please.  I should have asked for
> >>> more justification the first time I reviewed this. Please
> >>> provide what bug this is testing or what failure/weakness this
> >>> test exposes.  If there is a commit this is related to, please
> >>> reference it.
> >>>
> >> When I ran it on ext2, ext3 and ext4 which has dir_index feature
> >> disabled, I got something like this:
> >>
> >> EXT3-fs error (device loop1): ext3_readdir: bad entry in directory
> >> #34817: rec_len is \ smaller than minimal - offset=993, inode=0,
> >> rec_len=0, name_len=0 EXT3-fs error \ (device loop1):
> >> ext3_readdir: bad entry in directory #34817: rec_len is smaller
> >> than \ minimal - offset=1009, inode=0, rec_len=0, name_len=0
> >> EXT3-fs error (device loop1): \ ext3_readdir: bad entry in
> >> directory #34817: rec_len is smaller than minimal - \ offset=993,
> >> inode=0, rec_len=0, name_len=0 EXT3-fs error (device loop1): \
> >> ext3_readdir: bad entry in directory #34817: rec_len is smaller
> >> than minimal - \ offset=1009, inode=0, rec_len=0, name_len=0 ...
> >>
> >> If we configured errors=remount-ro, the filesystem will become
> >> read-only.
> > 
> > So what is the criteria for a test failure?  The test body is only
> > reading from the filesystem, so a ro,remount won't cause an obvious
> > failure of the test.
> 
> There haven't a obvious criteria for a test failure, you should see it
> from dmesg while you run the test.

Which means for most cases (i.e. automated test harnesses), a test
failure will go unnoticed.

The test *must* detect failures if it is to be useful as a
regression test. That's the whole point of a regression test harness
- that you don't have to do any extra work to determine if a test
has passed or failed as it is determined for you by the harness.

> > Perhaps the test should have more comments in it than "read this
> > URL" to explain what it is doing and what constitutes a failure?
> 
> Yes, i'll add more comments to explain it!

Given that there is a failure that can be captured, then I'd suggest
that this needs to be captured as well...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
