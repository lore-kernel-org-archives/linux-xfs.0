Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 601157FCC
	for <xfs@oss.sgi.com>; Thu,  7 Nov 2013 11:53:52 -0600 (CST)
Message-ID: <527BD39F.3020201@sgi.com>
Date: Thu, 07 Nov 2013 11:53:35 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: posix_memalign and io_submit do not set errno
References: <20131107170045.GA6599@infradead.org>
In-Reply-To: <20131107170045.GA6599@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On 11/07/13 11:00, Christoph Hellwig wrote:
> posix_memalign and io_submit do not set errno, but rather return the
> error respectively the negated error directly.
>
> Found this out while figuring out why 240 reported an impossible error
> from io_submit when run on NFS.
>
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
>


Looks like that took care of all the non-conforming posix_memalign and 
io_[submit | cancel | destroy | getevents | setup] calls in xfstests 
sources.

Reviewed-by: Mark Tinguely <tinguely@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
