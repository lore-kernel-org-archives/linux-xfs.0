Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 08:36:33 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6NFaSWX022847
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 08:36:29 -0700
Message-ID: <48875040.9090400@thebarn.com>
Date: Wed, 23 Jul 2008 10:37:36 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com>
In-Reply-To: <488692FB.1010101@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: markgw@sgi.com
Cc: xfs@oss.sgi.com

Mark Goodwin wrote:
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
> easier to push back out to oss). 
I'm sure you have seen this before:
http://oss.sgi.com/cgi-bin/gitweb.cgi?p=cattelan/xfs-import/.git;a=summary'

That is a running mirror of the ptools tree into git. (via the cvs tree)

It would be really nice to move all xfs development to git finally shut down
the whole ptools -> cvs update process.

This would help facilitate creation of more "experimental" trees and/or 
branches
so there would not be such a long delay of getting patches distributed.




> But the QA overhead remains a stubborn
> problem. I think we're going to have to ask for QA tests (both regression
> and performance) to be written as part of the patch acceptance policy -
> under this policy, merely passing existing QA will not be sufficient.
> Comments?
>
> We have recently set up external access to a system for QA and
> regression testing for Christoph's use .. perhaps that should
> be a permanent offering?
>
> Cheers
> -- Mark
>
