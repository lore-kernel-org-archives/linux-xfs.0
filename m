Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DDD7A7F37
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 14:32:06 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC1BC8F8068
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 12:32:06 -0800 (PST)
Received: from mail-ve0-f177.google.com (mail-ve0-f177.google.com
	[209.85.128.177]) by cuda.sgi.com with ESMTP id
	92pw28NK7q19ol3l (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 20 Jan 2014 12:32:02 -0800 (PST)
Received: by mail-ve0-f177.google.com with SMTP id jz11so1093098veb.8
	for <xfs@oss.sgi.com>; Mon, 20 Jan 2014 12:32:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140120135514.GA21567@infradead.org>
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
	<20140120135514.GA21567@infradead.org>
Date: Mon, 20 Jan 2014 12:32:01 -0800
Message-ID: <CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
Subject: Re: [RFC] unifying write variants for filesystems
From: Linus Torvalds <torvalds@linux-foundation.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Dave Kleikamp <shaggy@kernel.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Steve French <sfrench@samba.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>

On Mon, Jan 20, 2014 at 5:55 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Sun, Jan 19, 2014 at 05:13:35AM +0000, Al Viro wrote:
>> Folks, what do you think about the following:
>
> That's very much what Shaggy did in the aio-direct tree, except that
> it kept using a single set of methods.  Linus really didn't like it
> unfortunately.

Umm. That wasn't what I objected to.

I objected to the incredibly ugly implementation, the crazy new flags
arguments for core helper functions, ugly naming etc etc. I even
outlined what might fix it.

In other words, I thought the code was shit and ugly. Not that
iterators per se would be wrong. Just doing them badly is wrong.

So don't go putting words in my mouth. It isn't "unfortunate" at all
that I have higher quality standards.

          Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
