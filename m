Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 13 Jul 2008 21:12:01 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6E4BwUr015488
	for <xfs@oss.sgi.com>; Sun, 13 Jul 2008 21:11:58 -0700
Date: Mon, 14 Jul 2008 00:13:03 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs leaking?
Message-ID: <20080714041303.GA5040@infradead.org>
References: <4877928A.1020008@sandeen.net> <20080711233832.GH11558@disturbed> <4877FC4F.7020906@sandeen.net> <487810BE.5050701@sandeen.net> <487AD102.9020306@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <487AD102.9020306@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>

On Mon, Jul 14, 2008 at 02:07:30PM +1000, Mark Goodwin wrote:
>
>
> Eric Sandeen wrote:
>>
>> 2.6.26-rc9 passed without incident.
>
> So what is the conclusion here? Because you just down-rev? Or do we have
> an intermittent leak of some kind?

The symptoms in the first post look like an inode leak, which is more
likely to be in common code than in XFS.  I'd expect -rc9 just fixed it
or Eric didn't manage to hit it as easily.
