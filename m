Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 17 Apr 2008 11:26:49 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m3HIQRWL015628
	for <xfs@oss.sgi.com>; Thu, 17 Apr 2008 11:26:28 -0700
Date: Thu, 17 Apr 2008 14:27:02 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] - cleanup xfs_attr a bit
Message-ID: <20080417182702.GA7154@infradead.org>
References: <op.t9qhhmhx3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t9qhhmhx3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Thu, Apr 17, 2008 at 12:35:36PM +1000, Barry Naujok wrote:
> This patch starts using struct xfs_name more for the xattr code and
> is another step for using xfs_name in xfs_da_args.
>
> Also, the cred parameter is removed from xfs_attr_get and xfs_attr_fetch.

Looks good, but I'd really not expected a function called
xfs_attr_name_to_name to do the shutdown check.  Either keep it in the
callers or give the function a different name.
