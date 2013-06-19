Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [150.166.39.100])
	by oss.sgi.com (Postfix) with ESMTP id 66C3C29E09
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 21:05:53 -0500 (CDT)
Date: Tue, 18 Jun 2013 19:05:41 -0700
From: Phil White <pwhite@sgi.com>
Subject: Re: WANTED: xfstests results in different architectures
Message-ID: <20130619020541.GG424@caliban.engr.sgi.com>
References: <1371596399.22504.38.camel@chandra-dt.ibm.com>
	<20130618233426.GD29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130618233426.GD29338@dastard>
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, XFS mailing list <xfs@oss.sgi.com>

On Wed, Jun 19, 2013 at 09:34:26AM +1000, Dave Chinner wrote:
> How are you going to filter and display them on xfs.org? Should the
> scripts to do this be part of xfstests?
> 
> FWIW, without a database of results that users can use to filter the
> test results themselves, it will become unmanageable very quickly...
> 
> BTW, from my notes from the 2012 LSFMM XFs get-together, there are
> these line items related to exactly this:
> 
> ----
>        - Public repository of test results so we can better track failures
>                 - Look into resurrecting old ASG xfstests results
>                   repository and web iquery interface (Ben)
>                 - host on oss.sgi.com.
>                 - script to run xfstests and produce publishable output (Ben)
> ----
> 
> Ben, did you ever start to look into this?

That became my work, not Ben's.

The current proposal is to gather architecture, distro, memory size, number of
procs, characteristics of the storage device (size, performance, type, xfs_info
output), xfsprogs version numbers, the time it takes for each test to run, the
date & time it was run, and the hostname of the system.

The plan was to output that information into a database which we could add
benchmark information into as well with an eye to detecting performance
regressions.

(I felt, for example, that the recent discussion of CRC work and CPU usage
could have been helped by that.)

The last stage was to write a script to upload test run data which oss would
be able to publish.

Some of that work is done.  I need to get back around to it.

-Phil

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
