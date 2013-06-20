Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B49097CBF
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 22:50:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9CCB88F8033
	for <xfs@oss.sgi.com>; Wed, 19 Jun 2013 20:50:22 -0700 (PDT)
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	GEgamIpnwBM92A51 for <xfs@oss.sgi.com>;
	Wed, 19 Jun 2013 20:50:18 -0700 (PDT)
Date: Thu, 20 Jun 2013 13:50:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC PATCH 1/3] xfstests: get some basic source tree info
Message-ID: <20130620035005.GQ29338@dastard>
References: <1371596399.22504.38.camel@chandra-dt.ibm.com>
	<20130618233426.GD29338@dastard>
	<1371675639.22504.63.camel@chandra-dt.ibm.com>
	<20130619223750.GT20932@sgi.com> <20130619224436.GU20932@sgi.com>
	<51C274EA.3030506@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <51C274EA.3030506@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ben Myers <bpm@sgi.com>, Chandra Seetharaman <sekharan@us.ibm.com>, XFS mailing list <xfs@oss.sgi.com>

On Wed, Jun 19, 2013 at 10:20:10PM -0500, Eric Sandeen wrote:
> On 6/19/13 5:44 PM, Ben Myers wrote:
> > Grab some basic information about the souce trees being tested and save
> > it off for later.  
> 
> save it where?  Ah, results/check.log.
> 
> README updates maybe?
> 
> > This includes information about the git commit and
> > any patches which are applied.
> > 
> > Set SRCDIRS environment variable with paths to the sources you're
> > testing, colon delimited like PATH. 
> > 
> > e.g.
> > 
> > export SRCDIRS="/path/to/kernel:/path/to/xfsprogs:/path/to/xfsdump:/path/to/xfstests"
> 
> ok so after looking at the patch more carefully, this can be any
> collection of paths to git trees in any order, right, and outputs i.e.:
> 
> SRCDIRS       -- /mnt/test2/git/linux-2.6:/mnt/test2/git/xfsdump:/mnt/test2/git/xfsprogs
>     /mnt/test2/git/linux-2.6:
> 	URL           -- git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 	BRANCH        -- refs/heads/master
> 	DESC          -- v3.10-rc2-48-g4284097
>     /mnt/test2/git/xfsdump:
> 	URL           -- git://oss.sgi.com/xfs/cmds/xfsdump.git
> 	BRANCH        -- refs/heads/master
> 	DESC          -- v3.1.2-4-g71f940f
> ...
> 
> But what if we're testing packaged bits, not from a git tree,
> should that be collected?

Ideally, yes. My CI system builds packages, then ships them over to
the VMs that run tests and installs them before the tests are run.
So there's never any source trees available for such probing. And
often I just use the versions install on the distro I'm doing my
testing on.

> > +_full_source_details()
> > +{
> > +    if [ -z $SRCDIRS ]; then
> > +        return
> > +    fi
> > +
> > +    echo "SRCDIRS       -- $SRCDIRS"
> > +
> > +    dirs=$(echo $SRCDIRS | tr ":" "\n")
> > +    for dir in $dirs
> > +    do
> > +        echo "    $dir:"
> > +        if [ -d $dir/.git ]; then
> > +            # git url, branch, and description
> > +            url=$(cd $dir; git remote show origin | grep 'Fetch URL' | awk '{print $3}')
> > +            echo -e "\tURL           -- $url"
> > +            branch=$(cd $dir; git symbolic-ref HEAD)
> > +            echo -e "\tBRANCH        -- $branch"
> > +            desc=$(cd $dir; git describe)
> > +            echo -e "\tDESC          -- $desc"
> > +        fi
> > +
> > +        if [ -d $dir/patches ]; then
> > +            # quilt patches which are applied
> 
> what if it's guilt not quilt?

Then it will give a git signature that doesn't match anything that
was ever published.

But from my perspective, that simply doesn't matter.  I'm not going
to be sending lists of patches I'm testing to a remote server -
there's way too much scope for inadvertant information leaks in
doing this. Especially considering patch 3/3 sends the *patches* to
the remote server via the _archive function.  There's no way I'd be
recommending such functionality be used in environments that contain
both upstream and internal development trees.

What you propose might be fine for individual developer usage, but
it's not appropriate for public distribution of test results.
Result logs for public distribution need to be as anonymous as
possible with only the bare minimum of identifying information in
them.

Hence for public consumption, I'd suggest that we'd do far better to
just target released kernels and packages. e.g. the kernel release
tag like 3.10-rc4, and the xfsprogs/dump/test version being used.
Having a repository of full of failure reports from random developer
patchsets and kernels is not useful to anyone....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
