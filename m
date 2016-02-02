Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 547227CB0
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 17:19:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D88B5AC004
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2016 15:19:45 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id SfoMULraO9o5zbJk (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2016 15:19:42 -0800 (PST)
Date: Tue, 2 Feb 2016 23:19:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] dax: allow DAX to look up an inode's block device
Message-ID: <20160202231931.GR17997@ZenIV.linux.org.uk>
References: <1454454702-11889-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1454454702-11889-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, "J. Bruce Fields" <bfields@fieldses.org>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>

On Tue, Feb 02, 2016 at 04:11:42PM -0700, Ross Zwisler wrote:

> However, for raw block devices and for XFS with a real-time device, the
> value in inode->i_sb->s_bdev is not correct.  With the code as it is
> currently written, an fsync or msync to a DAX enabled raw block device will
> cause a NULL pointer dereference kernel BUG.  For this to work correctly we
> need to ask the block device or filesystem what struct block_device is
> appropriate for our inode.
> 
> To that end, add a get_bdev(struct inode *) entry point to struct
> super_operations.  If this function pointer is non-NULL, this notifies DAX
> that it needs to use it to look up the correct block_device.  If
> i_sb->get_bdev() is NULL DAX will default to inode->i_sb->s_bdev.

Umm...  It assumes that bdev will stay pinned for as long as inode is
referenced, presumably?  If so, that needs to be documented (and verified
for existing fs instances).  In principle, multi-disk fs might want to
support things like "silently move the inodes backed by that disk to other
ones"...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
