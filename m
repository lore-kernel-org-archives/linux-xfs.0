Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3A5C07F3F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 12:18:29 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 18737304064
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:18:25 -0800 (PST)
Received: from mail-pd0-f177.google.com (mail-pd0-f177.google.com
	[209.85.192.177]) by cuda.sgi.com with ESMTP id
	p5usgscyFPy0gtzG (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 12 Nov 2014 10:18:24 -0800 (PST)
Received: by mail-pd0-f177.google.com with SMTP id v10so12612183pde.22
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 10:18:24 -0800 (PST)
Message-ID: <5463A478.20603@kernel.dk>
Date: Wed, 12 Nov 2014 11:18:32 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: kernel BUG at drivers/block/virtio_blk.c:172!
References: <20141107080416.0837a88c@tlielax.poochiereds.net>	<87bnofnzop.fsf@rustcorp.com.au>	<54614AE7.2080204@kernel.dk>	<CACVXFVOgRMqCUASOaXQ7ys8yiKZFEH5SA-+mV=H0uvHuGseENQ@mail.gmail.com>	<20141111154250.GA16906@gmail.com>
	<CACVXFVNXSmw=Gu_9JAtpF3uxupSMr4kN2ge-jnZMxZAMcaHrfw@mail.gmail.com>
In-Reply-To: <CACVXFVNXSmw=Gu_9JAtpF3uxupSMr4kN2ge-jnZMxZAMcaHrfw@mail.gmail.com>
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
To: Ming Lei <tom.leiming@gmail.com>, Dongsu Park <dongsu.park@profitbricks.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, xfs@oss.sgi.com, Lukas Czerner <lczerner@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Linux Virtualization <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>

On 11/11/2014 09:42 AM, Ming Lei wrote:
> The attached patch should fix the problem, and hope it is the last one, :-)

Dongsu and Jeff, any of you test this variant? I think this is the last
one, at least I hope so as well...

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
