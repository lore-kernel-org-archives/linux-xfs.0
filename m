Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C43767F50
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 17:45:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 45BC0AC001
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 15:45:48 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	MzTt9z7kEGXCrMIH for <xfs@oss.sgi.com>;
	Tue, 03 Sep 2013 15:45:46 -0700 (PDT)
Date: Wed, 4 Sep 2013 08:45:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] xfs: defrag support for v5 filesystems
Message-ID: <20130903224542.GH23571@dastard>
References: <1377822225-17621-1-git-send-email-david@fromorbit.com>
	<20130903191201.GL1935@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130903191201.GL1935@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Sep 03, 2013 at 02:12:01PM -0500, Ben Myers wrote:
> Hey Dave,
> 
> On Fri, Aug 30, 2013 at 10:23:43AM +1000, Dave Chinner wrote:
> > Hi folks,
> > 
> > The following 2 patches implement the BMBT owner change transaction
> > that is necessary to enable the XFS_IOC_SWAPEXT ioctl to operate on
> > v5 filesystems correctly. The first patch implements the
> > transactional runtime change, and the second patch implements the
> > recovery of that change.
> > 
> > Both the run time and recovery code use the same mechanism for
> > changing the owner field in all the blocks in the BMBT on an inode,
> > and even though XFS_IOC_SWAPEXT only swaps the data fork, the code
> > has been written to be fork neutral so if we even need to swap
> > attribute forks it should just work for that, too.
> > 
> > Further, because the BMBT code uses the generic btree
> > infrastructure, the btree modification is done as a generic function
> > as well and so should work for all types of btrees supported by the
> > generic code. Hence if the need arises we can easily change the
> > owner of any btree that uses the generic code.
> > 
> > The testing carried out is documented in the description of the
> > second patch.
> > 
> > AFAIA, this is the only remaining feature that the kernel v5
> > filesystem implementation didn't support. Hence, with this patchset,
> > there are no more feature checkboxes that need to be ticked that
> > would prevent us from removing the experimental tag from it. Testing
> > is the only remaining gate to removing the tag from the kernel
> > code...
> 
> I believe there is still the discussion surrounding being able to use
> the self describing metadata without enabling crcs that needs to be
> resolved before removing the experimental tag.

There is no discussion to be had here - CRCs are not optional on v5
filesystems, nor is there any reason to make them optional. Please
stop bring this up over and over again - you're just wasting my time
by making me have to respond with the same answers over and over
again.

If people don't want CRCs, then we've still got a perfectly good v4
filesystem format that they can use.

> Some customers will want
> to use features such as t10-dif and won't want to calculate two separate
> crcs. 

This is a straw man argument.

T10-dif is a completely different layer of protection that is only
useful for filesystem metadata if the CRC we calculate for the
metadata is written into the T10-DIF CRC fields. This is the only
way for us to get full end-to-end protection for metadata from
T10-dif. i.e. we have to supply the CRCs ourselves before we issue
the write IO, and verify it ourselves after a read IO.

Guess what we do right now with CRC support?

That's right: the existing CRC infrastructure is ready to support
integrated, end-to-end T10 CRCs for metadata in the filesystem. All
that is missing is the block layer interfaces and a few changes to
the CRC code to do iterative per-sector CRCs rather than
per-filesystem object CRCs. Surprise you, it may, but I've actually
considered how to implement T10-dif support as part of the overall
metadata CRC infrastructure architecture...

Given that with T10-dif we still need calculate and verify the
CRCs ourselves, why would we not also store it in the filesystem
metadata at the same time? That would mean that tools like
xfs_repair and xfs_db can also verify the metadata as being correct
without needing to explicitly support T10-dif. Of course, if you
want them to be able to repair or modify a filesystem with t10-dif
enabled, we need feature bits and explicit userspace support, too.

Hence, before making strawman arguments about how filesystem
metadata CRCs will need to be turned off for t10-dif support,
perhaps it would be better to first consider a design and prototype
support for end-to-end T10-dif CRCs for filesystem metadata and
share that with us?

As I've said before, we do not make on disk format changes for
strawmen or "potential" features that have not had design documents
or code published - we make the changes when code arrives to
implement the feature. So, until you have code for a feature that
*fundamentally requires* CRCs to be disabled to function correctly,
then the is not point even starting a discussion about making CRCs
optional on v5 superblocks.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
