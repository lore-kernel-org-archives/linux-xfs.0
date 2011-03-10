Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2A7Xtwf089496 for <xfs@oss.sgi.com>; Thu, 10 Mar 2011 01:34:07 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CE0F8337AB4
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2011 23:36:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id nPuaYQ4ejPDKtzWy for
	<xfs@oss.sgi.com>; Wed, 09 Mar 2011 23:36:36 -0800 (PST)
Date: Thu, 10 Mar 2011 02:36:34 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: preallocation transactions do not need to be
	synchronous
Message-ID: <20110310073634.GA25374@infradead.org>
References: <1299713852-7663-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1299713852-7663-1-git-send-email-david@fromorbit.com>
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

On Thu, Mar 10, 2011 at 10:37:32AM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Preallocation and hole punch transactions are currently synchronous
> and this is causing performance problems in some cases. The
> transactions don't need to be synchronous as we don't need to
> guarantee the preallocation is persistent on disk until a
> fdatasync, fsync, sync operation occurs. If the file is opened
> O_SYNC or O_DATASYNC, only then should the transaction be issued
> synchronously.

I had the same patch in my queue, but it turns out even that isn't
enough for good performance when used fallocate in the fast path (e.g.
recent Samba).  I'll send a more comprehensive optimization that
includes this soon.

I also refactored the whole area to make the various flags more
sensible.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
