Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D9A07F37
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 05:04:25 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3AB5130405F
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 03:04:22 -0800 (PST)
Received: from mail-wg0-f53.google.com (mail-wg0-f53.google.com
	[74.125.82.53]) by cuda.sgi.com with ESMTP id Ds2mZfNX0NV4GHzE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 13 Nov 2014 03:04:20 -0800 (PST)
Received: by mail-wg0-f53.google.com with SMTP id b13so16539091wgh.12
	for <xfs@oss.sgi.com>; Thu, 13 Nov 2014 03:04:19 -0800 (PST)
Date: Thu, 13 Nov 2014 12:04:15 +0100
From: Dongsu Park <dongsu.park@profitbricks.com>
Subject: Re: kernel BUG at drivers/block/virtio_blk.c:172!
Message-ID: <20141113110415.GB16906@gmail.com>
References: <20141107080416.0837a88c@tlielax.poochiereds.net>
	<87bnofnzop.fsf@rustcorp.com.au> <54614AE7.2080204@kernel.dk>
	<CACVXFVOgRMqCUASOaXQ7ys8yiKZFEH5SA-+mV=H0uvHuGseENQ@mail.gmail.com>
	<20141111154250.GA16906@gmail.com>
	<CACVXFVNXSmw=Gu_9JAtpF3uxupSMr4kN2ge-jnZMxZAMcaHrfw@mail.gmail.com>
	<5463A478.20603@kernel.dk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <5463A478.20603@kernel.dk>
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
To: Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Ming Lei <tom.leiming@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>, xfs@oss.sgi.com, Lukas Czerner <lczerner@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Linux Virtualization <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>

On 12.11.2014 11:18, Jens Axboe wrote:
> On 11/11/2014 09:42 AM, Ming Lei wrote:
> > The attached patch should fix the problem, and hope it is the last one, :-)
> 
> Dongsu and Jeff, any of you test this variant? I think this is the last
> one, at least I hope so as well...

Yes, I've just tested it again with the Ming's patch.
It passed a full cycle of xfstests: No crash, no particular regression.
The code in blk_recount_segments() seems to make sense too.

Thanks! ;-)
Dongsu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
