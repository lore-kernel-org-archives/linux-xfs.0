Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AF45A7CA0
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 12:24:39 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 31EF6AC002
	for <xfs@oss.sgi.com>; Mon,  7 Mar 2016 10:24:36 -0800 (PST)
Received: from resqmta-ch2-10v.sys.comcast.net
	(resqmta-ch2-10v.sys.comcast.net [69.252.207.42]) by
	cuda.sgi.com with ESMTP id 5pRYTpvEPw02oiFb (version=TLSv1.2
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 Mar 2016 10:24:33 -0800 (PST)
Date: Mon, 7 Mar 2016 12:24:31 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC PATCH 1/2] percpu_counter: Allow falling back to global
	counter on large system
In-Reply-To: <1457146299-1601-2-git-send-email-Waiman.Long@hpe.com>
Message-ID: <alpine.DEB.2.20.1603071220470.1453@east.gentwo.org>
References: <1457146299-1601-1-git-send-email-Waiman.Long@hpe.com>
	<1457146299-1601-2-git-send-email-Waiman.Long@hpe.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Waiman Long <Waiman.Long@hpe.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Scott J Norton <scott.norton@hp.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, Douglas Hatch <doug.hatch@hp.com>, Dave Chinner <dchinner@redhat.com>, Tejun Heo <tj@kernel.org>

On Fri, 4 Mar 2016, Waiman Long wrote:

> This patch provides a mechanism to selectively degenerate per-cpu
> counters to global counters at per-cpu counter initialization time. The
> following new API is added:
>
>   percpu_counter_set_limit(struct percpu_counter *fbc,
>                            u32 percpu_limit)
>
> The function should be called after percpu_counter_set(). It will
> compare the total limit (nr_cpu * percpu_limit) against the current
> counter value.  If the limit is not smaller, it will disable per-cpu
> counter and use only the global counter instead. At run time, when
> the counter value grows past the total limit, per-cpu counter will
> be enabled again.

Hmmm... That is requiring manual setting of a limit. Would it not be
possible to completely automatize the switch over? F.e. one could
keep a cpumask of processors that use the per cpu counters.

Then in the fastpath if the current cpu is a member increment the per cpu
counter. If not do the spinlock thing. If there is contention add the
cpu to the cpumask and use the  per cpu counters. Thus automatically
scaling for the processors on which frequent increments are operating.

Then regularly (once per minute or so) degenerate the counter by folding
the per cpu diffs into the global count and zapping the cpumask.

If the cpumask is empty you can use the global count. Otherwise you just
need to add up the counters of the cpus set in the cpumask.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
