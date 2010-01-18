Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0IB2eqE099100 for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 05:02:41 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D0DED1C592E6
	for <xfs@oss.sgi.com>; Mon, 18 Jan 2010 03:03:38 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	gbJPFxONUtExCGtT for <xfs@oss.sgi.com>;
	Mon, 18 Jan 2010 03:03:38 -0800 (PST)
Date: Mon, 18 Jan 2010 22:03:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3 v2] xfs: implement quota warnings via netlink
Message-ID: <20100118110334.GE7264@discord.disaster>
References: <20100113220547.846700560@bombadil.infradead.org>
	<20100113220603.251930871@bombadil.infradead.org>
	<20100117223619.GA16102@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100117223619.GA16102@infradead.org>
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

On Sun, Jan 17, 2010 at 05:36:19PM -0500, Christoph Hellwig wrote:
> Wire up quota_send_warning to send quota warnings over netlink.  This is
> used by various desktops to show user quota warnings.
> 
> Tested by running the quota_nld daemon while running the xfstest quota
> tests and observing the warnings.  I'll see how I can get a more formal
> testcase for it written.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
