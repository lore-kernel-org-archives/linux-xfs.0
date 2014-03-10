Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 74B4E7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 17:10:06 -0500 (CDT)
Date: Mon, 10 Mar 2014 17:10:02 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Multi-CPU harmless lockdep on x86 while copying data
Message-ID: <20140310221002.GE26064@sgi.com>
References: <531BD8B9.1090400@gmail.com> <20140310025523.GV6851@dastard>
	<20140310103716.GA1431@infradead.org>
	<20140310204647.GW6851@dastard> <20140310211658.GT1935@sgi.com>
	<20140310212430.GB6851@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140310212430.GB6851@dastard>
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
Cc: Christoph Hellwig <hch@infradead.org>, "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Mar 11, 2014 at 08:24:30AM +1100, Dave Chinner wrote:
> On Mon, Mar 10, 2014 at 04:16:58PM -0500, Ben Myers wrote:
> > Hi,
> > 
> > On Tue, Mar 11, 2014 at 07:46:47AM +1100, Dave Chinner wrote:
> > > On Mon, Mar 10, 2014 at 03:37:16AM -0700, Christoph Hellwig wrote:
> > > > On Mon, Mar 10, 2014 at 01:55:23PM +1100, Dave Chinner wrote:
> > > > > Changing the directory code to handle this sort of locking is going
> > > > > to require a bit of surgery. However, I can see advantages to moving
> > > > > directory data to the same locking strategy as regular file data -
> > > > > locking heirarchies are identical, directory ilock hold times are
> > > > > much reduced, we don't get lockdep whining about taking page faults
> > > > > with the ilock held, etc.
> > > > > 
> > > > > A quick hack at to demonstrate the high level, initial step of using
> > > > > the IOLOCK for readdir serialisation. I've done a little smoke
> > > > > testing on it, so it won't die immediately. It should get rid of all
> > > > > the nasty lockdep issues, but it doesn't start to address the deeper
> > > > > restructing that is needed.
> > > > 
> > > > What synchronization do we actually need from the iolock?  Pushing the
> > > > ilock down to where it's actually needed is a good idea either way,
> > > > though.
> > > 
> > > The issue is that if we push the ilock down to the just the block
> > > mapping routines, the directory can be modified while the readdir is
> > > in progress. That's the root problem that adding the ilock solved.
> > > Now, just pushing the ilock down to protect the bmbt lookups might
> > > result in a consistent lookup, but it won't serialise sanely against
> > > modifications.
> > > 
> > > i.e. readdir only walks one dir block at a time but
> > > it maps multiple blocks for readahead and keeps them in a local
> > > array and doesn't validate them again before issuing read o nthose
> > > buffers. Hence at a high level we currently have to serialise
> > > readdir against all directory modifications.
> > > 
> > > The only other option we might have is to completely rewrite the
> > > directory readahead code not to cache mappings. If we use the ilock
> > > purely for bmbt lookup and buffer read, then the ilock will
> > > serialise against modification, and the buffer lock will stabilise
> > > the buffer until the readdir moves to the next buffer and picks the
> > > ilock up again to read it.
> > > 
> > > That would avoid the need for high level serialisation, but it's a
> > > lot more work than using the iolock to provide the high level
> > > serialisation and i'm still not sure it's 100% safe. And I've got no
> > > idea if it would work for CXFS. Hopefully someone from SGI will
> > > chime in here....
> > 
> > Also in leaf and node formats a single modification can change multiple
> > buffers, so I suspect the buffer lock isn't enough serialization to maintain a
> > consistent directory in the face of multiple readers and writers.  The iolock
> > does resolve that issue.
> 
> Right, but we don't care about anything other than the leaf block
> that we are currently reading is consistent when the read starts and
> is consistent across the entire processing. i.e. if the leaf is locked by
> readdir, then the modification is completely stalled until the
> readdir lets it go. And readdir then can't get the next buffer until
> the modification is complete because it blocks on the ilock to get
> the next mapping and buffer....

As long as [you pointed out above] the readahead buffers aren't cached, and all
of the callers who do require that data/freeindex/node/leaf blocks be
consistent continue to take the ilock...  Yeah, I think that might work.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
