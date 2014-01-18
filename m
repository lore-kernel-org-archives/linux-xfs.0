Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7B0B27F37
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 14:30:46 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1D343AC002
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 12:30:42 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id 7Wl34zVEoJSmZsv7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 Jan 2014 12:30:42 -0800 (PST)
Date: Sat, 18 Jan 2014 20:30:34 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140118203034.GK10323@ZenIV.linux.org.uk>
References: <20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
	<20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140118202717.GJ10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140118202717.GJ10323@ZenIV.linux.org.uk>
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

On Sat, Jan 18, 2014 at 08:27:17PM +0000, Al Viro wrote:

> Ouch^2: default_file_write_splice_write() keeps calling write_pipe_buf(),
> which does this:
>         data = buf->ops->map(pipe, buf, 0);
>         ret = __kernel_write(sd->u.file, data + buf->offset, sd->len, &tmp);
>         buf->ops->unmap(pipe, buf, data);
> IOW, ->write() (with whatever locks there might be) wrapped into
> kmap_atomic()/kunmap_atomic().  And anybody can do that - just a splice to
> file on procfs will hit that codepath...  Or on 9p, for that matter, or
> fat, or afs, or cifs, etc.

s/kmap_atomic/kmap/, so it's not that disastrously bad (kmap_atomic might
lose the mapping as soon as we block), but scarcity problem remains...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
