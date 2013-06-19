Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DF8D57CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 11:19:10 -0500 (CDT)
Date: Wed, 19 Jun 2013 11:19:07 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: WANTED: xfstests results in different architectures
Message-ID: <20130619161907.GP20932@sgi.com>
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

Dave, Chandra,

On Wed, Jun 19, 2013 at 09:34:26AM +1000, Dave Chinner wrote:
> On Tue, Jun 18, 2013 at 05:59:59PM -0500, Chandra Seetharaman wrote:
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

I did.  It is still pretty rough.  I'll post it in reply here.

My design criteria as best as I can remember...

1) not filesystem specific

2) capture the actual results

3) simple, lightweight, very little setup

4) compatible with something like hangcheck so you can figure out when a
machine has hung or crashed 

5) useable for an individual developer

6) useable for a maintainer

7) not web centric

8) uses tools that are likely to be installed with the base distro

9) includes what you're testing, along with the results.

10) upload target can be easily changed.

11) (not implemented) perl scripts to parse the output.

...and so on.  I have no objection to adding databases and web stuff on the
backend.

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

You're using a guilt workflow, right?  I think it could be useful if you grab
the commit id, and then a list of all the changes atop that.  I find this
useful with my quilt workflow.

> >     - which git tree (XFS git tree or Linus's)
> >     - xfsprogs version (or commit ID if from the git tree)
> 
> Same as for the kernel - base version is probably all that is useful
> here.
> 
> You'd probably also want to capture the console output indicating
> test runtimes and why certain tests weren't run.

Agreed, gathering runtimes and .notrun is worth doing.

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

Posting results as you go has certain benefits, like hangcheck.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
