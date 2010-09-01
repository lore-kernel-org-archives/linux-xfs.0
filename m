Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o81AJg0G127932 for <xfs@oss.sgi.com>; Wed, 1 Sep 2010 05:19:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6DAC741828
	for <xfs@oss.sgi.com>; Wed,  1 Sep 2010 03:20:22 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id mtyiKajqqv1EjYKR for
	<xfs@oss.sgi.com>; Wed, 01 Sep 2010 03:20:22 -0700 (PDT)
Date: Wed, 1 Sep 2010 06:20:21 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Disallow 32bit project quota id.
Message-ID: <20100901102021.GE31648@infradead.org>
References: <20100826081247.GD705@dastard>
	<1282817983-3301-1-git-send-email-arekm@maven.pl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1282817983-3301-1-git-send-email-arekm@maven.pl>
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
To: Arkadiusz Mi??kiewicz <arekm@maven.pl>
Cc: xfs@oss.sgi.com

On Thu, Aug 26, 2010 at 12:19:43PM +0200, Arkadiusz Mi??kiewicz wrote:
> Currently on-disk structure is able to keep only 16bit project quota id,
> so disallow 32bit ones. This fixes a problem where parts of kernel
> structures holding project quota id are 32bit while parts (on-disk)
> are 16bit variables which causes project quota member files to be
> inaccessible for some operations (like mv/rm).
> 
> Signed-off-by: Arkadiusz Mi??kiewicz <arekm@maven.pl>

Looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
