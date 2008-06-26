Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jun 2008 13:32:42 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5QKWWhR015386
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 13:32:34 -0700
Received: from gateway-1237.mvista.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E33DB182F6BB
	for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 13:33:31 -0700 (PDT)
Received: from gateway-1237.mvista.com (gateway-1237.mvista.com [63.81.120.158]) by cuda.sgi.com with ESMTP id OS0ZGckuG100V4js for <xfs@oss.sgi.com>; Thu, 26 Jun 2008 13:33:31 -0700 (PDT)
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
From: Daniel Walker <dwalker@mvista.com>
In-Reply-To: <1214455277-6387-2-git-send-email-david@fromorbit.com>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com>
	 <1214455277-6387-2-git-send-email-david@fromorbit.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 13:33:25 -0700
Message-Id: <1214512405.21035.110.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org


On Thu, 2008-06-26 at 14:41 +1000, Dave Chinner wrote:
> XFS object flushing doesn't quite match existing completion semantics.  It
> mixed exclusive access with completion. That is, we need to mark an object as
> being flushed before flushing it to disk, and then block any other attempt to
> flush it until the completion occurs.
> 
> To do this we introduce:
> 
> void init_completion_flush(struct completion *x)
> 	which initialises x->done = 1
> 
> void completion_flush_start(struct completion *x)
> 	which blocks if done == 0, otherwise decrements done to zero and
> 	allows the caller to continue.
> 
> bool completion_flush_start_nowait(struct completion *x)
> 	returns a failure status if done == 0, otherwise decrements done
> 	to zero and returns a "flush started" status. This is provided
> 	to allow flushing to begin safely while holding object locks in
> 	inverted order.
> 
> This replaces the use of semaphores for providing this exclusion
> and completion mechanism.

I think there is some basis to make the changes that you have here.
Specifically this email and thread,

http://lkml.org/lkml/2008/4/15/232

However, I don't like how your implementing this as specifically a
"flush" mechanism for XFS, and the count is limited to just 1 .. There
are several other places that do this kind of counting with semaphores,
and have counts above 1..

> +
> +static inline void completion_flush_start(struct completion *x)
> +{
> +	wait_for_completion(x);
> +}

Above seems completely pointless.. I would just call
wait_for_completion(), and make the rest of the interface generic.

Daniel
