Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B623A7F54
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 05:11:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 56B38AC005
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2016 03:11:26 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id R98nM9dft9b4oaFV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 18 Jan 2016 03:11:24 -0800 (PST)
Date: Mon, 18 Jan 2016 03:11:23 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] xfsprogs: misc uClibc patches: remove aio.h check
	from configure
Message-ID: <20160118111123.GA17495@infradead.org>
References: <569CBE64.6090603@gentoo.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <569CBE64.6090603@gentoo.org>
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
To: Joshua Kinard <kumba@gentoo.org>
Cc: xfs@oss.sgi.com

On Mon, Jan 18, 2016 at 05:28:52AM -0500, Joshua Kinard wrote:
> From: Joshua Kinard <kumba@gentoo.org>
> 
> Remove the configure check for aio.h, which is not provided by uClibc, and
> which does not appear to be used by xfsprogs.
> 
> Refer to Gentoo Bug #477758:
> https://bugs.gentoo.org/show_bug.cgi?id=477758

This looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
