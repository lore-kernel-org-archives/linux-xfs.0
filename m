Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 2DA0F7F6B
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 08:50:29 -0600 (CST)
Message-ID: <5280EEC0.3050605@sgi.com>
Date: Mon, 11 Nov 2013 08:50:40 -0600
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] xfstests: generic/273: do not use /proc/cpuinfo
References: <1382529524-2184-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<1382529524-2184-3-git-send-email-stanislav.kholmanskikh@oracle.com>
	<52686670.6080607@sgi.com> <20131024010929.GR2797@dastard>
In-Reply-To: <20131024010929.GR2797@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: vasily.isaenko@oracle.com, xfs@oss.sgi.com, Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

On 10/23/2013 08:09 PM, Dave Chinner wrote:
> On Wed, Oct 23, 2013 at 07:14:40PM -0500, Rich Johnston wrote:
>> This has been committed.
>
> Without commiting the other patch that implements
> _no_of_online_cpus....
>
>> Thanks
>> --Rich
>>
>> commit fd080d64b6e9677cb9d0a15dc7e308b6ca0e273f
>> Author: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
>> Date:   Wed Oct 23 11:58:44 2013 +0000
>>
>>      xfstests: generic/273: do not use /proc/cpuinfo
>
> generic/273 22s ... - output mismatch (see /home/dave/src/xfstests-dev/results//generic/273.out.bad)
>      --- tests/generic/273.out   2013-03-28 07:53:08.000000000 +1100
>      +++ /home/dave/src/xfstests-dev/results//generic/273.out.bad        2013-10-24 12:06:27.000000000 +1100
>      @@ -2,3 +2,5 @@
>       ------------------------------
>       start the workload
>       ------------------------------
>      +./tests/generic/273: line 50: _no_of_online_cpus: command not found
>      +./tests/generic/273: line 51: * 50: syntax error: operand expected (error token is "* 50")
>       ...
>       (Run 'diff -u tests/generic/273.out /home/dave/src/xfstests-dev/results//generic/273.out.bad' to see the entire diff)
> Ran: generic/273
> Failures: generic/273
> Failed 1 of 1 tests
>
> Rich, can you try to commit patch series as a whole, not piecemeal
> while parts of the patch series are still being discussed and
> reviewed?
>
> Cheers,
>
> Dave.
>
My apologies, I will look for series thread on the list as well as 
patchworks. (http://patchwork.xfs.org/project/XFS/list/). I did ask you 
about submitting some of the series you submitted  for review.
I did verify the the new function worked but I should have also run the
test suit also.


Two things, series patches should be:
	1. Resubmitted together with reviewed by's carried forward.
	2. If only one patch is being modified the patch caries the
	   series number along with the revision in the email subject.

#1
With the exception of your last submission (db series 37/37) Dave you
have always done this. I did carried the Reviewed-by: forward in that
case.

#2
You have always done this i.e
	[PATCH 15/37,V3] libxfs: fix root inode handling inconsistencies

In this case only the version was carried forward.
original
	 [PATCH 1/2] xfstests: implemented _no_of_online_cpus() function

The series was dropped from the subject.
  	[PATCH V3] xfstests: implemented _no_of_online_cpus() function

Thanks
--Rich
	

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
