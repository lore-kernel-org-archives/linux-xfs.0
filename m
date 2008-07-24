Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jul 2008 16:26:01 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6ONPwqs016417
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:25:59 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 71E7232BB31
	for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:27:08 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id kM8CSadH6WW0HzWK for <xfs@oss.sgi.com>; Thu, 24 Jul 2008 16:27:08 -0700 (PDT)
Date: Fri, 25 Jul 2008 09:26:59 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 04/15] add generic btree types
Message-ID: <20080724232659.GE15438@disturbed>
References: <20080723200842.GE7401@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080723200842.GE7401@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 10:08:42PM +0200, Christoph Hellwig wrote:
> Add generic union types for btree pointers, keys and records.  The generic
> btree pointer contains a 32 and 64bit big endian type for short and long
> form btrees, and the key and record contain the relevant type for each
> possible btree.
> 
> Split out from a bigger patch from Dave Chinner and simplified a little
> further.

Looks good.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
