Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p49E6wTh012520 for <xfs@oss.sgi.com>; Mon, 9 May 2011 09:07:01 -0500
Date: Mon, 9 May 2011 10:06:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: fix open_by_handle memory leak
Message-ID: <20110509140656.GA12262@infradead.org>
References: <1304700177-8505-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1304700177-8505-1-git-send-email-wkendall@sgi.com>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Fri, May 06, 2011 at 11:42:57AM -0500, Bill Kendall wrote:
> open_by_handle() calls handle_to_fshandle() which
> allocates an fshandle on the heap, which is never
> freed by open_by_handle(). There is no need to
> call handle_to_fshandle() though, just pass the
> fhandle (rather than fshandle) to handle_to_fsfd(),
> like the other *_by_handle() functions do.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
