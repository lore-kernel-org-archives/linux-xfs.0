Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53HIlTH185701 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 12:18:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C6E91BC8AE0
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 10:19:04 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sXnjmPHY5OaaXma7 for
	<xfs@oss.sgi.com>; Wed, 03 Jun 2009 10:19:04 -0700 (PDT)
Date: Wed, 3 Jun 2009 13:19:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfstests: Make the SCRATCH_DEV optional
Message-ID: <20090603171904.GA22100@infradead.org>
References: <4A26AC60.6060401@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A26AC60.6060401@redhat.com>
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

On Wed, Jun 03, 2009 at 12:01:20PM -0500, Eric Sandeen wrote:
> Tests will fail gracefully if there is no SCRATCH_DEV defined, so change
> 
> the check script to allow it, and update README to reflect this.
> 
> This just makes it simpler to set up the tests, at the expense of
> coverage.
> 
> Long term it might be nice to allow either SCRATCH_DEV xor TEST_DEV
> to be missing, but for now this is simple.

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
