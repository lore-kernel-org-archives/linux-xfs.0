Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 10 Jul 2008 21:17:44 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6B4HRJt014095
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:17:28 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8D671BB4C2F
	for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:18:32 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id lKIFkwKbKR1VCQ9I for <xfs@oss.sgi.com>; Thu, 10 Jul 2008 21:18:32 -0700 (PDT)
Message-ID: <4876DF17.9090904@sandeen.net>
Date: Thu, 10 Jul 2008 23:18:31 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: deadlocked xfs
References: <4876C667.608@sandeen.net> <4876C9EB.7060601@sgi.com> <4876D1C3.4000006@sgi.com> <20080711040447.GC11558@disturbed> <4876DD2D.2010903@sandeen.net> <4876DDE3.7020801@sgi.com>
In-Reply-To: <4876DDE3.7020801@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: markgw@sgi.com, xfs-oss <xfs@oss.sgi.com>

Timothy Shimmin wrote:
> Eric Sandeen wrote:
>> Dave Chinner wrote:
>>
>>> Patch for you to test, Eric, below.
>>>
>>> (I haven't been able to test it because UML panics on boot right now.
>>> I need to hoover in the unit-at-atime build patch that Jeff Dike
>>> posted this morning)
>>>
>>> Cheers,
>>>
>>> Dave.
>> Dave, you frighten me.
>>
>> Testing now, will let it run a while.
>>
> Excellent.
> 
> And it happened pretty reliably before, right?

It did, yep, though sometimes took a while.

But, w/ the patch it actually deadlocked really quickly (< 2000 inodes
written)

-Eric
