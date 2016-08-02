Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 42D517CA0
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 07:24:20 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 14B60304032
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2016 05:24:20 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id gyEF2zKlsI9rTXFK (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Aug 2016 05:24:18 -0700 (PDT)
Date: Tue, 2 Aug 2016 05:24:14 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] vfs: fix return type of ioctl_file_dedupe_range
Message-ID: <20160802122414.GB31492@infradead.org>
References: <20160801171339.GB8590@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160801171339.GB8590@birch.djwong.org>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, xfs@oss.sgi.com

On Mon, Aug 01, 2016 at 10:13:39AM -0700, Darrick J. Wong wrote:
> All the VFS functions in the dedupe ioctl path return int status, so
> the ioctl handler ought to as well.
> 
> Found by Coverity, CID 1350952.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
