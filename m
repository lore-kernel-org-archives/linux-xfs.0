Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 20:54:58 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6P3smku008160
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 20:54:49 -0700
Message-ID: <48894ECC.1070609@thebarn.com>
Date: Thu, 24 Jul 2008 22:55:56 -0500
From: Russell Cattelan <cattelan@thebarn.com>
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com> <48875040.9090400@thebarn.com> <48881B02.20900@sgi.com>
In-Reply-To: <48881B02.20900@sgi.com>
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
> Russell Cattelan wrote:
>>> Internally, we're attempting to refine our patch acceptance processes,
>>> (e.g. gitify our internal dev tree and mirror it on oss so it's much
>>> easier to push back out to oss).
>> I'm sure you have seen this before:
>> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=cattelan/xfs-import/.git;a=summary' 
>>
>> That is a running mirror of the ptools tree into git. (via the cvs tree)
>
> yes. But it's git -> ptools scripts that we need, preserving history, 
> etc.
> Niv has some scripts for this - they're not production quality yet, but
> we're getting there. Once this transitions, it'll be a *lot* easier for
> us to pull in patches from external developer branches because we'll all
> be using git for checkin.
Personally I don't see a reason to keep a ptools tree in lock step with
with a git tree. I all for not losing history (and I spent a bit of time 
when
the tree was re-organized to keep the rcs history in tack).
At this point the git tree has full xfs history and I would think this would
be sufficient for what ever code archeology  comes up.
>
>> It would be really nice to move all xfs development to git finally shut
>> down
>> the whole ptools -> cvs update process.
>
> once our internal dev tree is git based and internal git->ptools merging
> is fully automatic, there is no actual need to shutdown the cvs crons.
> It's worked for years and can stay running, no harm.
Ya I'm still amazed those scripts are holding up given nobody is giving
them any TLC.  :-(

>
>> This would help facilitate creation of more "experimental" trees and/or
>> branches
>> so there would not be such a long delay of getting patches distributed.
>
> I think we'd just end up with a git dev branch on oss, maybe with a
> daily pull from the internal dev tree (Russell, that would render
> your cvs->git mirror obsolete I guess). In any case, patch flow and
> turn-around should be greatly improved.
The one thing about about SCM's that they are entirely a pain in the
ass, but one of the most important tools in software engineering.
So whatever happens it should be simple yet sufficient.

>
> Anyone have comments on any of the above?
>
> Cheers
> -- Mark
>
