Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14GHcwI074170 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 10:17:39 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 665A81AF382
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 08:18:49 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id kwDuPgY2HvtoyW6c for
	<xfs@oss.sgi.com>; Thu, 04 Feb 2010 08:18:49 -0800 (PST)
Date: Thu, 4 Feb 2010 11:18:47 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] more reserved blocks fixups
Message-ID: <20100204161847.GA32102@infradead.org>
References: <4B60C8EE.5080700@sandeen.net>
	<20100128015817.GH15853@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100128015817.GH15853@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs mailing list <xfs@oss.sgi.com>

On Thu, Jan 28, 2010 at 12:58:17PM +1100, Dave Chinner wrote:
> On Wed, Jan 27, 2010 at 05:14:54PM -0600, Eric Sandeen wrote:
> > This mangles the reserved blocks counts a little more.
> > 
> > 1) add a helper function for the default reserved count
> > 2) add helper functions to save/restore counts on ro/rw
> > 3) save/restore reserved blocks on freeze/thaw
> > 4) disallow changing reserved count while readonly
> > 
> > for 2) - maybe better names (save_and_clear?)
> > for 4) - maybe allow, but change the _ro field instead?
> > 
> > (TBH not tested yet but wondered if this seems sane)
> 
> I was wondering if the save/restore could be encapsualted entirely
> within xfs_quiesce_attr(). i.e. save before the superblock write,
> restore directly after. That removes the need for a variable in
> the xfs_mount structure, and catches both remount,ro and freeze.

Seems like a bit fragile.  But I think we want Eric's version
over yours for a start - we should have a clean filesystem not
only after remount,ro but also for a frozen filesystem.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
