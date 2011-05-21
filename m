Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4L0kVxk119959 for <xfs@oss.sgi.com>; Fri, 20 May 2011 19:46:31 -0500
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B5EF45FD0B
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 17:46:31 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id 4co0l6wBHpVzT1T5 for
	<xfs@oss.sgi.com>; Fri, 20 May 2011 17:46:31 -0700 (PDT)
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com
	[9.17.195.106])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p4L0Z2eA006294
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 18:35:02 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p4L0lkKH107952 for <xfs@oss.sgi.com>; Fri, 20 May 2011 18:47:46 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p4KIjxqi022400
	for <xfs@oss.sgi.com>; Fri, 20 May 2011 12:45:59 -0600
Message-ID: <4DD70B5B.6090400@linux.vnet.ibm.com>
Date: Fri, 20 May 2011 17:46:19 -0700
From: Allison Henderson <achender@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [XFS Tests Punch Hole 2/3 v3] XFS TESTS: Add Fallocate Punch
	Hole Test Routines
References: <4DD43300.6010908@linux.vnet.ibm.com>
	<20110519013144.GF32466@dastard>
	<4DD560CF.3040706@linux.vnet.ibm.com>
	<20110519235601.GL32466@dastard>
	<4DD5C242.3010708@linux.vnet.ibm.com>
In-Reply-To: <4DD5C242.3010708@linux.vnet.ibm.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Eric Sandeen <sandeen@redhat.com>, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs-oss <xfs@oss.sgi.com>

