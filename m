Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 19 Apr 2008 18:55:57 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3K1tU9F032762
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 18:55:33 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71CD01595CBC
	for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 18:56:11 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id E6rp8xopVMdpI6vT for <xfs@oss.sgi.com>; Sat, 19 Apr 2008 18:56:11 -0700 (PDT)
Message-ID: <480AA2B9.10305@sandeen.net>
Date: Sat, 19 Apr 2008 20:56:09 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: x86: 4kstacks default
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com> <20080419151911.GB1595@cs181133002.pp.htv.fi>
In-Reply-To: <20080419151911.GB1595@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Adrian Bunk <bunk@kernel.org>
Cc: Oliver Pinter <oliver.pntr@gmail.com>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Adrian Bunk wrote:
> On Sat, Apr 19, 2008 at 04:35:31PM +0200, Oliver Pinter wrote:
>> ...
>> with the older kernel is typical: xfs+nfs+4k stack(+lvm)
> 
> Does anyone still experience problems with 2.6.25?

There are always problems.  You can always come up with something that
will crash in 4k, IMHO.

Rather than foisting this upon everyone, I'd rather see work put into
making stack size a boot parameter or something, so that people can
choose what's appropriate for their workload (or their IO stack, if you
prefer).

-Eric

> We all know that there once were problems, but if there are any left 
> they should be reported and fixed.
> 
>> Thanks,
>> Oliver
> 
> cu
> Adrian
> 
