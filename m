Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q254BBVW102752 for <xfs@oss.sgi.com>; Sun, 4 Mar 2012 22:11:11 -0600
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id lCEqjI8OtfTMe3Nf for <xfs@oss.sgi.com>;
	Sun, 04 Mar 2012 20:11:10 -0800 (PST)
Message-ID: <4F543CDD.9030703@sandeen.net>
Date: Sun, 04 Mar 2012 22:11:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: add freeze and dangerous groups
References: <4F50FBB1.1090107@redhat.com> <20120305030843.GB3592@dastard>
In-Reply-To: <20120305030843.GB3592@dastard>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 3/4/12 9:08 PM, Dave Chinner wrote:
> On Fri, Mar 02, 2012 at 10:56:17AM -0600, Eric Sandeen wrote:
>> Add 2 new test groups:
>>
>> freeze: tests which test filesystem freeze
> 
> That's fine.
> 
>> dangerous: tests which may hang or oops
> 
> Hmmm.
> 
>> The 2nd may be useful for automated testing to do i.e.
>>
>> ./check -g auto -x dangerous
>> ./check -g auto,dangerous
>>
>> to try to get fuller coverage before running into tests
>> which may panic or hang the box and stop the test cycle.
>>
>> I doubt I have all the potential dangerous tests, but
>> they can be added later when found.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> I'm not sure "dangerous" is a black and white status for a test.
> What if the test doesn't cause problems for upstream, but causes
> problems for older vendor kernels? Does that make it dangerous? e.g.
> test 104 will hang a RHEL5.x kernel, but is perfectly safe on a
> RHEL6.x kernel - does that make it dangerous? It seems that many of
> the recent tests for specific regressions fall into this sort of
> category. Indeed, how do we answer the question "when does a test no
> longer be considered dangerous" or "what test is considered
> dangerous for this kernel/platform"?

Well, I was thinking that if the original failure mode was a hang or oops, that's "dangerous."

I agree that it's a little nebulous; if you see no value, I'm not hung up on it.

maybe it's a bad choice of words... but the intention was to flag which tests have failure modes which will interrupt further tests.
-Eric

> Cheers,
> 
> Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
