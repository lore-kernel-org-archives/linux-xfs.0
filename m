Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2C4AE7F66
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 14:10:49 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 154A6304043
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 12:10:46 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id YzeNelvCmyFevvC6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 Jan 2014 12:10:44 -0800 (PST)
Date: Sat, 18 Jan 2014 20:10:31 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
Message-ID: <20140118201031.GI10323@ZenIV.linux.org.uk>
References: <20131212181459.994196463@bombadil.infradead.org>
	<20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
	<20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
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

On Sat, Jan 18, 2014 at 11:59:56AM -0800, Linus Torvalds wrote:
> On Fri, Jan 17, 2014 at 11:46 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > On Fri, Jan 17, 2014 at 11:22:04PM -0800, Linus Torvalds wrote:
> >> On Fri, Jan 17, 2014 at 10:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >> >
> >> > Objections, comments?
> >>
> >> I certainly object to the "map, then unmap" approach. No VM games.
> >
> > Um...
> >
> > If we are going to copy that data (and all users of generic_file_splice_write()
> > do that memcpy() to page cache), we have to kmap the source ;-/
> 
> Yeah, the kmap/kunmap we have to do. But that's a no-op on 64-bit, and
> has to be done one page at a time (well, I guess you could do a
> couple).
> 
> But you can't do that *around* the default_file_splice_write(), so I
> thought you meant some kind of "map into user space". And I absolutely
> *detest* that kind of approach.

Ouch...  No, I hadn't meant that kind of insanity, but I'd missed the
problem with scarcity of mappings completely...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
