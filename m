Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6E02229E09
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 18:34:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0F71EAC005
	for <xfs@oss.sgi.com>; Tue, 18 Jun 2013 16:34:31 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	saCtYACQpfExjTcG for <xfs@oss.sgi.com>;
	Tue, 18 Jun 2013 16:34:29 -0700 (PDT)
Date: Wed, 19 Jun 2013 09:34:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: WANTED: xfstests results in different architectures
Message-ID: <20130618233426.GD29338@dastard>
References: <1371596399.22504.38.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371596399.22504.38.camel@chandra-dt.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: XFS mailing list <xfs@oss.sgi.com>

On Tue, Jun 18, 2013 at 05:59:59PM -0500, Chandra Seetharaman wrote:
> Hello All,
> 
> Couple of weeks backs we had a discussion in xfs meeting to collect
> xfstests results. I volunteered to collect xfstests results from
> different architectures and upload to XFS.org.
> 
> I can run and get the results for x86_64 and ppc64. If anyone has other
> architectures that they can run the tests on and provide me the results,
> I will filter them an upload to XFS.org.

How are you going to filter and display them on xfs.org? Should the
scripts to do this be part of xfstests?

FWIW, without a database of results that users can use to filter the
test results themselves, it will become unmanageable very quickly...

BTW, from my notes from the 2012 LSFMM XFs get-together, there are
these line items related to exactly this:

----
       - Public repository of test results so we can better track failures
                - Look into resurrecting old ASG xfstests results
                  repository and web iquery interface (Ben)
                - host on oss.sgi.com.
                - script to run xfstests and produce publishable output (Ben)
----

Ben, did you ever start to look into this?

> Here is what I think would be of value to provide along with the results
> (others, please feel free to add more to the list for the results to be
> more useful)
>     - Architecture of the system

	- base distro (e.g. /etc/release).

>     - Configuration - memory size and number of procs

I think that all the info that we ask people to report in bug
reports would be a good start....

>     - Filesystem sizes

More useful is the MKFS_OPTIONS and MOUNT_OPTIONS used to run the
tests, as that tells us how much non-default test coverage we are
getting. i.e. default testing or something different.

>     - Commit ID of the kernel

Not useful for kernels built with local, non-public changes, which
is generally 100% of the kernels and userspace packages I test
with.

>     - which git tree (XFS git tree or Linus's)
>     - xfsprogs version (or commit ID if from the git tree)

Same as for the kernel - base version is probably all that is useful
here.

You'd probably also want to capture the console output indicating
test runtimes and why certain tests weren't run.

If you create a pristine $RESULTS_DIR and output all the information
you want to gather into it, then it will be trivial for users to
send information onwards. Providing a command line parameter that
generates a unique results directory and then packages the results
up into a tarball would be a great start. We'd then have a single
file that can be sent up a central point with all the test results
available. We could even do all the filtering/processing before
upload.

IOWs, the idea behind $RESULTS_DIR is to make this sort of scripted
test result gathering simple to do....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
