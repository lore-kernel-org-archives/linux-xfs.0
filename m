Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G9FeD0080931 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 04:16:01 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA0481C454B9
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:15:19 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id le0dn75vaXizkzSa for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:15:19 -0700 (PDT)
Date: Mon, 16 Mar 2009 05:15:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/5] [XFS] Remove xfs_flush_space
Message-ID: <20090316091513.GE2636@infradead.org>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
	<1237116707-25793-6-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237116707-25793-6-git-send-email-david@fromorbit.com>
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
Cc: mpatocka@redhat.com, xfs@oss.sgi.com

On Sun, Mar 15, 2009 at 10:31:47PM +1100, Dave Chinner wrote:
> The only thing we need to do now when we get an ENOSPC condition during delayed
> allocation reservation is flush all the other inodes with delalloc blocks on
> them and retry without EOF preallocation. Remove the unneeded mess that is
> xfs_flush_space() and just call xfs_flush_inodes() directly from
> xfs_iomap_write_delay().
> 
> Also, change the location of the retry label to avoid trying to do EOF
> preallocation because we don't want to do that at ENOSPC. This enables us to
> remove the BMAPI_SYNC flag as it is no longer used.

Looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
