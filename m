Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A52D67F51
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 19:34:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31CF6AC006
	for <xfs@oss.sgi.com>; Sun, 11 Aug 2013 17:34:06 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	Bo62OOhFD9vxBAbo for <xfs@oss.sgi.com>;
	Sun, 11 Aug 2013 17:34:04 -0700 (PDT)
Date: Mon, 12 Aug 2013 10:33:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: ***** SUSPECTED SPAM ***** Re: [PATCH 47/49] xfs: Add read-only
	support for dirent filetype field
Message-ID: <20130812003337.GJ12779@dastard>
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-48-git-send-email-david@fromorbit.com>
	<52016716.3080807@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52016716.3080807@sgi.com>
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
To: Mark Tinguely <tinguely@sgi.com>
Cc: xfs@oss.sgi.com

On Tue, Aug 06, 2013 at 04:13:58PM -0500, Mark Tinguely wrote:
> On 07/19/13 01:45, Dave Chinner wrote:
> >From: Dave Chinner<dchinner@redhat.com>
> >
> >Add support for the file type field in directory entries so that
> >readdir can return the type of the inode the dirent points to to
> >userspace without first having to read the inode off disk.
> >
> >The encoding of the type field is a single byte that is added to the
> >end of the directory entry name length. For all intents and
> >purposes, it appends a "hidden" byte to the name field which
> >contains the type information. As the directory entry is already of
> >dynamic size, helpers are already required to access and decode the
> >direct entry structures.
> >
> >Hence the relevent extraction and iteration helpers are updated to
> >understand the hidden byte.  Helpers for reading and writing the
> >filetype field from the directory entries are also added. Only the
> >read helpers are used by this patch.  It also adds all the code
> >necessary to read the type information out of the dirents on disk.
> >
> >Further we add the superblock feature bit and helpers to indicate
> >that we understand the on-disk format change. This is not a
> >compatible change - existing kernels cannot read the new format
> >successfully - so an incompatible feature flag is added. We don't
> >yet allow filesystems to mount with this flag yet - that will be
> >added once write support is added.
> >
> >Finally, the code to take the type from the VFS, convert it to an
> >XFS on-disk type and put it into the xfs_name structures passed
> >around is added, but the directory code does not use this field yet.
> >That will be in the next patch.
> >
> >Signed-off-by: Dave Chinner<dchinner@redhat.com>
> >---
> 
> Same as kernel patch (48/49) - written to support only v3 inodes. This
> should support v2 and v3 inodes.

It's a directory entry format change - it has nothing to do with the
version of the inode.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
