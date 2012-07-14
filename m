Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6E4RQmw227691 for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 23:27:27 -0500
Received: from mail-wg0-f41.google.com (mail-wg0-f41.google.com
	[74.125.82.41]) by cuda.sgi.com with ESMTP id fqpD4xtHezuUir1H
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 13 Jul 2012 21:27:25 -0700 (PDT)
Received: by wgbds1 with SMTP id ds1so1076166wgb.2
	for <xfs@oss.sgi.com>; Fri, 13 Jul 2012 21:27:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1341859315-17759-1-git-send-email-tj@kernel.org>
	<1341859315-17759-6-git-send-email-tj@kernel.org>
	<20120714035538.GB5638@dhcp-172-17-108-109.mtv.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Jul 2012 21:27:03 -0700
Message-ID: <CA+55aFyeauqCqrWsx4U2TB2ENrugZXYj+4vw3Fd0kGaeWBP3RA@mail.gmail.com>
Subject: Re: [PATCH 5/6] workqueue: introduce NR_WORKER_POOLS and
	for_each_worker_pool()
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
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, elder@kernel.org, rni@google.com, martin.petersen@oracle.com, linux-bluetooth@vger.kernel.org, gustavo@padovan.org, marcel@holtmann.org, linux-kernel@vger.kernel.org, vwadekar@nvidia.com, swhiteho@redhat.com, herbert@gondor.hengli.com.au, bpm@sgi.com, linux-crypto@vger.kernel.org, xfs@oss.sgi.com, joshhunt00@gmail.com, davem@davemloft.net, vgoyal@redhat.com, johan.hedberg@gmail.com

Seeing code like this

+       return &(*nr_running)[0];

just makes me go "WTF?"

Why are you taking the address of something you just dereferenced (the
"& [0]" part).

And you actually do that *twice*, except the inner one is more
complicated. When you assign nr_runing, you take the address of it, so
the "*nr_running" is actually just the same kind of odd thing (except
in reverse - you take dereference something you just took the
address-of).

Seriously, this to me is a sign of *deeply* confused code. And the
fact that your first version of that code was buggy *EXACTLY* due to
this confusion should have made you take a step back.

As far as I can tell, what you actually want that function to do is:

  static atomic_t *get_pool_nr_running(struct worker_pool *pool)
  {
    int cpu = pool->gcwq->cpu;

    if (cpu != WORK_CPU_UNBOUND)
        return per_cpu(pool_nr_running, cpu);

    return unbound_pool_nr_running;
  }

Notice how there isn't an 'address-of' operator anywhere in sight
there. Those things are arrays, they get turned into "atomic_t *"
automatically. And there isn't a single dereference (not a '*', and
not a "[0]" - they are the exact same thing, btw) in sight either.

What am I missing? Are there some new drugs that all the cool kids
chew that I should be trying? Because I really don't think the kinds
of insane "take the address of a dereference" games are a good idea.
They really look to me like somebody is having a really bad drug
experience.

I didn't test the code, btw. I just looked at the patch and went WTF.

                Linus

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
