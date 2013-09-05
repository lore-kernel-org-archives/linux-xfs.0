Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BC1A77F50
	for <xfs@oss.sgi.com>; Thu,  5 Sep 2013 14:34:32 -0500 (CDT)
Date: Thu, 5 Sep 2013 14:34:28 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/2] xfs: defrag support for v5 filesystems
Message-ID: <20130905193428.GP1935@sgi.com>
References: <1377822225-17621-1-git-send-email-david@fromorbit.com>
	<20130903191201.GL1935@sgi.com> <20130903224542.GH23571@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130903224542.GH23571@dastard>
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

Dave,

On Wed, Sep 04, 2013 at 08:45:42AM +1000, Dave Chinner wrote:
> On Tue, Sep 03, 2013 at 02:12:01PM -0500, Ben Myers wrote:
> > Hey Dave,
> > 
> > On Fri, Aug 30, 2013 at 10:23:43AM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > The following 2 patches implement the BMBT owner change transaction
> > > that is necessary to enable the XFS_IOC_SWAPEXT ioctl to operate on
> > > v5 filesystems correctly. The first patch implements the
> > > transactional runtime change, and the second patch implements the
> > > recovery of that change.
> > > 
> > > Both the run time and recovery code use the same mechanism for
> > > changing the owner field in all the blocks in the BMBT on an inode,
> > > and even though XFS_IOC_SWAPEXT only swaps the data fork, the code
> > > has been written to be fork neutral so if we even need to swap
> > > attribute forks it should just work for that, too.
> > > 
> > > Further, because the BMBT code uses the generic btree
> > > infrastructure, the btree modification is done as a generic function
> > > as well and so should work for all types of btrees supported by the
> > > generic code. Hence if the need arises we can easily change the
> > > owner of any btree that uses the generic code.
> > > 
> > > The testing carried out is documented in the description of the
> > > second patch.
> > > 
> > > AFAIA, this is the only remaining feature that the kernel v5
> > > filesystem implementation didn't support. Hence, with this patchset,
> > > there are no more feature checkboxes that need to be ticked that
> > > would prevent us from removing the experimental tag from it. Testing
> > > is the only remaining gate to removing the tag from the kernel
> > > code...
> > 
> > I believe there is still the discussion surrounding being able to use
> > the self describing metadata without enabling crcs that needs to be
> > resolved before removing the experimental tag.
> 
> There is no discussion to be had here - CRCs are not optional on v5
> filesystems, nor is there any reason to make them optional. Please
> stop bring this up over and over again - you're just wasting my time
> by making me have to respond with the same answers over and over
> again.

There is a discussion to be had here, and I'm sorry that you feel I'm wasting
your time.  I do feel that we need to get this sorted before removing the
experimental tag due to the possibility of needing to change interfaces to make
it work.

> If people don't want CRCs, then we've still got a perfectly good v4
> filesystem format that they can use.

People can still use v4 filesystem format, but the self describing metadata
includes checks that have value even without the crc.

> > Some customers will want
> > to use features such as t10-dif and won't want to calculate two separate
> > crcs. 
> 
> This is a straw man argument.

Read:  http://en.wikipedia.org/wiki/Straw_man

AFAICT at no time in my email did I misrepresent or even attempt to represent
your position on this issue.  Seems to me that I represented only my position
on the issue, and what I think customers will want.  Maybe you can find a
different fallacy in there but I don't think it's a straw man.

> T10-dif is a completely different layer of protection that is only
> useful for filesystem metadata if the CRC we calculate for the
> metadata is written into the T10-DIF CRC fields. This is the only
> way for us to get full end-to-end protection for metadata from
> T10-dif. i.e. we have to supply the CRCs ourselves before we issue
> the write IO, and verify it ourselves after a read IO.

I think of T10-dif as a superset of what you've implemented already, as opposed
to a completely different layer of protection.  Keeping a crc within the
filesystem metadata is useful, and I'm pretty sure we all agree on that.
However, today that crc cannot be checked in hardware as it goes across the
wire to and from the disk, because 1) the disk doesn't know about the length of
the structure protected by the crc, or the location of the crc in the
structure, and 2) the disk doesn't support the crc32c, it supports only a 16
bit t10-dif crc per sector.

> Guess what we do right now with CRC support?
> 
> That's right: the existing CRC infrastructure is ready to support
> integrated, end-to-end T10 CRCs for metadata in the filesystem. All
> that is missing is the block layer interfaces and a few changes to
> the CRC code to do iterative per-sector CRCs rather than
> per-filesystem object CRCs.

Yes!  This is exactly what I would like to discuss.

> Surprise you, it may, but I've actually
> considered how to implement T10-dif support as part of the overall
> metadata CRC infrastructure architecture...

Great, sounds we are thinking along the same lines.
 
> Given that with T10-dif we still need calculate and verify the
> CRCs ourselves, why would we not also store it in the filesystem
> metadata at the same time?

The reason we would not also want to store the crc32c in the filesystem
metadata itself is that the cost of calculating crc32c in addition to t10-dif
is redundant if you are already using t10-dif.  The disk cannot use crc32c, so
I'm trying to think like a customer, and it seems to me that a customer will
probably want to be able to turn off the crc32c you have implemented if he/she
is already using an alternate form of protection.  It's belt and suspenders.

> That would mean that tools like
> xfs_repair and xfs_db can also verify the metadata as being correct
> without needing to explicitly support T10-dif.

Right.  Userspace wouldn't necessarily have to explicitly support t10-dif,
given that today the block layer will do it for them.

> Of course, if you
> want them to be able to repair or modify a filesystem with t10-dif
> enabled, we need feature bits and explicit userspace support, too.

I think whether userspace needs explicit support depends upon the behavior of
the block layer when an error is found.  IIRC today it just retries several
times before giving up and you get EIO.  Not sure how well that information can
be used by userspace at this point.

> Hence, before making strawman arguments about how filesystem
> metadata CRCs will need to be turned off for t10-dif support,

AFAICT my assertion that your crc32c should be optional was not a straw man.
It comes as a consequence of it not being usable for t10-dif, and therefore
redundant.

> perhaps it would be better to first consider a design and prototype
> support for end-to-end T10-dif CRCs for filesystem metadata and
> share that with us?

A great idea.  I'll shop it around.
 
> As I've said before, we do not make on disk format changes for
> strawmen or "potential" features that have not had design documents
> or code published - we make the changes when code arrives to
> implement the feature.

Nah, we think further ahead than that.  When I need to move my rook across the
board I don't first put a knight in it's path.

> So, until you have code for a feature that
> *fundamentally requires* CRCs to be disabled to function correctly,
> then the is not point even starting a discussion about making CRCs
> optional on v5 superblocks.

'Fundamentally requires' is not the bar to pass for starting a discussion on
this list.  Customers will likely want to be able to disable crc32c in metadata
when they are using an alternate form of data protection.  That is enough to go
on for starting a discussion.  Insofar as supporting such a feature might
require interface changes to the existing work, I think we should discuss what
they might look like before finalizing the mkfs.xfs interfaces in a way that we
might find to be incompatible later.  If after some discussion we find that
this can be done without interface changes that will gate removal of the
experimental tag... then it won't gate.

Regards,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
