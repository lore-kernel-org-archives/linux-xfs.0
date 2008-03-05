Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 05 Mar 2008 12:43:13 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m25KgpLi000435
	for <xfs@oss.sgi.com>; Wed, 5 Mar 2008 12:42:54 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 76594659C06
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2008 12:43:19 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id YofWkuE0wJW3BIa2 for <xfs@oss.sgi.com>; Wed, 05 Mar 2008 12:43:19 -0800 (PST)
Message-ID: <47CF05E5.90409@sandeen.net>
Date: Wed, 05 Mar 2008 14:43:17 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: TAKE 977545 - xfsaild causing too many wakeups
References: <20080222041525.37EA858C4C0F@chook.melbourne.sgi.com>
In-Reply-To: <20080222041525.37EA858C4C0F@chook.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

David Chinner wrote:
> xfsaild causing too many wakeups
> 
> Idle state is not being detected properly by the xfsaild push code.
> The current idle state is detected by an empty list which may never
> happen with mostly idle filesystem or one using lazy superblock
> counters. A single dirty item in the list that exists beyond the
> push target can result repeated looping attempting to push
> up to the target because it fails to check if the push target
> has been acheived or not.
> 
> Fix by considering a dirty list with everything past the target
> as an idle state and set the timeout appropriately.

Will this go to 2.6.25?

-Eric
