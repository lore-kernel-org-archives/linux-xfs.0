Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 894837F8E
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 01:47:22 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2675EAC001
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 23:47:21 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id e9cbUOMQr8hgTZHT (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 23:47:20 -0800 (PST)
Date: Sat, 18 Jan 2014 07:46:49 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140118074649.GF10323@ZenIV.linux.org.uk>
References: <20131212181459.994196463@bombadil.infradead.org>
	<20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
	<20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jan 17, 2014 at 11:22:04PM -0800, Linus Torvalds wrote:
> On Fri, Jan 17, 2014 at 10:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Objections, comments?
> 
> I certainly object to the "map, then unmap" approach. No VM games.

Um...
int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
                 struct splice_desc *sd)
...
        if (buf->page != page) {
                char *src = buf->ops->map(pipe, buf, 1);
                char *dst = kmap_atomic(page);

                memcpy(dst + offset, src + buf->offset, this_len);
                flush_dcache_page(page);
                kunmap_atomic(dst);
                buf->ops->unmap(pipe, buf, src);
	}
...

->map() and ->unmap() (BTW, why are those methods, anyway?  They are
identical for all instances) are
void *generic_pipe_buf_map(struct pipe_inode_info *pipe,
                           struct pipe_buffer *buf, int atomic)
{  
        if (atomic) {
                buf->flags |= PIPE_BUF_FLAG_ATOMIC;
                return kmap_atomic(buf->page);
        }

        return kmap(buf->page);
}
and
void generic_pipe_buf_unmap(struct pipe_inode_info *pipe,
                            struct pipe_buffer *buf, void *map_data)
{
        if (buf->flags & PIPE_BUF_FLAG_ATOMIC) {
                buf->flags &= ~PIPE_BUF_FLAG_ATOMIC;
                kunmap_atomic(map_data);
        } else
                kunmap(buf->page);
}
resp.

If we are going to copy that data (and all users of generic_file_splice_write()
do that memcpy() to page cache), we have to kmap the source ;-/

> But if it can be done more naturally as a writev, then that may well
> be ok. As long as we're talking about just the
> default_file_splice_write() case, and people who want to do special
> things with page movement can continue to do so..

The thing is, after such change default_file_splice_write() is no worse than
generic_file_splice_write().  The only instances that really want something
else are the ones that try to steal pages (e.g. virtio_console, fuse miscdev)
or sockets, with their "do DMA from the sodding page, don't copy it at
anywhere" ->sendpage() method.  IOW, ones those special things you are
talking about.  Normal filesystems do not - not on pipe-to-file splice.
file-to-pipe - sure, that one plays with pagecache and tries hard to
do zero-copy, but that's ->splice_read(), not ->splice_write()...

_If_ somebody figures out how to deal with zero-copy on pipe-to-file - fine,
we'll be able to revisit that.  But there hadn't been one since 2007 and
there was zero activity in that area, so...

What I'm doing right now is taking do_readv_writev() apart and making the
stuff after rw_copy_check_uvector() non-static (visible in fs/internal.h).
As long as we do not go through rw_copy_check_uvector() (we'd just built
that iovec ourselves and it's already in kernel space), we should be fine -
single copy done straight to pagecache, with whatever locks fs wants to
take, etc.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
