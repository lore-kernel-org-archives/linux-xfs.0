Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n14JdPjl168499 for <xfs@oss.sgi.com>; Wed, 4 Feb 2009 13:39:26 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 45D0718C7A77
	for <xfs@oss.sgi.com>; Wed,  4 Feb 2009 11:38:47 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vHWO44sWzHeryjD5 for
	<xfs@oss.sgi.com>; Wed, 04 Feb 2009 11:38:47 -0800 (PST)
Date: Wed, 4 Feb 2009 14:38:46 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: reproducible xfs/vmap oops
Message-ID: <20090204193846.GA26436@infradead.org>
References: <20090201081224.GA22398@infradead.org>
	<20090204081547.GA21487@infradead.org>
	<20090204083037.GA17493@infradead.org>
	<200902042027.40762.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <200902042027.40762.nickpiggin@yahoo.com.au>
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
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: xfs@oss.sgi.com

On Wed, Feb 04, 2009 at 08:27:40PM +1100, Nick Piggin wrote:
> I've got a 32-bit machine running again. Is there any specific way to
> run xfsqa to reproduce the problem quickly?

Nothing quick unfortunately.  You need to set it up with a config
file pointing to at least two partitions and then run the auto group
using

	./check -g auto

I need a second run to trigger it most of the time, although sometimes
it gets hit in the first run.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
