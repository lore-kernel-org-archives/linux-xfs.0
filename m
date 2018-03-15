Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:49766 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752006AbeCOOpX (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 15 Mar 2018 10:45:23 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20180315115146.GX4064@hirez.programming.kicks-ass.net>
References: <20180315115146.GX4064@hirez.programming.kicks-ass.net> <20180313102056.GJ4043@hirez.programming.kicks-ass.net> <152066488891.40260.14605734226832760468.stgit@dwillia2-desk3.amr.corp.intel.com> <152066493247.40260.10849841915366086021.stgit@dwillia2-desk3.amr.corp.intel.com> <20180311112725.GC4043@hirez.programming.kicks-ass.net> <CAPcyv4jr53dqVTzdEQ6Ln1Qg7nWVMQSVTkf6uc+Lg6Y-xruhuw@mail.gmail.com> <3396.1521107922@warthog.procyon.org.uk>
Subject: Re: [RFC][PATCH] sched/wait_bit: Introduce wait_var_event()/wake_up_var()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <18970.1521125120.1@warthog.procyon.org.uk>
Date: Thu, 15 Mar 2018 14:45:20 +0000
Message-ID: <18971.1521125120@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Dan Williams <dan.j.williams@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@redhat.com>, Christoph Hellwig <hch@lst.de>, david <david@fromorbit.com>, linux-xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Ross Zwisler <ross.zwisler@linux.intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ralf Baechle <ralf@linux-mips.org>

Peter Zijlstra <peterz@infradead.org> wrote:

> Does the below address things sufficiently clear?

Yep.

> +wait_queue_head_t *__var_waitqueue(void *p)
> +{
> +	if (BITS_PER_LONG == 64) {
> +		unsigned long q = (unsigned long)p;
> +
> +		return bit_waitqueue((void *)(q & ~1), q & 1);
> +	}
> +	return bit_waitqueue(p, 0);
> +}

You might be better off not using bit_waitqueue() but rather do the
calculation directly since you don't actually have a bit number.

David
