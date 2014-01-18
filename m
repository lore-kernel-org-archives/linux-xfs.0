Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B353C7F8D
	for <xfs@oss.sgi.com>; Sat, 18 Jan 2014 01:22:12 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6AB31AC003
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 23:22:09 -0800 (PST)
Received: from mail-vb0-f50.google.com (mail-vb0-f50.google.com
	[209.85.212.50]) by cuda.sgi.com with ESMTP id GSlaNDApoPjAoegF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jan 2014 23:22:04 -0800 (PST)
Received: by mail-vb0-f50.google.com with SMTP id w8so1992143vbj.9
	for <xfs@oss.sgi.com>; Fri, 17 Jan 2014 23:22:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140118064040.GE10323@ZenIV.linux.org.uk>
References: <20131212181459.994196463@bombadil.infradead.org>
	<20140113141416.GA30117@infradead.org>
	<20140113235646.GR10323@ZenIV.linux.org.uk>
	<20140114132207.GA25170@infradead.org>
	<20140114172033.GU10323@ZenIV.linux.org.uk>
	<20140118064040.GE10323@ZenIV.linux.org.uk>
Date: Fri, 17 Jan 2014 23:22:04 -0800
Message-ID: <CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
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

On Fri, Jan 17, 2014 at 10:40 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> Objections, comments?

I certainly object to the "map, then unmap" approach. No VM games.

But if it can be done more naturally as a writev, then that may well
be ok. As long as we're talking about just the
default_file_splice_write() case, and people who want to do special
things with page movement can continue to do so..

              Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
