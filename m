Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 02 Feb 2007 10:07:18 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l12I79qw026205
	for <xfs@oss.sgi.com>; Fri, 2 Feb 2007 10:07:12 -0800
Date: Fri, 2 Feb 2007 18:06:14 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: Don't use kmap() in xfs_iozero().
Message-ID: <20070202180614.GA13938@infradead.org>
References: <20070202054044.GO33919298@melbourne.sgi.com> <20070202114830.GB23187@infradead.org> <20070202133941.GW33919298@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070202133941.GW33919298@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Sat, Feb 03, 2007 at 12:39:41AM +1100, David Chinner wrote:
> Even on 64 bit platforms? I just added an explicit cast as a matter
> of avoiding potential gcc warnings on other platforms/compiler
> versions. Maybe I'm just being paranoid and I can remove it?

Yes, it's fine on 64bit platforms aswell - I just built my equivalent
buffer.c changes on 64bit powerpc and we have lots of similar cases
all over the tree.
