Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 525637CA0
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 20:58:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D1080AC004
	for <xfs@oss.sgi.com>; Thu, 17 Mar 2016 18:58:50 -0700 (PDT)
Received: from resqmta-ch2-06v.sys.comcast.net
	(resqmta-ch2-06v.sys.comcast.net [69.252.207.38]) by
	cuda.sgi.com with ESMTP id KHZTmH8P7bfbtEEu (version=TLSv1.2
	cipher=DHE-RSA-AES128-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 17 Mar 2016 18:58:48 -0700 (PDT)
Date: Thu, 17 Mar 2016 20:58:46 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
Subject: Re: [RFC PATCH 1/2] percpu_counter: Allow falling back to global
	counter on large system
In-Reply-To: <56E9B219.7090500@hpe.com>
Message-ID: <alpine.DEB.2.20.1603172058190.18714@east.gentwo.org>
References: <1457146299-1601-1-git-send-email-Waiman.Long@hpe.com>
	<1457146299-1601-2-git-send-email-Waiman.Long@hpe.com>
	<alpine.DEB.2.20.1603071220470.1453@east.gentwo.org>
	<56E9B219.7090500@hpe.com>
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
To: Waiman Long <waiman.long@hpe.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Scott J Norton <scott.norton@hp.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ingo Molnar <mingo@redhat.com>, Douglas Hatch <doug.hatch@hp.com>, Dave Chinner <dchinner@redhat.com>, Tejun Heo <tj@kernel.org>

On Wed, 16 Mar 2016, Waiman Long wrote:

> > If the cpumask is empty you can use the global count. Otherwise you just
> > need to add up the counters of the cpus set in the cpumask.
> >
>
> I have modified the patch to try that out. However, that doesn't yield that
> much of improvement in term of performance and it slows down the percpu fast
> path a bit. So I am going to focus on my existing patch first and think about
> that later.

Hmmm... Maybe look at the cause of the slowdown first?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
