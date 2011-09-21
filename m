Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8LK55S3172375 for <xfs@oss.sgi.com>; Wed, 21 Sep 2011 15:05:05 -0500
Subject: Re: [PATCH v2] xfsdump: call mlog_exit in content_stream_restore
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1316633674-25677-1-git-send-email-wkendall@sgi.com>
References: <1316633674-25677-1-git-send-email-wkendall@sgi.com>
Date: Wed, 21 Sep 2011 15:04:17 -0500
Message-ID: <1316635457.5872.22.camel@doink>
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
To: Bill Kendall <wkendall@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, 2011-09-21 at 14:34 -0500, Bill Kendall wrote:
> This patch adds mlog_exit() calls to all the return paths in
> content_stream_restore(). mlog_exit() is supposed to be called before
> returning from content_stream_dump() and content_stream_restore(), but the
> latter did not do so, allowing for the stream exit status to be unset.
> 
> Signed-off-by: Bill Kendall <wkendall@sgi.com>

I did not give this as thorough a review as I did last time.
You have already implemented several of the suggestions I
made, and this now looks better than before to me.

Reviewed-by: Alex Elder <aelder@sgi.com>


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
