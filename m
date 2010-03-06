Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o26BToc6082389 for <xfs@oss.sgi.com>; Sat, 6 Mar 2010 05:29:50 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6468C13FF220
	for <xfs@oss.sgi.com>; Sat,  6 Mar 2010 03:31:20 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id skmTEwklIzSBRllr for
	<xfs@oss.sgi.com>; Sat, 06 Mar 2010 03:31:20 -0800 (PST)
Date: Sat, 6 Mar 2010 06:31:19 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] xfs: introduce new internal log vector structure
Message-ID: <20100306113119.GA25863@infradead.org>
References: <1267840284-4652-1-git-send-email-david@fromorbit.com>
	<1267840284-4652-9-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1267840284-4652-9-git-send-email-david@fromorbit.com>
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

On Sat, Mar 06, 2010 at 12:51:23PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> The current log IO vector structure is a flat array and not
> extensible. To make it possible to keep separate log IO vectors for
> individual log items, we need a method of chaining log IO vectors
> together.
> 
> Introduce a new log vector type that can be used to wrap the
> existing log IO vectors on use that internally to the log. This
> means that the existing external interface (xfs_log_write) does not
> change and hence no changes to the transaction commit code are
> required.
> 
> This initial use of the new log vectors does not use the chaining
> capability of the new log vector structure - it is not needed to
> implement the flat vector array the current transaction commit path
> creates.

Given that we don't need it yet I wonder if it would be a better idea
to postponed it to the start of the actual delayed logging series?

patch 9 would be nice to have before, but that might be a bit too much
rebase work.  Anyway, looking into a real review soon.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
