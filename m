Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB2D04is018503 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 07:00:04 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4266D3041AE
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 05:00:01 -0800 (PST)
Date: Tue, 2 Dec 2008 07:05:31 -0600
From: "Bill O'Donnell" <billodo@sgi.com>
Subject: Re: [PATCH 4/9] add infrastructure for crc in metadata
Message-ID: <20081202130531.GC27836@sgi.com>
References: <20080925225629.GE9822@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080925225629.GE9822@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@sgi.com

On Fri, Sep 26, 2008 at 12:56:29AM +0200, Christoph Hellwig wrote:
|
|  - add a mount feature bit for CRC enabled filesystems
|  - add some helpers for generating and verifying the CRCs
|  - add a copy_uuid helper
|  - add a pre-io callback to xfs_buf for calculating the CRCs
|
| The checksumming helpers are losely based on similar ones in sctp,
| all other bits come from Dave Chinner.
|
|
| Signed-off-by: Christoph Hellwig <hch@lst.de>

looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
