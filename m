Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 24 Oct 2007 01:03:42 -0700 (PDT)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9O83bMU031552
	for <xfs@oss.sgi.com>; Wed, 24 Oct 2007 01:03:38 -0700
Date: Wed, 24 Oct 2007 08:36:39 +0100
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC 1/2] Case-insensitive XFS - kernel patch
Message-ID: <20071024073639.GA32469@infradead.org>
References: <op.t0m36wxm3jf8g2@pc-bnaujok.melbourne.sgi.com> <20071023201912.GA23558@infradead.org> <op.t0oef0pk3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t0oef0pk3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>

On Wed, Oct 24, 2007 at 10:32:14AM +1000, Barry Naujok wrote:
> On Wed, 24 Oct 2007 06:19:12 +1000, Christoph Hellwig <hch@infradead.org> wrote:
> 
> > This patch is quite badly mangled by your mailer.  Could you just
> > attach it?  (Or even better use a mailer that handles inlined text

It's still mangled, e.g.


>   #include "xfs_vnodeops.h"
> +#include "xfs_da_btree.h"
> +#include "xfs_unicode.h"

The # should be lined up, with only one character (' ', '+' or '-') before
them.  No idea what the mailer does here.
