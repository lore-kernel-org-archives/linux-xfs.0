Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CC01E7F62
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 22:38:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 62EAEAC003
	for <xfs@oss.sgi.com>; Wed,  9 Oct 2013 20:38:38 -0700 (PDT)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93]) by
	cuda.sgi.com with ESMTP id oghz6gRXP6bgwnue for
	<xfs@oss.sgi.com>; Wed, 09 Oct 2013 20:38:37 -0700 (PDT)
Date: Thu, 10 Oct 2013 11:38:34 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [XFS on bad superblock] BUG: unable to handle kernel NULL
	pointer dereference at 00000003
Message-ID: <20131010033834.GA13141@localhost>
References: <20131009073910.GA387@localhost>
	<20131010005900.GE2025@devil.localdomain>
	<20131010011640.GA5726@localhost> <20131010014117.GA6017@localhost>
	<20131010031515.GT4446@dastard> <20131010032637.GA12725@localhost>
	<20131010033300.GA12952@localhost>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131010033300.GA12952@localhost>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, "ocfs2-devel@oss.oracle.com" <ocfs2-devel@oss.oracle.com>

On Thu, Oct 10, 2013 at 11:33:00AM +0800, Fengguang Wu wrote:
> On Thu, Oct 10, 2013 at 11:26:37AM +0800, Fengguang Wu wrote:
> > Dave,
> > 
> > > I note that you have CONFIG_SLUB=y, which means that the cache slabs
> > > are shared with objects of other types. That means that the memory
> > > corruption problem is likely to be caused by one of the other
> > > filesystems that is probing the block device(s), not XFS.
> > 
> > Good to know that, it would easy to test then: just turn off every
> > other filesystems. I'll try it right away.
> 
> Seems that we don't even need to do that. A dig through the oops
> database and I find stack dumps from other FS.
> 
> This happens in the kernel with same kconfig and commit 3.12-rc1.

Here is a summary of all FS with oops:

    411 ocfs2_fill_super
    189 xfs_fs_fill_super
     86 jfs_fill_super
     50 isofs_fill_super
     33 fat_fill_super
     18 vfat_fill_super
     15 msdos_fill_super
     11 ext2_fill_super
     10 ext3_fill_super
      3 reiserfs_fill_super

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
