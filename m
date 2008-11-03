Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 02 Nov 2008 16:43:40 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA30hRVI014684
	for <xfs@oss.sgi.com>; Sun, 2 Nov 2008 16:43:27 -0800
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 77E071BDB640
	for <xfs@oss.sgi.com>; Sun,  2 Nov 2008 16:43:28 -0800 (PST)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id WTSHkVNvKMTGmFS5 for <xfs@oss.sgi.com>; Sun, 02 Nov 2008 16:43:28 -0800 (PST)
Date: Mon, 3 Nov 2008 11:43:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 0/2] Urgent queue
Message-ID: <20081103004323.GL19509@disturbed>
References: <20081027133010.GA30607@infradead.org> <20081028064150.GS4985@disturbed> <4906EB5B.2020004@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4906EB5B.2020004@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Oct 28, 2008 at 09:37:15PM +1100, Mark Goodwin wrote:
>
>
> Dave Chinner wrote:
>> On Mon, Oct 27, 2008 at 09:30:10AM -0400, Christoph Hellwig wrote:
>>> Two patches that are small bugfixes / features that are what I consider the
>>> immediately merge queue.
>>
>> The entire set of 30 patches has passed XFSQA on my test box....
>
> individually (by series) or only after all 30? Bisectability is important,
> as Christoph alluded to in another thread.

All - there is no way in hell I'm going to run qa on each patch
individually given that most of them are trivial.

Bisectability is mainly about ensuring each patch builds
independently and at least runs without obvious problems.
Given most of the patches were independent, running QA over the
end series is usually sufficient to check that they will run
sufficiently well to do a bisect if they build.

That being said, given that I *have bisected* that series (to find
the directory corruption problem as a result of upgrading the
underlying kernel), I'd say it's just fine.

> Is the intention to try and take
> this lot for 28-rc3?

Just the urgent ones, I think. The rest are 2.6.29 candidates but
they still should be checked in and merged into the master branch so
that we can test them well before the .29 merge window comes
around...

> I think Lachlan is now very close to a pull req for
> .28, depending on his testing for the memleak and deadlock fixes - time
> is now getting pretty short :)

Given that 2.6.28-rc3 is now out, I have serious doubts that Linus
will take an update of this size. We've missed the merge window by
two weeks....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
