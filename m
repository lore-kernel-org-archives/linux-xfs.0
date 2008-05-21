Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 20 May 2008 17:40:29 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4L0eQgQ027700
	for <xfs@oss.sgi.com>; Tue, 20 May 2008 17:40:27 -0700
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: [PATCH] streamline init/exit path
References: <20080518130511.GA28501@lst.de>
Date: Wed, 21 May 2008 10:41:12 +1000
In-Reply-To: <20080518130511.GA28501@lst.de> (Christoph Hellwig's message of
	"Sun, 18 May 2008 15:05:11 +0200")
Message-ID: <nccprrg32vr.fsf@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

Christoph Hellwig <hch@lst.de> writes:

> Currently the xfs module init/exit code is a mess.  It's farmed out
> over a lot of function with very little error checking.  This patch
> merges xfs_init_zones and xfs_init into init_xfs_fs, and makes sure
> we propagate all initialization failures properly and clean up after
> them.  Various runtime initializations are replaced with compile-time
> initializations where possible to make this easier.  The exit path
> is similarly consolidated.

Looks good, appart from the fact that I don't see the point of merging
xfs_{init,destroy}_zones into xfs_{init,exit}, appart from clobbering it
and making it less readeable.

could be:
error = xfs_init_zones();
if (error)
      goto out;

and all the other error cases will end with
xfs_destroy_zones();

That would look much more like the rest of the calls in these functions.
-- 
Niv Sardi
