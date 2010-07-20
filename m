Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KJWXvM037169 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 14:32:33 -0500
Subject: Re: [PATCH 6/8] xfs: fix unsigned underflow
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20100715212116.GA7013@infradead.org>
References: <1279219605-12631-1-git-send-email-segooon@gmail.com>
	<20100715212116.GA7013@infradead.org>
Date: Tue, 20 Jul 2010 14:35:33 -0500
Message-ID: <1279654533.1859.242.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, 2010-07-15 at 17:21 -0400, Christoph Hellwig wrote:
> On Thu, Jul 15, 2010 at 10:46:45PM +0400, Kulikov Vasiliy wrote:
> > map_len is unsigned. Checking map_len <= 0 is buggy when it should be
> > below zero. So, check exact expression instead of map_len.
> > 
> > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> 
> Looks good,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Looks good to me too.  Do you want me to pull this
in via the XFS tree, or do you have other plans?

					-Alex

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
