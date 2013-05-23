Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3A86F7F37
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 18:35:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BDBD4AC002
	for <xfs@oss.sgi.com>; Thu, 23 May 2013 16:35:28 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	jVhuf9zhCwnSLeyz for <xfs@oss.sgi.com>;
	Thu, 23 May 2013 16:35:26 -0700 (PDT)
Date: Fri, 24 May 2013 09:35:01 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 09/11] xfs: rework remote attr CRCs
Message-ID: <20130523233501.GE24543@dastard>
References: <1369123330-9579-1-git-send-email-david@fromorbit.com>
	<1369123330-9579-10-git-send-email-david@fromorbit.com>
	<20130523215405.GT20028@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130523215405.GT20028@sgi.com>
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

On Thu, May 23, 2013 at 04:54:05PM -0500, Ben Myers wrote:
> Hi Dave,
> 
> On Tue, May 21, 2013 at 06:02:08PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Note: this changes the on-disk remote attribute format. I assert
> > that this is OK to do as CRCs are marked experimental and the first
> > kernel it is included in has not yet reached release yet. Further,
> > the userspace utilities are still evolving and so anyone using this
> > stuff right now is a developer or tester using volatile filesystems
> > for testing this feature. Hence changing the format right now to
> > save longer term pain is the right thing to do.
> 
> I have no objection to changing the on-disk format for an experimental feature
> even after it has released.  People know what they're signing up for when
> they're turning on experimental features.  Or they soon will.  We should
> probably be nice and use feature bits though.  I'm thinking about the unlinked
> list modifications...
> 
> > The fundamental change is to move from a header per extent in the
> > attribute to a header per filesytem block in the attribute. This
> > means there are more header blocks and the parsing of the attribute
> > data is slightly more complex, but it has the advantage that we
> > always know the size of the attribute on disk based on the length of
> > the data it contains.
> > 
> > This is where the header-per-extent method has problems. We don't
> > know the size of the attribute on disk without first knowing how
> > many extents are used to hold it. And we can't tell from a
> > mapping lookup, either, because remote attributes can be allocated
> > contiguously with other attribute blocks and so there is no obvious
> > way of determining the actual size of the atribute on disk short of
> > walking and mapping buffers.
> 
> You can't tell exactly how many extents will be required to store the attribute
> until after they've been allocated.  At least... not until you're down to
> trying to allocate the last block.
> 
> > The problem with this approach is that if we map a buffer
> > incorrectly (e.g. we make the last buffer for the attribute data too
> > long), we then get buffer cache lookup failure when we map it
> > correctly. i.e. we get a size mismatch on lookup.
> 
> Ah.  The resulting block count of a fragmented remote attribute is not
> reflected in 'valuelen' in the remote attribute entry, so the number of headers
> to account for is unknown.
> 
> typedef struct xfs_attr_leaf_name_remote {
> 	__be32  valueblk;               /* block number of value bytes */
> 	__be32  valuelen;               /* number of bytes in value */
> 	__u8    namelen;                /* length of name bytes */
> 	__u8    name[1];                /* name bytes */
>  } xfs_attr_leaf_name_remote_t;
> 
> Other options:
> 
> valuelen could be changed to a block count.  Now that you have offset and
> payload length in the header you can get valuelen from there on the last
> extent.

Which is an on-disk format change.

If valuelen is stored a block count, how do you know how long the
attribute data is in bytes? You don't - it's not stored on disk
anymore in the the attribute entry. How do you return the length
of the attribute to userspace on a lookup without now having to read
the data blocks directly?

> valuelen could be split in two, half is the block count and the other half is
> the payload length in the last extent.

Also an on disk format change. And it doesn't solve the problem, as
you still can't work out the attribute data length because you don't
know how many extents (and therefore headers) make up that block
count.

And both of these mean that all the remote attr code needs to handle
the remote attribute data length information differently. i.e.
Handle one type of indexing for existing filesystems and a different
type of indexing for v5 superblocks. 

It just adds more complexity to what is already complex and fragile.

> > This is not
> > necessarily fatal, but it's a cache coherency problem that can lead
> > to returning the wrong data to userspace or writing the wrong data
> > to disk. And debug kernels will assert fail if this occurs.
> 
> What data was being exposed?  The data after the attribute?  I thought testing
> for valuelen would take care of that.

Stale data. e.g. we do an attribute write and get a buffer
length of 16 blocks at bno X. we then do an attribute read, and get
a length of 8 blocks at bno X because we've failed to calculate the
length correctly.

A debug kernel will assert fail in _xfs_buf_find here because of the
length mismatch. A production kernel may fail to find a match, and
if it does fail, then we'll read from bno X to fill the buffer. So
what is returned is not attribute data but whatever stale data is on
disk at bno X....

> > +	ASSERT(len >= XFS_LBSIZE(mp));
> > +
> > +	while (len > 0 && *valuelen > 0) {
> > +		int hdr_size;
> > +		int byte_cnt = XFS_ATTR3_RMT_BUF_SPACE(mp, XFS_LBSIZE(mp));
> > +
> > +		byte_cnt = min(*valuelen, byte_cnt);
> 			   ^^^
> 
> You used 'min_t(int,...)' above and min() here.  Any reason?

Both are of the same type, so min is appropriate. I'll fix it up.

> > -	xfs_mount_t *mp;
> > -	xfs_bmbt_irec_t map;
> > -	xfs_buf_t *bp;
> > -	xfs_daddr_t dblkno;
> > -	xfs_dablk_t lblkno;
> > -	int valuelen, blkcnt, nmap, error, done, committed;
> > +	struct xfs_mount	*mp = args->dp->i_mount;
> > +	xfs_dablk_t		lblkno;
> > +	int			blkcnt;
> > +	int			error;
> > +	int			done;
> >  
> >  	trace_xfs_attr_rmtval_remove(args);
> >  
> > -	mp = args->dp->i_mount;
> > -
> >  	/*
> >  	 * Roll through the "value", invalidating the attribute value's blocks.
> >  	 * Note that args->rmtblkcnt is the minimum number of data blocks we'll
> 
> I believe this comment is now out of date and needs to be updated.

Yup, good catch. Will fix.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
