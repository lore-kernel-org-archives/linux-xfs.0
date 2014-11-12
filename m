Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8B5457F3F
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 15:02:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1C1DFAC008
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 13:02:41 -0800 (PST)
Received: from mail-qa0-f50.google.com (mail-qa0-f50.google.com
	[209.85.216.50]) by cuda.sgi.com with ESMTP id HlAcR9rhp5lk8VP5
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 12 Nov 2014 13:02:40 -0800 (PST)
Received: by mail-qa0-f50.google.com with SMTP id bm13so8997414qab.23
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2014 13:02:40 -0800 (PST)
Date: Wed, 12 Nov 2014 16:02:35 -0500
From: Jeff Layton <jlayton@poochiereds.net>
Subject: Re: kernel BUG at drivers/block/virtio_blk.c:172!
Message-ID: <20141112160235.19d8aefc@tlielax.poochiereds.net>
In-Reply-To: <5463A478.20603@kernel.dk>
References: <20141107080416.0837a88c@tlielax.poochiereds.net>
	<87bnofnzop.fsf@rustcorp.com.au> <54614AE7.2080204@kernel.dk>
	<CACVXFVOgRMqCUASOaXQ7ys8yiKZFEH5SA-+mV=H0uvHuGseENQ@mail.gmail.com>
	<20141111154250.GA16906@gmail.com>
	<CACVXFVNXSmw=Gu_9JAtpF3uxupSMr4kN2ge-jnZMxZAMcaHrfw@mail.gmail.com>
	<5463A478.20603@kernel.dk>
MIME-Version: 1.0
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
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Ming Lei <tom.leiming@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>, xfs@oss.sgi.com, Lukas Czerner <lczerner@redhat.com>, Linux Virtualization <virtualization@lists.linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dongsu Park <dongsu.park@profitbricks.com>

On Wed, 12 Nov 2014 11:18:32 -0700
Jens Axboe <axboe@kernel.dk> wrote:

> On 11/11/2014 09:42 AM, Ming Lei wrote:
> > The attached patch should fix the problem, and hope it is the last one, :-)
> 
> Dongsu and Jeff, any of you test this variant? I think this is the last
> one, at least I hope so as well...
> 

Yes, thanks! That patch seems to fix the problem for me. You can add:

Tested-by: Jeff Layton <jlayton@poochiereds.net>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
