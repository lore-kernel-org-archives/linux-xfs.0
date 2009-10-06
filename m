Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n96JPKti087035 for <xfs@oss.sgi.com>; Tue, 6 Oct 2009 14:25:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 173A84A7C61
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2009 12:26:46 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xiui415TF7LawXYY for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2009 12:26:46 -0700 (PDT)
Date: Tue, 6 Oct 2009 15:26:46 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mkfs: add discard support
Message-ID: <20091006192646.GA30105@infradead.org>
References: <1235789111.21721254856913943.JavaMail.root@mail-au.aconex.com>
	<837780486.21741254857073773.JavaMail.root@mail-au.aconex.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <837780486.21741254857073773.JavaMail.root@mail-au.aconex.com>
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
To: Nathan Scott <nscott@aconex.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Oct 07, 2009 at 06:24:33AM +1100, Nathan Scott wrote:
> It might be a bit cleaner to add this in with the existing platform-
> specific code in libxfs/linux.c (or perhaps include/platform_defs.h)
> with wrappers for the other platforms, rather than putting it directly
> in mkfs like this?  repair may want to use this someday too, I guess.

Yeah, that might be better. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
