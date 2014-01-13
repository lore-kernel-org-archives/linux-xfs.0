Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 75BB27F3F
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 17:57:02 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 48220304064
	for <xfs@oss.sgi.com>; Mon, 13 Jan 2014 15:57:01 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id FvHpcaOAHigVGO6R (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 13 Jan 2014 15:56:57 -0800 (PST)
Date: Mon, 13 Jan 2014 23:56:46 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140113235646.GR10323@ZenIV.linux.org.uk>
References: <20131212181459.994196463@bombadil.infradead.org>
	<20140113141416.GA30117@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140113141416.GA30117@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Mark Fasheh <mfasheh@suse.com>, linux-fsdevel@vger.kernel.org, Joel Becker <jlbec@evilplan.org>, xfs@oss.sgi.com

On Mon, Jan 13, 2014 at 06:14:16AM -0800, Christoph Hellwig wrote:
> ping?  Would be nice to get this into 3.14

Umm...  The reason for pipe_lock outside of ->i_mutex is this:
default_file_splice_write() calls splice_from_pipe() with
write_pipe_buf for callback.  splice_from_pipe() calls that
callback under pipe_lock(pipe).  And write_pipe_buf() calls
__kernel_write(), which certainly might want to take ->i_mutex.

Now, this codepath isn't taken for files that have non-NULL
->splice_write(), so that's not an issue for XFS and OCFS2,
but having pipe_lock nest between the ->i_mutex for filesystems
that do and do not have ->splice_write()...  Ouch...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
