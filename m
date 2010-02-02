Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o12BLrEm168669 for <xfs@oss.sgi.com>; Tue, 2 Feb 2010 05:21:56 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 861F7136DC3A
	for <xfs@oss.sgi.com>; Tue,  2 Feb 2010 03:23:02 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ro98E6BXUKfx6ANR for
	<xfs@oss.sgi.com>; Tue, 02 Feb 2010 03:23:02 -0800 (PST)
Date: Tue, 2 Feb 2010 06:23:00 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: State of XFS on ARM
Message-ID: <20100202112300.GA23809@infradead.org>
References: <13bb8ce11002011924h611099feh4955eedcc6e588a6@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <13bb8ce11002011924h611099feh4955eedcc6e588a6@mail.gmail.com>
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
To: Daniel Goller <morfic@gmail.com>, James.Bottomley@HansenPartnership.com
Cc: xfs@oss.sgi.com

On Mon, Feb 01, 2010 at 09:24:33PM -0600, Daniel Goller wrote:
> It seems i have not been able to unmount it and then mounting it
> cleanly once, always required xfs_repair -L   /dev/sdc3
> I Could understand power issues or lockups causing this, but on clean
> umount and followed mount to see it fail is surprising.
> When mounting fails on the headless arm machine i move the drive to a
> x86_64 and run xfs_repair there when mounting there fails too (so log
> can't be replayed, making -L necessary).
> All of this leads me to ask:  "Is XFS as well maintained on ARM as it
> is on x86/x86_64?"

XFS itself is platform neutral.  But it seems like you have an ARM
platform with virtually indexed caches, which currently can't support
the I/O XFS does.  James has been working on fixing this for a while,
but so far the architecture support patches for it unfortunately still
haven't made it to mainline despite many people running into this issue.

The git tree with the current versions of the patches to fix this is
here:

	http://git.kernel.org/?p=linux/kernel/git/jejb/xfs-vipt/.git;a=summary

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
