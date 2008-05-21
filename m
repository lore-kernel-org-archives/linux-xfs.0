Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 00:01:14 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L7153F000606
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 00:01:06 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] streamline init/exit path
References: <20080518130511.GA28501@lst.de> <nccprrg32vr.fsf@sgi.com>
	<20080521060103.GA25003@lst.de>
Date: Wed, 21 May 2008 17:01:51 +1000
In-Reply-To: <20080521060103.GA25003@lst.de> (Christoph Hellwig's message of
	"Wed, 21 May 2008 08:01:03 +0200")
Message-ID: <nccej7w2l9c.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig <hch@lst.de> writes:

> On Wed, May 21, 2008 at 10:41:12AM +1000, Niv Sardi wrote:
>> Looks good, appart from the fact that I don't see the point of merging
>> xfs_{init,destroy}_zones into xfs_{init,exit}, appart from clobbering it
>> and making it less readeable.
>> 
>> could be:
>> error = xfs_init_zones();
>> if (error)
>>       goto out;
>> 
>> and all the other error cases will end with
>> xfs_destroy_zones();
>> 
>> That would look much more like the rest of the calls in these functions.
>
> I don't really see the point for splitting this up, it's not like it
> makes the initialization much simpler.  But hey, if that's the only
> objection I can changed it.

it's not splitting it up, just leaving it split up like it was, reduces
the function length, reduces the out: gotos, and makes it nicely fit in
one editor window =)

> At least someone is looking at my xfs patches :)

Cheers =)
-- 
Niv Sardi
