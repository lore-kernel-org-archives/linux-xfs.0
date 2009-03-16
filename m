Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2G9EVZI080718 for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 04:14:52 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C363A19C326
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:14:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fwih9EYgllGUvPbf for
	<xfs@oss.sgi.com>; Mon, 16 Mar 2009 02:14:10 -0700 (PDT)
Date: Mon, 16 Mar 2009 05:14:10 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/5] [XFS] Flush delayed allcoation blocks on ENOSPC in
	create
Message-ID: <20090316091410.GD2636@infradead.org>
References: <1237116707-25793-1-git-send-email-david@fromorbit.com>
	<1237116707-25793-5-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1237116707-25793-5-git-send-email-david@fromorbit.com>
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

On Sun, Mar 15, 2009 at 10:31:46PM +1100, Dave Chinner wrote:
> If we are creating lots of small files, we can fail to get
> a reservation for inode create earlier than we should due to
> EOF preallocation done during delayed allocation reservation.
> Hence on the first reservation ENOSPC failure flush all the
> delayed allocation blocks out of the system and retry.
> 
> This fixes the last commonly triggered spurious ENOSPC issue
> that has been reported.

Looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
