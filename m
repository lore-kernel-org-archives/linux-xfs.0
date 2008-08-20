Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Aug 2008 20:55:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7K3tPAM013206
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 20:55:27 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9DAA6F7C337
	for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 20:56:45 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id UuCZsPqkT0hpfKf0 for <xfs@oss.sgi.com>; Tue, 19 Aug 2008 20:56:45 -0700 (PDT)
Date: Wed, 20 Aug 2008 13:56:42 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: TAKE 981498 - Use xfs_idestroy() to cleanup an inode.
Message-ID: <20080820035642.GB6061@disturbed>
References: <20080820033302.AF92058C52A8@chook.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080820033302.AF92058C52A8@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs@oss.sgi.com, markgw@sgi.com

On Wed, Aug 20, 2008 at 01:33:02PM +1000, Lachlan McIlroy wrote:
> Use xfs_idestroy() to cleanup an inode.

I'm not sure what has been checked in this patch, even though it's
recorded that I reviewed it. Yes, I reviewed the original patch, but
I asked for changes to be made. I *haven't reviewed* what got
checked in.

With the changelog being entirely useless - not even mentioning it
fixes a memory leak or a deadlock - I have no idea what changes were
made in response to my initial review.  I now have to wait for CVS
or git to be updated before being able to find out what just got
checked in so I can review it.

Lachlan (and for everyone else @ sgi), in future if someone in the
community reviews a patch and asks for change, can you please repost
the modified patches to close the review cycle before anything is
checked in?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
