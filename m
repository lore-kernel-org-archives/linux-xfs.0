Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 50F607F5A
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 18:57:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 401C330404E
	for <xfs@oss.sgi.com>; Tue,  1 Dec 2015 16:57:45 -0800 (PST)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	rWlpHSa1gaEo3kTe for <xfs@oss.sgi.com>;
	Tue, 01 Dec 2015 16:57:41 -0800 (PST)
Date: Wed, 2 Dec 2015 11:57:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: sleeps and waits during io_submit
Message-ID: <20151202005728.GG19199@dastard>
References: <565DA784.5080003@scylladb.com>
	<20151201145631.GD26129@bfoster.bfoster>
	<565DBB3E.2010308@scylladb.com>
	<20151201160133.GE26129@bfoster.bfoster>
	<565DC613.4090608@scylladb.com>
	<20151201162958.GF26129@bfoster.bfoster>
	<565DD449.5090101@scylladb.com>
	<20151201185113.GG26129@bfoster.bfoster>
	<565DF472.8080101@scylladb.com>
	<20151202001329.GA9633@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151202001329.GA9633@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Avi Kivity <avi@scylladb.com>, Glauber Costa <glauber@scylladb.com>, xfs@oss.sgi.com

On Tue, Dec 01, 2015 at 07:13:29PM -0500, Brian Foster wrote:
> On Tue, Dec 01, 2015 at 09:26:42PM +0200, Avi Kivity wrote:
> > On 12/01/2015 08:51 PM, Brian Foster wrote:
> > >On Tue, Dec 01, 2015 at 07:09:29PM +0200, Avi Kivity wrote:
> > >Nope, it's synchronous from a code perspective. The
> > >xfs_bmapi_read()->xfs_iread_extents() path could have to read in the
> > >inode bmap metadata if it hasn't been done already. Note that this
> > >should only happen once as everything is stored in-core, so in most
> > >cases this is skipped. It's also possible extents are read in via some
> > >other path/operation on the inode before an async I/O happens to be
> > >submitted (e.g., see some of the other xfs_bmapi_read() callers).
> > 
> > Is there (could we add) some ioctl to prime this cache?  We could call it
> > from a worker thread where we don't mind blocking during open.
> > 
> 
> I suppose that's possible, or the worker thread could perform some
> existing operation known to prime the cache. I don't think it's worth
> getting into without a concrete example, however.

You mean like EXT4_IOC_PRECACHE_EXTENTS?

You know, that ioctl that the ext4 googlers needed to add because
they already had AIO applications that depend on it and they hadn't
realised that the could do exactly the same thing with a FIEMAP
call? i.e. this call to count the number of extents in the file:

	struct fiemap fm = {
		.offset = 0,
		.length = FIEMAP_MAX_OFFSET,
	};

	res = ioctl(fd, FS_IOC_FIEMAP, &fm);

will cause XFS to read in the extent map and cache it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
