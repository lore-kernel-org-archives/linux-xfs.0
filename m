Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1CLP7pr031187 for <xfs@oss.sgi.com>; Fri, 12 Feb 2010 15:25:07 -0600
Date: Fri, 12 Feb 2010 16:26:22 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: eliminate some build warnings
Message-ID: <20100212212622.GE6084@infradead.org>
References: <201002122105.o1CL51p4026682@stout.americas.sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <201002122105.o1CL51p4026682@stout.americas.sgi.com>
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

On Fri, Feb 12, 2010 at 03:05:01PM -0600, Alex Elder wrote:
> A few minor changes to get rid of some build warnings.
> Also a gratuitous name change.
> 
> Signed-off-by: Alex Elder <aelder@sgi.com>

Except for the db/check.c hunks these are files shared with the kernel,
and changes should be done to the kernel files first and then resynced.
I've started a resync of the kernel code with libxfs, but it's actually
a lot of work, mostly due to the tracing changes on the kernel side.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
