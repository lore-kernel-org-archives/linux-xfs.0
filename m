Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 0D6D17F66
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 23:28:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E1FFB8F8070
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 21:28:30 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	RdGzBP03jHMbyhtj for <xfs@oss.sgi.com>;
	Wed, 09 Oct 2013 21:28:26 -0700 (PDT)
Date: Thu, 10 Oct 2013 15:28:20 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
	pointer dereference at 00000003
Message-ID: <20131010042820.GA5663@dastard>
References: <20131009073910.GA387@localhost>
	<20131010005900.GE2025@devil.localdomain>
	<20131010011640.GA5726@localhost> <20131010014117.GA6017@localhost>
	<20131010031515.GT4446@dastard> <20131010032637.GA12725@localhost>
	<20131010033300.GA12952@localhost>
	<20131010033834.GA13141@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010033834.GA13141@localhost>
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
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

On Thu, Oct 10, 2013 at 11:38:34AM +0800, Fengguang Wu wrote:
> On Thu, Oct 10, 2013 at 11:33:00AM +0800, Fengguang Wu wrote:
> > On Thu, Oct 10, 2013 at 11:26:37AM +0800, Fengguang Wu wrote:
> > > Dave,
> > > 
> > > > I note that you have CONFIG_SLUB=y, which means that the cache slabs
> > > > are shared with objects of other types. That means that the memory
> > > > corruption problem is likely to be caused by one of the other
> > > > filesystems that is probing the block device(s), not XFS.
> > > 
> > > Good to know that, it would easy to test then: just turn off every
> > > other filesystems. I'll try it right away.
> > 
> > Seems that we don't even need to do that. A dig through the oops
> > database and I find stack dumps from other FS.
> > 
> > This happens in the kernel with same kconfig and commit 3.12-rc1.
> 
> Here is a summary of all FS with oops:
> 
>     411 ocfs2_fill_super
>     189 xfs_fs_fill_super
>      86 jfs_fill_super
>      50 isofs_fill_super
>      33 fat_fill_super
>      18 vfat_fill_super
>      15 msdos_fill_super
>      11 ext2_fill_super
>      10 ext3_fill_super
>       3 reiserfs_fill_super

The order of probing on the original dmesg output you reported is:

	ext3
	ext2
	fatfs
	reiserfs
	gfs2
	isofs
	ocfs2

which means that no XFS filesystem was mounted in the original bug
report, and hence that further indicates that XFS is not responsible
for the problem and that perhaps the original bisect was not
reliable...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
