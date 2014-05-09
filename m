Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 95E4F7F51
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 02:29:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 253BFAC013
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 00:29:45 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id DivxHEZHeKFIAmJW (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 09 May 2014 00:29:43 -0700 (PDT)
Date: Fri, 9 May 2014 00:29:42 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] libxfs kernel infrastructure (was [XFS updates] XFS
	development tree branch, xfs-libxfs-in-kernel-RFC, created.
	xfs-for-linus-3.15-rc2-52-g6579dd8)
Message-ID: <20140509072942.GB7882@infradead.org>
References: <20140506071855.F152E7FBC@oss.sgi.com>
	<20140506075905.GA5421@dastard>
	<20140506083744.GA9976@infradead.org>
	<20140506090056.GH5421@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140506090056.GH5421@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, May 06, 2014 at 07:00:56PM +1000, Dave Chinner wrote:
> I did this because I'm sick of having to edit 50+ files whenever a
> single header dependency changes. There are almost all cookie cutter
> duplicates because of the dependencies - if it were code, we'd
> factor it in an instant.  I just don't see why we should treat 50
> copies of the same header includes any differently....

So let's factor it out by fixing our header mess like I started
with the format headers.  That's the real fix instead of encoding
that mess by wrapping it.

> >  - do we really need the separate include/ dir?  That always annoys
> >    me when editing code.  It makes sense for something that is a real
> >    public interface, which this is not.
> 
> It's for simplicity of updates with the userspace code. Both
> userspace and kernel need the same code layout, and userspace
> currently has a separate include directory for all the header files
> (and they get installed that way, too). If we want to change the
> userspace source layout and commingle all the headers with the C
> code, then that's a lot more work on the userspace side (i.e. it's
> more than just pointing the include/xfs symlink to libxfs/include).
> 
> I don't mind which approach we take - it's trivial to rework the
> patchset to place all the headers in the libxfs/ directory - I just
> took the one that matched the current userspace infrastructure...

The only ones installed are xfs_fs.h and xfs_types.h.  The first one
is special.  I'd really prefer to to make a major mess of the layout
for this.  In fact I don't even really see the need for a subdirectory
just to share the files.

> 
> > Also is libxfs/ really the right name?  libxfs in userspace has quite
> > a bit more code than this, so maybe we should just called this "shared"
> > for the shared user/kernel code?
> 
> I'd like to have this kernel code define libxfs/, while in userspace
> we separate out all the support code (i.e. libxfs/rdwr.c, etc) into
> a different directory that builds the userspace libraries. i.e.
> libxfs/ is a static object archive that is wrapped by the userspace
> infrastructure, just like the kernel wraps it with infrastructure to
> make it useful...

Well, libxfs is the whole think in userspace.  So even if you absolutely
want to stick to a messy hiecharical layout we could at least condens it
to:

fs/xfs/shared
fs/xfs/include

	in the kernel

libxfs/shared
libxfs/include

	in userspace

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
