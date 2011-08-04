Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p74CJMrd068291 for <xfs@oss.sgi.com>; Thu, 4 Aug 2011 07:19:23 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9E1EB5322CD
	for <xfs@oss.sgi.com>; Thu,  4 Aug 2011 05:19:18 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	2eeXdiiNepHH2QhA for <xfs@oss.sgi.com>;
	Thu, 04 Aug 2011 05:19:18 -0700 (PDT)
Date: Thu, 4 Aug 2011 08:19:16 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/2] Improve writeout pattern from xfs_flush_pages()
Message-ID: <20110804121916.GA17783@infradead.org>
References: <1312404545-15400-1-git-send-email-jack@suse.cz>
	<20110803214206.GA20477@infradead.org>
	<20110804103616.GF17196@quack.suse.cz>
	<20110804104210.GA30823@infradead.org>
	<20110804120724.GA20800@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110804120724.GA20800@quack.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Aug 04, 2011 at 02:07:24PM +0200, Jan Kara wrote:
>   Hmm, BTW, shouldn't the call to xfs_flush_pages() in
> xfs_file_buffered_aio_write() be converted to an asynchronous one? I don't
> quite see a point in waiting for io completion... Generally, flushing of
> the inode there seems of limited usefulness to me since that inode could be
> just a tiny victim not holding much delayallocated blocks.

This comes from commit

	xfs: make inode flush at ENOSPC synchronous

from Dave - before that it was asynchronous and in weird context, so
it seems we defintively need it to be synchronous.  I agree that just
flushing this inode seems like a rather odd handling for ENOSPC.  It's
even more odd as we already use the big hammer before in when we
git ENOSPC in ->write_begin.  The only thing I can imagine is that
this is the last attempt to get anything freed.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
