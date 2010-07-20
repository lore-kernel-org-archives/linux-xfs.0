Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6KKJ4hS039234 for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 15:19:04 -0500
Received: from mail-ew0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BA83C1BE1CC9
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 13:22:04 -0700 (PDT)
Received: from mail-ew0-f53.google.com (mail-ew0-f53.google.com
	[209.85.215.53]) by cuda.sgi.com with ESMTP id v63wY2mkIqRaoTAH
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 13:22:04 -0700 (PDT)
Received: by ewy19 with SMTP id 19so2224534ewy.26
	for <xfs@oss.sgi.com>; Tue, 20 Jul 2010 13:22:03 -0700 (PDT)
Date: Wed, 21 Jul 2010 00:21:56 +0400
From: Vasiliy Kulikov <segooon@gmail.com>
Subject: Re: [PATCH 6/8] xfs: fix unsigned underflow
Message-ID: <20100720202155.GA31829@albatros>
References: <1279219605-12631-1-git-send-email-segooon@gmail.com>
	<20100715212116.GA7013@infradead.org>
	<1279654533.1859.242.camel@doink>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1279654533.1859.242.camel@doink>
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
To: Alex Elder <aelder@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Tue, Jul 20, 2010 at 14:35 -0500, Alex Elder wrote:
> On Thu, 2010-07-15 at 17:21 -0400, Christoph Hellwig wrote:
> > On Thu, Jul 15, 2010 at 10:46:45PM +0400, Kulikov Vasiliy wrote:
> > > map_len is unsigned. Checking map_len <= 0 is buggy when it should be
> > > below zero. So, check exact expression instead of map_len.
> > > 
> > > Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> > 
> > Looks good,
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> 
> Looks good to me too.  Do you want me to pull this
> in via the XFS tree, or do you have other plans?
Yes, pull it please.

> 
> 					-Alex
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
