Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6026A7F37
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 16:32:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 47EBC304053
	for <xfs@oss.sgi.com>; Tue, 15 Dec 2015 14:32:18 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	sDUAvpnlebvGD7Ch for <xfs@oss.sgi.com>;
	Tue, 15 Dec 2015 14:32:14 -0800 (PST)
Date: Wed, 16 Dec 2015 09:32:01 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFSTESTS 5/6] Add richacl tests
Message-ID: <20151215223201.GQ26718@dastard>
References: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
	<1447856269-7872-6-git-send-email-agruenba@redhat.com>
	<20151123230847.GH26718@dastard>
	<CAHc6FU4BDRqTM6dMONtyb98YqHSVp5M=GYnJ+k7EQRVNPvrQNA@mail.gmail.com>
	<20151207211156.GD26718@dastard>
	<CAHc6FU4X+7rPtR8LE9W4HZv2UGsZ-+1zHSq5X5sFgVQmL5mCqQ@mail.gmail.com>
	<20151208064410.GD19802@dastard>
	<CAHc6FU5Y91VYLpEbG5zFEwDs+CwWpafJMj4XMRKZgeaUY2m6zA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAHc6FU5Y91VYLpEbG5zFEwDs+CwWpafJMj4XMRKZgeaUY2m6zA@mail.gmail.com>
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
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: XFS Developers <xfs@oss.sgi.com>

On Tue, Dec 15, 2015 at 12:32:10AM +0100, Andreas Gruenbacher wrote:
> It then also makes sense to run all of the richacl tests at once, on
> the same scratch file system, similar to xfs/191.

No, it doesn't. just because I refered you to how some piece of
infrastructure works via a given test, it doesn't mean that
everythign the test does is correct. xfs/191 is a bad test because
it aggregates lots of little regression tests into a single test via
it's own internal harness - exactly the same issues that I'm telling
you know is not acceptible for the richacl tests.

The rule of thumb is that there should be one xfs test per
individual regression test. You've got at least 10 separate
regression tests there, so there should be at least 10 xfstests.
They should not be aggregated into a single test - if you need to
run them all at once, then that is what the richacl test group is
for....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
