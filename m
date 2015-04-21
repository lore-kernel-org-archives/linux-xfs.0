Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5262D7F4E
	for <xfs@oss.sgi.com>; Mon, 20 Apr 2015 23:28:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 24B58304043
	for <xfs@oss.sgi.com>; Mon, 20 Apr 2015 21:28:28 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id WlrMZHTJy9iBFrHQ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Apr 2015 21:28:25 -0700 (PDT)
Date: Mon, 20 Apr 2015 21:28:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: question re: xfs inode to inode copy implementation
Message-ID: <20150421042820.GA11601@birch.djwong.org>
References: <20150421010646.GX8110@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150421010646.GX8110@shells.gnugeneration.com>
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
To: xfs@pengaru.com, vito.caputo@coreos.com
Cc: xfs <xfs@oss.sgi.com>

On Mon, Apr 20, 2015 at 08:06:46PM -0500, xfs@pengaru.com wrote:
> Hello list,
> 
> I'm prototyping something like reflinks in xfs and was wondering if
> anyone could give me some pointers on the best way to duplicate the

Heh, funny, I'm working on that too...

> blocks of the shared inode at the reflink inode, the copy which must
> occur when breaking the link.

...though I'm not sure what "the shared inode at the reflink inode" means.
Are there somehow three inodes involved with reflinking one file to another?

> It would be nice to do the transfer via the page cache after allocating
> the space at the desintation inode, but it doesn't seem like I can use
> any of the kernel helpers for copying the data via the address_space
> structs since I don't have a struct file on hand for the copy source.
> I'm doing this in xfs_file_open() so the only struct file I have is the
> file being opened for writing - the destination of the copy.

So you're cloning the entire file's contents (i.e. breaking the reflink) as
soon as the file is opened rw?

> What I do have on hand is the shared inode and the destination inode
> opened and ready to go, and the struct file for the destination.

The design I'm pursuing is different from yours, I think -- two files can use
the regular bmbt to point to the same physical blocks, and there's a per-ag
btree that tracks reference counts for physical extents.  What I'd like to do
for the CoW operation is to clone the page (somehow), change the bmbt mapping
to "delayed allocation", and let the dirty pages flush out like normal.

I haven't figured out /how/ to do this, mind you.  The rest of the bookkeeping
parts are already written, though.

With reflink enabled, xfsrepair theoretically can solve multiply claimed blocks
by simply adding the appropriate agblock:refcount entry to the refcount btree
and it's done.

> My prototype already mostly works just using xfs_alloc_file_space() to
> allocate the appropriate space in the destination inode, but I need to
> get that allocated space populated from the shared inode's extents.

I think you're asking how to copy extent map entries from one file to another?

--D

> 
> Any pointers appreciated, thanks!
> 
> Regards,
> Vito Caputo
> 
> 
> P.S. I've seen Dave Chinner's mention of reflink prototypes in XFS on
> lwn but haven't been able to find any code, what's the status of that?
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
