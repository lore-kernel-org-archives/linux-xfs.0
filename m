Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 20:46:27 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N3kJ9D016082
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 20:46:19 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EB5273175D9
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 20:47:29 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id ABjBBvHPi4g7MXhw for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 20:47:29 -0700 (PDT)
Message-ID: <4886A9A3.8090805@sandeen.net>
Date: Tue, 22 Jul 2008 22:46:43 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com>
In-Reply-To: <488692FB.1010101@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Mark Goodwin wrote:
> 
> Dave Chinner wrote:
>> On Tue, Jul 22, 2008 at 03:27:33AM -0400, Christoph Hellwig wrote:
>>> ...
>>> I only fear
>>> we'll never get it in with the current review and commit latencies
>>> for XFS :(
>> I can see this being a big issue in the not-too-distant future.....
> 
> [getting off-topic for this thread, but anyway ..]
> This is already a big issue, obviously, and has been for some time.
> 
> Internally, we're attempting to refine our patch acceptance processes,
> (e.g. gitify our internal dev tree and mirror it on oss so it's much
> easier to push back out to oss). But the QA overhead remains a stubborn
> problem. I think we're going to have to ask for QA tests (both regression
> and performance) to be written as part of the patch acceptance policy -
> under this policy, merely passing existing QA will not be sufficient.
> Comments?

I think that'll depend very much on what the change is.  For new
functionality, sounds good; for bugfixes with testcases, sounds good.
For general algorithm improvements... how do you write a new QA test for
"Use the inode tree for finding dirty inodes?"  Or for that matter, my
remaining 2 shouting-removal patches ;)

> We have recently set up external access to a system for QA and
> regression testing for Christoph's use .. perhaps that should
> be a permanent offering?

Sounds awesome, for serious contributors.  I'd be happy to use it, too ;)

-Eric
