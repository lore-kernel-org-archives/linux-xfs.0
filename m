Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 23:01:41 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m6O61ZXr006489
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 23:01:36 -0700
Message-ID: <48881B02.20900@sgi.com>
Date: Thu, 24 Jul 2008 16:02:42 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH 2/4] XFS: Use the inode tree for finding dirty inodes
References: <1216556394-17529-1-git-send-email-david@fromorbit.com> <1216556394-17529-3-git-send-email-david@fromorbit.com> <20080722042829.GB27123@infradead.org> <20080722053019.GI6761@disturbed> <20080722072733.GA15376@infradead.org> <20080723000548.GG5947@disturbed> <488692FB.1010101@sgi.com> <48875040.9090400@thebarn.com>
In-Reply-To: <48875040.9090400@thebarn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com



Russell Cattelan wrote:
>> Internally, we're attempting to refine our patch acceptance processes,
>> (e.g. gitify our internal dev tree and mirror it on oss so it's much
>> easier to push back out to oss).
> I'm sure you have seen this before:
> http://oss.sgi.com/cgi-bin/gitweb.cgi?p=cattelan/xfs-import/.git;a=summary'
> That is a running mirror of the ptools tree into git. (via the cvs tree)

yes. But it's git -> ptools scripts that we need, preserving history, etc.
Niv has some scripts for this - they're not production quality yet, but
we're getting there. Once this transitions, it'll be a *lot* easier for
us to pull in patches from external developer branches because we'll all
be using git for checkin.

> It would be really nice to move all xfs development to git finally shut
> down
> the whole ptools -> cvs update process.

once our internal dev tree is git based and internal git->ptools merging
is fully automatic, there is no actual need to shutdown the cvs crons.
It's worked for years and can stay running, no harm.

> This would help facilitate creation of more "experimental" trees and/or
> branches
> so there would not be such a long delay of getting patches distributed.

I think we'd just end up with a git dev branch on oss, maybe with a
daily pull from the internal dev tree (Russell, that would render
your cvs->git mirror obsolete I guess). In any case, patch flow and
turn-around should be greatly improved.

Anyone have comments on any of the above?

Cheers
-- Mark
