Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 16 Oct 2008 17:13:15 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9H0DC09014214
	for <xfs@oss.sgi.com>; Thu, 16 Oct 2008 17:13:12 -0700
Message-ID: <48F7E6CB.1010502@sgi.com>
Date: Fri, 17 Oct 2008 11:13:47 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: another problem with latest code drops
References: <48F6A19D.9080900@sgi.com> <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com> <20081016072019.GH25906@disturbed> <48F6FCB7.6050905@sgi.com> <20081016090805.GA32101@infradead.org>
In-Reply-To: <20081016090805.GA32101@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Thu, Oct 16, 2008 at 06:35:03PM +1000, Lachlan McIlroy wrote:
>> I'm not seeing a leak in that slab - actually that slab doesn't even
>> show up.  I am seeing a lot of memory used here though:
> 
> Are you using slab or slub?  The latter merges caches of equal size, so
> it's totally useless for the kind of debug stats Dave looked at.
> 
It's slub.
