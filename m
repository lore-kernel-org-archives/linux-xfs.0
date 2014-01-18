Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 121667F89
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 02:27:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EBD21304048
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 00:27:45 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id Lsn8bsmGdF9qkKE1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 Jan 2014 00:27:44 -0800 (PST)
Date: Sat, 18 Jan 2014 08:27:30 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140118082730.GH10323@ZenIV.linux.org.uk>
References: <20131212181459.994196463@bombadil.infradead.org>
	<20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
	<20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140118074649.GF10323@ZenIV.linux.org.uk>
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
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Miller <davem@davemloft.net>

On Sat, Jan 18, 2014 at 07:46:49AM +0000, Al Viro wrote:
> On Fri, Jan 17, 2014 at 11:22:04PM -0800, Linus Torvalds wrote:
> > On Fri, Jan 17, 2014 at 10:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Objections, comments?
> > 
> > I certainly object to the "map, then unmap" approach. No VM games.
[snip]
> > But if it can be done more naturally as a writev, then that may well
> > be ok. As long as we're talking about just the
> > default_file_splice_write() case, and people who want to do special
> > things with page movement can continue to do so..
> 
> The thing is, after such change default_file_splice_write() is no worse than
> generic_file_splice_write().  The only instances that really want something
> else are the ones that try to steal pages (e.g. virtio_console, fuse miscdev)
> or sockets, with their "do DMA from the sodding page, don't copy it at
> anywhere" ->sendpage() method.  IOW, ones those special things you are
> talking about.  Normal filesystems do not - not on pipe-to-file splice.
> file-to-pipe - sure, that one plays with pagecache and tries hard to
> do zero-copy, but that's ->splice_read(), not ->splice_write()...

BTW, would sockets benefit from having ->sendpages() that would take an
array of (page, offset, len) triples?  It would be trivial to do and
some of the helpers that are falling out of writing that writev-based
default_file_splice_write() look like they could be reused for
calling that one...  Dave?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
