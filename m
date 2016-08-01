Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 836F77CDA
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 01:29:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 04D7AAC002
	for <xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:29:35 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id BjiXqIhvN8RkiFRk (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 31 Jul 2016 23:29:34 -0700 (PDT)
Date: Sun, 31 Jul 2016 23:29:32 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/17] reflink: test cross-mountpoint reflink and dedupe
Message-ID: <20160801062932.GN596@infradead.org>
References: <146914477514.11762.3144320628851923350.stgit@birch.djwong.org>
	<146914485237.11762.2526971565060691741.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146914485237.11762.2526971565060691741.stgit@birch.djwong.org>
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
Cc: linux-btrfs@vger.kernel.org, eguan@redhat.com, fstests@vger.kernel.org, xfs@oss.sgi.com

On Thu, Jul 21, 2016 at 04:47:32PM -0700, Darrick J. Wong wrote:
> Test sharing blocks via reflink and dedupe between two different
> mountpoints of the same filesystem.  This shouldn't work, since
> we don't allow cross-mountpoint functions.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
