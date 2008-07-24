Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 00:06:29 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6O76OKK019297
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 00:06:24 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD42FE91E0F
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 00:07:35 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id J92VG8Au3irB718W for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 00:07:35 -0700 (PDT)
Date: Thu, 24 Jul 2008 17:07:32 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/4] fix the noquota mount option
Message-ID: <20080724070732.GU6761@disturbed>
References: <20080525190750.GC13372@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080525190750.GC13372@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Sun, May 25, 2008 at 09:07:50PM +0200, Christoph Hellwig wrote:
> Noquota should clear all mount options, and not just user and group
> quota.  Probably doesn't matter very much in real life.

ACK. I noticed this discrepency reviewing the previous patch
and wondered about it.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
