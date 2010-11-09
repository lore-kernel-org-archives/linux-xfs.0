Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oA90Jk1E126242 for <xfs@oss.sgi.com>; Mon, 8 Nov 2010 18:19:46 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ED8A4139C6E1
	for <xfs@oss.sgi.com>; Mon,  8 Nov 2010 16:21:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	d04WbPBK6aNXM94M for <xfs@oss.sgi.com>;
	Mon, 08 Nov 2010 16:21:12 -0800 (PST)
Date: Tue, 9 Nov 2010 11:21:10 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 00/16] xfs: current patch stack for 2.6.38 window
Message-ID: <20101109002110.GZ2715@dastard>
References: <1289206519-18377-1-git-send-email-david@fromorbit.com>
	<20101108141746.GA15588@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101108141746.GA15588@infradead.org>
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
Cc: xfs@oss.sgi.com

On Mon, Nov 08, 2010 at 09:17:46AM -0500, Christoph Hellwig wrote:
> On Mon, Nov 08, 2010 at 07:55:03PM +1100, Dave Chinner wrote:
> > My tree is currently based on the VFS locking changes I have out for review,
> > so there's a couple fo patches that won't apply sanely to a mainline or OSS xfs
> > dev tree. See below for a pointer to a git tree with all the patches in it.
> 
> The only think that should depend on it are the inode hash changes.  I
> suspect it might be a better idea if we feed those via Al together with
> the VFS scalability bits, and only feed the rest through the XFS tree to
> avoid having nasty dependencies.

Yes, sounds reasonable.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
