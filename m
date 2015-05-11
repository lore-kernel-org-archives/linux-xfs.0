Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8FC0029DFB
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 09:14:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1BF9EAC001
	for <xfs@oss.sgi.com>; Mon, 11 May 2015 07:14:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id p965ZunwW6hYVvF9 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 11 May 2015 07:14:48 -0700 (PDT)
Date: Mon, 11 May 2015 10:14:44 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [ANNOUNCE, DISCUSS] xfsprogs: libxfs-4.1-update branch created
Message-ID: <20150511141442.GB43723@bfoster.bfoster>
References: <20150511000508.GD16689@dastard>
	<20150511123917.GA43723@bfoster.bfoster>
	<20150511132009.GD15721@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150511132009.GD15721@dastard>
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
Cc: xfs@oss.sgi.com

On Mon, May 11, 2015 at 11:20:09PM +1000, Dave Chinner wrote:
> On Mon, May 11, 2015 at 08:39:18AM -0400, Brian Foster wrote:
> > On Mon, May 11, 2015 at 10:05:08AM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > I' ve just added a branch to the xfsprogs repository on kernel.org
> > > that is up to date with the current 4.1-rc2 kernel code. It's smoke
> > > tested, so I don't think there's any major problems with it. Can
> > > everyone with development patches (i.e. things that change on disk
> > > formats) for xfsprogs please rebase their work against this branch,
> > > retest and repost? This branch will end up being the 3.3 release
> > > tree...
> > > 
> > > FWIW, now that I've done this update, I'm considered how we keep
> > > this up to date in future. Keeping the userspace code up to date and
> > > working with all the internal kernel API changes takes quite a bit
> > > of effort and that currently is all being done by the Maintainer.
> > > i.e. me. This is the reason that userspace is not updated
> > > frequently.
> > > 
> > > With this update, libxfs in the kernel and userspace are mostly
> > > identical, so I'm thinking that a new rule for XFS developers needs
> > > to be put in place: if you modify a libxfs kernel API, then you need
> > > to make the same change to userspace. This means all the changes
> > > needed for xfs_repair, xfs_db, etc, need to be done as well, because
> > > sometimes these things are non-trivial.
> > > 
> > > A good example of this is Christoph's xfs_trans_commit() patchset.
> > > There's 42 xfs_trans_commit() calls in userspace and it has a
> > > completely different implementation in userspace. To put that in
> > > context, there are 61 xfs_trans_commit() in the kernel code. If I
> > > merge that changeset into the kernel code, then Christoph walks away
> > > and it has become the Maintainer's problem to make userspace work
> > > with the API change.
> > > 
> > > This *sucks* from a maintainer's POV - - it simply does not scale.
> > > This is one of the reasons why my productivity as an XFS developer
> > > has cratered over the last year. This userspace update work needs to
> > > be distributed over the developers making the API and functionality
> > > changes, so I'm throwing this out there to see what people think
> > > about solving this problem.
> > > 
> > > I'm thinking that we need a userspace dev branch similar to the
> > > for-next branch for the kernel code, where we aggregate topic
> > > branches that contain each set of userspace patches that add/change
> > > functionality that is shared with the kernel. If the developer
> > > hasn't done the work to update userspace and test the changes there,
> > > then the change is incomplete.
> > > 
> > > Note that I'm only suggesting this for the main XFS developers
> > > making internal API or on-disk format changes to XFS - the typical
> > > drive-by patches and bug fixes from random people we commit to the
> > > kernel code will still need the maintainer to push them across to
> > > userspace.
> > > 
> > > This will make my life easier from both an update and maintenance
> > > point of view, and will make it easier for us as developers to get
> > > the latest dev code faster. It will also make porting kernel changes
> > > over to userspace faster, as the patches will mostly apply cleanly
> > > to the userspace libxfs code base. And if it gets merged quicker,
> > > tehn we'll get better test coverage of the dev tree because we'll be
> > > testing it sooner. And as developers, we won't have to be working
> > > out what changed and needs forward porting from the kernel to
> > > userspace to make stuff work....
> > > 
> > > So, what do the people I'm asking to do more work so I don't have
> > > to spend so much time on time consuming maintenance tasks think?
> > > 
> > 
> > This seems reasonable to me. As it is, I'd expect to do this anyways for
> > anything that changes on-disk format. Such a change isn't really
> > complete if mkfs/xfs_repair/xfs_db can't handle it appropriately.
> > Provided we keep the development branch up to date, I don't see much
> > harm in extending that to libxfs API level changes as well.
> 
> Right - the point of this is making sure we keep userspace up to
> date, rather than doing an update once every blue moon and it being
> a lot of work to do.
> 
> > What's the proposition with regard to submission/review process? I don't
> > think we necessarily need the userspace bits until there is some review
> > feedback on the kernel bits because that just increases development and
> > review overhead (though nothing precludes posting both, of course). Also
> 
> Yes, that's fine - the userspace libxfs bits should be a straight
> conversion of the kernel patches with a simple bit of path
> stripping. e.g. the kernel patch path will be a/fs/xfs/libxfs/....
> and the xfsprogs patch path is a/libxfs/...
> 
> Hence the same patch should apply, simply with a -p 5 (?) path strip
> level rather than -p 1. i.e. `patch -p 5 < kernel.diff` should
> simply apply the kernel patches to the xfsprogs libxfs.
> 
> > (and I think we discussed this briefly at LSF), I assume it is
> > reasonable to condense a kernel patch series to a single userspace "sync
> > XYZ feature to xfsprogs" patch for the bits that port directly over,
> > since we have the kernel git log for finer grained history..?
> 
> Haven't really thought about it. Fine grained history is more
> important for the kernel, but for userspace I can still see it being
> useful for things like API changes where the same set of steps made
> to the kernel code to make review easy should be made to make the
> xfs_repair/db/... changes easy to review.
> 

