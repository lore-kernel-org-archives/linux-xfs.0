Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 21:03:12 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N433AW018163
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:03:05 -0700
Message-ID: <4886ADB6.5060109@sgi.com>
Date: Wed, 23 Jul 2008 14:04:06 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com> <4886A9A3.8090805@sandeen.net>
In-Reply-To: <4886A9A3.8090805@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com



Eric Sandeen wrote:
> Mark Goodwin wrote:
>> Dave Chinner wrote:
>>> On Tue, Jul 22, 2008 at 03:27:33AM -0400, Christoph Hellwig wrote:
>>>> ...
>>>> I only fear
>>>> we'll never get it in with the current review and commit latencies
>>>> for XFS :(
>>> I can see this being a big issue in the not-too-distant future.....
>> [getting off-topic for this thread, but anyway ..]
>> This is already a big issue, obviously, and has been for some time.
>>
>> Internally, we're attempting to refine our patch acceptance processes,
>> (e.g. gitify our internal dev tree and mirror it on oss so it's much
>> easier to push back out to oss). But the QA overhead remains a stubborn
>> problem. I think we're going to have to ask for QA tests (both regression
>> and performance) to be written as part of the patch acceptance policy -
>> under this policy, merely passing existing QA will not be sufficient.
>> Comments?
> 
> I think that'll depend very much on what the change is.  For new
> functionality, sounds good; for bugfixes with testcases, sounds good.

and for cleanups, just run existing QA (new test wouldn't normally make 
sense).

> For general algorithm improvements... how do you write a new QA test for
> "Use the inode tree for finding dirty inodes?"

Case by case basis I guess. e.g. write a test that exercises or stresses
the changed algorithm or functionality, especially corner cases (low
space, full AGs, mem pressure, whatever). Performance regression testing
is trickier - need access to suitable h/w and the historical data; so it's
probably best run on dedicated h/w every night against the dev tree.

> Or for that matter, my
> remaining 2 shouting-removal patches ;)

As above, just run QA for cleanups.

> 
>> We have recently set up external access to a system for QA and
>> regression testing for Christoph's use .. perhaps that should
>> be a permanent offering?
> 
> Sounds awesome, for serious contributors.  I'd be happy to use it, too ;)
> 
> -Eric
> 
> 

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
