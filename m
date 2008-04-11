Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 11 Apr 2008 00:40:11 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3B7dplr010189
	for <xfs@oss.sgi.com>; Fri, 11 Apr 2008 00:39:53 -0700
Date: Fri, 11 Apr 2008 09:40:23 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: odd code in xfs_remove
Message-ID: <20080411074023.GB9236@lst.de>
References: <20080410185445.GA7521@lst.de> <20080411023145.GK103491721@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080411023145.GK103491721@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Fri, Apr 11, 2008 at 12:31:45PM +1000, David Chinner wrote:
> Looks like no harm is done by this and it's a rarely hit corner
> case, but it would appear that we should be passing in resblks in
> remove if only to avoid a potential transaction reservation
> overrun....

Okay, I'll prepare a patch and test it a little.  This was the only
spurious difference between xfs_remove and xfs_rmdir left, after this
we can almost trivially merge them.
