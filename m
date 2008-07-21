Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 15:58:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LMwPCx014387
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 15:58:26 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 56E12310A0C
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 15:59:34 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id fBG2FG0oBEVQJOS9 for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 15:59:34 -0700 (PDT)
Date: Tue, 22 Jul 2008 08:59:31 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/4] don't leak m_fsname/m_rtname/m_logname
Message-ID: <20080721225931.GF6761@disturbed>
References: <20080525190736.GA13372@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525190736.GA13372@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, May 25, 2008 at 09:07:37PM +0200, Christoph Hellwig wrote:
> Add a helper to free the m_fsname/m_rtname/m_logname allocations and use
> it properly for all mount failure cases.  Also switch the allocations
> for these to kstrdup while we're at it.

Looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
