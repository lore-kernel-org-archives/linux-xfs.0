Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6K9Vx2S034533
	for <linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 04:32:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F33AEA99FF5
	for <linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 02:40:42 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id fQBjsEQI6lEsuxNf for
	<linux-xfs@oss.sgi.com>; Mon, 20 Jul 2009 02:40:42 -0700 (PDT)
Date: Mon, 20 Jul 2009 05:32:40 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] don't fail if nslookup is not found (was: xfstests:
	nslookup not found)
Message-ID: <20090720093240.GA24549@infradead.org>
References: <alpine.DEB.2.01.0907191050010.6439@bogon>
	<20090719182012.GA10936@infradead.org>
	<alpine.DEB.2.01.0907191653240.6439@bogon>
	<20090720001637.GA31674@infradead.org>
	<alpine.DEB.2.01.0907191840150.6439@bogon>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.0907191840150.6439@bogon>
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
To: Christian Kujau <lists@nerdbynature.de>
Cc: linux-xfs@oss.sgi.com

On Sun, Jul 19, 2009 at 06:46:25PM -0700, Christian Kujau wrote:
> On Sun, 19 Jul 2009 at 20:16, Christoph Hellwig wrote:
> > Yes, that's exactly it.  Can you resend it with a proper subject,
> > description and add your Signed-off-by tag?
> 
> 
> When nslookup is not available, execution would stop. This patch moves the 
> check for nslookup and the _get_fqdn function into the ./new script (since 
> this is the only place where it's used) and we don't fail any more but try 
> to find out our FQDN without nslookup.

Thanks, I've put the patch in and pushed it to the kernel.org
repository.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
