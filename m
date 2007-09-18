Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Sep 2007 20:56:20 -0700 (PDT)
Received: from mail.lst.de (verein.lst.de [213.95.11.210])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8I3uFuw001345
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2007 20:56:17 -0700
Date: Tue, 18 Sep 2007 05:56:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/4] simplify validata_fields
Message-ID: <20070918035616.GA12857@lst.de>
References: <20070914162746.GB7110@lst.de> <46EF4C51.5060503@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EF4C51.5060503@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>, xfs@oss.sgi.com

On Tue, Sep 18, 2007 at 01:56:01PM +1000, Lachlan McIlroy wrote:
> Can we drop the i_size_read() check and just call i_size_write()?
> The work we may not do by not calling i_size_write() we have to do
> in i_size_read() anyway, sometimes doing the work twice.  And we
> get to lose another stack variable.

Sounds good to me, but I'd prefer to keep it in a separate patch
so this is just the mechanical removal of the xfs_getattr call.

I'll send a separate patch for it today or tomorrow.
