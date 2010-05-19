Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JIMGrN146654 for <xfs@oss.sgi.com>; Wed, 19 May 2010 13:22:16 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84DE635BA96
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 11:24:35 -0700 (PDT)
Received: from bombadil.infradead.org ([18.85.46.34]) by cuda.sgi.com with
	ESMTP id gKZ0bE9RvhJaHX9r for <xfs@oss.sgi.com>;
	Wed, 19 May 2010 11:24:35 -0700 (PDT)
Date: Wed, 19 May 2010 14:24:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: noatime,nodiratime?
Message-ID: <20100519182434.GB6264@infradead.org>
References: <4BF3F212.5030600@hardwarefreak.com>
	<87mxvveqyq.fsf@petole.demisel.net>
	<4BF42725.8060903@hardwarefreak.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4BF42725.8060903@hardwarefreak.com>
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
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: xfs@oss.sgi.com

On Wed, May 19, 2010 at 01:00:05PM -0500, Stan Hoeppner wrote:
> Yes, the defaults for each parameter are in your mount man page.
> logbsize=256K is higher than the default, which is 32K for any system with
> over 32MB RAM.  logbufs=8 will be the default if your blocksize is 64K.  If
> your blocksize is 4K you'll get logbufs=2 by default.  This is all in the
> XFS section of man mount.

But it's not actually true anymore for a long time.  XFS is always using
8 32k log buffers these days.  I'll prepare an update for the mount man
page to correct this.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
