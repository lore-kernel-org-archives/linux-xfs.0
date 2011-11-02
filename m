Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA2HqNaF189973 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 12:52:23 -0500
Message-ID: <1320256339.3145.30.camel@doink>
Subject: Re: [PATCH] Fix possible memory corruption in xfs_readlink
From: Alex Elder <aelder@sgi.com>
Date: Wed, 2 Nov 2011 12:52:19 -0500
In-Reply-To: <1320156842.30281.28.camel@deadeye>
References: <1320156842.30281.28.camel@deadeye>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Carlos Maiolino <cmaiolino@redhat.com>, xfs@oss.sgi.com

I don't konw why, but I *think* the response I
thought I sent earlier didn't actually make it
out.

Just in case, I'm trying to recreate what I had
before, below.  Sorry if something like this
shows up twice.

On Tue, 2011-11-01 at 14:14 +0000, Ben Hutchings wrote:
> On Tue, 2011-10-18 at 02:18 -0200, Carlos Maiolino wrote:
> > Fixes a possible memory corruption when the link is larger than
> > MAXPATHLEN and XFS_DEBUG is not enabled. This also remove the
> > S_ISLNK assert, since the inode mode is checked previously in
> > xfs_readlink_by_handle() and via VFS.
> > 
> > Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
> > ---
> >  fs/xfs/xfs_vnodeops.c |   11 ++++++++---
> >  1 files changed, 8 insertions(+), 3 deletions(-)

A few comments inline below, followed by Ben's original
message and some explanation from me.

> > diff --git a/fs/xfs/xfs_vnodeops.c b/fs/xfs/xfs_vnodeops.c
> > index 51fc429..c3288be 100644
> > --- a/fs/xfs/xfs_vnodeops.c
> > +++ b/fs/xfs/xfs_vnodeops.c
> > @@ -123,13 +123,18 @@ xfs_readlink(
> >  
> >  	xfs_ilock(ip, XFS_ILOCK_SHARED);
> >  
> > -	ASSERT(S_ISLNK(ip->i_d.di_mode));
> > -	ASSERT(ip->i_d.di_size <= MAXPATHLEN);
> > -
> >  	pathlen = ip->i_d.di_size;
> pathlen is a signed int (32-bit) and di_size has signed 64-bit type.

I concur, di_size here is an xfs_fsize_t, which is defined
as __int64_t (a signed 64-bit integer).  pathlen is defined
as a (signed) int.

> So, even if di_size was verified to be non-negative earlier (is it?)...

More on this question below.

> >  	if (!pathlen)
> >  		goto out;
> >  
> > +	if (pathlen > MAXPATHLEN) {
> 
> ...pathlen may be negative here and will pass this check.
> 
> Ben.

You are right to call attention to this.  I think defining
pathlen to be an int here is a mistake in any case (the type
ought to match that of id.di_size), though in practice it
will not be a problem.

You mention two remaining issues:
- can a value held in ip->i_d.di_size result in a negative
  value in pathlen as a result of the assignment?
- is ip->i_d.di_size guaranteed (verified) to be non-negative?

On the first question, the C standard says that the result of
the assignment--if id.di_size exceeds what can be represented
by pathlen--is implementation defined, therefore it is not
safe.  So you're right, this needs to be fixed.

On the second question, ip->i_d.di_size is assigned
in a lot of places.  I started looking at all the
places where this field gets assigned.  In about half
of them I examined the assignment obviously left its
value non-negative, or only allowing a negative assignment
if the previous value was already negative.

But rather than complete this research task, I think
it will be better (for now) to simply check for a negative
ip->i_d.di_size, and if it's seen, either return
an error or initiate a forced shutdown (since it
represents corruption).

I'm interested in what others think.

					-Alex

> > +		xfs_alert(mp, "%s: inode (%llu) symlink length (%d) too long",
> > +			 __func__, (unsigned long long)ip->i_ino, pathlen);
> > +		ASSERT(0);
> > +		return XFS_ERROR(EFSCORRUPTED);
> > +	}
> > +
> > +
> >  	if (ip->i_df.if_flags & XFS_IFINLINE) {
> >  		memcpy(link, ip->i_df.if_u1.if_data, pathlen);
> >  		link[pathlen] = '\0';
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs





_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
