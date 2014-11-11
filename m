Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 49E7B7F3F
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 18:56:30 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D8D8AAC003
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 16:56:29 -0800 (PST)
Received: from mail-ob0-f170.google.com (mail-ob0-f170.google.com
	[209.85.214.170]) by cuda.sgi.com with ESMTP id
	JYULSA9pxR4wLhfJ (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 10 Nov 2014 16:56:28 -0800 (PST)
Received: by mail-ob0-f170.google.com with SMTP id nt9so7258802obb.29
	for <xfs@oss.sgi.com>; Mon, 10 Nov 2014 16:56:28 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54614AE7.2080204@kernel.dk>
References: <20141107080416.0837a88c@tlielax.poochiereds.net>
	<87bnofnzop.fsf@rustcorp.com.au> <54614AE7.2080204@kernel.dk>
Date: Tue, 11 Nov 2014 08:56:27 +0800
Message-ID: <CACVXFVOgRMqCUASOaXQ7ys8yiKZFEH5SA-+mV=H0uvHuGseENQ@mail.gmail.com>
Subject: Re: kernel BUG at drivers/block/virtio_blk.c:172!
From: Ming Lei <tom.leiming@gmail.com>
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
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, xfs@oss.sgi.com, Jeff Layton <jlayton@poochiereds.net>, Linux Virtualization <virtualization@lists.linux-foundation.org>

On Tue, Nov 11, 2014 at 7:31 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2014-11-10 02:59, Rusty Russell wrote:
>>
>> Jeff Layton <jlayton@poochiereds.net> writes:
>>
>>> In the latest Fedora rawhide kernel in the repos, I'm seeing the
>>> following oops when mounting xfs. rc2-ish kernels seem to be fine:
>>>
>>> [   64.669633] ------------[ cut here ]------------
>>> [   64.670008] kernel BUG at drivers/block/virtio_blk.c:172!
>>
>>
>> Hmm, that's:
>>
>>         BUG_ON(req->nr_phys_segments + 2 > vblk->sg_elems);
>>
>> But during our probe routine we said:
>>
>>         /* We can handle whatever the host told us to handle. */
>>         blk_queue_max_segments(q, vblk->sg_elems-2);
>>
>> Jens?
>
>
> Known, I'm afraid, Ming is looking into it.

There is one obvious bug which should have been fixed by below
patch(0001-block-blk-merge-fix-blk_recount_segments.patch"):

http://marc.info/?l=linux-virtualization&m=141562191719405&q=p3

And there might be another one, I appreciate someone can post
log which is printed by patch("blk-seg.patch") in below link if the
bug still can be triggered even with above fix:

http://marc.info/?l=linux-virtualization&m=141473040618467&q=p3


Thanks,
-- 
Ming Lei

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
