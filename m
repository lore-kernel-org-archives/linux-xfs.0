Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 697CB7F3F
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2015 04:08:40 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 483F8304051
	for <xfs@oss.sgi.com>; Wed, 14 Jan 2015 02:08:37 -0800 (PST)
Received: from newverein.lst.de (verein.lst.de [213.95.11.211]) by
	cuda.sgi.com with ESMTP id y9dGSapojeThJY3P (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 14 Jan 2015 02:08:31 -0800 (PST)
Date: Wed, 14 Jan 2015 11:08:27 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 17/18] xfs: implement pnfs export operations
Message-ID: <20150114100827.GA11788@lst.de>
References: <1420561721-9150-1-git-send-email-hch@lst.de>
	<1420561721-9150-18-git-send-email-hch@lst.de>
	<20150107002434.GG31508@dastard> <20150107104010.GD28783@lst.de>
	<20150107211140.GC25000@dastard> <20150108124327.GA15222@lst.de>
	<20150108210405.GG25000@dastard> <20150109114159.GA25728@lst.de>
	<20150112030401.GA29484@destitution>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150112030401.GA29484@destitution>
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
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@primarydata.com>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On Mon, Jan 12, 2015 at 02:04:01PM +1100, Dave Chinner wrote:
> Ok, so:
> 
> client				server
> 
> get layout
> dev id == 0
> 				grow
> 				gen++ (=1)
> 				crash
> 				....
> 				gen = 0 (initialised after boot)
> 
> commit layout
> dev id == 0
> 				server executes op, even though
> 				device has changed....
> 
> What prevents this? Shouldn't the server be rejecting the commit
> layout operation as there was a grow operation between the client
> operations?

There is no need to reject the commit.  Grows for the block layout
driver never invalidate existing layouts, as they are purely grow
operation.  The only reason to bother with the generation is
to ensure that new layouts might point into areas the client
didn't previously known about.  So the interesting variation of your
scenario above is:

client				server

				grow
 				gen++ (=1)

get layout
dev id == (x, 1)
 				crash
 				....
 				gen = 0 (initialised after boot)
 
commit layout
id == 1

Which will be rejected, and the client either choses to get a
new layout / deviceID, or just writes the data back through normal
I/O.

Now one interesting case would be a resize that completed in
memory, gets a layout refering to it send out, but not commited to disk,
and then anothe resize to a smaller size before the commit.  Not
really practical, but if it happend we could get writes beyond the
end of the filesystem.

I didn't assume this was possible as I assumed growfs to be synchronous,
but it turns out while we do various synchronous buffer writes the
transaction isn't actually commited synchronously.

I think we should just make growfs commit the transaction
synchronously to avoid both the pnfs problem, as well as the
problem of growfs potentially updating the secondary superblocks
before the transaction hit the disk.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
