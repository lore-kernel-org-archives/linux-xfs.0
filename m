Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 13 Jun 2008 03:25:03 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5DAOxsW024926
	for <xfs@oss.sgi.com>; Fri, 13 Jun 2008 03:25:00 -0700
Date: Fri, 13 Jun 2008 06:25:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] Invalidate dentry on unlink/rmdir if using CI mode
Message-ID: <20080613102555.GA1700@infradead.org>
References: <op.ucoa9vjb3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ucoa9vjb3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Jun 13, 2008 at 04:06:57PM +1000, Barry Naujok wrote:
> Once of the interesting features of vfs_unlink/d_delete functionality
> is that if it's the only inode being referenced, it makes the dentry
> negative. CI doesn't work with negative dentries, so the following code
> invalidate the dentry in CI mode.

Please add a comment like this patch description near the the calls
you added, otherwise ok.
