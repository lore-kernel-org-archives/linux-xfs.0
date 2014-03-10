Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB6257F3F
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 15:46:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D09D68F8037
	for <xfs@oss.sgi.com>; Mon, 10 Mar 2014 13:46:56 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Xs2p4TrcxHjiJIY3 for <xfs@oss.sgi.com>;
	Mon, 10 Mar 2014 13:46:52 -0700 (PDT)
Date: Tue, 11 Mar 2014 07:46:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Multi-CPU harmless lockdep on x86 while copying data
Message-ID: <20140310204647.GW6851@dastard>
References: <531BD8B9.1090400@gmail.com> <20140310025523.GV6851@dastard>
	<20140310103716.GA1431@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140310103716.GA1431@infradead.org>
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
Cc: "Michael L. Semon" <mlsemon35@gmail.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Mar 10, 2014 at 03:37:16AM -0700, Christoph Hellwig wrote:
> On Mon, Mar 10, 2014 at 01:55:23PM +1100, Dave Chinner wrote:
> > Changing the directory code to handle this sort of locking is going
> > to require a bit of surgery. However, I can see advantages to moving
> > directory data to the same locking strategy as regular file data -
> > locking heirarchies are identical, directory ilock hold times are
> > much reduced, we don't get lockdep whining about taking page faults
> > with the ilock held, etc.
> > 
> > A quick hack at to demonstrate the high level, initial step of using
> > the IOLOCK for readdir serialisation. I've done a little smoke
> > testing on it, so it won't die immediately. It should get rid of all
> > the nasty lockdep issues, but it doesn't start to address the deeper
> > restructing that is needed.
> 
> What synchronization do we actually need from the iolock?  Pushing the
> ilock down to where it's actually needed is a good idea either way,
> though.

The issue is that if we push the ilock down to the just the block
mapping routines, the directory can be modified while the readdir is
in progress. That's the root problem that adding the ilock solved.
Now, just pushing the ilock down to protect the bmbt lookups might
result in a consistent lookup, but it won't serialise sanely against
modifications.

i.e. readdir only walks one dir block at a time but
it maps multiple blocks for readahead and keeps them in a local
array and doesn't validate them again before issuing read o nthose
buffers. Hence at a high level we currently have to serialise
readdir against all directory modifications.

The only other option we might have is to completely rewrite the
directory readahead code not to cache mappings. If we use the ilock
purely for bmbt lookup and buffer read, then the ilock will
serialise against modification, and the buffer lock will stabilise
the buffer until the readdir moves to the next buffer and picks the
ilock up again to read it.

That would avoid the need for high level serialisation, but it's a
lot more work than using the iolock to provide the high level
serialisation and i'm still not sure it's 100% safe. And I've got no
idea if it would work for CXFS. Hopefully someone from SGI will
chime in here....

> > This would be a straight forward change, except for two things:
> > filestreams and lockdep. The filestream allocator takes the
> > directory iolock and makes assumptions about parent->child locking
> > order of the iolock which will now be invalidated. Hence some
> > changes to the filestreams code is needed to ensure that it never
> > blocks on directory iolocks and deadlocks. instead it needs to fail
> > stream associations when such problems occur.
> 
> I think the right fix is to stop abusing the iolock in filestreams.
> To me it seems like a look inside fstrm_item_t should be fine
> for what the filestreams code wants if I understand it correctly.
> 
> From looking over some of the filestreams code just for a few minutes
> I get an urge to redo lots of it right now..

I get that urge from time to time, too. So far I've managed to avoid
it.

> > @@ -1228,7 +1244,7 @@ xfs_create(
> >  	 * the transaction cancel unlocking dp so don't do it explicitly in the
> >  	 * error path.
> >  	 */
> > -	xfs_trans_ijoin(tp, dp, XFS_ILOCK_EXCL);
> > +	xfs_trans_ijoin(tp, dp, XFS_IOLOCK_EXCL | XFS_ILOCK_EXCL);
> 
> What do we need the iolock on these operations for?

These are providing the high level readdir vs modification
serialisation protection. And we have to unlock it on transaction
commit, which is why it needs to be added to the xfs_trans_ijoin()
calls...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
