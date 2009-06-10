Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n5ABiZQQ089438 for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 06:44:35 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B81961D3C865
	for <xfs@oss.sgi.com>; Wed, 10 Jun 2009 04:44:56 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id dZhi6yOmWgJhm69f for
	<xfs@oss.sgi.com>; Wed, 10 Jun 2009 04:44:56 -0700 (PDT)
Date: Wed, 10 Jun 2009 07:44:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: xfs_growfs doesn't grow on 2TB raid
Message-ID: <20090610114455.GA31824@infradead.org>
References: <BAY108-W1262BA63B7F70EB6364C9AF3450@phx.gbl>
	<20090610110902.GA19633@infradead.org>
	<BAY108-W15E9D46A3841C023FEBE4DF3450@phx.gbl>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <BAY108-W15E9D46A3841C023FEBE4DF3450@phx.gbl>
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
To: jack the ripper <evil_metalpeet@hotmail.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Wed, Jun 10, 2009 at 01:22:17PM +0200, jack the ripper wrote:
> 
> When I do:
> 
> zgrep LBD /proc/config.gz
> 
> I get no output, I also can't find anything about LBD in my /usr/src/linux/.config.
> 
> This is the kernel I'm running: 
> Linux RoSe 2.6.29-gentoo-r5 #3 SMP Sun Jun 7 19:24:08 CEST 2009 x86_64 Intel(R) Core(TM)2 CPU 6400 @ 2.13GHz GenuineIntel GNU/Linux
> Does this indicate a problem or is it normal behaviour?

Oh, it's an x86-64 kernel.  In that case you do not need CONFIG_LBD,
sorry for the noise.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
