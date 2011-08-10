Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7AGcnmB197970 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 11:38:49 -0500
Subject: Re: [PATCH v3 1/2] xfstests: make more tests generic
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110810163322.GA30292@infradead.org>
References: <cover.1312193821.git.sbehrens@giantdisaster.de>
	<c9703ec698de4de685eb6822773d3934452b8334.1312193821.git.sbehrens@giantdisaster.de>
	<20110810155214.GE20461@twin.jikos.cz>
	<20110810163322.GA30292@infradead.org>
Date: Wed, 10 Aug 2011 11:38:43 -0500
Message-ID: <1312994323.2865.42.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Wed, 2011-08-10 at 12:33 -0400, Christoph Hellwig wrote:
> On Wed, Aug 10, 2011 at 05:52:14PM +0200, David Sterba wrote:
> > there's a hardcoded path for mkfs.btrfs in common.rc:_scratch_mkfs_sized()
> > 
> > 335     btrfs)
> > 336         /sbin/mkfs.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV -b $fssize
> > 337         ;;
> > 
> > I have a /usr/local/ installation of btrfsprogs from git,
> > _scratch_mkfs_sized() was not called for btrfs before.
> > 
> > Possible ways to fix this:
> > 1) use /sbin/mkfs -t $FSTYP like _scratch_mkfs, or
> > 2) set $MKFS_BTRFS_PROG like for some other filesystems
> > 
> > 
> > What is preferred?
> 
> Please send a patch for variant 2.  As soon as we have option using
> the generic mkfs wrapper sounds like a good idea.  In addition to that
> treating btrfs the same way as other filesystems is always good.

Whoops, we gave different answers.  Do what Christoph says...	-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
