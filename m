Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 972CE7F37
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 17:41:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1A0B3AC003
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:41:00 -0800 (PST)
Received: from mail-lb0-f182.google.com (mail-lb0-f182.google.com
	[209.85.217.182]) by cuda.sgi.com with ESMTP id
	AlbUn56sxgu50vah (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:40:58 -0800 (PST)
Received: by lbbkw15 with SMTP id kw15so116794116lbb.0
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:40:57 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151207213611.GE26718@dastard>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
	<1447856269-7872-6-git-send-email-agruenba@redhat.com>
	<20151123230847.GH26718@dastard>
	<CAHc6FU60ALpg6xE4md9B1JG1H9KwgCkdOTHmuHZYQ+NjNemhjw@mail.gmail.com>
	<20151207213611.GE26718@dastard>
Date: Tue, 15 Dec 2015 00:40:56 +0100
Message-ID: <CAHc6FU5vsKPL0Y9woemk27z4HhjsTGWf=ahzXha-wKb_G=NBrw@mail.gmail.com>
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

On Mon, Dec 7, 2015 at 10:36 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Fri, Dec 04, 2015 at 12:10:27AM +0100, Andreas Gruenbacher wrote:
>> Dave,
>>
>> On Tue, Nov 24, 2015 at 12:08 AM, Dave Chinner <david@fromorbit.com> wrote:
>> > On Wed, Nov 18, 2015 at 03:17:48PM +0100, Andreas Gruenbacher wrote:
>> [...]
>> >> +ncheck "touch x"
>> >> +ncheck "setrichacl --set 'owner@:rwp::allow group@:rwp::allow everyone@:r::allow' x"
>> >> +check "getrichacl x" <<EOF
>> >> +x:
>> >> +    owner@:rwp----------::allow
>> >> +    group@:rwp----------::allow
>> >> + everyone@:r------------::allow
>> >> +EOF
>> >
>> > Ok, let's break this down, because most of the tests are similar.
>> >
>> > ncheck is not needed, as golden output matching will catch an
>> > unexpected error.
>> >
>> > check is not needed, because the output of the command should
>> > match what is in the golden output file. i.e, this test should be
>> > simply:
>> >
>> > touch x
>> > setrichacl --set 'owner@:rwp::allow group@:rwp::allow everyone@:r::allow' x
>> > getrichacl x
>> >
>> > And the golden output file should contain:
>> >
>> > x:
>> >     owner@:rwp----------::allow
>> >     group@:rwp----------::allow
>> >  everyone@:r------------::allow
>> >
>> > The fact that you do golden output matching directly in the script
>> > to calculate "checks_succeeded" and "checks_failed" and then check
>> > those at the end of the test to set the exit status is completely
>> > unnecessary. The xfstests tsts harness does all this pattern
>> > matching for you via the golden output file. Using output files
>> > correctly make patches 3 and 4 in this series go away.
>>
>> This is really not where I want to go with those tests. I'm not using
>> golden output files on full purpose; I really do want the output and
>> exit status of each command under test to be checked individually.
>
> Which you get from golden output matching. If the test succeeds, it
> is silent, if a command fails, then it should be outputting an error
> message to the user. That will be captured by the test harness.
> Silent errors (i.e. error by return code only) indicate a broken
> user interface....
>
>> I
>> also do want proper logging and error reporting --- Which commands
>> from where in the test script were executed with which parameters?
>
> logging goes to $seqres.full, and logging of commands executed to
> $seqres.full can be done via the _do() wrapper, though we tend not
> to do that because it's easier to debug tests when there aren't
> wrappers like this in use. And, funnily enough, _do() also can be
> used to check the return value of the command that is run, emit an
> error message iand potentially fail the test if that happens.
>
> Essentially you're arguing that you need functionality that xfstests
> already provides you with.

No, you're still missing my point; see below.

>> Were they successful and did they produce the expected output? If not,
>> what's the difference between the expected and actual output?
>>
>> With xfstest output matching, I get none of that reliably. I don't
>
> This is an argument I hear all the time from people who aren't
> familiar with xfstests. It's wrong....

If people are complaining all the time, there may be other reasons
than "use too stupid" as well.

>> even get to know which exact commands are executed;
>
> see above.
>
>> parameters which
>> differ from run to run are masked on purpose (grepping for "sed" in
>> xfstests shows some examples).
>
> And, sure, we *filter* the output to mask things that change that
> are irrelevant to what we are testing. That means the tests canbe
> made generic and independent of filesystem and platform
> configurations. That's not something you need to care about, because
> all of the richacl tests have the same output regardless of
> filesystem/platform configurations.
>
> Yes, the test harness provides capabilities and infrastructure you
> don't need, but that's not a valid reason for being unable to
> integrate a *set of pattern matching tests* into a test harness
> whose error detection architecture is based around *pattern
> matching*....
>
>> When a test fails, I have to start
>> guessing which command might have caused the failure; the tests are
>> peppered with echo "Here I am" statements to make that possible at
>> all.
>
> Those statements are good for documentation purposes, not just
> debugging. But you don't need to add them - you can use comments
> just as well - or you can use other logging infrastructure (as I've
> mentioned) to capture everything in the full logging file that is
> provided *expressly for debugging purposes*.
>
>> For example, the above test produces the following log:
>>
>>     [8] touch x -- ok
>>     [9] setrichacl --set 'owner@:rwp::allow group@:rwp::allow
>> everyone@:r::allow' x -- ok
>>     [10] getrichacl x -- ok
>>   [...]
>>     46 tests (46 passed, 0 failed)
>>
>> A failure would come out as follows (with exit status 1):
>>
>>     [8] touch x -- ok
>>     [9] setrichacl --set 'owner@:rwp::allow group@:rwp::allow
>> everyone@:r::allow' x -- ok
>>     [10] getrichacl x -- FAILED
>>     --- expected
>>     +++ got
>>     @@ -1,4 +1,4 @@
>>     x:
>>     -    owner@:rwp----------::allow
>>     -    group@:rwp----------::allow
>>     +    owner@:r------------::allow
>>     +    group@:r------------::allow
>>      everyone@:r------------::allow
>
> I don't understand your problem - that's exactly the output that
> xfstests will give you through golden output matching.

The difference is that the output includes the line number and the
exact command executed. When something fails, I immediately know where
to start looking.

With golden output matching, I may or may not find the command
executed in the log (depending on which additional echo commands have
been inserted to the test case), and the command will contain
placeholders for parameters which may vary from run to run. I may or
may not find the actual commands executed in the full log. I also only
get an overall diff which doesn't tell me where the failure happened
in the test case; I have to study the test case in order to find out,
which can be tricky.

See my recent fsx patch [*] which fixes several problems of that kind.

  [*] http://oss.sgi.com/archives/xfs/2015-12/msg00207.html

The approach I'm using in the richacl tests avoids some of those
problems at least.

>> I also do want these tests to remain functional inside the richacl
>> package, where they are coming from.
>
> While that may be important to you because that's where you do all
> your development, it's irrelevant to all the filesystem developers
> using xfstests.
>
> It's the filesystem developers that are going to inadvertantly break
> the xattr/richacl code as they make future changes to the filesystem
> code - they are also the people that need to find out about such
> breakages immediately, and that means having regression test
> coverage in xfstests is far more important than having it in the
> richacl package where it is only used by one person....

Fair enough, I've not said I don't want richacl test coverage in
xfstests. I'm not willing to sacrifice testability of the richacl
package ("make check") either though, and there, I don't have access
to the xfstests harness so something more lightweight will have to do.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
