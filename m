Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 04:21:32 -0700 (PDT)
Received: from kernel.dk (brick.kernel.dk [80.160.20.94])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5FBLPWt022667
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2007 04:21:27 -0700
Date: Fri, 15 Jun 2007 13:21:37 +0200
From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: always requeue !fs requests at the front
Message-ID: <20070615112137.GT6149@kernel.dk>
References: <200706020122.49989.rjw@sisk.pl> <46706968.7000703@dgreaves.com> <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org> <200706140115.58733.rjw@sisk.pl> <46714ECF.8080203@gmail.com> <46715A66.8030806@suse.de> <20070615094246.GN29122@htj.dyndns.org> <20070615110544.GR6149@kernel.dk> <20070615111728.GO29122@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070615111728.GO29122@htj.dyndns.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tejun Heo <htejun@gmail.com>
Cc: David Greaves <david@dgreaves.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linus Torvalds <torvalds@linux-foundation.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>, Jeff Garzik <jgarzik@pobox.com>

On Fri, Jun 15 2007, Tejun Heo wrote:
> SCSI marks internal commands with REQ_PREEMPT and push it at the front
> of the request queue using blk_execute_rq().  When entering suspended
> or frozen state, SCSI devices are quiesced using
> scsi_device_quiesce().  In quiesced state, only REQ_PREEMPT requests
> are processed.  This is how SCSI blocks other requests out while
> suspending and resuming.  As all internal commands are pushed at the
> front of the queue, this usually works.
> 
> Unfortunately, this interacts badly with ordered requeueing.  To
> preserve request order on requeueing (due to busy device, active EH or
> other failures), requests are sorted according to ordered sequence on
> requeue if IO barrier is in progress.
> 
> The following sequence deadlocks.
> 
> 1. IO barrier sequence issues.
> 
> 2. Suspend requested.  Queue is quiesced with part or all of IO
>    barrier sequence at the front.
> 
> 3. During suspending or resuming, SCSI issues internal command which
>    gets deferred and requeued for some reason.  As the command is
>    issued after the IO barrier in #1, ordered requeueing code puts the
>    request after IO barrier sequence.
> 
> 4. The device is ready to process requests again but still is in
>    quiesced state and the first request of the queue isn't
>    REQ_PREEMPT, so command processing is deadlocked -
>    suspending/resuming waits for the issued request to complete while
>    the request can't be processed till device is put back into
>    running state by resuming.
> 
> This can be fixed by always putting !fs requests at the front when
> requeueing.
> 
> The following thread reports this deadlock.
> 
>   http://thread.gmane.org/gmane.linux.kernel/537473
> 
> Signed-off-by: Tejun Heo <htejun@gmail.com>
> Cc: Jenn Axboe <jens.axboe@oracle.com>
> Cc: David Greaves <david@dgreaves.com>
> ---
> > Yep looks good, except for the bad multi-line comment style, but that's
> > minor stuff ;-)
> 
> That's how Jeff likes it in libata and my fingers are hardcoded to it,
> but I do appreciate the paramount importance of each maintainer's
> right to his/her own comment style, so here's the respinned patch.  :-)

Thanks a lot! I'll pass it right on for 2.6.22.

-- 
Jens Axboe
