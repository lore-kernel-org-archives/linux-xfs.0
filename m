Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8F4D57F37
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 07:55:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F4AB8F8071
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 05:55:27 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id DUC6eoZ5FzZiJ9PV (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jan 2014 05:55:26 -0800 (PST)
Date: Mon, 20 Jan 2014 05:55:14 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140120135514.GA21567@infradead.org>
References: <20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
	<20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140119051335.GN10323@ZenIV.linux.org.uk>
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
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Sun, Jan 19, 2014 at 05:13:35AM +0000, Al Viro wrote:
> Folks, what do you think about the following:

That's very much what Shaggy did in the aio-direct tree, except that
it kept using a single set of methods.  Linus really didn't like it
unfortunately.

https://github.com/kleikamp/linux-shaggy/commits/aio_loop

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
