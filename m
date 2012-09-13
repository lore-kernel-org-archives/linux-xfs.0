Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8D0JdvW070157 for <xfs@oss.sgi.com>; Wed, 12 Sep 2012 19:19:39 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CUb0LJFC7mlxw2KG for
	<xfs@oss.sgi.com>; Wed, 12 Sep 2012 17:20:44 -0700 (PDT)
Message-ID: <505126D4.5030106@redhat.com>
Date: Wed, 12 Sep 2012 19:20:36 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: Ubuntu Ext4 regression testing
References: <50511241.2090603@canonical.com> <5051142D.1050603@redhat.com>
	<5051177E.6000903@canonical.com>
In-Reply-To: <5051177E.6000903@canonical.com>
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
To: Brad Figg <brad.figg@canonical.com>
Cc: linux-ext4@vger.kernel.org, xfs-oss <xfs@oss.sgi.com>

On 9/12/12 6:15 PM, Brad Figg wrote:
> I'm going to be doing some new runs so anything I find will be reported.

Dave Chinner also pointed out that i.e.

http://kernel.ubuntu.com/beta/testing/test-results/statler.2012-09-11_22-42-47/xfstests/default/control

seems to redefine, re-group, exclude etc various tests, and is taking "intelligence" out of the test suite itself.

I'd be wary of that; xfstests is dynamic - things get fixed, tests get added, groups changed, etc.

If you hard code for example "this test is for xfs" somewhere else, you might miss updates which add coverage.

Another example :

	    #'197' : ['xfs'],# This test is only valid on 32 bit machines

but the test handles that gracefully:

bitsperlong=`src/feature -w`
if [ "$bitsperlong" -ne 32 ]; then
        _notrun "This test is only valid on 32 bit machines"
fi

In general any test should be runnable; it may then issue 'not run' for some reason or other, but there's no harm in it - not as much harm as skipping regression tests because some config file got out of date...

and:

	    #'275' : ['generic'] # ext4 fails

but I just fixed that one up, and it should pass now.  Who will update the 3rd party config?

Failing tests absolutely should be run as well.  That information is as valuable as passing tests.  The goal is getting a complete picture, not just a series of "pass" results.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
