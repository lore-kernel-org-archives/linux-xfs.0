Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 20:49:16 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6B3nAO5008688
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 20:49:11 -0700
Message-ID: <4876D872.2060408@sgi.com>
Date: Fri, 11 Jul 2008 13:50:10 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: deadlocked xfs
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com> <20080711032258.GB11558@disturbed>
In-Reply-To: <20080711032258.GB11558@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs-oss <xfs@oss.sgi.com>



Dave Chinner wrote:
> On Fri, Jul 11, 2008 at 12:48:11PM +1000, Mark Goodwin wrote:
>> Thanks for the report Eric. This looks very similar to a
>> deadlock Lachlan recently hit in the patch for
>> "Use atomics for iclog reference counting"
>> http://oss.sgi.com/archives/xfs/2008-02/msg00130.html
>>
>> It seems this patch can cause deadlocks under heavy log traffic.
>> I don't think anyone has a fix yet ... Lachlan is out this week,
>> but Tim can follow-up here ...
> 
> Nice to know - why didn't anyone email me or report this to the
> list when the bug was first found? I mean, I wrote that code, I know
> what it is supposed to be doing and as a result should be able

Only recently found and didn't think it was this easy to hit.
But no excuses ...

> help find and fix the bug. Can you please post what details you have
> about the problem (test case, stack traces, debugging info, etc)
> so I can try to find the problem.

See Tim's follow-up.

> This is a regression that is in the mainline kernel that is due to
> be released probably in the next couple of days. Having a little
> bit of time to try and find the bug would have been nice...

At this stage, I think it would be safest to back-out the commit,
all the way to mainline. Tim, can you please work thru that today
with priority.

Thanks

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
