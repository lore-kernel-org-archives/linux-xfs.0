Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6UESuYv138290 for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 09:28:57 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 236AF52DC03
	for <xfs@oss.sgi.com>; Sat, 30 Jul 2011 07:28:55 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	VUMvGem1EgFXBawX for <xfs@oss.sgi.com>;
	Sat, 30 Jul 2011 07:28:55 -0700 (PDT)
Date: Sat, 30 Jul 2011 10:28:54 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 4/4] xfstests: Changed test 079 to be generic for all
	filesystems
Message-ID: <20110730142854.GB31200@infradead.org>
References: <cover.1311953979.git.sbehrens@giantdisaster.de>
	<d63d92aa14e5fa81b4a40d0903001e70f7da9249.1311953979.git.sbehrens@giantdisaster.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <d63d92aa14e5fa81b4a40d0903001e70f7da9249.1311953979.git.sbehrens@giantdisaster.de>
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
To: Stefan Behrens <sbehrens@giantdisaster.de>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Jul 29, 2011 at 06:07:01PM +0200, Stefan Behrens wrote:
> Changed the test 079 to be generic for all filesystems and to be
> executed for all filesystems.
> In src/t_immutable.c which is compiled for Linux only, replaced the
> old style XFS and ext2 specific code for setting the append-only and
> immutable flags by generic code that makes use of the
> ioctl(FS_IOC_SETFLAGS) and ioctl(FS_IOC_GETFLAGS).
> Therefore the check for the specific filesystem type was removed.
> FS_IOC_GETFLAGS/FS_IOC_SETFLAGS is always used. This code is inside an
> '#ifdef FS_IOC_SETFLAGS' block in order to never fail compilation.
> Without support for FS_IOC_SETFLAGS, the test completes with _notrun.

A little nitpicking for the subject again, I'd rather see something like:

	xfstests: make t_immutable and 079 filesystem-agnostic

> +$timmutable -c $SCRATCH_MNT/$seq >$tmp.out 2>&1
> +if grep -q 'Operation not supported' $tmp.out
> +then

if grep -q 'Operation not supported' $tmp.out; then

please

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
