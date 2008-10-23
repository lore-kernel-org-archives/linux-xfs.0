Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 15:27:00 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9NMQn5o013027
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 15:26:49 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 766511454982
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 15:28:33 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 7bEEJxCl3hpo3mMC for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 15:28:33 -0700 (PDT)
Date: Fri, 24 Oct 2008 09:28:30 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock with latest xfs
Message-ID: <20081023222830.GB18495@disturbed>
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081023205727.GA28490@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Oct 23, 2008 at 04:57:28PM -0400, Christoph Hellwig wrote:
> On Thu, Oct 23, 2008 at 07:17:30PM +1000, Lachlan McIlroy wrote:
> > another problem with latest xfs
> 
> Is this with the 2.6.27-based ptools/cvs tree or with the 2.6.28 based
> git tree?  It does looks more like a VM issue than a XFS issue to me.

I hit this immediately after I upgraded to a 2.6.28 base tree from a
2.6.27-rc9. I couldn't get to the bottom of it - it did look like
a lost I/O or VM lockup but I haven't seen it since so I haven't
been able to do anything more....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
