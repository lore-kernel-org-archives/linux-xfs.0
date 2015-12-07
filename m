Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9876F7F37
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 17:45:12 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 867A1304048
	for <xfs@oss.sgi.com>; Mon,  7 Dec 2015 15:45:09 -0800 (PST)
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	tSi8I65EEDNPfhgh (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Dec 2015 15:45:07 -0800 (PST)
Received: by lbbcs9 with SMTP id cs9so1726879lbb.1
	for <xfs@oss.sgi.com>; Mon, 07 Dec 2015 15:45:05 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151207211156.GD26718@dastard>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
	<1447856269-7872-6-git-send-email-agruenba@redhat.com>
	<20151123230847.GH26718@dastard>
	<CAHc6FU4BDRqTM6dMONtyb98YqHSVp5M=GYnJ+k7EQRVNPvrQNA@mail.gmail.com>
	<20151207211156.GD26718@dastard>
Date: Tue, 8 Dec 2015 00:45:05 +0100
Message-ID: <CAHc6FU4X+7rPtR8LE9W4HZv2UGsZ-+1zHSq5X5sFgVQmL5mCqQ@mail.gmail.com>
Subject: Re: [XFSTESTS 5/6] Add richacl tests
From: Andreas Gruenbacher <agruenba@redhat.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: XFS Developers <xfs@oss.sgi.com>

On Mon, Dec 7, 2015 at 10:11 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, Dec 06, 2015 at 06:31:20PM +0100, Andreas Gruenbacher wrote:
>> Dave,
>>
>> On Tue, Nov 24, 2015 at 12:08 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Wed, Nov 18, 2015 at 03:17:48PM +0100, Andreas Gruenbacher wrote:
>> >> Add the Rich Access Control List tests from the richacl package.  The
>> >> new tests require TEST_DEV and TEST_DIR to be set.
>> >>
>> >> When the check script is run, it first makes sure that the test
>> >> filesystem has richacls enabled or disabled as appropriate: with the
>> >> -richacl option, richacls must be enabled; without the -richacl option,
>> >> richacls must be disabled.  If TEST_DEV has incorrect richacl support,
>> >> the TEST_DEV filesystem is recreated.
>> >
>> > No, we don't recreate the testdev like this with the test harness.
>> > The test device is intended to remain unchanged from run to run, so
>> > give us long term aging of the test filesystem over months of
>> > regression test running.
>> >
>> > If you want to test the testdev with richacls enabled, then you need
>> > to manually create the testdev with richacls.  Any test that
>> > specifically needs to enable richacls should use the scratch device
>> > and use a _requires_scratch_richacls() test to check that the
>> > scratch device can be created with richacl support.
>>
>> well, let's leave it to users to create their TEST_DEV with richacl
>> support if they want the richacl tests to be run then. Those tests
>> will already be skipped on unsuitable filesystems anyway.
>
> No, that's not the way xfstests works, or how developers really
> expect it to run. If you have new functionality that requires
> specific on-disk format requirements that are different to the
> defaults that the developers userspace progs are using then you
> should be using the scratch device for those tests after probing that

That should be possible. Those tests would then only be using
SCRATCH_DEV / SCRATCH_MNT and not TEST_DEV / TEST_DIR at all. Any
ideas how xfstests could be made to not always require TEST_DEV /
TEST_DIR to be set?

>> >> The -richacl option currently selects the tests in the richacl group to
>> >> be run.  Additional test groups or tests can be specified on the command
>> >> line, e.g.,
>> >>
>> >>>   ./check -richacl -g quick
>> >> (Eventually, the -richacl option will be changed to only skip tests
>> >> which are incompatible with richacls.)
>> >
>> > No, this is wrong. If you want to check richacls, it should be via a
>> > test group, not a specific command line option
>> >
>> >    ./check -g richacl
>>
>> The richacl tests were in a separate group already ...
>
> No, they aren't - you've set them up as a /filesystem/ group, not a
> test group.

Not true. Both versions of the patches I've posted did add a group
file in tests/rchacl with entries like:

  001-apply-masks [...] richacl

which did define a richacl group. Running "./check -g richacl" did
select the appropriate test cases based on that definition.

There already are directories in tests/ which don't classify test
cases by filesystem (generic/ and shared/), so adding another for
keeping related things together is not a new concept.

>> > That makes the first 2 patches in the series go away.
>> >
>> >> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>> >> ---
>> >>  .gitignore                          |   1 +
>> >>  check                               |  39 +++++++-
>> >>  common/rc                           |  23 ++++-
>> >>  src/Makefile                        |   2 +-
>> >>  src/require-richacls.c              |  35 +++++++
>> >
>> > That's a red flag.
>>
>> What is, any why?
>
> That you are using C code to detect whether an on-disk feature is
> supported or not. This is done through running the userspace tools
> to check they support the on-disk feature, then creating a
> filesystem with those tools and mounting it to determine whether the
> kernel supports the feature correctly as well.

Someone might run "check -g richacl" on a filesystem that doesn't
support richacls. In that case, I want the richacl test cases to be
skipped, with an explanation why; I don't want the test cases to just
explode. That's the same as what the POSIX ACL related test cases do
in common/attr:_require_acls().

_require_acls() uses the chacl utility for probing for POSIX ACL
support. The require-richacls program serves the same purpose. I could
probe using getfattr instead, but getfattr isn't necessarily
installed, and I won't want to create an unnecessary dependency.

>> > i.e. only the numbered version of the test should exist,
>> > and all the other files be moved into them. They shouldn't be in
>> > tests/richacl, either - these are generic tests and so should
>> > be in tests/generic, using whatever the next unused test numbers
>> > are. And then, in the tests/generic/group file, there will be
>> > entries like:
>> >
>> > 178-apply-masks auto quick richacl
>> > 179-auto-inheritance auto quick richacl
>> > ....
>>
>> The richacl tests started out in the richacl package, they were not
>> written for xfstests form scratch. I want to keep them working there
>> as well, and integrate them into xfstests with as little friction on
>> either side as necessary.
>
> There is no point in maintaining two test suites - you'll change
> stuff in your richacl package test suite, and the xfstests stuff
> will be ignored, because *you won't be using xfstests*.
> The whole point of getting this stuff into xfstests is so that
> there's one place to both run and maintain the tests.

I don't want to maintain two test suites, I want the same tests to
work in both contexts.

>> The symlinks avoid having to rename files on every update of those tests.
>>
>> > These tests need to use the common xfstests structure (i.e. the
>> > setup code from the "new" script).
>>
>> Why does the new script require TEST_DEV and TEST_DIR to be set when
>> it doesn't run tests? I'm not running the tests on the same host on
>> which I build the test suite.
>
> Because it simply sources common code. Nobody has raised this as a
> problem before, so if it bugs you, send patches to fix it.
>
>> > The file that has all the common functionality in it (test-lib.sh)
>> > needs to be moved to common/richacl and included along with the
>> > necessary common files. At this point, the makefile can also go
>> > away.
>>
>> What's the benefit? The tests don't need anything from common/, I want
>> to keep them well separated so that updating them will remain easy.
>
> What's the benefit? That the tests all follow the same patterns, and
> that means any xfstests user can modify and update the tests without
> having to learn some new, weird frankenstein test infrastructure.

>From the point of view of the xfstests infrastructure, all you really
have to know about the richacl tests is that they are scripts that
signal with their exit status whether a test has succeeded, failed, or
has been skipped. (That's actually how simple autoconf tests work as
well.)

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
