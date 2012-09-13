Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8D0eNVe072699 for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 19:40:23 -0500
Received: from youngberry.canonical.com (youngberry.canonical.com
	[91.189.89.112]) by cuda.sgi.com with ESMTP id 7yQmbAvsauuoNd9u
	for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 17:41:28 -0700 (PDT)
Message-ID: <50512BB1.5010605@canonical.com>
Date: Wed, 12 Sep 2012 17:41:21 -0700
From: Brad Figg <brad.figg@canonical.com>
MIME-Version: 1.0
Subject: Re: Ubuntu Ext4 regression testing
References: <50511241.2090603@canonical.com> <5051142D.1050603@redhat.com>
	<5051177E.6000903@canonical.com> <505126D4.5030106@redhat.com>
In-Reply-To: <505126D4.5030106@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On 09/12/2012 05:20 PM, Eric Sandeen wrote:
> On 9/12/12 6:15 PM, Brad Figg wrote:
>> I'm going to be doing some new runs so anything I find will be reported.
> 
> Dave Chinner also pointed out that i.e.
> 
> http://kernel.ubuntu.com/beta/testing/test-results/statler.2012-09-11_22-42-47/xfstests/default/control
> 
> seems to redefine, re-group, exclude etc various tests, and is taking "intelligence" out of the test suite itself.
> 
> I'd be wary of that; xfstests is dynamic - things get fixed, tests get added, groups changed, etc.
> 
> If you hard code for example "this test is for xfs" somewhere else, you might miss updates which add coverage.
> 
> Another example :
> 
> 	    #'197' : ['xfs'],# This test is only valid on 32 bit machines
> 
> but the test handles that gracefully:
> 
> bitsperlong=`src/feature -w`
> if [ "$bitsperlong" -ne 32 ]; then
>         _notrun "This test is only valid on 32 bit machines"
> fi
> 
> In general any test should be runnable; it may then issue 'not run' for some reason or other, but there's no harm in it - not as much harm as skipping regression tests because some config file got out of date...
> 
> and:
> 
> 	    #'275' : ['generic'] # ext4 fails
> 
> but I just fixed that one up, and it should pass now.  Who will update the 3rd party config?
> 
> Failing tests absolutely should be run as well.  That information is as valuable as passing tests.  The goal is getting a complete picture, not just a series of "pass" results.  :)
> 
> -Eric
> 

Eric,

Thanks for taking the time to point this out. We will adjust our testing accordingly.
We initially tried to run xfstest against ext2, ext3, ext4, xfs and btrfs. We are also
trying to get these tests to run on several different kernel versions as you can
see from our test results. We were running into issues on different kernels and various
file-systems while getting our act together, we did this as a band-aid.

I accept that we have some things to learn w.r.t. running this test suite. We will work
to run the xfstests "as is" without any outside "intelligence". We do recognise that
is a dynamic set of tests that people are adding to regularly.

I am not attempting to get just a series of "pass" results. If that were my goal
I could accomplish it much easier and would not have engaged with the community
on the mailing list. We want to help where we can and will accept constructive
criticism.

Brad
-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
