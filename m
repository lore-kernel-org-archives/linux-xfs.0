Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D807A7CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 17:37:53 -0500 (CDT)
Date: Wed, 19 Jun 2013 17:37:50 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: WANTED: xfstests results in different architectures
Message-ID: <20130619223750.GT20932@sgi.com>
References: <1371596399.22504.38.camel@chandra-dt.ibm.com>
	<20130618233426.GD29338@dastard>
	<1371675639.22504.63.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1371675639.22504.63.camel@chandra-dt.ibm.com>
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

Hi Chandra,

On Wed, Jun 19, 2013 at 04:00:39PM -0500, Chandra Seetharaman wrote:
> On Wed, 2013-06-19 at 09:34 +1000, Dave Chinner wrote:
> 
> 
> Hi Dave,
> > On Tue, Jun 18, 2013 at 05:59:59PM -0500, Chandra Seetharaman wrote:
> > > Hello All,
> > > 
> > > Couple of weeks backs we had a discussion in xfs meeting to collect
> > > xfstests results. I volunteered to collect xfstests results from
> > > different architectures and upload to XFS.org.
> > > 
> > > I can run and get the results for x86_64 and ppc64. If anyone has other
> > > architectures that they can run the tests on and provide me the results,
> > > I will filter them an upload to XFS.org.
> > 
> > How are you going to filter and display them on xfs.org? Should the
> > scripts to do this be part of xfstests?
> 
> I wasn't thinking of very elaborate filtering of all the results
> submitted by all variants of kernel/xfsprogs. 
> 
> My thinking was very simple:
>  - get test results based on publicly available git tree commit IDs
>  - show the commit ID, and the failures seen in a specific arch.
>  
> This would help when anybody runs xfstests and sees a failure with any
> newer code, they would know if it is a regression or already seen.
> 
> But, looks like there is more elaborate work in progress. I will sync up
> with Ben and Phil to see how to help.

Here is what little I have so far.  One of my goals is to be able to track all
of the testing in a centralized location for every patch that has been posted
to the list.  Tracking only the test results is useful, but I've found that it
is not valuable as I'd like unless I have a pretty good idea what code was
being tested.  Message-ID seems like the best way to accomplish this mapping to
mailing list archive.

Patch 1:

Grabs some information about the source trees in question.  We don't want this
to be xfs specific so it goes after an environment variable to figure out where
to look for sources.  Set SRCDIRS like a path:

export SRCDIRS="/path/to/kernel:/path/to/xfsprogs:/path/to/xfsdump:/path/to/xfstests"

It will print the git tree/branch/desc of each directory and any quilt patches
you have applied.  It prints md5sum/messageid/patchworkid for each patch that
is applied.  This doesn't address other workflows that use packaging, so I'm
toying with the idea of adding the ability to specify a package name in here,
which would allow those who prefer to use a packaging-based approach a way to
include sources with their test results.

Here is some sample output, which I admit isn't very pretty:

# ./check -g auto
fatal: ref HEAD is not a symbolic ref
SRCDIRS       -- /root/xfs:/root/xfsprogs:/root/xfsdump:/root/xfstests
    /root/xfs:
        URL           -- git://oss.sgi.com/xfs/xfs.git
        BRANCH        -- refs/heads/master
        DESC          -- v3.10-rc1-39-g2fb8b50
        PATCHES:
                /root/xfs/patches/xfs-update-mount-options-documentation.patch
                md5sum:         09a25d03e65fd969c058d6dd39fc1315
                X-Patchwork-Id: 5621
                Message-Id:     <1371617468-32559-2-git-send-email-david@fromorbit.com>
                /root/xfs/patches/xfs-add-pluging-for-bulkstat-readahead.patch
                md5sum:         0c3772ba0792d42332139268e86036e2
                X-Patchwork-Id: 5620
                Message-Id:     <1371617468-32559-3-git-send-email-david@fromorbit.com>
