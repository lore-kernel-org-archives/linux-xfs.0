Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 04:29:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8QBT68Z001722
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 04:29:06 -0700
Date: Fri, 26 Sep 2008 07:30:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080926113041.GC3287@infradead.org>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <20080926003401.GG27997@disturbed> <48DC3BBB.4080807@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC3BBB.4080807@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Fri, Sep 26, 2008 at 11:32:43AM +1000, Lachlan McIlroy wrote:
>> but it doesn't fix the underlying problem that was causing the
>> spurious wakeups, which is the fact that xfs_qm_dqflush() is not
>> obeying non-blocking flush directions.
> The underlying problem has nothing to do with xfs_qm_dqflush() - the
> spurious wakeups are caused by calls to wake_up_process() that arbitrarily
> wake up a process that is in a state where it shouldn't be woken up.  If
> we don't fix the spurious wakeups then we could easily re-introduce this
> problem again.  If xfs_qm_dqflush() should be non-blocking then that's a
> separate change and it sounds like a good change too.

That sounds like there is one single underlying problem, but there
isn't.  The first problem was that we didn't re-check the condition
after sv_wait.  We must always do this, if only for robustness reasons.
The second problem we have here is that xfssyncd blocks when flushing
quotas.
