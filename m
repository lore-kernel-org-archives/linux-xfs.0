Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0O5Ql7X250235 for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 23:26:48 -0600
Received: from postoffice2.aconex.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 50CD41BA883C
	for <xfs@oss.sgi.com>; Fri, 23 Jan 2009 21:26:03 -0800 (PST)
Received: from postoffice2.aconex.com (mail.aconex.com [203.89.202.182]) by
	cuda.sgi.com with ESMTP id F712vBPeNzjwS0vf for
	<xfs@oss.sgi.com>; Fri, 23 Jan 2009 21:26:03 -0800 (PST)
Subject: Re: [PATCH] xfsprogs: update doc/CHANGES
From: Nathan Scott <nscott@aconex.com>
In-Reply-To: <20090123005648.GA3194@infradead.org>
References: <20090123005648.GA3194@infradead.org>
Date: Sat, 24 Jan 2009 16:22:58 +1100
Message-Id: <1232774578.13684.5.camel@verge.scott.net.au>
Mime-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, 2009-01-22 at 19:56 -0500, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>

> +	- Various xfs_quta fixes, thanks to Arkadiusz Miskiewicz

typo.

> +	- Addition of the xfs_fsr and xfs_estimate tools previous found
> +	  in the xfsdump package

rpm magic is probably needed in build/rpm/rpm.spec.in to prevent
old versions of xfsdump from being installed alongside the new
xfsprogs ... else rpm will report file conflicts, I think?  Same
will be needed in debian/control... hmm, both should be pretty
easy - just change "Conflicts: xfsdump < 2.0.0" to "3.0.0" (and
we should make xfsdump v3 at this time too, so its very clear).

Else, all looks good.

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
