Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04CA97F37
	for <xfs@oss.sgi.com>; Thu, 20 Jun 2013 12:03:45 -0500 (CDT)
Date: Thu, 20 Jun 2013 12:03:41 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [RFC PATCH 1/3] xfstests: get some basic source tree info
Message-ID: <20130620170341.GX20932@sgi.com>
References: <1371596399.22504.38.camel@chandra-dt.ibm.com>
	<20130618233426.GD29338@dastard>
	<1371675639.22504.63.camel@chandra-dt.ibm.com>
	<20130619223750.GT20932@sgi.com> <20130619224436.GU20932@sgi.com>
	<51C274EA.3030506@sandeen.net> <20130620035005.GQ29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130620035005.GQ29338@dastard>
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
To: Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, XFS mailing list <xfs@oss.sgi.com>

Hey Eric & Dave,

On Thu, Jun 20, 2013 at 01:50:05PM +1000, Dave Chinner wrote:
> On Wed, Jun 19, 2013 at 10:20:10PM -0500, Eric Sandeen wrote:
> > On 6/19/13 5:44 PM, Ben Myers wrote:
> > > Grab some basic information about the souce trees being tested and save
> > > it off for later.  
> > 
> > save it where?  Ah, results/check.log.
> > 
> > README updates maybe?
> > 
> > > This includes information about the git commit and
> > > any patches which are applied.
> > > 
> > > Set SRCDIRS environment variable with paths to the sources you're
> > > testing, colon delimited like PATH. 
> > > 
> > > e.g.
> > > 
> > > export SRCDIRS="/path/to/kernel:/path/to/xfsprogs:/path/to/xfsdump:/path/to/xfstests"
> > 
> > ok so after looking at the patch more carefully, this can be any
> > collection of paths to git trees in any order, right, and outputs i.e.:
> > 
> > SRCDIRS       -- /mnt/test2/git/linux-2.6:/mnt/test2/git/xfsdump:/mnt/test2/git/xfsprogs
> >     /mnt/test2/git/linux-2.6:
> > 	URL           -- git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > 	BRANCH        -- refs/heads/master
> > 	DESC          -- v3.10-rc2-48-g4284097
> >     /mnt/test2/git/xfsdump:
> > 	URL           -- git://oss.sgi.com/xfs/cmds/xfsdump.git
> > 	BRANCH        -- refs/heads/master
> > 	DESC          -- v3.1.2-4-g71f940f
> > ...
> > 
> > But what if we're testing packaged bits, not from a git tree,
> > should that be collected?

IMO we should support both git tree and packaged workflows.

> Ideally, yes. My CI system builds packages, then ships them over to
> the VMs that run tests and installs them before the tests are run.
> So there's never any source trees available for such probing. And
> often I just use the versions install on the distro I'm doing my
> testing on.

Any suggestions on how to track the sources the packaged workflow?  My
first thought is that we could package sources in the .rpm or .deb or
srpm and ship that over to the test machine.  Then add the name of the
rpm/deb to the SRCDIRS envvar and teach this thing to grab the sources
from there.  But if you're talking about a kernel-source rpm this could
get fairly large.

Alternatively, if you have a way of tagging what you're testing and
linking that up with your SCM you don't have to go after the sources on
the test box, just make sure to make a note of the tag.  Maybe add the
git url/branch/desc the rpm info which you could query with -qi?

> > > +_full_source_details()
> > > +{
> > > +    if [ -z $SRCDIRS ]; then
> > > +        return
> > > +    fi
> > > +
> > > +    echo "SRCDIRS       -- $SRCDIRS"
> > > +
> > > +    dirs=$(echo $SRCDIRS | tr ":" "\n")
> > > +    for dir in $dirs
> > > +    do
> > > +        echo "    $dir:"
> > > +        if [ -d $dir/.git ]; then
> > > +            # git url, branch, and description
> > > +            url=$(cd $dir; git remote show origin | grep 'Fetch URL' | awk '{print $3}')
> > > +            echo -e "\tURL           -- $url"
> > > +            branch=$(cd $dir; git symbolic-ref HEAD)
> > > +            echo -e "\tBRANCH        -- $branch"
> > > +            desc=$(cd $dir; git describe)
> > > +            echo -e "\tDESC          -- $desc"
> > > +        fi
> > > +
> > > +        if [ -d $dir/patches ]; then
> > > +            # quilt patches which are applied
> > 
> > what if it's guilt not quilt?

Right now I'm a quilt guy... but I think it would be nice if we could
support both.
 
> Then it will give a git signature that doesn't match anything that was
> ever published.
>
> But from my perspective, that simply doesn't matter.
>
> I'm not going to be sending lists of patches I'm testing to a remote
> server - there's way too much scope for inadvertant information leaks
> in doing this.  Especially considering patch 3/3 sends the *patches*
> to the remote server via the _archive function.  There's no way I'd be
> recommending such functionality be used in environments that contain
> both upstream and internal development trees.

I want to do this in a way that doesn't force users to use it.  Maybe
add an --upload option to check so that it's clearer whether you're
going to upload?
 
> What you propose might be fine for individual developer usage, but
> it's not appropriate for public distribution of test results.

I'm looking for something that is flexable enough for both individual
developer usage as well as public distribution, in the same mechanism.

> Result logs for public distribution need to be as anonymous as
> possible with only the bare minimum of identifying information in
> them.

To what end?  We're already posting to a publicly available mailing list
which is archived for posterity.  There is no anonymity here.  I guess
we could hash the hostname into something unrecognisable?  It's worth
keeping an email address, I think.
 
> Hence for public consumption, I'd suggest that we'd do far better to
> just target released kernels and packages. e.g. the kernel release tag
> like 3.10-rc4, and the xfsprogs/dump/test version being used.

I tend to agree that for public consumption you'd want to upload only
tthe results of tagged versions of the kernels/xfsprogs/dump/test.  You
generally wouldn't want to upload results from day-to-day development
work to a public location, but this does allow you to upload those
results to an internal server if you want to.

However, if Jane Developer wants to post test results for the patches
she has published, I want to enable her to do so... maybe to a different
location than the tagged versions.

> Having a repository of full of failure reports from random developer
> patchsets and kernels is not useful to anyone....

Too much data from test reports is a problem I'd love to have.  ;)

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
