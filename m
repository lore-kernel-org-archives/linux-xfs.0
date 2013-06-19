Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id EE02C7CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 16:00:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D6C098F8033
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 14:00:46 -0700 (PDT)
Received: from e9.ny.us.ibm.com (e9.ny.us.ibm.com [32.97.182.139]) by
	cuda.sgi.com with ESMTP id hd9JwtcgM5Cu4FvF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 14:00:45 -0700 (PDT)
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
	Violators will be prosecuted
	for <xfs@oss.sgi.com> from <sekharan@us.ibm.com>;
	Wed, 19 Jun 2013 17:00:43 -0400
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 2AF9FC9005E
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 17:00:40 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	r5JL0fva44367954
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 17:00:41 -0400
Received: from d01av05.pok.ibm.com (loopback [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	r5JL0ex1005336 for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 17:00:40 -0400
Subject: Re: WANTED: xfstests results in different architectures
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20130618233426.GD29338@dastard>
References: <1371596399.22504.38.camel@chandra-dt.ibm.com>
	<20130618233426.GD29338@dastard>
Date: Wed, 19 Jun 2013 16:00:39 -0500
Message-ID: <1371675639.22504.63.camel@chandra-dt.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
Cc: XFS mailing list <xfs@oss.sgi.com>

On Wed, 2013-06-19 at 09:34 +1000, Dave Chinner wrote:


Hi Dave,
> On Tue, Jun 18, 2013 at 05:59:59PM -0500, Chandra Seetharaman wrote:
> > Hello All,
> > 
> > Couple of weeks backs we had a discussion in xfs meeting to collect
> > xfstests results. I volunteered to collect xfstests results from
> > different architectures and upload to XFS.org.
> > 
> > I can run and get the results for x86_64 and ppc64. If anyone has other
> > architectures that they can run the tests on and provide me the results,
> > I will filter them an upload to XFS.org.
> 
> How are you going to filter and display them on xfs.org? Should the
> scripts to do this be part of xfstests?

I wasn't thinking of very elaborate filtering of all the results
submitted by all variants of kernel/xfsprogs. 

My thinking was very simple:
 - get test results based on publicly available git tree commit IDs
 - show the commit ID, and the failures seen in a specific arch.
 
This would help when anybody runs xfstests and sees a failure with any
newer code, they would know if it is a regression or already seen.

But, looks like there is more elaborate work in progress. I will sync up
with Ben and Phil to see how to help.
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
> 
> > Here is what I think would be of value to provide along with the results
> > (others, please feel free to add more to the list for the results to be
> > more useful)
> >     - Architecture of the system
> 
> 	- base distro (e.g. /etc/release).
> 
> >     - Configuration - memory size and number of procs
> 
> I think that all the info that we ask people to report in bug
> reports would be a good start....
> 
> >     - Filesystem sizes
> 
> More useful is the MKFS_OPTIONS and MOUNT_OPTIONS used to run the
> tests, as that tells us how much non-default test coverage we are
> getting. i.e. default testing or something different.
> 
> >     - Commit ID of the kernel
> 
> Not useful for kernels built with local, non-public changes, which
> is generally 100% of the kernels and userspace packages I test
> with.
> 
> >     - which git tree (XFS git tree or Linus's)
> >     - xfsprogs version (or commit ID if from the git tree)
> 
> Same as for the kernel - base version is probably all that is useful
> here.
> 
> You'd probably also want to capture the console output indicating
> test runtimes and why certain tests weren't run.
> 
> If you create a pristine $RESULTS_DIR and output all the information
> you want to gather into it, then it will be trivial for users to
> send information onwards. Providing a command line parameter that
> generates a unique results directory and then packages the results
> up into a tarball would be a great start. We'd then have a single
> file that can be sent up a central point with all the test results
> available. We could even do all the filtering/processing before
> upload.
> 
> IOWs, the idea behind $RESULTS_DIR is to make this sort of scripted
> test result gathering simple to do....
> 
> Cheers,
> 
> Dave.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
