Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o65IpJj1134784 for <xfs@oss.sgi.com>; Mon, 5 Jul 2010 13:51:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C70EF15B49C6
	for <xfs@oss.sgi.com>; Mon,  5 Jul 2010 11:59:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SxCSsYtHv1ffmifr for
	<xfs@oss.sgi.com>; Mon, 05 Jul 2010 11:59:32 -0700 (PDT)
Date: Mon, 5 Jul 2010 14:54:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Slow delete
Message-ID: <20100705185406.GA26435@infradead.org>
References: <AANLkTinPmhJRD3CDdsHtkLFzYd2jF9ee7gPqgO6XBSfl@mail.gmail.com>
	<20100705171338.3bb38e1d@harpe.intellique.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100705171338.3bb38e1d@harpe.intellique.com>
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
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Andrei Deftu <andreideftu@gmail.com>, xfs@oss.sgi.com

Using nobarrier really is a bad idea in general as it does not
actually provides any transactional guarantee.  But if you're the kind
of person that would use it anyway please upgrade to a 2.6.35-rc kernel
and use the "delaylog" mount option, which will uses a new logging
mechanism that will get you much better delete performance.  It's still
experimental, but it's defintively not any worse than using nobarrier.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
