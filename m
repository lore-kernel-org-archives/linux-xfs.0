Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pADC9KUr110249 for <xfs@oss.sgi.com>; Sun, 13 Nov 2011 06:09:20 -0600
Date: Sun, 13 Nov 2011 07:09:18 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/8] xfsprogs: xfs_db: unmount fs before exiting
Message-ID: <20111113120918.GF19435@infradead.org>
References: <3ed89446f6dc1231ec1de712f242522052952b7e.1320955675.git.aelder@sgi.com>
	<f91d3489cdc9ad68b6dac8224cf761fb2c51ad1e.1320955676.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <f91d3489cdc9ad68b6dac8224cf761fb2c51ad1e.1320955676.git.aelder@sgi.com>
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
To: Alex Elder <aelder@sgi.com>
Cc: Kevan Rehm <kfr@sgi.com>, xfs@oss.sgi.com

On Thu, Nov 10, 2011 at 02:35:16PM -0600, Alex Elder wrote:
> From: Kevan Rehm <kfr@sgi.com>
> 
> The main routine calls libxfs_mount() via init(), but never calls
> libxfs_umount() at the end of the program so there could be
> filesystem changes queued which never get flushed to disk.  This
> adds the missing libxfs_umount() call.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
