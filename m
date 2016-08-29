Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5719F7CA0
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 18:28:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A8D16AC004
	for <xfs@oss.sgi.com>; Mon, 29 Aug 2016 16:28:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id v7hEGK7beaEwUM4K (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 29 Aug 2016 16:28:09 -0700 (PDT)
Date: Mon, 29 Aug 2016 18:28:06 -0500
From: "Bill O'Donnell" <billodo@redhat.com>
Subject: Re: [PATCH] xfsprogs: don't populate fs table with foreign fs paths
	unless foreign_allowed
Message-ID: <20160829232806.GB29648@redhat.com>
References: <1472478012-23627-1-git-send-email-billodo@redhat.com>
	<20160829151323.GG22760@birch.djwong.org>
	<20160829154349.GA4643@redhat.com> <20160829231649.GP19025@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160829231649.GP19025@dastard>
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
Cc: xfs@oss.sgi.com, "Darrick J. Wong" <darrick.wong@oracle.com>

On Tue, Aug 30, 2016 at 09:16:49AM +1000, Dave Chinner wrote:
> On Mon, Aug 29, 2016 at 10:43:49AM -0500, Bill O'Donnell wrote:
> > On Mon, Aug 29, 2016 at 08:13:23AM -0700, Darrick J. Wong wrote:
> > > On Mon, Aug 29, 2016 at 08:40:12AM -0500, Bill O'Donnell wrote:
> > > > Commits b20b6c2 and 29647c8 modified xfs_quota for use on
> > > > non-XFS filesystems. One modification in fs_initialise_mounts
> > > > (paths.c) resulted in an xfstest fail (xfs/261), due to foreign
> > > > fs paths entering the fs table.
> > > > 
> > > > This patch reverts the behavior in fs_initialise_mounts back
> > > > to skip populating the table with foreign paths, unless the
> > > > -f flag is thrown in xfs_quota to set foreign_allowed true.
> > > > 
> > > > Signed-off-by: Bill O'Donnell <billodo@redhat.com>
> > > > ---
> > > >  libxcmd/paths.c | 5 +++++
> > > >  quota/init.c    | 1 -
> > > >  2 files changed, 5 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/libxcmd/paths.c b/libxcmd/paths.c
> > > > index 4158688..7375c0e 100644
> > > > --- a/libxcmd/paths.c
> > > > +++ b/libxcmd/paths.c
> > > > @@ -34,6 +34,7 @@ extern char *progname;
> > > >  int fs_count;
> > > >  struct fs_path *fs_table;
> > > >  struct fs_path *fs_path;
> > > > +bool foreign_allowed = false;	/* foreign filesystems not allowed (default) */
> > > 
> > > /me wonders if this would be better as a parameter to
> > > fs_table_initialise_mounts() ?
> > 
> > Hrmm, it could be, but my notion is that keeping it global
> > is a bit cleaner than having to add automatics in 4
> > function calls.
> 
> For some definition of "cleaner" (i.e. less code change), yes.
> 
> However, hiding behavioural state in library globals hides the
> connection between the program code that sets it and the library
> code that uses it. It's better to explicitly pass function behaviour
> control parameters as function parameters, that way you can just
> follow the call chain to know what is supposed to be happening as
> you read the source....

Agreed. I thought about it today, and it is indeed "safer" and better
understood to use arguments instead of an external variable. I'll fix
it.
Thanks-
Bill


> 
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
