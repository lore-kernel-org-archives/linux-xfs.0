Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DCE457F51
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 13:59:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id B40078F8071
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 11:59:58 -0800 (PST)
Received: from mail-ve0-f180.google.com (mail-ve0-f180.google.com
	[209.85.128.180]) by cuda.sgi.com with ESMTP id
	kGNma4sBNNFSNuRP (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 18 Jan 2014 11:59:57 -0800 (PST)
Received: by mail-ve0-f180.google.com with SMTP id db12so348085veb.39
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 11:59:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140118074649.GF10323@ZenIV.linux.org.uk>
References: <20131212181459.994196463@bombadil.infradead.org>
	<20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
	<20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
Date: Sat, 18 Jan 2014 11:59:56 -0800
Message-ID: <CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
Subject: Re: [PATCH 0/5] splice: locking changes and code refactoring
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Jan 17, 2014 at 11:46 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Fri, Jan 17, 2014 at 11:22:04PM -0800, Linus Torvalds wrote:
>> On Fri, Jan 17, 2014 at 10:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> >
>> > Objections, comments?
>>
>> I certainly object to the "map, then unmap" approach. No VM games.
>
> Um...
>
> If we are going to copy that data (and all users of generic_file_splice_write()
> do that memcpy() to page cache), we have to kmap the source ;-/

Yeah, the kmap/kunmap we have to do. But that's a no-op on 64-bit, and
has to be done one page at a time (well, I guess you could do a
couple).

But you can't do that *around* the default_file_splice_write(), so I
thought you meant some kind of "map into user space". And I absolutely
*detest* that kind of approach.

                  Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
