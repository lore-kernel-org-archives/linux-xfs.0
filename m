Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 19 Apr 2007 00:49:53 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l3J7nnfB011915
	for <xfs@oss.sgi.com>; Thu, 19 Apr 2007 00:49:50 -0700
Subject: Re: review: allocate bmapi args
From: Nathan Scott <nscott@aconex.com>
Reply-To: nscott@aconex.com
In-Reply-To: <20070419072505.GS48531920@melbourne.sgi.com>
References: <20070419072505.GS48531920@melbourne.sgi.com>
Content-Type: text/plain
Date: Thu, 19 Apr 2007 17:51:02 +1000
Message-Id: <1176969062.6273.169.camel@edge>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, 2007-04-19 at 17:25 +1000, David Chinner wrote:
> 
> +       bma = kmem_zalloc(sizeof(xfs_bmalloca_t), KM_SLEEP);
> +       if (!bma)
> +               return XFS_ERROR(ENOMEM); 

I guess you meant KM_NOSLEEP?  Are you sure this is legit though?
(are all callers going to be able to handle this?)  I'm thinking
of the writeout paths where we're doing space allocation (unwritten
extent conversion comes through here too) in order to free up some
page cache so other memory allocs elsewhere can proceed.  I don't
see any other memory allocations in this area of the code, so I
guess I'd be treading really carefully here..

(Oh, and why the _zalloc?  Could just do an _alloc, since previous
code was using non-zeroed memory - so, should have been filling in
all fields).

cheers.

-- 
Nathan
