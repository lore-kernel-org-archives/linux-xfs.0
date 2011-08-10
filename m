Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7AGhHUf198137 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 11:43:18 -0500
Date: Wed, 10 Aug 2011 12:43:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 1/2] xfstests: make more tests generic
Message-ID: <20110810164314.GA2308@infradead.org>
References: <cover.1312193821.git.sbehrens@giantdisaster.de>
	<c9703ec698de4de685eb6822773d3934452b8334.1312193821.git.sbehrens@giantdisaster.de>
	<20110810155214.GE20461@twin.jikos.cz>
	<1312994169.2865.41.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312994169.2865.41.camel@doink>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Alex Elder <aelder@sgi.com>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>, dave@jikos.cz, xfs@oss.sgi.com

On Wed, Aug 10, 2011 at 11:36:09AM -0500, Alex Elder wrote:
> > Possible ways to fix this:
> > 1) use /sbin/mkfs -t $FSTYP like _scratch_mkfs, or
> > 2) set $MKFS_BTRFS_PROG like for some other filesystems
> > 
> > 
> > What is preferred?
> 
> Whatever works.  My personal preference would be option (1)
> if it works, since it's does the generic thing directly
> rather than suggesting something special is needed for
> btrfs.  But if that doesn't work, consistency rules so
> MKFS_BTRFS_PROG "like for some other filesystems" is good.

Normally I'd agree with you, but I've run into problems with the
generic mkfs binary, as it parses some options that might otherwise
be left to the filesystem.  E.g. it parses -l by itself, which causes
problems when creating an xfs filesystem with an external log.

Note that any filesystem supported by _scratch_mkfs_sized is special;
there is no generic way to specify the size of a filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
