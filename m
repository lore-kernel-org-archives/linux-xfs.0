Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8NAb8gh121577 for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 05:37:09 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 69E29184FFBF
	for <xfs@oss.sgi.com>; Thu, 23 Sep 2010 03:38:03 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Ch2d0W7fIPepmfZc for
	<xfs@oss.sgi.com>; Thu, 23 Sep 2010 03:38:03 -0700 (PDT)
Date: Thu, 23 Sep 2010 06:38:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS errors on large Infiniband fileserver setup
Message-ID: <20100923103802.GA16984@infradead.org>
References: <29252416bd0d9dc973a909e411dbec6a@phys.ethz.ch>
	<eb1b2cfa58cddc44c92c3a87a0e0a6c4@phys.ethz.ch>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <eb1b2cfa58cddc44c92c3a87a0e0a6c4@phys.ethz.ch>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christian Herzog <horeizo@phys.ethz.ch>
Cc: xfs@oss.sgi.com

On Thu, Sep 23, 2010 at 12:01:55PM +0200, Christian Herzog wrote:
> 
> Dear list,
> 
> my colleague has been running tests without ISER all morning, and so
> far we haven't encountered an error, even though we have copied > twice
> as much data as for the other tests. Is it possible that a problem in
> the transport layer remains undetected and only manifests itself in the
> filesystem?

Yes, that could very well possible.  While I'm not an expert on iSER it
looks like it doesn't use the software crc32c checksums in iscsi over
TCP but relies on the RDMA protocols guaranteeing it.

Btw, what target do you use?  According to
http://www.spinics.net/lists/linux-stgt/msg02038.html it seems like the
stgt iser target has some issues that look quite similar to yours.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
