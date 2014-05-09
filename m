Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 363457F3F
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 16:45:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEAD0AC002
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 14:45:27 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	0UadNcvCcIQYDoc4 for <xfs@oss.sgi.com>;
	Fri, 09 May 2014 14:45:22 -0700 (PDT)
Date: Sat, 10 May 2014 07:45:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140509214502.GL26353@dastard>
References: <20140506071855.F152E7FBC@oss.sgi.com>
	<20140506075905.GA5421@dastard>
	<20140506083744.GA9976@infradead.org>
	<20140506090056.GH5421@dastard>
	<20140509072942.GB7882@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140509072942.GB7882@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Fri, May 09, 2014 at 12:29:42AM -0700, Christoph Hellwig wrote:
> On Tue, May 06, 2014 at 07:00:56PM +1000, Dave Chinner wrote:
> > I did this because I'm sick of having to edit 50+ files whenever a
> > single header dependency changes. There are almost all cookie cutter
> > duplicates because of the dependencies - if it were code, we'd
> > factor it in an instant.  I just don't see why we should treat 50
> > copies of the same header includes any differently....
> 
> So let's factor it out by fixing our header mess like I started
> with the format headers.  That's the real fix instead of encoding
> that mess by wrapping it.

Ok, I'm not exactly sure what the layout you envisiage is. Can you
explain it so that I've got some idea of how much more work is
involved in getting to that?

> > >  - do we really need the separate include/ dir?  That always annoys
> > >    me when editing code.  It makes sense for something that is a real
> > >    public interface, which this is not.
> > 
> > It's for simplicity of updates with the userspace code. Both
> > userspace and kernel need the same code layout, and userspace
> > currently has a separate include directory for all the header files
> > (and they get installed that way, too). If we want to change the
> > userspace source layout and commingle all the headers with the C
> > code, then that's a lot more work on the userspace side (i.e. it's
> > more than just pointing the include/xfs symlink to libxfs/include).
> > 
> > I don't mind which approach we take - it's trivial to rework the
> > patchset to place all the headers in the libxfs/ directory - I just
> > took the one that matched the current userspace infrastructure...
> 
> The only ones installed are xfs_fs.h and xfs_types.h.  The first one
> is special.  I'd really prefer to to make a major mess of the layout
> for this.  In fact I don't even really see the need for a subdirectory
> just to share the files.

I'd prefer to have a subdir layout the same across both code bases
simply because it makes management of the synchronisation process so
much easier. The overhead of synchronisation is one of the reasons
it doesn't get done as often as it should, and that's a problem we
really need to solve. same directory heirarchy in user and kernel
land makes it simple to script...

> > > Also is libxfs/ really the right name?  libxfs in userspace has quite
> > > a bit more code than this, so maybe we should just called this "shared"
> > > for the shared user/kernel code?
> > 
> > I'd like to have this kernel code define libxfs/, while in userspace
> > we separate out all the support code (i.e. libxfs/rdwr.c, etc) into
> > a different directory that builds the userspace libraries. i.e.
> > libxfs/ is a static object archive that is wrapped by the userspace
> > infrastructure, just like the kernel wraps it with infrastructure to
> > make it useful...
> 
> Well, libxfs is the whole think in userspace.  So even if you absolutely
> want to stick to a messy hiecharical layout we could at least condens it
> to:
> 
> fs/xfs/shared
> fs/xfs/include
> 
> 	in the kernel
> 
> libxfs/shared
> libxfs/include
> 
> 	in userspace

Realistically, if we're going to change the entire libxfs code
layout in userspace as well, we may as well just change userspace to
handle all the exported libxfs include files directly from the
libxfs directory, and keep it as a flat directory.

Like I said, I just did the libxfs/include to make it easy to retain
the existing userspace structure, so if we aren't going to do that
then we don't need a separate libxfs/include. I think I'll head down
that path (modify both kernel and userland structure) so that we
don't end up with deep heirarchies...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
