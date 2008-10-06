Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 05 Oct 2008 21:03:48 -0700 (PDT)
Received: from relay.sgi.com (netops-testserver-3.corp.sgi.com [192.26.57.72])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9643hst019108
	for <xfs@oss.sgi.com>; Sun, 5 Oct 2008 21:03:43 -0700
Message-ID: <48E990BA.3080306@sgi.com>
Date: Mon, 06 Oct 2008 14:14:50 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] XFS: Check for valid transaction headers in recovery
References: <1222218974-5161-1-git-send-email-david@fromorbit.com> <48D9AF0C.3050404@sandeen.net> <20080924034120.GG5448@disturbed>
In-Reply-To: <20080924034120.GG5448@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

Looks fine now Dave.

Dave Chinner wrote:
> On Tue, Sep 23, 2008 at 10:07:56PM -0500, Eric Sandeen wrote:
>> Dave Chinner wrote:
>>> When we are about to add a new item to a transaction in recovery,
>>> we need to check that it is valid first. Current we just assert
>>> that header magic number matches, but in production systems
>>> that is not done add a corrupted transaction to the list to be
>>> processed. This results in a kernel oops later when processing the
>>> corrupted transaction.
>>>
>>> Instead, if we detect a corrupted transaction, abort recovery and
>>> leave the user to clean up the mess that has occurred.
>>>
>>> Signed-off-by: Dave Chinner <david@fromorbit.com>
>> Seems fine to me (I guess you tried the provided corrupt image?)
> 
> Yes, I tried to mount it.
> 
>> but the
>> commit message could be made a bit more ... English ;)
> 
> Right. Updated patch (description) below ;)
> 
> Cheers,
> 
> Dave.
