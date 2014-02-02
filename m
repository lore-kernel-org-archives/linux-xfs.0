Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 806637F8C
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 13:23:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 48B338F8040
	for <xfs@oss.sgi.com>; Sun,  2 Feb 2014 11:23:16 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id ossG0CMsNypaWmtX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 02 Feb 2014 11:23:14 -0800 (PST)
Date: Sun, 2 Feb 2014 19:23:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] unifying write variants for filesystems
Message-ID: <20140202192306.GU10323@ZenIV.linux.org.uk>
References: <20140118064040.GE10323@ZenIV.linux.org.uk>
	<CA+55aFw4LgyYEkygxHUnpKZg3jMACGzsyENc9a9rWFmLcaRefQ@mail.gmail.com>
	<20140118074649.GF10323@ZenIV.linux.org.uk>
	<CA+55aFzM0N7WjqnLNnuqTkbj3iws9f3bYxei=ZBCM8hvps4zYg@mail.gmail.com>
	<20140118201031.GI10323@ZenIV.linux.org.uk>
	<20140119051335.GN10323@ZenIV.linux.org.uk>
	<20140120135514.GA21567@infradead.org>
	<CA+55aFzEA-eM9v2PvsWx4v4ANaKXuRGYyGCkegJg++rhtHvnig@mail.gmail.com>
	<20140201224301.GS10323@ZenIV.linux.org.uk>
	<20140202192104.GA21959@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140202192104.GA21959@ZenIV.linux.org.uk>
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
Cc: Jens Axboe <axboe@kernel.dk>, Steve French <sfrench@samba.org>, Sage Weil <sage@inktank.com>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@suse.com>, Miklos Szeredi <miklos@szeredi.hu>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, Joel Becker <jlbec@evilplan.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Anton Altaparmakov <anton@tuxera.com>

On Sun, Feb 02, 2014 at 07:21:04PM +0000, Al Viro wrote:
> BTW, is there any reason why fuse/dev.c doesn't use atomic kmaps for
> everything?  After all, as soon as we'd done kmap() in there, we
> grab a spinlock and don't drop it until just before kunmap().  With
> nothing by memcpy() done in between...  Miklos?  AFAICS, we only win

s/by/but/ - sorry...

> from switching to kmap_atomic there - we can't block anyway, we don't
> need it to be visible on other CPUs and nesting isn't a problem.
> Looks like it'll be cheaper in highmem cases and do exactly the same
> thing as now for non-highmem...  Comments?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