I'd always expect non-libxfs stuff to consist of independent patches as
normally done...

> > Case in
> > point: I could squash the sparse inode kernel patches into a single
> > xfsprogs patch. The functional xfsprogs bits on top of that (e.g., mkfs,
> > repair, etc.) would of course remain as independent patches that require
> > indepenent review.
> 
> Right, for something that is all new code this can be done. It does
> mean we'll have to be vigilant about merging bug fixes into the
> userspace code, though. Those are really only picked up during
> the large merges right now...
> 
> > Something to note here is that I think this might warrant a bit more
> > positive feedback with regard to when things are considered reviewed on
> > the kernel side (i.e., merge is imminent). Perhaps we could create the
> > kernel topic branch but not merge it until the userspace bits are
> > available..? Just a thought, whatever works best for you is probably
> > fine provided the developer is made clear where things stand.
> 
> Well, for on-disk format changes we'll need the userspace code at
> tha same time so that reviewers can test the changes, but for
> everything else a port from the topic branch that gets merged into
> the for-next tree is probably fine from a timing POV.
> 

Sure, we at least need a subset of the kernel code sufficient to
facilitate testing. The tarballs for the sparse inode code, for example,
might not precisely match all the little fixups/reworks in the kernel
code.

My assumption has been that things that are reviewed and pending merge
aren't necessarily merged immediately. The merges may be more timed with
the kernel release process or whatever your process happens to be. My
point is just that if things are not merged synchronous to review
so-to-speak, positive feedback when merge is imminent is useful to know
when is the optimal time to backport changes. That could manifest as
making a non-merged branch available, posting more reviewed-by's, etc.

> What I'd really like to is for all the changes merged in a kernel
> -rc1 window are already merged into the userspace tree, or are at
> least well on their way to being merged. That way we can even start
> to think about a simple rolling release of xfsprogs that mirrors
> the timing of the kernel release cycle. That way for new features
> we get userspace support released at the same time that kernel
> support is released....
> 
> The other benefit of doing this is that we get the changes committed
> while it is still fresh in our minds - we don't have to look back to
> code written 6-9 months ago and scratch our heads wondering why the
> obvious merge changes aren't working because we've forgotten some
> little detail about the change....
> 

Agreed.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
