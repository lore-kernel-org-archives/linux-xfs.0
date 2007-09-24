Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 24 Sep 2007 11:27:04 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8OIQtQ3008262
	for <xfs@oss.sgi.com>; Mon, 24 Sep 2007 11:27:00 -0700
Date: Mon, 24 Sep 2007 19:03:15 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Review: fix mount flags as printed by xfsidbg
Message-ID: <20070924180315.GB2865@infradead.org>
References: <46F78159.5080907@sgi.com> <20070924161433.GA4098@puku.stupidest.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070924161433.GA4098@puku.stupidest.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Chris Wedgwood <cw@f00f.org>
Cc: Donald Douwsma <donaldd@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Mon, Sep 24, 2007 at 09:14:33AM -0700, Chris Wedgwood wrote:
> On Mon, Sep 24, 2007 at 07:20:25PM +1000, Donald Douwsma wrote:
> 
> > -		"32BITINOOPT",	/* 0x8000 */
> > +		"SMALL_INUMS",	/* 0x8000 */
> 
> why rename that?

It's just renamed to what's æctually in the mount flags.  We didn't
actually have a 32BITINOOPT flag before so it's a bit of a mistery
how the original one got there.
