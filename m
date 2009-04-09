Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n39HEVoI003303 for <xfs@oss.sgi.com>; Thu, 9 Apr 2009 12:14:46 -0500
Date: Thu, 9 Apr 2009 13:14:12 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/2] xfs: fix getbmap vs mmap deadlock
Message-ID: <20090409171412.GB25303@infradead.org>
References: <20090224133902.GC15820@infradead.org>
	<2B47193B-9486-4500-80C4-E96750BEA54B@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <2B47193B-9486-4500-80C4-E96750BEA54B@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, Apr 06, 2009 at 07:42:57PM -0500, Felix Blyakher wrote:
> Actually with the patch we either get all requested extents, or none
> if we fail to get memory for them.
> Should we teach the callers to expect ENOMEM and repeat the call
> to xfs_getbmap with smaller number of extents?

The problem with any of that is that we don't actually get the exact
extent list but always a racy version.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
