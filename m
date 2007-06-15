Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Jun 2007 08:57:24 -0700 (PDT)
Received: from mail.dvmed.net (srv5.dvmed.net [207.36.208.214])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5FFvIWt031102
	for <xfs@oss.sgi.com>; Fri, 15 Jun 2007 08:57:20 -0700
Message-ID: <4672AB7F.7030702@garzik.org>
Date: Fri, 15 Jun 2007 11:08:47 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
Subject: Re: [PATCH] block: always requeue !fs requests at the front
References: <200706020122.49989.rjw@sisk.pl> <46706968.7000703@dgreaves.com> <alpine.LFD.0.98.0706131507360.14121@woody.linux-foundation.org> <200706140115.58733.rjw@sisk.pl> <46714ECF.8080203@gmail.com> <46715A66.8030806@suse.de> <20070615094246.GN29122@htj.dyndns.org> <20070615110544.GR6149@kernel.dk> <20070615111728.GO29122@htj.dyndns.org>
In-Reply-To: <20070615111728.GO29122@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Greaves <david@dgreaves.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linus Torvalds <torvalds@linux-foundation.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>, linux-pm <linux-pm@lists.osdl.org>, Neil Brown <neilb@suse.de>

Tejun Heo wrote:
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

Acked-by: Jeff Garzik <jeff@garzik.org>

Thanks Tejun, you kick ass as usual.

	Jeff
