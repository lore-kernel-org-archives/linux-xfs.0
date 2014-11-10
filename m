Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AAB357F3F
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 17:31:59 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8A555304032
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 15:31:56 -0800 (PST)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id MHj2dx75qZxtrt4m
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 10 Nov 2014 15:31:55 -0800 (PST)
Received: by mail-pa0-f43.google.com with SMTP id eu11so9300637pac.30
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 15:31:54 -0800 (PST)
Message-ID: <54614AE7.2080204@kernel.dk>
Date: Mon, 10 Nov 2014 16:31:51 -0700
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
Subject: Re: kernel BUG at drivers/block/virtio_blk.c:172!
References: <20141107080416.0837a88c@tlielax.poochiereds.net>
	<87bnofnzop.fsf@rustcorp.com.au>
In-Reply-To: <87bnofnzop.fsf@rustcorp.com.au>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Rusty Russell <rusty@rustcorp.com.au>, Jeff Layton <jlayton@poochiereds.net>, "Michael S. Tsirkin" <mst@redhat.com>, Dave Chinner <david@fromorbit.com>
Cc: Ming Lei <tom.leiming@gmail.com>, xfs@oss.sgi.com, virtualization@lists.linux-foundation.org

On 2014-11-10 02:59, Rusty Russell wrote:
> Jeff Layton <jlayton@poochiereds.net> writes:
>
>> In the latest Fedora rawhide kernel in the repos, I'm seeing the
>> following oops when mounting xfs. rc2-ish kernels seem to be fine:
>>
>> [   64.669633] ------------[ cut here ]------------
>> [   64.670008] kernel BUG at drivers/block/virtio_blk.c:172!
>
> Hmm, that's:
>
> 	BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>
> But during our probe routine we said:
>
> 	/* We can handle whatever the host told us to handle. */
> 	blk_queue_max_segments(q, vblk->sg_elems-2);
>
> Jens?

Known, I'm afraid, Ming is looking into it.

-- 
Jens Axboe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
