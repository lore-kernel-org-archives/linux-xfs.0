Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 346B67CAF
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 06:32:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 03B72304039
	for <xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:32:27 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 4xkZvMFRWCAGMvva (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 17 Jun 2016 04:32:26 -0700 (PDT)
Date: Fri, 17 Jun 2016 04:32:23 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 001/119] vfs: fix return type of ioctl_file_dedupe_range
Message-ID: <20160617113223.GA19042@infradead.org>
References: <146612627129.12839.3827886950949809165.stgit@birch.djwong.org>
	<146612627940.12839.15145788608361492501.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <146612627940.12839.15145788608361492501.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, vishal.l.verma@intel.com, xfs@oss.sgi.com

On Thu, Jun 16, 2016 at 06:17:59PM -0700, Darrick J. Wong wrote:
> All the VFS functions in the dedupe ioctl path return int status, so
> the ioctl handler ought to as well.
> 
> Found by Coverity, CID 1350952.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

This should go out to Al as a separate patch.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
