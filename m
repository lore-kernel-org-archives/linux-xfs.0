Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAH9aI8a220469 for <xfs@oss.sgi.com>; Wed, 17 Nov 2010 03:36:18 -0600
Date: Wed, 17 Nov 2010 04:37:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3 8/9] xfsrestore: remove nix_t
Message-ID: <20101117093751.GH17317@infradead.org>
References: <20101116150502.179825893@sgi.com>
	<20101116150705.222071282@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101116150705.222071282@sgi.com>
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
To: wkendall@sgi.com
Cc: xfs@oss.sgi.com

On Tue, Nov 16, 2010 at 09:05:10AM -0600, wkendall@sgi.com wrote:
> The nix_t type is a 64-bit version of a (32-bit) nh_t, created "to
> facilitate conversion to a 64-bit offset." At this point there's only
> one case where an nh_t is converted to an off64_t, so just do an
> explicit cast in that case and remove the nix_t.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>
> 
> Reviewed-by: Alex Elder <aelder@sgi.com>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
