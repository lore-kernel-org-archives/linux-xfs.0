Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMAMILx215525 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 04:22:19 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5784D198BE7
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 02:23:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nPJ3VEcVPcTxVTwD for
	<xfs@oss.sgi.com>; Mon, 22 Nov 2010 02:23:55 -0800 (PST)
Date: Mon, 22 Nov 2010 05:23:51 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix exporting with left over 64-bit inodes
Message-ID: <20101122102350.GA7440@infradead.org>
References: <20101119133848.GA5471@infradead.org>
	<20101122003754.GE13830@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101122003754.GE13830@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, Samuel Kvasnica <samuel.kvasnica@ims.co.at>, xfs@oss.sgi.com

On Mon, Nov 22, 2010 at 11:37:54AM +1100, Dave Chinner wrote:
> Won't this mean that people exporting non-root directories suddenly
> have those exports stop working on a kernel upgrade due to changing
> the handle format?

No, if NFSD used ->encode_fh to encode the handle for the export
directory we wouldn't even have that problem.  NFSD directly encodes
i_ino as 32-bit value for the legacy subdirectory export fs handle.
So it will break whenever that particulat inode has a too large
inode number.

Check fs/nfsd/nfsfh.h:mk_fsid() for the glory details.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
