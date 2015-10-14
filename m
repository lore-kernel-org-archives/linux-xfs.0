Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6777B7F37
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 12:08:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 55ED7304062
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 10:08:21 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id enN5YUPa3rNa8lMD (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 14 Oct 2015 10:08:20 -0700 (PDT)
Date: Wed, 14 Oct 2015 10:08:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 07/51] xfs_db: enable blockget for v5 filesystems
Message-ID: <20151014170818.GA10559@infradead.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050558.1504.97525.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151007050558.1504.97525.stgit@birch.djwong.org>
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
Cc: xfs@oss.sgi.com

On Tue, Oct 06, 2015 at 10:05:58PM -0700, Darrick J. Wong wrote:
> Plumb in the necessary finobt scanning, magic number checks, and other
> fixups required to handle v5 filesystems.  This makes it so that check
> can spot-check v5 filesystems even though xfs_repair is now the
> preferred fixer tool, which makes the xfstests fs check function a
> little happier.

As is this makes xfstests rather unhappy by failing tests.  I'm not
sure if that's issues in the blockget / xfs_check functionality or
because it actually finds bugs in the kernel code.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
