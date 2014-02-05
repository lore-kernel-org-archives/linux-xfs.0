Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B2D8B7F52
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 14:43:11 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 944A98F804C
	for <xfs@oss.sgi.com>; Wed,  5 Feb 2014 12:43:05 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Go6wKCBxvdo1Q6u4 for
	<xfs@oss.sgi.com>; Wed, 05 Feb 2014 12:43:04 -0800 (PST)
Date: Wed, 5 Feb 2014 12:42:03 -0800
From: Zach Brown <zab@redhat.com>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140205204203.GE11325@lenny.home.zabbo.net>
References: <20140201224301.GS10323@ZenIV.linux.org.uk>
	<52EFC271.3090205@oracle.com>
	<20140204124409.GG10323@ZenIV.linux.org.uk>
	<20140204125220.GB12440@kmo-pixel>
	<20140204151728.GH10323@ZenIV.linux.org.uk>
	<20140204172723.GA11325@lenny.home.zabbo.net>
	<20140204180040.GI10323@ZenIV.linux.org.uk>
	<20140204183356.GB11325@lenny.home.zabbo.net>
	<20140204183609.GK10323@ZenIV.linux.org.uk>
	<20140205195838.GO10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140205195838.GO10323@ZenIV.linux.org.uk>
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
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Mark Fasheh <mfasheh@suse.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>, Dave Kleikamp <dave.kleikamp@oracle.com>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Anton Altaparmakov <anton@tuxera.com>

> So what exactly does generic_segments_check() give us?  Is it just that
> everybody went "well, maybe there's some weird path where we don't do
> validation; let's leave it there"?  Linus?

Sounds likely.  I'd bet that the btrfs call was just copied from
__generic_file_aio_write() when btrfs grew its own .aio_write method:

11c65dccf70be9ace5dbd3906778e1a099b1fee1
Author: Josef Bacik <josef@redhat.com>
Date:   Sun May 23 11:07:21 2010 -0400

    Btrfs: do aio_write instead of write

It probably amounts to no more than ocount = iov_length().

- z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
