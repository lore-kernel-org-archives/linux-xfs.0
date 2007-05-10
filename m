Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 May 2007 00:22:08 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4A7M2fB023732
	for <xfs@oss.sgi.com>; Thu, 10 May 2007 00:22:04 -0700
Date: Thu, 10 May 2007 17:25:28 +1000
From: Timothy Shimmin <tes@sgi.com>
Subject: Re: Review: unwritten extent conversion vs synchronous direct I/O
Message-ID: <0072C73B201FC2AD6A7E01D0@timothy-shimmins-power-mac-g5.local>
In-Reply-To: <20070510065153.GY85884050@sgi.com>
References: <20070508065126.GK32602149@melbourne.sgi.com>
 <AA27F76178127851854604F7@timothy-shimmins-power-mac-g5.local> <20070510065153.GY85884050@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

--On 10 May 2007 4:51:53 PM +1000 David Chinner <dgc@sgi.com> wrote:

> On Thu, May 10, 2007 at 04:11:01PM +1000, Timothy Shimmin wrote:
>> So you were tossing up whether to flush the queue as in the patch given
>> or to effectively call the code of xfs_end_bio_unwritten to
>> do the unwritten extent conversion straight away.
>> Hmmm....I dunno :)
>>  Does it matter? What are the pros and cons? :)
>
> I think with async buffered writes we are doing I/O completion in
> IRQ context as well so it seems to me that we have to push the
> unwritten extent conversion off to a workqueue in that case.
>
> I don't think there's any great overhead from flushing only when
> we are doing sync dio writes - all that calling
> xfs_end_bio_unwritten() directly saves us is a couple of context
> switches. However, that could promote I/o completion ahead of
> other I/Os waiting in the workqueue....

That's true.

>
> I think I'm convincing myself that the workqueue flush is the
> correct thing to do here ;)
:)

>
>
>>  Does it matter if we flush the whole queue now or later?
>
> We have to wait for it to complete, and that's what the flush does;
> it waits for the queued work up to the flush entrance sequence
> to complete. It's really the only way we can wait for a specific
> item in a workqueue to be run. So yes, it needs to be run now,
> not later.
>
I was meaning for any i/o's previously existing in the queue which didn't
need to do completion straight away - we are now handling those one's too.
Not that it may matter but was just trying to see any differences
in old behaviour.


--Tim
