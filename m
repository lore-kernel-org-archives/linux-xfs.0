Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jun 2008 05:27:19 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5ACRHUo020022
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 05:27:17 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 40AA612C28E6
	for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 05:28:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id c7ekYpbaXtIzM2BS for <xfs@oss.sgi.com>; Tue, 10 Jun 2008 05:28:13 -0700 (PDT)
Date: Tue, 10 Jun 2008 08:28:11 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Probems with xfs_repair on large filesystem and 32bit OS.
Message-ID: <20080610122811.GB15871@infradead.org>
References: <6A32BC807C106440B7E23208F280DDAF01D3F6C8A8@bcmail1.VIDMARK.LOCAL> <20080610115038.GD3005@sillage.bis.pasteur.fr> <6A32BC807C106440B7E23208F280DDAF01D3F6C8B4@bcmail1.VIDMARK.LOCAL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6A32BC807C106440B7E23208F280DDAF01D3F6C8B4@bcmail1.VIDMARK.LOCAL>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lance Reed <lreed@brightcove.com>
Cc: Tru Huynh <tru@pasteur.fr>, "'xfs@oss.sgi.com'" <xfs@oss.sgi.com>

On Tue, Jun 10, 2008 at 08:07:18AM -0400, Lance Reed wrote:
> SO, I take it from what you say that that I can running any newer version of xfs progs and a 64bit host (fiber attached, easy to do this), and run xfs_repair on the 32bit XFS volumes without fear of data corruption?
> Is this because XFS is not version specific, and xfs_repair will honor the 32bit file data structures?

Yes, this is fine.  All the actual filesystem structures are endian and
32/64bit clean.  The log needs to be in the same endianess and had 32bit
vs 64bit problems on x86 for a while, but it needs to be recovered
before you run xfs_repair anyway.
