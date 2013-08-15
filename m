Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id AD3E37F51
	for <xfs@oss.sgi.com>; Thu, 15 Aug 2013 17:40:30 -0500 (CDT)
Date: Thu, 15 Aug 2013 17:40:29 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 48/49] xfs: Add read-only support for dirent filetype field
Message-ID: <20130815224029.GO12719@sgi.com>
References: <1374215120-7271-1-git-send-email-david@fromorbit.com>
	<1374215120-7271-49-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1374215120-7271-49-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com
Cc: Mark Tinguely <tinguely@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, Christoph Hellwig <hch@infradead.org>, Ric Wheeler <rwheeler@redhat.com>

Hey Gents,

On Fri, Jul 19, 2013 at 04:25:19PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Add support for the file type field in directory entries so that
> readdir can return the type of the inode the dirent points to to
> userspace without first having to read the inode off disk.
> 
> The encoding of the type field is a single byte that is added to the
> end of the directory entry name length. For all intents and
> purposes, it appends a "hidden" byte to the name field which
> contains the type information. As the directory entry is already of
> dynamic size, helpers are already required to access and decode the
> direct entry structures.
> 
> Hence the relevent extraction and iteration helpers are updated to
> understand the hidden byte.  Helpers for reading and writing the
> filetype field from the directory entries are also added. Only the
> read helpers are used by this patch.  It also adds all the code
> necessary to read the type information out of the dirents on disk.
> 
> Further we add the superblock feature bit and helpers to indicate
> that we understand the on-disk format change. This is not a
> compatible change - existing kernels cannot read the new format
> successfully - so an incompatible feature flag is added. We don't
> yet allow filesystems to mount with this flag yet - that will be
> added once write support is added.
> 
> Finally, the code to take the type from the VFS, convert it to an
> XFS on-disk type and put it into the xfs_name structures passed
> around is added, but the directory code does not use this field yet.
> That will be in the next patch.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

After some discussion during our weekly call I believe we have come to an
agreement regarding this feature.  I wrote some things down:

* Eric volunteered to do an xfstest
* xfs_repair, Dave said he was working on this
* v4 support in the kernel to be done by Mark
* v4 support for mkfs.xfs to be done by Mark
* Plan for 3.13

With uncharacteristic promptness I have posted 'full' meeting notes here:

http://www.xfs.org/index.php/Meeting_notes_for_2013#Meeting_of_Aug_15

With that I hope that we can move on and put the flames to rest for awhile.  At
this point I believe the rest of this series is all applied.  I'll push patch
50 tomorrow.  We'll be pulling in work from Chandra, Dwight, and Zwu shortly.
Thanks to Eric for playing the Ambassador.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
