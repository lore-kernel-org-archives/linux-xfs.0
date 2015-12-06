Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 4B31C7F37
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 11:31:28 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C4924AC001
	for <xfs@oss.sgi.com>; Sun,  6 Dec 2015 09:31:24 -0800 (PST)
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	kZCSn7F1gm3FRFCT (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 06 Dec 2015 09:31:22 -0800 (PST)
Received: by lbbcs9 with SMTP id cs9so44179724lbb.1
	for <xfs@oss.sgi.com>; Sun, 06 Dec 2015 09:31:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151123230847.GH26718@dastard>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
	<1447856269-7872-6-git-send-email-agruenba@redhat.com>
	<20151123230847.GH26718@dastard>
Date: Sun, 6 Dec 2015 18:31:20 +0100
Message-ID: <CAHc6FU4BDRqTM6dMONtyb98YqHSVp5M=GYnJ+k7EQRVNPvrQNA@mail.gmail.com>
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

Dave,

On Tue, Nov 24, 2015 at 12:08 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Wed, Nov 18, 2015 at 03:17:48PM +0100, Andreas Gruenbacher wrote:
>> Add the Rich Access Control List tests from the richacl package.  The
>> new tests require TEST_DEV and TEST_DIR to be set.
>>
>> When the check script is run, it first makes sure that the test
>> filesystem has richacls enabled or disabled as appropriate: with the
>> -richacl option, richacls must be enabled; without the -richacl option,
>> richacls must be disabled.  If TEST_DEV has incorrect richacl support,
>> the TEST_DEV filesystem is recreated.
>
> No, we don't recreate the testdev like this with the test harness.
> The test device is intended to remain unchanged from run to run, so
> give us long term aging of the test filesystem over months of
> regression test running.
>
> If you want to test the testdev with richacls enabled, then you need
> to manually create the testdev with richacls.  Any test that
> specifically needs to enable richacls should use the scratch device
> and use a _requires_scratch_richacls() test to check that the
> scratch device can be created with richacl support.

well, let's leave it to users to create their TEST_DEV with richacl
support if they want the richacl tests to be run then. Those tests
will already be skipped on unsuitable filesystems anyway.

>> The -richacl option currently selects the tests in the richacl group to
>> be run.  Additional test groups or tests can be specified on the command
>> line, e.g.,
>>
>>>   ./check -richacl -g quick
>> (Eventually, the -richacl option will be changed to only skip tests
>> which are incompatible with richacls.)
>
> No, this is wrong. If you want to check richacls, it should be via a
> test group, not a specific command line option
>
>    ./check -g richacl

The richacl tests were in a separate group already ...

> That makes the first 2 patches in the series go away.
>
>> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
>> ---
>>  .gitignore                          |   1 +
>>  check                               |  39 +++++++-
>>  common/rc                           |  23 ++++-
>>  src/Makefile                        |   2 +-
>>  src/require-richacls.c              |  35 +++++++
>
> That's a red flag.

What is, any why?

>>  tests/richacl/001-apply-masks       |   1 +
>>  tests/richacl/002-auto-inheritance  |   1 +
>>  tests/richacl/003-basic             |   1 +
>>  tests/richacl/004-chmod             |   1 +
>>  tests/richacl/005-chown             |   1 +
>>  tests/richacl/006-create            |   1 +
>>  tests/richacl/007-ctime             |   1 +
>>  tests/richacl/008-delete            |   1 +
>>  tests/richacl/009-setrichacl-modify |   1 +
>>  tests/richacl/010-write-vs-append   |   1 +
>
> These seem very short for tests. Oh, they just call one of the
> files below:
>
>>  tests/richacl/Makefile              |  44 +++++++++
>>  tests/richacl/apply-masks           | 163 ++++++++++++++++++++++++++++++
>>  tests/richacl/auto-inheritance      | 191 ++++++++++++++++++++++++++++++++++++
>>  tests/richacl/basic                 |  97 ++++++++++++++++++
>>  tests/richacl/chmod                 |  40 ++++++++
>>  tests/richacl/chown                 |  42 ++++++++
>>  tests/richacl/create                |  36 +++++++
>>  tests/richacl/ctime                 |  35 +++++++
>>  tests/richacl/delete                |  89 +++++++++++++++++
>>  tests/richacl/group                 |  15 +++
>>  tests/richacl/setrichacl-modify     |  57 +++++++++++
>>  tests/richacl/test-lib.sh           | 149 ++++++++++++++++++++++++++++
>>  tests/richacl/write-vs-append       |  54 ++++++++++
>
> That's a strange way of running tests, an dmost definitely not the
> way xfstests are written or supposed to be executed.
>
> And looking at tests/richacl/Makefile, these files need to be
> installed somewhere in the path for the tests to work.

No, the tests don't need to be installed anywhere, they can just as
well be run directly. Compare with tests/generic/Makefile which also
has an install target which looks similar.

> i.e. only the numbered version of the test should exist,
> and all the other files be moved into them. They shouldn't be in
> tests/richacl, either - these are generic tests and so should
> be in tests/generic, using whatever the next unused test numbers
> are. And then, in the tests/generic/group file, there will be
> entries like:
>
> 178-apply-masks auto quick richacl
> 179-auto-inheritance auto quick richacl
> ....

The richacl tests started out in the richacl package, they were not
written for xfstests form scratch. I want to keep them working there
as well, and integrate them into xfstests with as little friction on
either side as necessary.

The symlinks avoid having to rename files on every update of those tests.

> These tests need to use the common xfstests structure (i.e. the
> setup code from the "new" script).

Why does the new script require TEST_DEV and TEST_DIR to be set when
it doesn't run tests? I'm not running the tests on the same host on
which I build the test suite.

> The file that has all the common functionality in it (test-lib.sh)
> needs to be moved to common/richacl and included along with the
> necessary common files. At this point, the makefile can also go
> away.

What's the benefit? The tests don't need anything from common/, I want
to keep them well separated so that updating them will remain easy.

>> diff --git a/tests/richacl/apply-masks b/tests/richacl/apply-masks
>> new file mode 100755
>> index 0000000..7a99cf9
>> --- /dev/null
>> +++ b/tests/richacl/apply-masks
>> @@ -0,0 +1,163 @@
>> +#! /bin/sh
>
> We use /bin/bash in xfstests.

Okay, those scripts are not dependent on any of the xfstests
infrastructure and don't require bash, but I can use /bin/bash just as
well.

>> +
>> +. ${0%/*}/test-lib.sh
>> +
>> +require_richacls
>> +use_tmpdir
>
> No test actually uses $tmpdir, so why does this exist?

All the tests run inside $tmpdir:

  use_tmpdir() {
      tmpdir=$PWD/tmp.$$
      mkdir "$tmpdir" && cd "$tmpdir" || exit 2
  }

I'll repost an updated patch set shortly.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
