Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 20 Aug 2008 04:14:17 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7KBDoiX017823
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 04:13:50 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3C5D1A17A75
	for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 04:15:08 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id XpIP6oeXsLcwBwYX for <xfs@oss.sgi.com>; Wed, 20 Aug 2008 04:15:08 -0700 (PDT)
Date: Wed, 20 Aug 2008 21:15:03 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TAKE 981498 - Use xfs_idestroy() to cleanup an inode.
Message-ID: <20080820111503.GC6061@disturbed>
References: <20080820033302.AF92058C52A8@chook.melbourne.sgi.com> <20080820035642.GB6061@disturbed> <48ABB602.5030404@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48ABB602.5030404@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com, markgw@sgi.com

On Wed, Aug 20, 2008 at 04:13:22PM +1000, Lachlan McIlroy wrote:
> This change was part of another patch that you reviewed.  This small
> change got left out when I merged my changes in with your inode
> allocation cleanup which you asked me to do. 

Yes, I did ask for you to do that and I kinda expected to see the
result for review again after that. I did not review the changes
that were committed.

A second review would have caught the bug you introduced by
integrating the bug fix into my patch as I would have suggested that
you keep the enhancment and the bug fix as two separare commits.
Then the commit logs that would have a 'use init_once' commit and a
'deadlock + memory leak fix' commit....

> I also had to modify
> your original patch because it did not apply cleanly due other changes
> that you made (the semaphore completion stuff).

You could have asked for an updated patch when you found it
didn't apply. I had one ready to go and ended up posting
it twice before your commit...

> I didn't have to take
> your cleanup patch - I could have just fixed the bug.

Your choice, but either way I kind of expect some kind of dialogue
when changes are neceessary.  It only takes a few seconds to send a
'doesn't apply - can you update/going with original bugfix'
message.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
