Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 16:39:15 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6ONdC64018601
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:39:13 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DBC8FE9D32D
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:40:23 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id I0PseUDKGRMWVKQC for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:40:23 -0700 (PDT)
Date: Fri, 25 Jul 2008 09:40:20 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/15] refactor btree validation helpers
Message-ID: <20080724234020.GI15438@disturbed>
References: <20080723200904.GI7401@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723200904.GI7401@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 10:09:04PM +0200, Christoph Hellwig wrote:
> Move the various btree validation helpers around in xfs_btree.c so that
> they are close to each other and in common #ifdef DEBUG sections.
> 
> Also add a new xfs_btree_check_ptr helper to check a btree ptr that
> can be either long or short form.
> 
> 
> Split out from a bigger patch from Dave Chinner with various small
> changes applied by me.

Looks ok.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
