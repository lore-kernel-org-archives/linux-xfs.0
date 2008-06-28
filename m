Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 27 Jun 2008 17:08:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5S08F2c003746
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:08:15 -0700
Received: from ipmail04.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B0610296740
	for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:09:16 -0700 (PDT)
Received: from ipmail04.adl2.internode.on.net (ipmail04.adl2.internode.on.net [203.16.214.57]) by cuda.sgi.com with ESMTP id D7Hkn84drpeQrVgh for <xfs@oss.sgi.com>; Fri, 27 Jun 2008 17:09:16 -0700 (PDT)
Date: Sat, 28 Jun 2008 10:09:14 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: rfc: kill ino64 mount option
Message-ID: <20080628000914.GE29319@disturbed>
References: <20080627153928.GA31384@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627153928.GA31384@lst.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@oss.sgi.com

On Fri, Jun 27, 2008 at 05:39:28PM +0200, Christoph Hellwig wrote:
> Does anyone have objections to kill the ino64 mount option?  It's purely
> a debug tool to force inode numbers outside of the range representable
> in 32bits and is quite invasive for something that could easily be
> debugged by just having a large enough filesystem..

It's the "large enough fs" that is the problem. XFSQA uses
small partitions for the most part, and this allows testing
of 64 bit inode numbers with a standard qa config.

That being said, I don't really if it goes or stays...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
