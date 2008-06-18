Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 17 Jun 2008 21:29:16 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5I4TEk6000914
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 21:29:14 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 674182426A4
	for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 21:30:11 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id MH9DsiCWiCc9piZS for <xfs@oss.sgi.com>; Tue, 17 Jun 2008 21:30:11 -0700 (PDT)
Date: Wed, 18 Jun 2008 14:30:02 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH V2] make inode reclaim wait for log I/O to complete
Message-ID: <20080618043002.GS3700@disturbed>
References: <48364E43.3030108@sgi.com> <48588E6B.3010006@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48588E6B.3010006@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Jun 18, 2008 at 02:26:19PM +1000, Lachlan McIlroy wrote:
> ping.
>
> Lachlan McIlroy wrote:
>> During a forced shutdown a xfs inode can be destroyed before log
>> I/O involving that inode is complete.  We need to wait for the
>> inode to be unpinned before tearing it down.  Version 2 cleans up
>> the code a bit by relying on xfs_iflush() to do the unpinning and
>> forced shutdown check.

Sorry I missed this when you first posted it. This one looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
