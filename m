Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8B5107F50
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 01:00:00 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6DAF28F8050
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 23:00:00 -0800 (PST)
Received: from mail-ve0-f176.google.com (mail-ve0-f176.google.com
	[209.85.128.176]) by cuda.sgi.com with ESMTP id
	Tt7o5wqedPtAGUCq (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 11 Feb 2014 22:59:59 -0800 (PST)
Received: by mail-ve0-f176.google.com with SMTP id oz11so7004390veb.35
	for <xfs@oss.sgi.com>; Tue, 11 Feb 2014 22:59:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140212063150.GD13997@dastard>
References: <20140211210841.GM13647@dastard> <52FA9ADA.9040803@sandeen.net>
	<20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<20140212055027.GA28502@redhat.com>
	<20140212061038.GC13997@dastard> <20140212063150.GD13997@dastard>
Date: Tue, 11 Feb 2014 22:59:58 -0800
Message-ID: <CA+55aFyp91=1seVT0ZV8T+GjOuafWvvjHNHn+MKGydsG+8eUEQ@mail.gmail.com>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
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
To: Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Dave Jones <davej@redhat.com>, xfs@oss.sgi.com, Eric Sandeen <sandeen@sandeen.net>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel <linux-kernel@vger.kernel.org>

On Tue, Feb 11, 2014 at 10:31 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> FYI, just creating lots of files with open(O_CREAT):
>
> [  348.718357] fs_mark (4828) used greatest stack depth: 2968 bytes left
> [  348.769846] fs_mark (4814) used greatest stack depth: 2312 bytes left
> [  349.777717] fs_mark (4826) used greatest stack depth: 2280 bytes left
> [  418.139415] fs_mark (4928) used greatest stack depth: 1936 bytes left
> [  460.492282] fs_mark (4993) used greatest stack depth: 1336 bytes left
> [  544.825418] fs_mark (5104) used greatest stack depth: 1112 bytes left
> [  689.503970] fs_mark (5265) used greatest stack depth: 1000 bytes left
>
> We've got absolutely no spare stack space anymore in the IO path.
> And the IO path can't get much simpler than filesystem -> virtio
> block device.

Ugh, that's bad. A thousand bytes of stack space is much too close to
any limits.

Do you have the stack traces for these things so that we can look at
worst offenders?

If the new block-mq code is to blame, it needs to be fixed.
__virtblk_add_req() has a 300-byte stack frame, it seems. Looking
elsewhere, blkdev_issue_discard() has 350 bytes of stack frame, but is
hopefully not in any normal path - online discard is moronic, and I'm
assuming XFS doesn't do that.

There's a lot of 200+ byte stack frames in block/blk-core.s, and they
all seem to be of the type perf_trace_block_buffer() - things created
with DECLARE_EVENT_CLASS(), afaik. Why they all have 200+ bytes of
frame, I have no idea. That sounds like a potential disaster too,
although hopefully it's mostly leaf functions - but leaf functions
*deep* in the callchain. Tejun? Steven, why _do_ they end up with such
huge frames?

And if the stack use comes from the VFS layer, we can probably work on
that too. But I don't think that has really changed much lately..

                Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
