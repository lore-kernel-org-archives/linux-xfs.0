Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7F38C7F50
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 06:40:44 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 0DC74AC001
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 04:40:43 -0800 (PST)
Received: from cdptpa-oedge-vip.email.rr.com
	(cdptpa-outbound-snat.email.rr.com [107.14.166.226]) by
	cuda.sgi.com with ESMTP id J8f1o8MNAUCtmGwU for
	<xfs@oss.sgi.com>; Wed, 12 Feb 2014 04:40:39 -0800 (PST)
Date: Wed, 12 Feb 2014 07:40:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
Message-ID: <20140212074036.4c6105b5@gandalf.local.home>
In-Reply-To: <CA+55aFyp91=1seVT0ZV8T+GjOuafWvvjHNHn+MKGydsG+8eUEQ@mail.gmail.com>
References: <20140211210841.GM13647@dastard> <52FA9ADA.9040803@sandeen.net>
	<20140212004403.GA17129@redhat.com>
	<20140212010941.GM18016@ZenIV.linux.org.uk>
	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>
	<20140212040358.GA25327@redhat.com>
	<20140212042215.GN18016@ZenIV.linux.org.uk>
	<20140212054043.GB13997@dastard>
	<20140212055027.GA28502@redhat.com>
	<20140212061038.GC13997@dastard> <20140212063150.GD13997@dastard>
	<CA+55aFyp91=1seVT0ZV8T+GjOuafWvvjHNHn+MKGydsG+8eUEQ@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, Peter Zijlstra <peterz@infradead.org>, Eric Sandeen <sandeen@sandeen.net>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com, Al Viro <viro@zeniv.linux.org.uk>, Frederic Weisbecker <fweisbec@gmail.com>, Tejun Heo <tj@kernel.org>, Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@kernel.org>

[ Added the perf tracepoint maintainers ]

On Tue, 11 Feb 2014 22:59:58 -0800
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Tue, Feb 11, 2014 at 10:31 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > FYI, just creating lots of files with open(O_CREAT):
> >
> > [  348.718357] fs_mark (4828) used greatest stack depth: 2968 bytes left
> > [  348.769846] fs_mark (4814) used greatest stack depth: 2312 bytes left
> > [  349.777717] fs_mark (4826) used greatest stack depth: 2280 bytes left
> > [  418.139415] fs_mark (4928) used greatest stack depth: 1936 bytes left
> > [  460.492282] fs_mark (4993) used greatest stack depth: 1336 bytes left
> > [  544.825418] fs_mark (5104) used greatest stack depth: 1112 bytes left
> > [  689.503970] fs_mark (5265) used greatest stack depth: 1000 bytes left
> >
> > We've got absolutely no spare stack space anymore in the IO path.
> > And the IO path can't get much simpler than filesystem -> virtio
> > block device.
> 
> Ugh, that's bad. A thousand bytes of stack space is much too close to
> any limits.
> 
> Do you have the stack traces for these things so that we can look at
> worst offenders?
> 
> If the new block-mq code is to blame, it needs to be fixed.
> __virtblk_add_req() has a 300-byte stack frame, it seems. Looking
> elsewhere, blkdev_issue_discard() has 350 bytes of stack frame, but is
> hopefully not in any normal path - online discard is moronic, and I'm
> assuming XFS doesn't do that.
> 
> There's a lot of 200+ byte stack frames in block/blk-core.s, and they
> all seem to be of the type perf_trace_block_buffer() - things created
> with DECLARE_EVENT_CLASS(), afaik. Why they all have 200+ bytes of
> frame, I have no idea. That sounds like a potential disaster too,
> although hopefully it's mostly leaf functions - but leaf functions
> *deep* in the callchain. Tejun? Steven, why _do_ they end up with such
> huge frames?

The perf_trace_##event is defined in include/trace/ftrace.h.

There we have this:

perf_trace_##call(void *__data, proto)					\
{									\
	struct ftrace_event_call *event_call = __data;			\
	struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
	struct ftrace_raw_##call *entry;				\
	struct pt_regs __regs;						\
	u64 __addr = 0, __count = 1;					\
	struct task_struct *__task = NULL;				\
	struct hlist_head *head;					\
	int __entry_size;						\
	int __data_size;						\
	int rctx;							\
									\

Mostly pointers except for two structures. The __data_offests, is
dynamically defined, and only consists of values from the tracepoint
entry_structure that defines dynamic arrays. But the other structure on
the stack looks a bit harrier. The pt_regs structure.

That's what? 21 unsigned longs? 21 * 8 = 168. I think that's the
culprit here.

Peter and Frederic, is there a way not to store that on the stack?

-- Steve

> 
> And if the stack use comes from the VFS layer, we can probably work on
> that too. But I don't think that has really changed much lately..
> 
>                 Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
