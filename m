Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 20:29:56 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9T3Th7H032364
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 20:29:43 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1FAC7556939
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 20:29:43 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 2AMMbTBbySg9VJ8m for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 20:29:43 -0700 (PDT)
Date: Wed, 29 Oct 2008 14:29:41 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: assertion failure with latest xfs
Message-ID: <20081029032941.GG4985@disturbed>
References: <49003EFF.4090404@sgi.com> <20081023173149.GA30316@infradead.org> <20081023222126.GA18495@disturbed> <4907B1B3.4020008@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4907B1B3.4020008@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 29, 2008 at 11:43:31AM +1100, Lachlan McIlroy wrote:
> Dave Chinner wrote:
>> Hmmmm - there's also another bug in xfs_iget_cache_hit() - we don't
>> drop the reference we got if we found an unlinked inode after the
>> igrab() (the ENOENT case). I'll fix that as well.
>>
>> Patch below that I'm currently running through xfsqa.
>
> I gave this patch a go and it still asserted at the same place running
> the same test.

Can you put more inode trace points in so that we can see where the
extra reference is coming from?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
