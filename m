Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 22F7E7CA1
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 03:09:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D763B8F8037
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 01:09:48 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id OLsitMaAV1bIJQxu (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 01:09:47 -0700 (PDT)
Date: Thu, 25 Aug 2016 01:09:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfs: don't log the entire end of the AGF
Message-ID: <20160825080944.GF28747@infradead.org>
References: <147200522764.14738.15186015137934319456.stgit@birch.djwong.org>
	<147200523494.14738.13569285576029583652.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <147200523494.14738.13569285576029583652.stgit@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

On Tue, Aug 23, 2016 at 07:20:35PM -0700, Darrick J. Wong wrote:
> When we're logging the last non-spare field in the AGF, we don't
> need to log the spare fields, so plumb in a new AGF logging flag
> to help us avoid that.
> 
> (This patch is already in xfsprogs.)

Looks fine, and reminds me that I need to send out my patches that
fix the SGF/AGI logging API..

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
