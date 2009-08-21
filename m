Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7LFlhCB178750 for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 10:47:53 -0500
Received: from mx1.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EEF5B1507851
	for <xfs@oss.sgi.com>; Fri, 21 Aug 2009 08:48:30 -0700 (PDT)
Received: from mx1.suse.de (cantor.suse.de [195.135.220.2]) by cuda.sgi.com
	with ESMTP id XClWg0iey0KLQhkz for <xfs@oss.sgi.com>;
	Fri, 21 Aug 2009 08:48:30 -0700 (PDT)
Date: Fri, 21 Aug 2009 17:48:29 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 07/17] vfs: Introduce new helpers for syncing after
	writing to O_SYNC file or IS_SYNC inode
Message-ID: <20090821154829.GE3007@duck.novell.com>
References: <1250697884-22288-1-git-send-email-jack@suse.cz>
	<1250697884-22288-8-git-send-email-jack@suse.cz>
	<20090819162638.GE6150@infradead.org>
	<20090820121531.GC16486@duck.novell.com>
	<20090820162729.GA24659@infradead.org>
	<20090821152339.GD3007@duck.novell.com>
	<20090821153235.GA5874@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090821153235.GA5874@infradead.org>
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
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ntfs-dev@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>, Anton Altaparmakov <aia21@cantab.net>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Evgeniy Polyakov <zbr@ioremap.net>, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com

On Fri 21-08-09 11:32:35, Christoph Hellwig wrote:
> On Fri, Aug 21, 2009 at 05:23:39PM +0200, Jan Kara wrote:
> >   Hmm, I can imagine it would buy us something in two cases (but looking at
> > the code, neither is implemented in such a way that it would really help
> > us in any way):
> > 1) when an inode and it's data are stored in one block (e.g. OCFS2 or UDF) do
> >    this.
> 
> >   In the first case we would wait for block with data to be written only to
> > submit it again because inode was still dirty.
> 
> But we would not actually store in the pagecache or at least never
> writeback it via the pacache in that case, but always just write it as
> part of the inode.
  Yes, probably. Actually, that's what UDF does. It's just that then the
sequence fdatawrite(), fdatawait() does not really send the data to disk.
But that probably does not matter.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
