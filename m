Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7P53SKG162036 for <xfs@oss.sgi.com>; Thu, 25 Aug 2011 00:03:28 -0500
Date: Thu, 25 Aug 2011 01:03:26 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsdump: call mlog_exit in content_stream_restore
Message-ID: <20110825050326.GE23901@infradead.org>
References: <1313434763-22340-1-git-send-email-wkendall@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1313434763-22340-1-git-send-email-wkendall@sgi.com>
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

On Mon, Aug 15, 2011 at 01:59:23PM -0500, Bill Kendall wrote:
> This patch adds mlog_exit() calls to all the return paths in
> content_stream_restore(). mlog_exit() is supposed to be called before
> returning from content_stream_dump() and content_stream_restore(), but
> many paths in the latter did not do so, allowing for the stream exit
> status to be incorrect.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

Looks okay, but once again I'd prefer to use goto labels so that
we have a logical grouping of that required exit.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
