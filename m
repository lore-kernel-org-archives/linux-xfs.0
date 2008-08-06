Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Aug 2008 13:21:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m76KLiew017598
	for <xfs@oss.sgi.com>; Wed, 6 Aug 2008 13:21:44 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3EEA36736D
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2008 13:22:59 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id Vp9D30rlruD0RTgm for <xfs@oss.sgi.com>; Wed, 06 Aug 2008 13:22:59 -0700 (PDT)
Date: Thu, 7 Aug 2008 06:22:56 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TAKE 981498 - use KM_MAYFAIL in xfs_mountfs
Message-ID: <20080806202256.GR21635@disturbed>
References: <20080806054121.CB2F258C52A4@chook.melbourne.sgi.com> <cc7060690808061022i1dce01dfx9e43ad3a75e5c936@mail.gmail.com> <489A01B0.5050606@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489A01B0.5050606@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Bhagi rathi <jahnu77@gmail.com>, Lachlan McIlroy <lachlan@sgi.com>, sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Wed, Aug 06, 2008 at 02:55:28PM -0500, Eric Sandeen wrote:
> Bhagi rathi wrote:
> > Why are we going to block for ever? Mounting a file-system
> > requires in-core log space buffers, reading of other buffers
> > which needs allocation of memory greater than per ag
> > structures.
.....
> In general KM_MAYFAIL sounds like a good plan when you can handle the
> failure gracefully, I think.

Yes, and that is the long term plan - to remove all KM_SLEEP
allocations from XFS and allow them to fail gracefully. There's
lots of work needed before we get there, though. e.g.
right now we cannot survive an ENOMEM error in a transaction....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
