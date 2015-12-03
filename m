Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AA3537F50
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 17:10:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 353EEAC002
	for <xfs@oss.sgi.com>; Thu,  3 Dec 2015 15:10:31 -0800 (PST)
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	K0OZeyxiLYDmlXNm (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 03 Dec 2015 15:10:29 -0800 (PST)
Received: by lbbcs9 with SMTP id cs9so10812628lbb.1
	for <xfs@oss.sgi.com>; Thu, 03 Dec 2015 15:10:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20151123230847.GH26718@dastard>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
	<1447856269-7872-6-git-send-email-agruenba@redhat.com>
	<20151123230847.GH26718@dastard>
Date: Fri, 4 Dec 2015 00:10:27 +0100
Message-ID: <CAHc6FU60ALpg6xE4md9B1JG1H9KwgCkdOTHmuHZYQ+NjNemhjw@mail.gmail.com>
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
[...]
>> +ncheck "touch x"
>> +ncheck "setrichacl --set 'owner@:rwp::allow group@:rwp::allow everyone@:r::allow' x"
>> +check "getrichacl x" <<EOF
>> +x:
>> +    owner@:rwp----------::allow
>> +    group@:rwp----------::allow
>> + everyone@:r------------::allow
>> +EOF
>
> Ok, let's break this down, because most of the tests are similar.
>
> ncheck is not needed, as golden output matching will catch an
> unexpected error.
>
> check is not needed, because the output of the command should
> match what is in the golden output file. i.e, this test should be
> simply:
>
> touch x
> setrichacl --set 'owner@:rwp::allow group@:rwp::allow everyone@:r::allow' x
> getrichacl x
>
> And the golden output file should contain:
>
> x:
>     owner@:rwp----------::allow
>     group@:rwp----------::allow
>  everyone@:r------------::allow
>
> The fact that you do golden output matching directly in the script
> to calculate "checks_succeeded" and "checks_failed" and then check
> those at the end of the test to set the exit status is completely
> unnecessary. The xfstests tsts harness does all this pattern
> matching for you via the golden output file. Using output files
> correctly make patches 3 and 4 in this series go away.

This is really not where I want to go with those tests. I'm not using
golden output files on full purpose; I really do want the output and
exit status of each command under test to be checked individually. I
also do want proper logging and error reporting --- Which commands
from where in the test script were executed with which parameters?
Were they successful and did they produce the expected output? If not,
what's the difference between the expected and actual output?

With xfstest output matching, I get none of that reliably. I don't
even get to know which exact commands are executed; parameters which
differ from run to run are masked on purpose (grepping for "sed" in
xfstests shows some examples). When a test fails, I have to start
guessing which command might have caused the failure; the tests are
peppered with echo "Here I am" statements to make that possible at
all.

For example, the above test produces the following log:

    [8] touch x -- ok
    [9] setrichacl --set 'owner@:rwp::allow group@:rwp::allow
everyone@:r::allow' x -- ok
    [10] getrichacl x -- ok
  [...]
    46 tests (46 passed, 0 failed)

A failure would come out as follows (with exit status 1):

    [8] touch x -- ok
    [9] setrichacl --set 'owner@:rwp::allow group@:rwp::allow
everyone@:r::allow' x -- ok
    [10] getrichacl x -- FAILED
    --- expected
    +++ got
    @@ -1,4 +1,4 @@
    x:
    -    owner@:rwp----------::allow
    -    group@:rwp----------::allow
    +    owner@:r------------::allow
    +    group@:r------------::allow
     everyone@:r------------::allow
  [...]
    46 tests (45 passed, 1 failed)

I also do want these tests to remain functional inside the richacl
package, where they are coming from.

Thanks,
Andreas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
