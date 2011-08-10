Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7AGaDPO197880 for <xfs@oss.sgi.com>; Wed, 10 Aug 2011 11:36:13 -0500
Subject: Re: [PATCH v3 1/2] xfstests: make more tests generic
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110810155214.GE20461@twin.jikos.cz>
References: <cover.1312193821.git.sbehrens@giantdisaster.de>
	<c9703ec698de4de685eb6822773d3934452b8334.1312193821.git.sbehrens@giantdisaster.de>
	<20110810155214.GE20461@twin.jikos.cz>
Date: Wed, 10 Aug 2011 11:36:09 -0500
Message-ID: <1312994169.2865.41.camel@doink>
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
To: dave@jikos.cz
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>, xfs@oss.sgi.com

On Wed, 2011-08-10 at 17:52 +0200, David Sterba wrote:
> Hi,
> 
> On Mon, Aug 01, 2011 at 12:31:19PM +0200, Stefan Behrens wrote:
> > Use _scratch_mkfs / _scratch_mkfs_sized instead of _scratch_mkfs_xfs
> > where possible.
> > Execute 015, 062, 083, 117, 120 and 192 for all filesystems, these
> > tests used to be XFS specific.
>  
> this patch is now in xfstests-dev and somehow breaks btrfs testing.

. . .

> there's a hardcoded path for mkfs.btrfs in common.rc:_scratch_mkfs_sized()
> 
> 335     btrfs)
> 336         /sbin/mkfs.$FSTYP $MKFS_OPTIONS $SCRATCH_DEV -b $fssize
> 337         ;;
> 
> I have a /usr/local/ installation of btrfsprogs from git,
> _scratch_mkfs_sized() was not called for btrfs before.
> 
> Possible ways to fix this:
> 1) use /sbin/mkfs -t $FSTYP like _scratch_mkfs, or
> 2) set $MKFS_BTRFS_PROG like for some other filesystems
> 
> 
> What is preferred?

Whatever works.  My personal preference would be option (1)
if it works, since it's does the generic thing directly
rather than suggesting something special is needed for
btrfs.  But if that doesn't work, consistency rules so
MKFS_BTRFS_PROG "like for some other filesystems" is good.

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
