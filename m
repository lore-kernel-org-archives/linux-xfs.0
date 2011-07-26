Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6QMdBNp146166 for <xfs@oss.sgi.com>; Tue, 26 Jul 2011 17:39:11 -0500
Subject: Re: [PATCH 2/3] xfs: prevent against ioend livelocks in xfs_file_fsync
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110726150711.GB18000@infradead.org>
References: <20110726150633.GA17400@infradead.org>
	<20110726150711.GB18000@infradead.org>
Date: Tue, 26 Jul 2011 17:39:02 -0500
Message-ID: <1311719942.11557.14.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Tue, 2011-07-26 at 11:07 -0400, Christoph Hellwig wrote:
> We need to take some locks to prevent new ioends from coming in when we wait
> for all existing ones to go away.  Up to Linux 3.0 that was done using the
> i_mutex held by the VFS fsync code, but now that we are called without
> it we need to take care of it ourselves.  Use the I/O lock instead of
> i_mutex just like we do in other places.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
