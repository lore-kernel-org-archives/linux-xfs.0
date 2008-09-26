Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 04:27:06 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8QBQxDY001024
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 04:26:59 -0700
Date: Fri, 26 Sep 2008 07:28:33 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] Use atomic_t and wait_event to track dquot pincount
Message-ID: <20080926112833.GB3287@infradead.org>
References: <48D9C1DD.6030607@sgi.com> <48D9EB8F.1070104@sgi.com> <48D9EF6E.8010505@sgi.com> <20080924074604.GK5448@disturbed> <48D9F718.4010905@sgi.com> <20080925010318.GB27997@disturbed> <48DB4F3F.8040307@sgi.com> <48DC3682.2030602@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48DC3682.2030602@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Peter Leckie <pleckie@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Fri, Sep 26, 2008 at 11:10:26AM +1000, Lachlan McIlroy wrote:
> Good work Pete.  We should also consider replacing all calls to
> wake_up_process() with wake_up() and a wait queue so we don't go
> waking up threads when we shouldn't be.

No.  The daemons should not block anyway in these places, and using
a waitqueue just causes additional locking overhead.
