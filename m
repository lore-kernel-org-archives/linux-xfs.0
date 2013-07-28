Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 636F77F61
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 20:12:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2C716304059
	for <xfs@oss.sgi.com>; Sat, 27 Jul 2013 18:12:59 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	N7BMRcNrZbrwVFlr for <xfs@oss.sgi.com>;
	Sat, 27 Jul 2013 18:12:56 -0700 (PDT)
Date: Sun, 28 Jul 2013 11:12:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 44/49] xfs: Reduce allocations during CIL insertion
Message-ID: <20130728011255.GY13468@dastard>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-45-git-send-email-david@fromorbit.com>
	<51EEF26F.5040001@sgi.com> <51EEF949.9020104@gmail.com>
	<51EFD68A.40400@sgi.com> <51F2E011.5020904@gmail.com>
	<51F2E4DD.4020301@sgi.com> <20130727015822.GV13468@dastard>
	<51F41250.9010703@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51F41250.9010703@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs@oss.sgi.com

On Sat, Jul 27, 2013 at 01:32:48PM -0500, Mark Tinguely wrote:
> On 07/26/13 20:58, Dave Chinner wrote:
> >On Fri, Jul 26, 2013 at 04:06:37PM -0500, Mark Tinguely wrote:
> >>
> >>I can reproduce a problem in patch 44 too. It takes my copy test 20
> >>minutes to deplete the log space with patch 44, Same test with patch
> >>43 has been running a day and a half. I do not think that patch 44
> >>is 100 times faster than patch 43 but I will let patch 43 spin all
> >>weekend on a couple machines to verify that patch 43 does not hang.
> >
> >Details, please. What's your "copy test"?
> >
> >http://xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F
> >
> >Cheers,
> >
> >Dave.
> 
> Micheal found the problem using a simple copy, so I am using copy-like test.
> 
> I have hung patch 44 with fsstress but I am currently using the
> simple perl scripts from bugzilla bug 922, but I do not do the silly
> step of reducing the log to an abnormal amount.
> 
> Just mkfs the filesystem
> 
> Create the the test files. the creation script:
>   http://oss.sgi.com/bugzilla/attachment.cgi?id=304
> 
> Run the test script:
>   http://oss.sgi.com/bugzilla/attachment.cgi?id=305
>           ----
> This test seems to stress the log much like xfstest 273 only it runs
> forever.

Ok, thanks, for the info, Mark. I'll try to reproduce it here. FWIW,
we should probably add this to xfstests as a "stress" test. i.e. not
part of the auto group, but something that uses the scale parameters
to determine runtime. then add all the other tests that have scale
parameters to the same group, and if we run ./check --stress <scale>
it runs through all the stress tests with that given scale factor...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
