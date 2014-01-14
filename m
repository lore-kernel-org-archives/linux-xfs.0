Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id BDC5B7F3F
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 07:22:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4B787AC002
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 05:22:20 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id YeMe726TDdXKVsYu (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Jan 2014 05:22:16 -0800 (PST)
Date: Tue, 14 Jan 2014 05:22:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140114132207.GA25170@infradead.org>
References: <20131212181459.994196463@bombadil.infradead.org>
	<20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140113235646.GR10323@ZenIV.linux.org.uk>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel@vger.kernel.org

On Mon, Jan 13, 2014 at 11:56:46PM +0000, Al Viro wrote:
> On Mon, Jan 13, 2014 at 06:14:16AM -0800, Christoph Hellwig wrote:
> > ping?  Would be nice to get this into 3.14
> 
> Umm...  The reason for pipe_lock outside of ->i_mutex is this:
> default_file_splice_write() calls splice_from_pipe() with
> write_pipe_buf for callback.  splice_from_pipe() calls that
> callback under pipe_lock(pipe).  And write_pipe_buf() calls
> __kernel_write(), which certainly might want to take ->i_mutex.
> 
> Now, this codepath isn't taken for files that have non-NULL
> ->splice_write(), so that's not an issue for XFS and OCFS2,
> but having pipe_lock nest between the ->i_mutex for filesystems
> that do and do not have ->splice_write()...  Ouch...

What would be the alternative?  Duplicating the code in even more
filesystems to enforce an non-natural locking order for filesystems
actually implementing splice?  There don't actually seem to be a whole
lot of real filesystems not implemting splice_write, the prime use
would be for device drivers or synthetic ones.  I'm not even sure
how much that fallback gets used in practice.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
