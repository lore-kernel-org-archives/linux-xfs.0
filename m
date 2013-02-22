Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 980207F50
	for <xfs@oss.sgi.com>; Fri, 22 Feb 2013 10:17:14 -0600 (CST)
Date: Fri, 22 Feb 2013 10:17:13 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: inode64 superblock flag is still worth
Message-ID: <20130222161713.GV22182@sgi.com>
References: <20130222132721.GA10079@andromeda.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130222132721.GA10079@andromeda.usersys.redhat.com>
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
To: Carlos Maiolino <cmaiolino@redhat.com>
Cc: xfs@oss.sgi.com

Hi Carlos,

On Fri, Feb 22, 2013 at 10:27:21AM -0300, Carlos Maiolino wrote:
> I was looking the "Ideas for XFS" wiki page, and noticed a topic about the
> implementation of a flag in superblock to identify the filesystem is using
> 64-bit inodes. Once we use it by default now, is this idea still worth? I can
> work on it, but I don't think this is still worth to be implemented.
> If still looks worth, I'd suggest a flag set when 32-bit inodes only is used not
> 64, but I really dunno how this might be useful for kernel. From a user
> perspective, it might help, but `mount` command or mtab already shows inode32
> option when it's used.

So the inode32 allocation policy becomes persistent and no longer need to be
set at mount time.  This is definately worth working on, IMO.

Setting a bit in the superblock would work fine for inode32.  We should think
about something more general before making on-disk changes for this.  For
example, Rich recently posted the agskip data allocation policy which (like
inode32) was implemented as a mount option.  If agskip=5 were to be made
persistent we'd need space in the superblock to keep track of the 5.

I think an xattr on the root inode could be a good solution as long as it is
invisible to the user.  The interface for changing alloc policies should
probably be in xfs_io or xfs_mkfs.

-Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
