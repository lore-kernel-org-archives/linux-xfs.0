Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 19:09:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6N28xpZ002808
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 19:09:02 -0700
Message-ID: <488692FB.1010101@sgi.com>
Date: Wed, 23 Jul 2008 12:10:03 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed>
In-Reply-To: <20080723000548.GG5947@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com



Dave Chinner wrote:
> On Tue, Jul 22, 2008 at 03:27:33AM -0400, Christoph Hellwig wrote:
>> ...
>> I only fear
>> we'll never get it in with the current review and commit latencies
>> for XFS :(
>
> I can see this being a big issue in the not-too-distant future.....

[getting off-topic for this thread, but anyway ..]
This is already a big issue, obviously, and has been for some time.

Internally, we're attempting to refine our patch acceptance processes,
(e.g. gitify our internal dev tree and mirror it on oss so it's much
easier to push back out to oss). But the QA overhead remains a stubborn
problem. I think we're going to have to ask for QA tests (both regression
and performance) to be written as part of the patch acceptance policy -
under this policy, merely passing existing QA will not be sufficient.
Comments?

We have recently set up external access to a system for QA and
regression testing for Christoph's use .. perhaps that should
be a permanent offering?

Cheers
-- Mark
