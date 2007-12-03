Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 03 Dec 2007 07:48:14 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lB3Fm9f9018429
	for <linux-xfs@oss.sgi.com>; Mon, 3 Dec 2007 07:48:10 -0800
Date: Mon, 3 Dec 2007 15:09:05 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Message-ID: <20071203150905.GA18082@infradead.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org> <474FBA21.4070201@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <474FBA21.4070201@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Chris Wedgwood <cw@f00f.org>, linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>

On Fri, Nov 30, 2007 at 06:22:09PM +1100, Timothy Shimmin wrote:
> Hmmm, don't see the point of "eof" local var now.
> Previously bhv_vop_readdir() returned eof.
> I presume if we don't move the offset (offset == startoffset) then
> we're done and break out?
> So we lost eof when going to the filldir in the getdents code etc...

Yes, it's just copy & paste.  We can trivially kill the variable.
