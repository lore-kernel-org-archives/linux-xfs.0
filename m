Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EEABF7F72
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 09:57:33 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CE80130407E
	for <xfs@oss.sgi.com>; Mon, 24 Nov 2014 07:57:30 -0800 (PST)
Received: from imap.thunk.org (imap.thunk.org [74.207.234.97]) by cuda.sgi.com
	with ESMTP id RIgJqOXitk3qG0oD (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 24 Nov 2014 07:57:29 -0800 (PST)
Date: Mon, 24 Nov 2014 10:56:58 -0500
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/4] fs: split update_time() into update_time() and
	write_time()
Message-ID: <20141124155658.GA31339@thunk.org>
References: <1416599964-21892-1-git-send-email-tytso@mit.edu>
	<1416599964-21892-2-git-send-email-tytso@mit.edu>
	<20141124152101.GA12575@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20141124152101.GA12575@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Mon, Nov 24, 2014 at 07:21:01AM -0800, Christoph Hellwig wrote:
> On Fri, Nov 21, 2014 at 02:59:21PM -0500, Theodore Ts'o wrote:
> > We needed to preserve update_time() because btrfs wants to have a
> > special btrfs_root_readonly() check; otherwise we could drop the
> > update_time() inode operation entirely.
> 
> Can't btrfs just set the immutable flag on every inode that is read
> when the root has the BTRFS_ROOT_SUBVOL_RDONLY flag?  That would
> cut down the places that need this check to the ioctl path so that
> we prevent users from clearling the immutable flag.

Sounds like a good plan to me, although I'm not sure I understand how
BTRFS_ROOT_SUBVOL_RDONLY flag works, since I would have thought there
are all sorts of places in the VFS layer where it is currently
checking MS_RDONLY and MNT_READONLY and _not_ checking
BTRFS_ROOT_SUBVOL_RDONLY isn't causing other problems.

But unless there's something more subtle going on, it would seem to me
that setting the immutable flag on each inode would be a better way to
go in any case.

					- Ted

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
