Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 01 Aug 2008 18:14:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m721ECDk022516
	for <xfs@oss.sgi.com>; Fri, 1 Aug 2008 18:14:12 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB57F352C7A
	for <xfs@oss.sgi.com>; Fri,  1 Aug 2008 18:15:25 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id F6hpy0xbA8HlFo7W for <xfs@oss.sgi.com>; Fri, 01 Aug 2008 18:15:25 -0700 (PDT)
Date: Sat, 2 Aug 2008 11:15:23 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 13/21] implement generic xfs_btree_update
Message-ID: <20080802011523.GM6201@disturbed>
References: <20080729193116.GN19104@lst.de> <20080730052959.GN13395@disturbed> <20080801194624.GG1263@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801194624.GG1263@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Aug 01, 2008 at 09:46:24PM +0200, Christoph Hellwig wrote:
> On Wed, Jul 30, 2008 at 03:29:59PM +1000, Dave Chinner wrote:
> > Oh, it's be moved inside the update code itself. So, why always call
> > the update function and then check the ptr? Why not the way it was
> > originally done?
> 
> Because all three callers do different checks, and I could not proof
> that they are either identical or hamrless for the other cases.
> We can clean this mess up later in small standalone patches.

Ok. Sounds like a good plan.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
