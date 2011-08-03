Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p73J2LFS172343 for <xfs@oss.sgi.com>; Wed, 3 Aug 2011 14:02:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D5FDD531776
	for <xfs@oss.sgi.com>; Wed,  3 Aug 2011 12:02:17 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	UOoSpter4DfYb1fp for <xfs@oss.sgi.com>;
	Wed, 03 Aug 2011 12:02:17 -0700 (PDT)
Date: Wed, 3 Aug 2011 15:02:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: skip over "rootfs" entry if mtab links to
	/proc/mounts
Message-ID: <20110803190216.GA31421@infradead.org>
References: <4E399677.1010508@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E399677.1010508@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Aug 03, 2011 at 01:41:59PM -0500, Eric Sandeen wrote:
> This is for RH bug 727938, xfs_fsr regression for root file system
> 
> Fedora has made /etc/mtab a symlink to /proc/mounts, but when
> we issue "xfs_fsr /" and fsr's getmntany() goes looking for
> the "/" entry, the first one it finds is
> 
> rootfs / rootfs rw 0 0
> 
> it says no way, that's a rootfs filesystem type, not xfs!
> And it never finds this later:
> 
> /dev/sda2 / xfs rw,relatime,attr2,noquota 0 0
> 
> This patch to skip over the rootfs entry seems to fix it.

I don't like this.  rootfs is the symptom, but the underlying problem
is that in Linux we're perfectly fine to have multiple filesystems
mounted on a single mountpoint, and the getmntany can't deal with it.

I think the right fix is to simply remove the break from the loop,
and thus let a second match for our fs override the first.  This relies
on getmntent returning entries in the order they were mounted, but
without that I can't think of a reliable way for getmntent to work
with the multiple mounts in Linux.

It would also be nice to have a testcase for this behaviour in xfstests,
creating two loop devices with different backing files and mounting them
at the same mount point.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
