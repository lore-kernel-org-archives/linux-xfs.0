Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 754177F37
	for <xfs@oss.sgi.com>; Tue,  6 Aug 2013 16:13:59 -0500 (CDT)
Message-ID: <52016716.3080807@sgi.com>
Date: Tue, 06 Aug 2013 16:13:58 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 47/49] xfs: Add read-only support for dirent filetype field
References: <1374216324-8781-1-git-send-email-david@fromorbit.com>
	<1374216324-8781-48-git-send-email-david@fromorbit.com>
In-Reply-To: <1374216324-8781-48-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 07/19/13 01:45, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
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
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---

Same as kernel patch (48/49) - written to support only v3 inodes. This
should support v2 and v3 inodes.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
