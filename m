Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 18 Jun 2008 15:30:07 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5IMU1IL001853
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 15:30:01 -0700
Received: from zen.pimp.org.za (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DB90217E32BE
	for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 15:30:59 -0700 (PDT)
Received: from zen.pimp.org.za (zen.pimp.org.za [70.85.31.111]) by cuda.sgi.com with ESMTP id GLSRLF50yc3F13sQ for <xfs@oss.sgi.com>; Wed, 18 Jun 2008 15:30:59 -0700 (PDT)
Date: Wed, 18 Jun 2008 23:30:50 +0100
From: Michael-John Turner <mj@mjturner.net>
Subject: Re: Directory mtime update issue (kernel 2.6.25)
Message-ID: <20080618223050.GA15558@aurora.pimp.org.za>
References: <20080618144534.GC11301@aurora.pimp.org.za> <20080618163356.GA6330@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080618163356.GA6330@infradead.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Wed, Jun 18, 2008 at 12:33:56PM -0400, Christoph Hellwig wrote:
> Below is an untested patch to always just update the ctime:

Just a quick update - the patch does the trick and changes the rename(2)
behaviour to be what I expect. Now, when a directory is renamed, its mtime
doesn't change, even if it has a new parent.

-mj
-- 
Michael-John Turner 
mj@mjturner.net      <>  http://mjturner.net/
