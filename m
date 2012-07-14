Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6E4ijaX229117 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 23:44:45 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id 3LX1fFmF0wz3W08j
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Jul 2012 21:44:44 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so8183453pbb.26
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 21:44:43 -0700 (PDT)
Date: Fri, 13 Jul 2012 21:44:38 -0700
From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/6] workqueue: introduce NR_WORKER_POOLS and
	for_each_worker_pool()
Message-ID: <20120714044438.GA7718@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-6-git-send-email-tj@kernel.org>
	<20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
	<CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, gustavo@padovan.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Hello, Linus.

On Fri, Jul 13, 2012 at 09:27:03PM -0700, Linus Torvalds wrote:
> Seeing code like this
> 
> +       return &(*nr_running)[0];
> 
> just makes me go "WTF?"

I was going WTF too.  This was the smallest fix and I wanted to make
it minimal because there's another stack of patches on top of it.
Planning to just fold nr_running into worker_pool afterwards which
will remove the whole function.

> Why are you taking the address of something you just dereferenced (the
> "& [0]" part).

nr_running is atomic_t (*nr_running)[2].  Ignoring the pointer to
array part, it's just returning the address of N'th element of the
array.  ARRAY + N == &ARRAY[N].

> And you actually do that *twice*, except the inner one is more
> complicated. When you assign nr_runing, you take the address of it, so
> the "*nr_running" is actually just the same kind of odd thing (except
> in reverse - you take dereference something you just took the
> address-of).
> 
> Seriously, this to me is a sign of *deeply* confused code. And the
> fact that your first version of that code was buggy *EXACTLY* due to
> this confusion should have made you take a step back.

Type-wise, I don't think it's confused.  Ah okay, you're looking at
the fifth patch in isolation.  Upto this point, the index is always 0.
I'm puttin it in as a placeholder for the next patch which makes use
of non-zero index.  This patch is supposed to prepare everything for
multiple pools and thus non-zero index.

> As far as I can tell, what you actually want that function to do is:
> 
>   static atomic_t *get_pool_nr_running(struct worker_pool *pool)
>   {
>     int cpu = pool->gcwq->cpu;
> 
>     if (cpu != WORK_CPU_UNBOUND)
>         return per_cpu(pool_nr_running, cpu);
> 
>     return unbound_pool_nr_running;
>   }

More like the folloiwng in the end.

static atomic_t *get_pool_nr_running(struct worker_pool *pool)
{
	int cpu = pool->gcwq->cpu;
	int is_highpri = pool_is_highpri(pool);

	if (cpu != WORK_CPU_UNBOUND)
		return &per_cpu(pool_nr_running, cpu)[is_highpri];

	return &unbound_pool_nr_running[is_highpri];
}

> I didn't test the code, btw. I just looked at the patch and went WTF.

Eh... yeah, with or without [2], this is WTF.  I'll just refresh it
with the above version.

Thanks.

-- 
tejun

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
