Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 May 2008 23:04:39 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4264EqO007351
	for <xfs@oss.sgi.com>; Thu, 1 May 2008 23:04:21 -0700
Date: Fri, 2 May 2008 08:04:50 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: xfsqa 166 failure
Message-ID: <20080502060450.GA21443@lst.de>
References: <20080501205004.GA30384@lst.de> <20080501224237.GO108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501224237.GO108924158@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, May 02, 2008 at 08:42:37AM +1000, David Chinner wrote:
> gawk supports C comment syntax inside procedure blocks and doesn't
> interpret them as regexes. I think the standard comment syntax
> is supposed to be like bash - use "#". Of course, the gawk man
> page doesn't define comment syntax at all, but mawk does.
> 
> Does the patch below fix it?

Yes, this fixes it.
