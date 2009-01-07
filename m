Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	n07IqQDP023055 for <xfs@oss.sgi.com>; Wed, 7 Jan 2009 12:52:30 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C00DF1BA1294
	for <xfs@oss.sgi.com>; Wed,  7 Jan 2009 10:52:26 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yEtjowIJxt07bQsb for
	<xfs@oss.sgi.com>; Wed, 07 Jan 2009 10:52:26 -0800 (PST)
Date: Wed, 7 Jan 2009 13:52:26 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: problems showing up as XFS problems on kernels after 2.6.28-git2
Message-ID: <20090107185226.GA19010@infradead.org>
References: <20090107165218.GA11132@dth.net>
	<20090107180246.GA15218@infradead.org>
	<20090107182415.GA12039@dth.net>
	<20090107183115.GA6261@infradead.org>
	<20090107184420.GA15653@dth.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090107184420.GA15653@dth.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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
To: Danny ter Haar <dth@dth.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Wed, Jan 07, 2009 at 07:44:20PM +0100, Danny ter Haar wrote:
> Will compile a new kernel in the mean time with those 2 options:
> CONFIG_XFS_DEBUG & CONFIG_DEBUG_INFO

Please only with CONFIG_DEBUG_INFO in that case.  CONFIG_XFS_DEBUG would
be useful if you could reproduce it, but it does change the addresses,
so it's harmful for the case of getting back to the source line.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
