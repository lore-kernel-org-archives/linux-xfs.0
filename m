Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 09 Aug 2007 23:08:54 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7A68ibm014782
	for <xfs@oss.sgi.com>; Thu, 9 Aug 2007 23:08:47 -0700
Message-ID: <46BC00ED.1010201@sgi.com>
Date: Fri, 10 Aug 2007 16:08:45 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: REVIEW:  fix xfs_repair phase 4 ag_stride with prefetch
References: <op.twgq8w1a3jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.twgq8w1a3jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:
> 
> AG stride testing was performed on a system with ample amounts
> of memory, so prefetching with AG stride during Phase 4 was
> missed. The attached patch fixes this.
> 
> 32 AGs, ag_stride = 4:
> 
> Phase 3 - for each AG...
>         - scan and clear agi unlinked lists...
>         - process known inodes and perform inode discovery...
>         - agno = 0
>         - agno = 4
>         - agno = 8
>         - agno = 12
>         - agno = 16
>         - agno = 20
>         - agno = 24
>         - agno = 28
> 
> which is correct... but in Phase 4:
> 
> Phase 4 - check for duplicate blocks...
>         - setting up duplicate extent list...
>         - check for inodes claiming duplicate blocks...
>         - agno = 0
>         - agno = 1
>         - agno = 2
>         - agno = 5
>         - agno = 6
>         - agno = 4
>         - agno = 7
>         - agno = 3


Okay I replied to this in the bug but forgot about the review
email request so I will reply here too:)


==========================
ADDITIONAL INFORMATION (ADD)
From: timothy shimmin <tes@sgi.com>
Date: Aug 09 2007 10:59:01PM
[BugWorks mailnews processor v1.7.1]
==========================

bnaujok@sgi.com via BugWorks wrote:
 >
 > [ EXCESSIVE QUOTED TEXT DELETED ]
 >
 >         - 12:00:16: setting up duplicate extent list - 32 of 32 allocation groups done
 >         - check for inodes claiming duplicate blocks...
 >         - agno = 0
 >         - agno = 1
 >         - agno = 2
 >         - agno = 5
 >         - agno = 6
 >         - agno = 4
 >         - agno = 7
 >         - agno = 3

So you need to replicate the logic/code you used in phase 3 and put it
into phase4 I presume.

And the changes are in phase4.c/process_ags() (like in phase3.c/process_ags).

So previously it would iterate thru the thread-count and then
prefetch and queue up to the ag-count stepping by the ag-stride.

And now we go thru each AG but only do an ag-stride worth at a time for
a thread. So each thread will get an ag-stride worth of ags to deal with:

Fixed code:
Thread 0 - gets ag 0-3  (go thru a loop doing a fetch & queue work on ag 0-3)
Thread 1 - gets ag 4-7
Thread 2 - gets ag 8-11
etc...

Okay, starting to get it now :)

So previously (broken code) it would do:
Thread 0 - gets ag 0,4,8,12,16,...
Thread 1 - gets ag 1,5,9,13,17,...
Thread 2 - gets ag 2,6,10,14,18,...

I presume the bad phase 4 msgs above are coming out in a different order
than what I said above
just because of the threading. Or did I make a mistake in my reading
of the code.

Pity we couldn't share some code there between the phases but I haven't
looked to see the difficulties with that are - do tell me.
Would be nice to guarantee handling the striding/threading the same in both phases by
both using the same iterator code - particularly if it needs
to be changed in the future etc. But whatever.

And I presume the fix is so that the prefetching for a thread is done in
ag-order (and they are just given a chunks worth)
instead of the old bad way where the prefetching would be done with a jump
over AGs by the stride instead of in order.

So it looks fine if my understanding is correct.

Cheers,
Tim.
