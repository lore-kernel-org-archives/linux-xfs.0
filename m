Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 22 Jan 2008 22:55:12 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m0N6t5id017290
	for <xfs@oss.sgi.com>; Tue, 22 Jan 2008 22:55:08 -0800
Date: Wed, 23 Jan 2008 06:55:22 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW 1/2] Case insensitive support for XFS - kernel patch
Message-ID: <20080123065522.GA11132@infradead.org>
References: <op.t43zfc073jf8g2@pc-bnaujok.melbourne.sgi.com> <47918927.2000603@sandeen.net> <op.t49g2olx3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t49g2olx3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

I'm currently sick in my bed, so just a very quick glance over the
patch and a few comments:

 - no need to export the new inode ops, they're not used by the quota
   or dmapi methods.
 - any chance you could rebase this ontop of my various vnode removals,
   this should make some things a little cleaner.
 - there's a lot of hair dcache internals in here, so please run this
   patch past linux-fsdevel@vger.kernel.org to get some broader review.
