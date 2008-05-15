Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 21:56:38 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4F4uFhC012010
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 21:56:17 -0700
Date: Thu, 15 May 2008 00:57:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] XFS: Return case-insensitive match for dentry cache
Message-ID: <20080515045700.GA4328@infradead.org>
References: <20080513075749.477238845@chook.melbourne.sgi.com> <20080513080152.911303131@chook.melbourne.sgi.com> <20080513085724.GC21919@infradead.org> <op.ua4wa7t03jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ua4wa7t03jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, aia21@cantab.net

On Wed, May 14, 2008 at 05:55:45PM +1000, Barry Naujok wrote:
> Not quite sure if this is the right test, but I did 1000 creates on
> a brand new filesystem with and without ci on my SATA drive, both
> sustained almost 600 creates per second.
>
> I believe creates would be the worst case scenario for not adding
> negative dentries?

No, negative dentries shouldn't have any effect on that.  negative
entries help to optimize away lookups.  E.g. thing of the PATH variable
and say your shell is not in the first directory listed there.  Having
a negative dentry for it means that you don't have to do a lookup in
the first directories everytime someone wants to use the shell.
