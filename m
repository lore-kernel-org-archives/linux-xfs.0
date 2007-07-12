Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jul 2007 09:45:10 -0700 (PDT)
Received: from lucidpixels.com (lucidpixels.com [75.144.35.66])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6CGhrbm029577
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 09:43:55 -0700
Date: Thu, 12 Jul 2007 12:43:56 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: xfsqa 144 is failing now
In-Reply-To: <20070712150431.GA3763@infradead.org>
Message-ID: <Pine.LNX.4.64.0707121243470.28925@p34.internal.lan>
References: <20070712150431.GA3763@infradead.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com



On Thu, 12 Jul 2007, Christoph Hellwig wrote:

> I'm trying to fix up dmapi for the patch that uses filldir internally,
> and 144 is the xfsqa test for this functionality.  It worked fine a
> few weeks ago when I started that work but fails with plain TOT linux-xfs
> now with errors like:
>
>
> < report: get #0 had no errors.
> < report: get #1 had no errors.
> ---
>> ERROR: get #0, expected mode 35034, but found 33188
>> ERROR: get #0, expected uid -756063452, but found 0
>> ERROR: get #0, expected gid 323693819, but found 0
>> ERROR: get #0, expected mtime -424339458, but found 1184248449
>> ERROR: get #0, expected ctime -862739105, but found 1184248449
>> ERROR: get #0, expected dtime -862739105, but found 1184248449
>> ERROR: get #0, expected size 1125898004553757, but found 29696
>> report: 1 tests correct for get #0.
>> ERROR: get #1, expected mode 34544, but found 33188
>> ERROR: get #1, expected uid -1407127963, but found 0
>> ERROR: get #1, expected gid 1043573623, but found 0
>> ERROR: get #1, expected mtime -1589334486, but found
>
> does anyone have an idea what might be causing this?
>
> The only recent changes to xfs_dm.c are the hole punching fixes which
> seem rather unrelated.
>
>

Curious, what do you use that utilizes DMAPI?
