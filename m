Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q32JP30L243934 for <xfs@oss.sgi.com>; Mon, 2 Apr 2012 14:25:03 -0500
Message-ID: <4F79FD0B.2030907@sgi.com>
Date: Mon, 02 Apr 2012 14:24:59 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/5] xfs: avoid taking the ilock unnessecarily in
	xfs_qm_dqattach
References: <20120327143445.196524266@bombadil.infradead.org>
	<20120327143826.255746245@bombadil.infradead.org>
In-Reply-To: <20120327143826.255746245@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 03/27/12 09:34, Christoph Hellwig wrote:
> Check if we actually need to attach a dquot before taking the ilock in
> xfs_qm_dqattach.  This avoid superflous lock roundtrips for the common cases
> of quota support compiled in but not activated on a filesystem and an
> inode that already has the dquots attached.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>

Looks good.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
