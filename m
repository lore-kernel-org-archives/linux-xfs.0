Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 20 Sep 2008 00:00:52 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8K6xvif008821
	for <xfs@oss.sgi.com>; Fri, 19 Sep 2008 23:59:57 -0700
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8C29210715A1
	for <xfs@oss.sgi.com>; Sat, 20 Sep 2008 00:01:29 -0700 (PDT)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net [203.16.214.145]) by cuda.sgi.com with ESMTP id nNy3fZoG01zfHZmq for <xfs@oss.sgi.com>; Sat, 20 Sep 2008 00:01:29 -0700 (PDT)
Date: Sat, 20 Sep 2008 17:01:26 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] Unlock inode before calling xfs_idestroy()
Message-ID: <20080920070126.GQ5811@disturbed>
References: <48D3193C.6060201@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D3193C.6060201@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Fri, Sep 19, 2008 at 01:15:08PM +1000, Lachlan McIlroy wrote:
> Lock debugging reported the ilock was being destroyed
> without being unlocked.

Is this going to go in before or after my changes to refactor
this function? If it is before< can you please push it out to
the master git tree ASAP (and all the other outstanding changes)
so I can rediff all the outstanding patches I have before I
send them again?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
