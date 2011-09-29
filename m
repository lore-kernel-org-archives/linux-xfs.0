Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8T0xnAx150313 for <xfs@oss.sgi.com>; Wed, 28 Sep 2011 19:59:50 -0500
Date: Wed, 28 Sep 2011 20:59:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/5] xfsprogs: libxcmd: don't clobber fs_table on realloc()
Message-ID: <20110929005946.GA26863@infradead.org>
References: <1317207432-8464-1-git-send-email-aelder@sgi.com>
	<08dbe8c3d0f49bac0c18570a68e7aa983cb4c731.1317207144.git.aelder@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <08dbe8c3d0f49bac0c18570a68e7aa983cb4c731.1317207144.git.aelder@sgi.com>
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
Cc: xfs@oss.sgi.com

On Wed, Sep 28, 2011 at 05:57:08AM -0500, Alex Elder wrote:
> In fs_table_insert(), realloc() is called to resize the global
> fs_table.  If it fails, it overwrites a previously valid fs_table
> pointer with NULL.
> 
> Instead, assign the return value to a local temporary and overwrite
> fs_table only if the realloc() call succeeds.  The only defined
> errno value for a realloc() failure is ENOMEM, so return that
> explicitly in the event it fails.

Looks good.  Did you encounter this issue in real life?

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
