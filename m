Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3F7hJNp052609 for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 02:43:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 142F6121FAD5
	for <xfs@oss.sgi.com>; Fri, 15 Apr 2011 00:46:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id MX1EHpBVVBipXMUV for
	<xfs@oss.sgi.com>; Fri, 15 Apr 2011 00:46:42 -0700 (PDT)
Date: Fri, 15 Apr 2011 03:46:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: fix duplicate message output
Message-ID: <20110415074640.GA4761@infradead.org>
References: <1302615260-29450-1-git-send-email-david@fromorbit.com>
	<20110412160651.GA22506@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110412160651.GA22506@infradead.org>
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
Cc: xfs@oss.sgi.com

On Tue, Apr 12, 2011 at 12:06:51PM -0400, Christoph Hellwig wrote:
> On Tue, Apr 12, 2011 at 11:34:20PM +1000, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > Commit 957935dc ("xfs: fix xfs_debug warnings" broke the logic in
> > __xfs_printk(). Instead of only printing one of two possible output
> > strings based on whether the fs has a name or not, it outputs both.
> > Fix it to only output one message again.
> 
> My fault, sorry.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

And since I recently upgraded my compiler this bug even causes 085
to oops the kernel for me, so pushing it ASAP would be good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
