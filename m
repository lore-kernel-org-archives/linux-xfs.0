Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jul 2008 21:17:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N4HR01020191
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:17:27 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5AF13E87C97
	for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:18:36 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id qKSbxOkD9eSrcDRi for <xfs@oss.sgi.com>; Tue, 22 Jul 2008 21:18:36 -0700 (PDT)
Date: Wed, 23 Jul 2008 14:18:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
Message-ID: <20080723041832.GH5947@disturbed>
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <488692FB.1010101@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 12:10:03PM +1000, Mark Goodwin wrote:
>
>
> Dave Chinner wrote:
>> On Tue, Jul 22, 2008 at 03:27:33AM -0400, Christoph Hellwig wrote:
>>> ...
>>> I only fear
>>> we'll never get it in with the current review and commit latencies
>>> for XFS :(
>>
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

In general - unnecessary because most changes submitted don't
change behaviour or interfaces or that subsystem/behaviour
is already tested by the QA suite. For new features with externally
visable interfaces (the rare case) then requiring new tests is
just fine.

In reality - the community will route around SGI and go straight
to Andrew or Linus if this proves to be a burden.

Passing XFSQA is a significant indication that the change is as good
as the developer can do in their own environment; if it passes
review then at that point it needs wider QA, and that comes from
committing to *public repositories* so that and varied workloads and
machines stress the code.

If QA is a burden, it's because you're not allowing the wider
community easy access to the dev code to test at an early
stage. A dev tree is *meant to break*, it's not a prodution
environment. Gett eh code out there early and distribute the
QA workload, don't make it a burden on the developers or
a bottleneck to getting code accepted.

> We have recently set up external access to a system for QA and
> regression testing for Christoph's use .. perhaps that should
> be a permanent offering?

Yes.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
