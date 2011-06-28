Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5SBbANE215898 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 06:37:10 -0500
Received: from ipmail07.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CA283516B
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 04:37:08 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	vvVnclwLygIsILzq for <xfs@oss.sgi.com>;
	Tue, 28 Jun 2011 04:37:08 -0700 (PDT)
Date: Tue, 28 Jun 2011 21:37:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfs_repair: Check if agno is inside the filesystem
Message-ID: <20110628113702.GO32466@dastard>
References: <1309193610-17078-1-git-send-email-lczerner@redhat.com>
	<20110628012838.GI32466@dastard>
	<alpine.LFD.2.00.1106281120250.3864@dhcp-27-109.brq.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1106281120250.3864@dhcp-27-109.brq.redhat.com>
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
To: Lukas Czerner <lczerner@redhat.com>
Cc: aelder@sgi.com, xfs@oss.sgi.com

On Tue, Jun 28, 2011 at 11:24:46AM +0200, Lukas Czerner wrote:
> On Tue, 28 Jun 2011, Dave Chinner wrote:
> 
> > On Mon, Jun 27, 2011 at 06:53:30PM +0200, Lukas Czerner wrote:
> > > When getting an inode tree pointer from an array inode_tree_ptrs, we
> > > should check if agno, which is used as a pointer to the array, lives
> > > within the file system, because if it is not, we can end up touching
> > > uninitialized memory.
> > 
> > How do you get an agno outside the bounds of the filesystem?
> 
> Hi Dave,
> 
> in my particular case the problem was in
> longform_dir2_entry_check_data(). xfs_dir2_data_entry_t was read and we
> used inode numbed (xfs_dir2_data_entry_t)->inumber to compute AG number.
> However it contained garbage so the resulting agno was too high. In
> modify mode it was not a problem, because the inode was cleared in the
> earlies phase, but in no_modify mode, the was still there.

Ok, a corrupted directory entry is the cause. Might be worthwhile
mentioning that in the commit log.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
