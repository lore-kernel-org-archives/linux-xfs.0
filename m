Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0GHmM6b105866 for <xfs@oss.sgi.com>; Mon, 16 Jan 2012 11:48:23 -0600
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	sC5mYiSaC8DECn1N for <xfs@oss.sgi.com>;
	Mon, 16 Jan 2012 09:48:20 -0800 (PST)
Date: Mon, 16 Jan 2012 12:48:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: concurrent direct IO write in xfs
Message-ID: <20120116174819.GA19417@infradead.org>
References: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFLer83FBZG9ZCrT2jUZBcTC2a2tx_CDmykyPF4cTP0dbHGw7Q@mail.gmail.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Zheng Da <zhengda1936@gmail.com>
Cc: xfs@oss.sgi.com

On Sun, Jan 15, 2012 at 07:01:42PM -0500, Zheng Da wrote:
> Hello,
> 
> I surprisedly found that writing data to a file (no appending) with direct
> IO and with multiple threads has the same performance as a single thread.
> Actually, it seems there is only one core is working at a time. In my case,
> each time I write a page to a file and the offset is always aligned to the
> page size, so there is no overlapping between writes.

What kernel version are you using?  Also, what is the exact I/O
pattern?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
