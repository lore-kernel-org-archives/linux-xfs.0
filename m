Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 04:48:30 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3KBm4Xk021177
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 04:48:08 -0700
Received: from smtp-out03.alice-dsl.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA2BF786D73
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 04:48:45 -0700 (PDT)
Received: from smtp-out03.alice-dsl.net (smtp-out03.alice-dsl.net [88.44.63.5]) by cuda.sgi.com with ESMTP id RNWkPQXNVqEl8nWQ for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 04:48:45 -0700 (PDT)
Subject: Re: x86: 4kstacks default
From: Andi Kleen <andi@firstfloor.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org>
	<20080418142934.38ce6bf4.akpm@linux-foundation.org>
	<20080419142329.GA5339@elte.hu>
	<6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com>
	<20080419151911.GB1595@cs181133002.pp.htv.fi>
	<480AA2B9.10305__23983.3358479247$1208657639$gmane$org@sandeen.net>
Date: Sun, 20 Apr 2008 13:48:40 +0200
In-Reply-To: <480AA2B9.10305__23983.3358479247$1208657639$gmane$org@sandeen.net> (Eric Sandeen's message of "Sat, 19 Apr 2008 20:56:09 -0500")
Message-ID: <87abjobvc7.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Adrian Bunk <bunk@kernel.org>, Oliver Pinter <oliver.pntr@gmail.com>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

Eric Sandeen <sandeen@sandeen.net> writes:

> Adrian Bunk wrote:
>> On Sat, Apr 19, 2008 at 04:35:31PM +0200, Oliver Pinter wrote:
>>> ...
>>> with the older kernel is typical: xfs+nfs+4k stack(+lvm)
>> 
>> Does anyone still experience problems with 2.6.25?
>
> There are always problems.  You can always come up with something that
> will crash in 4k, IMHO.

But what are a few crashes compared against the ability to run 50000
kernel threads on a 32bit machine? Something has to give in the aim
for useless checkbox numbers after all. 

-Andi
