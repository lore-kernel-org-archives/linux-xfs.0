Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E1F17F67
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 20:10:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B8B58F804B
	for <xfs@oss.sgi.com>; Wed, 23 Oct 2013 18:10:00 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	hQ4j0NWBrXtJkw5S for <xfs@oss.sgi.com>;
	Wed, 23 Oct 2013 18:09:58 -0700 (PDT)
Date: Thu, 24 Oct 2013 12:09:29 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/2] xfstests: generic/273: do not use /proc/cpuinfo
Message-ID: <20131024010929.GR2797@dastard>
References: <1382529524-2184-1-git-send-email-stanislav.kholmanskikh@oracle.com>
	<1382529524-2184-3-git-send-email-stanislav.kholmanskikh@oracle.com>
	<52686670.6080607@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52686670.6080607@sgi.com>
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
To: Rich Johnston <rjohnston@sgi.com>
Cc: vasily.isaenko@oracle.com, xfs@oss.sgi.com, Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

On Wed, Oct 23, 2013 at 07:14:40PM -0500, Rich Johnston wrote:
> This has been committed.

Without commiting the other patch that implements
_no_of_online_cpus....

> Thanks
> --Rich
> 
> commit fd080d64b6e9677cb9d0a15dc7e308b6ca0e273f
> Author: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
> Date:   Wed Oct 23 11:58:44 2013 +0000
> 
>     xfstests: generic/273: do not use /proc/cpuinfo

generic/273 22s ... - output mismatch (see /home/dave/src/xfstests-dev/results//generic/273.out.bad)
    --- tests/generic/273.out   2013-03-28 07:53:08.000000000 +1100
    +++ /home/dave/src/xfstests-dev/results//generic/273.out.bad        2013-10-24 12:06:27.000000000 +1100
    @@ -2,3 +2,5 @@
     ------------------------------
     start the workload
     ------------------------------
    +./tests/generic/273: line 50: _no_of_online_cpus: command not found
    +./tests/generic/273: line 51: * 50: syntax error: operand expected (error token is "* 50")
     ...
     (Run 'diff -u tests/generic/273.out /home/dave/src/xfstests-dev/results//generic/273.out.bad' to see the entire diff)
Ran: generic/273
Failures: generic/273
Failed 1 of 1 tests

Rich, can you try to commit patch series as a whole, not piecemeal
while parts of the patch series are still being discussed and
reviewed?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
