Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7C3D47F37
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 10:56:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 64325304032
	for <xfs@oss.sgi.com>; Mon, 17 Jun 2013 08:56:48 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id qK2A7jEk5oPl8o4Q (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Jun 2013 08:56:46 -0700 (PDT)
Date: Mon, 17 Jun 2013 08:56:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 18/27] xfs: split out xfs inode operations into separate
	file
Message-ID: <20130617155644.GA26043@infradead.org>
References: <1371032567-21772-1-git-send-email-david@fromorbit.com>
	<1371032567-21772-19-git-send-email-david@fromorbit.com>
	<20130612140519.GB28988@infradead.org>
	<20130613011414.GB29338@dastard> <20130613080009.GL29338@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130613080009.GL29338@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jun 13, 2013 at 06:00:09PM +1000, Dave Chinner wrote:
> So what I really think needs to happen here first is similar to the
> dir2 header file re-org. That is, a header file to define the
> format, and a header file to define the in-kernel structures and
> APIs....

Yes, I think we need to do this rather sooner than later.  In fact
I'd feeling we need to tackle the whole header mess first before
splitting the .c files.  Making sure the on-disk format is in one
or just a few headers is the most important bit of that.

These days I'm actually of the opinion that we probably should be
even more drastic about cutting the number of headers.  For the
on disk format a xfs_format.h for all the regular on disk format and
maybe and xfs_log_format.h should be more than enough.

But back to the _ops.c naming.  I really hate it and the best counter
proposals I can come up with is to add a _common postfix to every file
intended to be shared with userspace.  Using a directly also would make
sense, but for some reason Kbuild always had problems with modules built
from multiple directories and I'm more than glad that we finally managed
to get rid of the subdirectories.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
