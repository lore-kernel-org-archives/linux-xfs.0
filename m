Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 19 Dec 2007 03:17:59 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id lBJBHp7D028797
	for <linux-xfs@oss.sgi.com>; Wed, 19 Dec 2007 03:17:54 -0800
Received: from mallaury.nerim.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4389549D615
	for <linux-xfs@oss.sgi.com>; Wed, 19 Dec 2007 03:18:03 -0800 (PST)
Received: from mallaury.nerim.net (smtp-103-wednesday.noc.nerim.net [62.4.17.103]) by cuda.sgi.com with ESMTP id lq50nRIUnsl80SVz for <linux-xfs@oss.sgi.com>; Wed, 19 Dec 2007 03:18:03 -0800 (PST)
From: Damien Wyart <damien.wyart@free.fr>
Subject: Re: Important regression with XFS update for 2.6.24-rc6
References: <20071218112804.GA3069@localhost.localdomain>
	<20071218122445.GJ4396912@sgi.com> <877ijckrco.fsf@free.fr>
	<20071218151946.GQ4396912@sgi.com> <20071219104544.GC4612@sgi.com>
Date: Wed, 19 Dec 2007 12:17:30 +0100
In-Reply-To: <20071219104544.GC4612@sgi.com> (David Chinner's message of "Wed,
	19 Dec 2007 21:45:44 +1100")
Message-ID: <87r6hjaq7p.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Lachlan McIlroy <lachlan@sgi.com>, Peter Leckie <pleckie@sgi.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

* David Chinner <dgc@sgi.com> [071219 11:45]:
> Can someone pass me a brown paper bag, please?

My first impression on this bug was not so wrong, after all ;-)

> That also explains why we haven't seen it - it requires the user
> buffer to fill on the first entry of a backing buffer and so it is
> largely dependent on the pattern of name lengths, page size and
> filesystem block size aligning just right to trigger the problem.

I guess I was lucky to trigger it quite easily...

> Can you test this patch, Damien?

Works fine, all the bad symptoms have disappeared and strace output is
normal.

So you can add:

Tested-by: Damien Wyart <damien.wyart@free.fr>

-- 
Damien
