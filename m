Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 509717F6B
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 11:34:33 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D3519AC001
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 09:34:32 -0800 (PST)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id OsG6g5c3zatObCw0 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 09:34:30 -0800 (PST)
Date: Mon, 24 Nov 2014 18:34:30 +0100
From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
	write_time()
Message-ID: <20141124173430.GB26471@twin.jikos.cz>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-2-git-send-email-tytso@mit.edu>
	<20141124152101.GA12575@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141124152101.GA12575@infradead.org>
Reply-To: dsterba@suse.cz
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
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 24, 2014 at 07:21:01AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 21, 2014 at 02:59:21PM -0500, Theodore Ts'o wrote:
> > We needed to preserve update_time() because btrfs wants to have a
> > special btrfs_root_readonly() check; otherwise we could drop the
> > update_time() inode operation entirely.
> 
> Can't btrfs just set the immutable flag on every inode that is read
> when the root has the BTRFS_ROOT_SUBVOL_RDONLY flag? 

This would lead to change in return code from EROFS to EPERM/EACCESS for
all syscalls that do not pass through permissions() callback. Also, now
each file from a readonly subvol will show the 'i' attribute and there's
now way to determine if the file had had the 'i' attribute before it was
snapshotted.

> That would
> cut down the places that need this check to the ioctl path so that
> we prevent users from clearling the immutable flag.

This means that even the root or capable user are not able to clear the
flag.

Even though the extra btrfs_root_readonly checks are not all great, the
number of surprises that the immutable bit could bring is IMO not great
either.

These callbacks that now implement the extra check:

- update_time
- setattr
- setflags (ioctl)
- setxattr
- removexattr

The btrfs_root_readonly checks in setxattr and removexattr are
unnecessary because they're done through xattr_permisssion. I'll send a
patch to remove them.

'setflags' is an ioctl and all the checks have to be done there.
The generic permission() callback cannot be used here because it would
fail to clear eg. the immutable flag.

'setattr' does limited permission checks (IMMUTABLE and APPEND), nothing
that calls to the filesystem directly or indirectly.

The remaining one is 'update_time'. I'm not sure if the amount of work
the switch to IMUUTABLE bit would need is justified, compared to this
one instance of extra btrfs_root_readonly test. As the VFS layer has no
notion of subvolume it's not able to determine the RO/RW status without
asking the filesystem anyway.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
