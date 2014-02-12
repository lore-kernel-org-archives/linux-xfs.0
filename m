Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A4E987F54
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 09:57:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6E8008F8039
	for <xfs@oss.sgi.com>; Wed, 12 Feb 2014 07:57:57 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id UKbTF0wX7WFq8UyG for <xfs@oss.sgi.com>;
	Wed, 12 Feb 2014 07:57:55 -0800 (PST)
Message-ID: <52FB9A01.8060601@sandeen.net>
Date: Wed, 12 Feb 2014 09:57:53 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: 3.14-rc2 XFS backtrace because irqs_disabled.
References: <20140211172707.GA1749@redhat.com>
	<20140211210841.GM13647@dastard>	<52FA9ADA.9040803@sandeen.net>
	<20140212004403.GA17129@redhat.com>	<20140212010941.GM18016@ZenIV.linux.org.uk>	<CA+55aFwoWT-0A_KTkXMkNqOy8hc=YmouTMBgWUD_z+8qYPphjA@mail.gmail.com>	<20140212040358.GA25327@redhat.com>	<20140212042215.GN18016@ZenIV.linux.org.uk>	<20140212054043.GB13997@dastard>	<20140212055027.GA28502@redhat.com>
	<20140212061038.GC13997@dastard>
In-Reply-To: <20140212061038.GC13997@dastard>
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
To: Dave Chinner <david@fromorbit.com>, Dave Jones <davej@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On 2/12/14, 12:10 AM, Dave Chinner wrote:
> On Wed, Feb 12, 2014 at 12:50:27AM -0500, Dave Jones wrote:
>> On Wed, Feb 12, 2014 at 04:40:43PM +1100, Dave Chinner wrote:
>>
>>  > None of the XFS code disables interrupts in that path, not does is
>>  > call outside XFS except to dispatch IO. The stack is pretty deep at
>>  > this point and I know that the standard (non stacked) IO stack can
>>  > consume >3kb of stack space when it gets down to having to do memory
>>  > reclaim during GFP_NOIO allocation at the lowest level of SCSI
>>  > drivers. Stack overruns typically show up with symptoms like we are
>>  > seeing.
>>  > ..
>>  > 
>>  > Dave, before chasing ghosts, can you (like Eric originally asked)
>>  > turn on stack overrun detection?
>>
>> CONFIG_DEBUG_STACKOVERFLOW ? Already turned on.
> 
> That only checks stack usage when an interrupt is taken. If no
> interrupts are taken when stack usage is within 128 bytes of
> overflow, then it doesn't catch it.
> 
> I tend to use CONFIG_DEBUG_STACK_USAGE=y as it records the maximum
> stack usage of a process via canary overwrites and it records it in
> do_exit(). I also use the stack tracer to record the largest stack
> usage seen so I know exactly what code paths are approaching stack
> overruns...
> 
> Cheers,
> 
> Dave.
> 


I'm not sure if I'm off base here, but maybe this would make sense: check
for a corrupted stack in __might_sleep.  Compile tested only,
possibly inelegant, and/or completely wrong, but:


From: Eric Sandeen <sandeen@redhat.com>

sched: Test for corrupted task_struct in __might_sleep

If a thread overruns the stack, it may corrupt the task_struct,
leading to false positives on tests like irqs_disabled().

Warn if this seems to be the case.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b46131e..6920c3c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6934,6 +6934,8 @@ static inline int preempt_count_equals(int preempt_offset)
 
 void __might_sleep(const char *file, int line, int preempt_offset)
 {
+	struct task_struct *tsk = current;
+	unsigned long *stackend;
 	static unsigned long prev_jiffy;	/* ratelimiting */
 
 	rcu_sleep_check(); /* WARN_ON_ONCE() by default, no rate limit reqd. */
@@ -6952,6 +6954,11 @@ void __might_sleep(const char *file, int line, int preempt_offset)
 			in_atomic(), irqs_disabled(),
 			current->pid, current->comm);
 
+	/* A corrupted stack can cause a false positive on irqs_disabled etc */
+	stackend = end_of_stack(tsk);
+	if (tsk != &init_task && *stackend != STACK_END_MAGIC)
+		printk(KERN_EMERG "Thread overran stack, or stack corrupted\n");
+	
 	debug_show_held_locks(current);
 	if (irqs_disabled())
 		print_irqtrace_events(current);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
