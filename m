Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 10:09:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3KH90qd009300
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 10:09:04 -0700
Received: from QMTA04.westchester.pa.mail.comcast.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5EF1AB749A
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 10:09:38 -0700 (PDT)
Received: from QMTA04.westchester.pa.mail.comcast.net (qmta04.westchester.pa.mail.comcast.net [76.96.62.40]) by cuda.sgi.com with ESMTP id u1Rzx8CbX7arZdSF for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 10:09:38 -0700 (PDT)
Date: Sun, 20 Apr 2008 09:59:39 -0700
From: Chris Wedgwood <cw@f00f.org>
Subject: Re: x86: 4kstacks default
Message-ID: <20080420165939.GB7963@puku.stupidest.org>
References: <200804181737.m3IHbabI010051@hera.kernel.org> <20080418142934.38ce6bf4.akpm@linux-foundation.org> <20080419142329.GA5339@elte.hu> <6101e8c40804190735g17f1e0bj25c2bc0e2a6eac26@mail.gmail.com> <20080419151911.GB1595@cs181133002.pp.htv.fi> <480AA2B9.10305@sandeen.net> <20080420074228.GE1595@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080420074228.GE1595@cs181133002.pp.htv.fi>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Adrian Bunk <bunk@kernel.org>
Cc: Eric Sandeen <sandeen@sandeen.net>, Oliver Pinter <oliver.pntr@gmail.com>, Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@infradead.org>, David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Sun, Apr 20, 2008 at 10:42:28AM +0300, Adrian Bunk wrote:

> We are going from 6k to 4k.

6k?

> Why should users have to poke with such deeply internal things?
> That doesn't sound right.

they shouldn't, so a 4k default is a problem for them

> Excessive stack usage in the kernel is considered to be a bug.

define excessive

> We should identify and fix all remaining problems (if any).

let's see your patches then
