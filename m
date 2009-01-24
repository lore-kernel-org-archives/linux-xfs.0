Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0O3RsTL244688 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 21:27:55 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1ED33B3D50
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 19:27:10 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id VbiNGbHljGADHFKd for
	<xfs@oss.sgi.com>; Fri, 23 Jan 2009 19:27:10 -0800 (PST)
Date: Fri, 23 Jan 2009 22:26:38 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs:move fsr over from xfsdump
Message-ID: <20090124032638.GB14080@infradead.org>
References: <20090123003342.GA24067@infradead.org>
	<133A2143-EFC5-4D09-BF73-5C32B14C5C47@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <133A2143-EFC5-4D09-BF73-5C32B14C5C47@sgi.com>
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
To: Felix Blyakher <felixb@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Fri, Jan 23, 2009 at 01:06:16AM -0600, Felix Blyakher wrote:
> Christoph,
>
> There are several whitespace warnings while applying this patch:

It's really just moving over the code, no need for whitespace cleanups.
Especially not in userspace code where we don't have the whitespace
policy on our kneck..

> /data/lwork/attica1/felixb/xfscmds-git/xfsprogs/.git/rebase-apply/ 
> patch:1632: space before tab in indent.

Btw, I'd _really_ prefer just apply my patches myself to the shared
commit development tree and not recreating the previous bottleneck.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
