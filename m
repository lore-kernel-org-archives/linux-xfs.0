Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 833627F87
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 01:57:15 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6044B304070
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 23:57:15 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id fk5QhRcFGhbKlDV6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 17 Jan 2014 23:57:14 -0800 (PST)
Date: Sat, 18 Jan 2014 07:56:47 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140118075647.GG10323@ZenIV.linux.org.uk>
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
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Sat, Jan 18, 2014 at 07:46:49AM +0000, Al Viro wrote:

> Um...
> int pipe_to_file(struct pipe_inode_info *pipe, struct pipe_buffer *buf,
>                  struct splice_desc *sd)
> ...
>         if (buf->page != page) {
>                 char *src = buf->ops->map(pipe, buf, 1);
>                 char *dst = kmap_atomic(page);
> 
>                 memcpy(dst + offset, src + buf->offset, this_len);
>                 flush_dcache_page(page);
>                 kunmap_atomic(dst);
>                 buf->ops->unmap(pipe, buf, src);
> 	}

BTW, that if (buf->page != page) is always true - it's a leftover from
before Nick's removal of ->steal() uses in pipe_to_file() (as well as
the big fat comment in front of that function that had lost any relation
to what it's doing 7 years ago)...

Is there anybody maintaining fs/splice.c these days?  I'd been doing
massive RTFS in that area lately, but it would certainly be nice to
have some braindump on the design and issues in that thing, preferably
still matching the code...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
