Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nAPL75ex008694 for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 15:07:05 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 72DAED82374
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2009 13:07:31 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id RHABA2TnL5FSqRSZ for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2009 13:07:31 -0800 (PST)
Date: Wed, 25 Nov 2009 16:07:31 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests 213: Add enospc case to fallocate test
Message-ID: <20091125210731.GB12150@infradead.org>
References: <4B0D66F7.5080704@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4B0D66F7.5080704@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Nov 25, 2009 at 11:18:47AM -0600, Eric Sandeen wrote:
> Add a test for ENOSPC when fallocating.
> 
> Also, add an expected output, not sure how that went missing!

Oops.  Easily to do because xfstests doesn't complain but rather just
skips tests without golden output..

I guess the ENOSPC test is to catch the inverted error returns just
detected?

Anyway, looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
