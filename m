Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p72A437h096008 for <xfs@oss.sgi.com>; Tue, 2 Aug 2011 05:04:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id ACF99B3FFD
	for <xfs@oss.sgi.com>; Tue,  2 Aug 2011 03:04:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	0FQGv6zULcHhsyNS for <xfs@oss.sgi.com>;
	Tue, 02 Aug 2011 03:04:02 -0700 (PDT)
Date: Tue, 2 Aug 2011 06:03:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Build using CFLAGS passed in at configure
Message-ID: <20110802100359.GA8028@infradead.org>
References: <20110730165517.GA13918@infradead.org>
	<1312235904-21187-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1312235904-21187-1-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: hch@infradead.org, Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Mon, Aug 01, 2011 at 05:58:24PM -0400, Theodore Ts'o wrote:
> In order to build xfsprogs in a hermetic build, we need be able to
> pass in -I and -L flags to the compiler and linker, respectively.
> This needs to be used by the configure script, but we also need to
> make sure these flags are used by the Makefiles as well.

Thanks a lot a Ted!

I've added this to xfsprogs, xfsdump and dmapi.  xfstests actually
already has it, sent in in 2009 by Arek for the same reason you want
it in xfsprogs.  Wish we would have been a bit better to propagate build
system fixes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
