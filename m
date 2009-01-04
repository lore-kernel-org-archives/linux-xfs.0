Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n04GmaLY017647 for <xfs@oss.sgi.com>; Sun, 4 Jan 2009 10:48:36 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 253175E0EA
	for <xfs@oss.sgi.com>; Sun,  4 Jan 2009 08:48:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id J0ksjEDD4CKCQ3SV for
	<xfs@oss.sgi.com>; Sun, 04 Jan 2009 08:48:36 -0800 (PST)
Date: Sun, 4 Jan 2009 11:48:35 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs_repair: allow filesystems with a single AG
Message-ID: <20090104164835.GB16133@infradead.org>
References: <20081224231901.GA652@infradead.org> <4953C8B8.4010500@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4953C8B8.4010500@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Dec 25, 2008 at 11:54:00AM -0600, Eric Sandeen wrote:
> Christoph Hellwig wrote:
> > Currently xfs_repair bails out on a filesystem with just a single AG.
> > But that's a perfectly valid configureation, so we should allow it.
> > 
> > Skip the geomery validation because we simply can't do it if we don't
> > have a secondary SB, and make sure to take the internal log into account
> > when guestimating the first inode cluster.
> > 
> > I'll also cook up a testcase for repair on single AG filesystems.
> 
> While I think we should certainly allow this, what's the worst-case
> scenario for a corrupted superblock when we can't validate it and
> continue with repair?
> 
> I wonder if something like
> 
> # xfs_repair --allow-single-sb
> 
> should be required, with some man page docs suggesting a run with -n
> first etc to be sure that garbled geometry doesn't trash the whole thing...?

Maybe.  Given that we don't auto fsck anyway it's at least doable.  But
given that there is no other way to repair a single AG filesystem I'm
not sure it helps.  But I can cook up a variant that requires an option.
In fact existing repair code would allow it (and fail utterly) when
a flag is set - there's just no way to set that flag on the command
line..

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
