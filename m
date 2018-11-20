Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36147 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbeKTNYs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 20 Nov 2018 08:24:48 -0500
Date: Tue, 20 Nov 2018 10:57:50 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH 1/6] fsx: add clone range
Message-ID: <20181120025750.GH3889@desktop>
References: <154215237717.21151.11976488103599724788.stgit@magnolia>
 <154215238338.21151.852724936803809717.stgit@magnolia>
 <20181116192626.GA9387@magnolia>
 <20181118135108.GE3889@desktop>
 <20181120022755.GA6783@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181120022755.GA6783@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Nov 19, 2018 at 06:27:55PM -0800, Darrick J. Wong wrote:
> On Sun, Nov 18, 2018 at 09:51:08PM +0800, Eryu Guan wrote:
> > On Fri, Nov 16, 2018 at 11:26:26AM -0800, Darrick J. Wong wrote:
> > > On Tue, Nov 13, 2018 at 03:39:43PM -0800, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > > 
> > > > Add support for FICLONERANGE to fsx.
> > > > 
> > > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > > ---
> > > >  ltp/fsx.c |  182 +++++++++++++++++++++++++++++++++++++++++++++++++++++--------
> > > >  1 file changed, 158 insertions(+), 24 deletions(-)
> > > > 
> > > > 
> > > > diff --git a/ltp/fsx.c b/ltp/fsx.c
> > > > index b0157ba3..2b0a2b28 100644
> > > > --- a/ltp/fsx.c
> > > > +++ b/ltp/fsx.c
> > > > @@ -88,25 +88,28 @@ int			logcount = 0;	/* total ops */
> > > >   * mode being run.
> > > >   */
> > > >  
> > > > -/* common operations */
> > > > -#define	OP_READ		0
> > > > -#define OP_WRITE	1
> > > > -#define OP_MAPREAD	2
> > > > -#define OP_MAPWRITE	3
> > > > -#define OP_MAX_LITE	4
> > > > -
> > > > -/* !lite operations */
> > > > -#define OP_TRUNCATE		4
> > > > -#define OP_FALLOCATE		5
> > > > -#define OP_PUNCH_HOLE		6
> > > > -#define OP_ZERO_RANGE		7
> > > > -#define OP_COLLAPSE_RANGE	8
> > > > -#define OP_INSERT_RANGE	9
> > > > -#define OP_MAX_FULL		10
> > > > -
> > > > -/* integrity operations */
> > > > -#define OP_FSYNC		10
> > > > -#define OP_MAX_INTEGRITY	11
> > > > +enum {
> > > > +	/* common operations */
> > > > +	OP_READ = 0,
> > > > +	OP_WRITE,
> > > > +	OP_MAPREAD,
> > > > +	OP_MAPWRITE,
> > > > +	OP_MAX_LITE,
> > > > +
> > > > +	/* !lite operations */
> > > > +	OP_TRUNCATE = OP_MAX_LITE,
> > > > +	OP_FALLOCATE,
> > > > +	OP_PUNCH_HOLE,
> > > > +	OP_ZERO_RANGE,
> > > > +	OP_COLLAPSE_RANGE,
> > > > +	OP_INSERT_RANGE,
> > > > +	OP_CLONE_RANGE,
> > > > +	OP_MAX_FULL,
> > > > +
> > > > +	/* integrity operations */
> > > > +	OP_FSYNC = OP_MAX_FULL,
> > > > +	OP_MAX_INTEGRITY,
> > > > +};
> > > >  
> > > >  #undef PAGE_SIZE
> > > >  #define PAGE_SIZE       getpagesize()
> > > > @@ -160,6 +163,7 @@ int     punch_hole_calls = 1;           /* -H flag disables */
> > > >  int     zero_range_calls = 1;           /* -z flag disables */
> > > >  int	collapse_range_calls = 1;	/* -C flag disables */
> > > >  int	insert_range_calls = 1;		/* -I flag disables */
> > > > +int	remap_calls = 1;		/* -J flag disables */
> > > >  int 	mapped_reads = 1;		/* -R flag disables it */
> > > >  int	integrity = 0;			/* -i flag */
> > > >  int	fsxgoodfd = 0;
> > > > @@ -254,6 +258,7 @@ static const char *op_names[] = {
> > > >  	[OP_ZERO_RANGE] = "zero_range",
> > > >  	[OP_COLLAPSE_RANGE] = "collapse_range",
> > > >  	[OP_INSERT_RANGE] = "insert_range",
> > > > +	[OP_CLONE_RANGE] = "clone_range",
> > > >  	[OP_FSYNC] = "fsync",
> > > >  };
> > > >  
> > > > @@ -275,6 +280,25 @@ static int op_code(const char *name)
> > > >  	return -1;
> > > >  }
> > > >  
> > > > +void
> > > > +log5(int operation, int arg0, int arg1, int arg2, enum opflags flags)
> > > > +{
> > > > +	struct log_entry *le;
> > > > +
> > > > +	le = &oplog[logptr];
> > > > +	le->operation = operation;
> > > > +	if (closeopen)
> > > > +		flags |= FL_CLOSE_OPEN;
> > > > +	le->args[0] = arg0;
> > > > +	le->args[1] = arg1;
> > > > +	le->args[2] = arg2;
> > > 
> > > I would like to withdraw this patch so that I can add a fourth args[]
> > > slot so that we can maintain the convention of printing the
> > > pre-operation file size after the other operation arguments.  This will
> > > make tracking the location of EOF through an fsxops file easier.
> > 
> > I'll wait for the new version of the whole patchset then, that gives me
> > extra time to look at & test them :)
> 
> I also added separate command line arguments to disable each of {clone,
> dedupe, copy} range, and fixed the "does this overlap with the bad
> range" reporting.  I also added a new mode where you can ask fsx to
> reread the entire file after every operation to look for corruption
> problems.  Will send patches shortly.

As we're seeing many new failures (even crashes and hangs) when
clone/dedupe/copy range are enabled, is it better to mark them as
disabled by default?

Thanks,
Eryu
