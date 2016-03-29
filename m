Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C3957CB5
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 03:09:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 21C3F8F8035
	for <xfs@oss.sgi.com>; Tue, 29 Mar 2016 01:09:33 -0700 (PDT)
Received: from zimbra13.linbit.com (zimbra13.linbit.com [212.69.166.240]) by
	cuda.sgi.com with ESMTP id Wi8fqrhLRGF4Yrwf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 29 Mar 2016 01:09:25 -0700 (PDT)
Date: Tue, 29 Mar 2016 10:09:21 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: Re: [PATCH 7/8] block: drbd: avoid to use BIO_MAX_SIZE
Message-ID: <20160329080921.GG15579@soda.linbit>
References: <1458627149-12988-1-git-send-email-ming.lei@canonical.com>
	<1458627149-12988-8-git-send-email-ming.lei@canonical.com>
	<20160329073124.GH18920@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160329073124.GH18920@infradead.org>
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
Cc: Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Philipp Reisner <philipp.reisner@linbit.com>, Anton Altaparmakov <anton@tuxera.com>, drbd-dev@lists.linbit.com

On Tue, Mar 29, 2016 at 12:31:24AM -0700, Christoph Hellwig wrote:
> On Tue, Mar 22, 2016 at 02:12:28PM +0800, Ming Lei wrote:
> > drbd is the only user of BIO_MAX_SIZE, so use BIO_MAX_PAGES
> > instead.
> 
> That whole code block looks completely bogus to me, although your patch
> doesn't make it any worse.
> 
> I/O size for a network protocol shouldn't dependend on the number of
> vectors in a kernel internal structure.

That's correct.  But we needed some limit there.
Initially, up until I changed it like six years ago iirc,
the receiving side would receive into a single bio.
So limiting us to what a single bio could usually handle
seemed like a good idea at the time.

Today, we should be able to handle 128 MiB easily,
maybe more. But that would require a protocol bump
to stay backwards compatible.

The part about "architecture not supported",
if our limit (1 MiB) is bigger than the "system" limit:
Never met that in real life. Probably not even possible.
Just a paranoia on my side: what if.
If that would have happened somewhere,
on some strange architecture or configuration,
I wanted to know about that.
Best way: don't even compile.

> Well, getting rid of BIO_MAX_SIZE is worth it, so:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks,

    Lars Ellenberg

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
