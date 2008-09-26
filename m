Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 18:36:59 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q1awt2016678
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 18:36:58 -0700
Message-ID: <48DC3D13.1010805@sgi.com>
Date: Fri, 26 Sep 2008 11:38:27 +1000
From: Peter Leckie <pleckie@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <20080926003401.GG27997@disturbed> <48DC3BBB.4080807@sgi.com>
In-Reply-To: <48DC3BBB.4080807@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
Cc: xfs@oss.sgi.com, xfs-dev@sgi.com

Lachlan McIlroy wrote:
> The underlying problem has nothing to do with xfs_qm_dqflush() - the
> spurious wakeups are caused by calls to wake_up_process() that 
> arbitrarily
> wake up a process that is in a state where it shouldn't be woken up.  If
> we don't fix the spurious wakeups then we could easily re-introduce this
> problem again.  If xfs_qm_dqflush() should be non-blocking then that's a
> separate change and it sounds like a good change too.
Ok so what do we want to do. It almost sounds like there are 3 issues I 
need to solve,
first clean up the code, second make xfs_qm_dqflush() non blocking, and 3ed
fix up the spurious wakeups.

Should I propose 3 patches to fix each of these issues?

Pete