...
                Message-Id:     <1371617468-32559-12-git-send-email-david@fromorbit.com>
                /root/xfs/patches/xfs-use-inode-create-transaction.patch
                md5sum:         fb7259b0b3eb7c29a3dfc3a487c1584e
                X-Patchwork-Id: 5630
                Message-Id:     <1371617468-32559-13-git-send-email-david@fromorbit.com>
    /root/xfsprogs:
        URL           -- git://oss.sgi.com/xfs/cmds/xfsprogs.git
        BRANCH        --
        DESC          -- v3.1.9
        PATCHES:
    /root/xfsdump:
        URL           -- git://oss.sgi.com/xfs/cmds/xfsdump.git
        BRANCH        -- refs/heads/3.1.2
        DESC          -- v3.1.2
    /root/xfstests:
        URL           -- git://oss.sgi.com/xfs/cmds/xfstests.git
        BRANCH        -- refs/heads/master
        DESC          -- linux-v3.8-131-ge2549c6
        PATCHES:
                /root/xfstests/patches/keep-track-10
                md5sum:         64f67d028b133bb540a29d2a1223492c
                X-Patchwork-Id:
                Message-Id:
                /root/xfstests/patches/xfstests-check-cleanup-check.log-update-4
                md5sum:         eb41327c478bf99adb62cd8db3258ad5
                X-Patchwork-Id:
                Message-Id:
                /root/xfstests/patches/putresults-4
                md5sum:         f41fb9bfe8b88e5bab2de440de91e47a
                X-Patchwork-Id:
                Message-Id:
FSTYP         -- xfs (debug)
PLATFORM      -- Linux/x86_64 xfsqa-sum1 3.10.0-rc1+
MKFS_OPTIONS  -- -f -bsize=4096 /dev/sdb1
MOUNT_OPTIONS -- /dev/sdb1 /mnt/scratch

generic/001 5s ... 5s

You can see I'm testing a chunk of the 3.11 queue on this machine...  This
gives us a way to map back from a set of test results to the exact message on
the list.

Patch 2:

This guy just switches us to use a temporary check.log file so that it can be
uploaded later.  At the end it appends this to check.log in the results
directory so that the behavior looks the same as before.  Not much to see here.

Patch 3:

This one archives the description of what is being tested as well as those
sources which are not in the git tree that are being tested.  This should give
you all the info you need to duplicate the test run at a later date.  It also
archives test results during the run, including timestamps of when each test
starts and stops.  This is done so that on the upload end a cron job will be
able to tell whether a given system has hung in the middle of a test run, and
take action if a test is taking longer than expected (future work).  Currently
it is using curl to upload via ftp, which you control by setting an environment
variable:

export ARCHIVE_URL=ftp://anonymous:joe_at_xyz.com@ftp.xyz.com/xfstests/results

I think it might be helpful to add a few more url types.  Ideas that come to
mind are dir://path/to/my/local/archive, and tar:/path/to/tarball.tar

Here's what the current directory structure looks like:

/ftp/xfstests/results/xfsqa-sum1.americas.sgi.com/3.10.0-rc1+/1371679906
	hostname      ^^^^^^^^^^^^^^^^^^^^^^^^^^^ 
	kernel version                            ^^^^^^^^^^^
	start date                                            ^^^^^^^^^^

# ls
5015.start  5015.stop  check.desc  check.log  check.time  root/

# find root
root
root/xfs
root/xfs/patches
root/xfs/patches/xfs-update-mount-options-documentation.patch
...
root/xfs/patches/xfs-use-inode-create-transaction.patch
root/xfstests
root/xfstests/patches
root/xfstests/patches/keep-track-10
root/xfstests/patches/xfstests-check-cleanup-check.log-update-4
root/xfstests/patches/putresults-4

All of the patches are in there...

# cat *.st*
tests/generic/001 61919
tests/generic/001 61924

Those are the start and stop times for test 'generic/001'.

check.desc is the output you saw above, check.log is the standard output you'd
expect but only for this run, check.time is the amount of time each test took,
and you also get $seq.notrun, as well as test failure output uploaded.

-----

My future ideas are to write a perl script to parse through the test results
and print some reports.  Based upon that script, we could throw the output into
a website or database, for people who are into that kind of thing.

So, in conclusion, there isn't a whole lot here!  ;)

I would like to stress that it is important to keep track of what you're
testing along with the results, that making the test archival function part of
the test scripts themselves has some advantages, and hopefully this could be
extended to address everyone's preferred workflow.  It is important to have
something that is useful for individual developers as well as commercial
interests, without the fuss of a great deal of web/sql setup.  I've made
provisions for those who prefer to keep their testing private, and also for
people who wish to mine their test results on a larger scale.  Just set
ARCHIVE_URL to something that suits your needs.

I'm hoping to explore some of those ideas again soon.

Thanks,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