On 5/19/2011 6:22 PM, Allison Henderson wrote:
> On 5/19/2011 4:56 PM, Dave Chinner wrote:
>> On Thu, May 19, 2011 at 11:26:23AM -0700, Allison Henderson wrote:
>>> On 5/18/2011 6:31 PM, Dave Chinner wrote:
>>>> On Wed, May 18, 2011 at 01:58:40PM -0700, Allison Henderson wrote:
>>>>> This patch adds low level routines to common.punch
>>>>> for populating test files and punching holes in them using
>>>>> fallocate. When a hole is punched, file is then analyzed to
>>>>> verify that the hole was punched correctly. These routines will
>>>>> be used to test various corner cases in the new fallocate
>>>>> punch hole tests.
>>>>
>>>> So what condition does this test cover that test 252 doesn't?
>> ....
>>>> ....
>>>>
>>>> I think maybe this test is trying to be too smart and do too much,
>>>> and the verbosity is hurting my eyes. I'm giving up here because I
>>>> think it overlaps greatly with test 252, and I can't see what
>>>> addition failures this test would actually detect that fsx and 252
>>>> wouldn't. If there are corner cases that 252 isn't covering that
>>>> this test does, then I think they should be added to 252....
>>>>
>>>>
>>>
>>>
>>> Hi there,
>>>
>>> Thx for the all the reviewing on this one. Im not quite sure I
>>> agree that the tests are analogous though. I did some poking around
>>> in xfsprogs which I believe is what test 252 is using to do perform
>>> most of its operations. I found the code where the hole gets
>>> punched, but I didnt find any code that does any kind of analyzing
>>> to verify that the hole was punched correctly.
>>
>> It's in the golden output - we use the "$map_cmd" output and filter
>> it to the normalise the data/unwritten/hole pattern, and if that
>> doesn't match the golden output, the test will fail. So it does
>> indeed test that the hole is exactly where we expect it to be, just
>> without needing the complex logic.
>>
>>> Maybe I over looked
>>> it? It kinda looks like the hole gets punched and it just checks
>>> the return code (fpunch_f in io/prealloc.c right?).
>>
>> For the immediate exectution of the punch, yes. That code doesn't do
>> the checking that there is a hole in the right place, though, which
>> is what the golden output checks at the end of the test do.
>>
>>> The reason this concerns me is that because a lot of the bugs that I
>>> worked out during development did not show up in the form of a bad
>>> return code or kernel oops. Initially the tests were not automated
>>> as they are now. They would just perform the operations and print
>>> out info about the file, the fs, fragmentation etc, and I would just
>>> go through the raw output to make sure that every thing added up, as
>>> well as just looking for anything that was out of the ordinary. To
>>> be honest, I feel that I caught a lot more bugs before they started
>>> just with a careful eye, than if I had just been watching return
>>> codes. The above routine was meant to automate that work for
>>> xfstests, but sense I do not see anything in xfstests or xfsprogs
>>> that is doing any kinda of analyzing, I cannot say that I think
>>> removing this layer provides the same level of verification.
>>
>> Looking through the raw output in an automated fashion is exactly
>> what the filter and golden image checks do.
>>
>>> Unfortunately it does sound like a lot of what is going would not
>>> work on all file systems, but I would feel better if we at least
>>> kept the hexdumps. The reason I'm diffing hexdumps in here is
>>> because some files get quite large and can take a while to copy, but
>>> if they are full of repeating data the hexdumps are small.
>>
>> You've got to read the files to produce hexdumps, md5sums or just
>> plain diff the binary files, so there's no saving in what you
>> propose anyway. IMO, it's just a poor way to compare two files. You
>> should have a golden image, and compare the test file against the
>> golden image. You don't need hexdump to do that, and the files. And
>> given the files are small, there is no reason not to copy stuff
>> around.
>>
>> The only thing that 252 does not do is compare the file contents to
>> determine whether the zeros start and stop at the correct spot.
>> Realistically, fsx will do a much better job of testing these corner
>> cases from a data POV than any manual test could ever do. Hence
>> it's quite valid to make the assumption that we don't need to test
>> the data for zeros because we have other tests that do a better job
>> of it...
>>
>> Remember that robust unit testing is not based around the concept of
>> "we need to check everything in one test". It's based around the
>> concept that a test should be as simple as possible and test one
>> thing. Then you write another simple test to cover a different
>> aspect of the same functionality, and the test suite as a whole then
>> covers all the functionality needing to be verified. fsx will cover
>> the "user data being zeroed correctly" cases, test 252 covers the
>> "hole being punched in the right place" cases. IOWs, there isn't One
>> True Test to test hole punching is working correctly - it's the
>> coverage provided by the entire suite that gives us the confidence
>> that hole punching is working correctly.
>>
>>> They can
>>> be placed in the golden output just the same I suppose. As much as
>>> I would like to include output about the extents, I do not know how
>>> that would work since the file may be inherently fragmented
>>> differently from test to test.
>>
>> That's the problem that the map output (extent) filtering fixes.
>>
>> And FWIW, there's a bunch of interesting hole punching tests in the
>> DMAPI part of xfstests that is not normally run on mainline kernels
>> (no dmapi support) because punching out extents is a primary
>> functionality of a HSM and, as I've said before, a common place to
>> find data corruption bugs. IOWs, XFS has had hole punch test
>> coverage for a lot longer than the recent test cases have been
>> around. Those are tests 145, 161, 175, 176 and 185. If we want more
>> robust hole punch coverage, taking those and making them run without
>> needing dmapi or XFS specific interfaces would be a good place to
>> start. We don't need to re-invent the wheel just to have generic
>> tests....
>>
>> Cheers,
>>
>> Dave.
>
>
> Hi Dave,
>
> Thanks for all the explaining, I did not initially see how the tests
> were verifying the holes, but I think that is a sufficient test then. I
> am ok with just adding the non overlapping tests, and I will take a peek
> at those older tests.
>
> Also, there was one more test that I meant to be a part of this
> collection, but I was not finished with it at the time I submitted the
> patch for feedback. Basically it checks to see if a hole can still be
> punched out when the disk is full. In ext4 this is allowable because
> reserved space is used to allow the operation to proceed where it would
> have otherwise failed. I'm not sure if this is also ext4 specific
> though. Would this be another candidate for adding to 252? Thx!
>
> Allison Henderson
>

Hi again,

I just didnt want this question to get washed away in the traffic.  I am 
working on an updated patch set, should I include the extra test case?  Thx!

Allison Henderson


> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
