Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ADDDD7CA0
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 19:42:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 73E4D8F8033
	for <xfs@oss.sgi.com>; Mon, 25 Apr 2016 17:42:02 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	OFMnqMkHXTDGsjAA for <xfs@oss.sgi.com>;
	Mon, 25 Apr 2016 17:41:58 -0700 (PDT)
Date: Tue, 26 Apr 2016 10:41:55 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Message-ID: <20160426004155.GF18496@dastard>
References: <1459303190-20072-1-git-send-email-vishal.l.verma@intel.com>
	<1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
	<x49twj26edj.fsf@segfault.boston.devel.redhat.com>
	<20160420205923.GA24797@infradead.org>
	<1461434916.3695.7.camel@intel.com>
	<20160425083114.GA27556@infradead.org>
	<1461604476.3106.12.camel@intel.com>
	<20160425232552.GD18496@dastard>
	<1461628381.1421.24.camel@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1461628381.1421.24.camel@intel.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "jack@suse.cz" <jack@suse.cz>, "axboe@fb.com" <axboe@fb.com>, "linux-nvdimm@ml01.01.org" <linux-nvdimm@ml01.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>

On Mon, Apr 25, 2016 at 11:53:13PM +0000, Verma, Vishal L wrote:
> On Tue, 2016-04-26 at 09:25 +1000, Dave Chinner wrote:
> >=A0
> <>
> =

> > > =

> > > - It checks badblocks and discovers it's files have lost data
> > Lots of hand-waving here. How does the application map a bad
> > "sector" to a file without scanning the entire filesystem to find
> > the owner of the bad sector?
> =

> Yes this was hand-wavey, but we talked about this a bit at LSF..
> The idea is that a per-block-device badblocks list is available at
> /sys/block/<pmemX>/badblocks. The application (or a suitable yet-to-be-
> written library function) does a fiemap to figure out the sectors its
> files are using, and correlates the two lists.
> We can also look into providing an easier-to-use interface from the
> kernel, in the form of an fiemap flag to report only the bad sectors, or
> a SEEK_BAD flag..
> The application doesn't have to scan the entire filesystem, but
> presumably it knows what files it 'owns', and does a fiemap for those.

You're assuming that only the DAX aware application accesses it's
files.  users, backup programs, data replicators, fileystem
re-organisers (e.g.  defragmenters) etc all may access the files and
they may throw errors. What then?

> > > - It write()s those sectors (possibly converted to file offsets
> > > using
> > > fiemap)
> > > =A0 =A0 * This triggers the fallback path, but if the application is
> > > doing
> > > this level of recovery, it will know the sector is bad, and write
> > > the
> > > entire sector
> > Where does the application find the data that was lost to be able to
> > rewrite it?
> =

> The data that was lost is gone -- this assumes the application has some
> ability to recover using a journal/log or other redundancy - yes, at the
> application layer. If it doesn't have this sort of capability, the only
> option is to restore files from a backup/mirror.

So the architecture has a built in assumption that only userspace
can handle data loss?

What about filesytsems like NOVA, that use log structured design to
provide DAX w/ update atomicity and can potentially also provide
redundancy/repair through the same mechanisms? Won't pmem native
filesystems with built in data protection features like this remove
the need for adding all this to userspace applications?

If so, shouldn't that be the focus of development rahter than
placing the burden on userspace apps to handle storage repair
situations?

> > > - Or it replaces the entire file from backup also using write() (not
> > > mmap+stores)
> > > =A0 =A0 * This just frees the fs block, and the next time the block is
> > > reallocated by the fs, it will likely be zeroed first, and that will
> > > be
> > > done through the driver and will clear errors
> > There's an implicit assumption that applications will keep redundant
> > copies of their data at the /application layer/ and be able to
> > automatically repair it? And then there's the implicit assumption
> > that it will unlink and free the entire file before writing a new
> > copy, and that then assumes the the filesystem will zero blocks if
> > they get reused to clear errors on that LBA sector mapping before
> > they are accessible again to userspace..
> > =

> > It seems to me that there are a number of assumptions being made
> > across multiple layers here. Maybe I've missed something - can you
> > point me to the design/architecture description so I can see how
> > "app does data recovery itself" dance is supposed to work?
> =

> There isn't a document other than the flow in my head :) - but maybe I
> could write one up..
> I wasn't thinking the application itself maintains and restores from
> backup copy of the file.. The application hits either a SIGBUS or EIO
> depending on how it accesses the data, and crashes or raises some alarm.
> The recovery is then done out-of-band, by a sysadmin or such (i.e.
> delete the file, replace with a known good copy, restart application).
> =

> To summarize, the two cases we want to handle are:
> 1. Application has inbuilt recovery:
> =A0 - hits badblock
> =A0 - figures out it is able to recover the data
> =A0 - handles SIGBUS or EIO
> =A0 - does a (sector aligned) write() to restore the data

The "figures out" step here is where >95% of the work we'd have to
do is. And that's in filesystem and block layer code, not
userspace, and userspace can't do that work in a signal handler.
And it  can still fall down to the second case when the application
doesn't have another copy of the data somewhere.

FWIW, we don't have a DAX enabled filesystem that can do
reverse block mapping, so we're a year or two away from this being a
workable production solution from the filesystem perspective. And
AFAICT, it's not even on the roadmap for dm/md layers.

> 2. Application doesn't have any inbuilt recovery mechanism
> =A0 - hits badblock
> =A0 - gets SIGBUS (or EIO) and crashes
> =A0 - Sysadmin restores file from backup

Which is no different to an existing non-DAX application getting an
EIO/sigbus from current storage technologies.

Except: in the existing storage stack, redundancy and correction has
already had to have failed for the application to see such an error.
Hence this is normally considered a DR case as there's had to be
cascading failures (e.g.  multiple disk failures in a RAID) to get
to this stage, not a single error in a single sector in
non-redundant storage.

We need some form of redundancy and correction in the PMEM stack to
prevent single sector errors from taking down services until an
administrator can correct the problem. I'm trying to understand
where this is supposed to fit into the picture - at this point I
really don't think userspace applications are going to be able to do
this reliably....

Cheers,

Dave.
-- =

Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
