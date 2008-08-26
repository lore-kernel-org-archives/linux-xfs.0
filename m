Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 26 Aug 2008 12:10:55 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7QJAnYO032074
	for <xfs@oss.sgi.com>; Tue, 26 Aug 2008 12:10:51 -0700
Date: Tue, 26 Aug 2008 15:12:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: xfs_metadump improvements
Message-ID: <20080826191208.GA2788@infradead.org>
References: <op.udjxj3hm3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.udjxj3hm3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, Jun 30, 2008 at 05:53:53PM +1000, Barry Naujok wrote:
> Based on what I found in xfs_check, I fixed up xfs_metadump in the
> same way.

That's the pop_cur bits and they look sane to me.

>
> Also, I've increased the default maximum expected extent size for
> a directory, as in practice, 400 block extents for directory
> structures is not rare.

Also looks good, but mixing these two up in the same commit doesn't
seem like a good idea.
