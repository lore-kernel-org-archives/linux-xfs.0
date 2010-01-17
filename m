Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0HBsHhx009861 for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 05:54:17 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 46F8B1C57698
	for <xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:55:16 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8E88L7Qy1cmincO0 for
	<xfs@oss.sgi.com>; Sun, 17 Jan 2010 03:55:16 -0800 (PST)
Date: Sun, 17 Jan 2010 06:55:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs: Make the compile output cleaner V2
Message-ID: <20100117115515.GA16856@infradead.org>
References: <1263377007-4500-1-git-send-email-david@fromorbit.com>
	<20100113220814.GA17310@infradead.org>
	<20100113223001.GR17483@discord.disaster>
	<20100114065123.GA32559@infradead.org>
	<20100114101128.GX17483@discord.disaster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100114101128.GX17483@discord.disaster>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Thu, Jan 14, 2010 at 09:11:28PM +1100, Dave Chinner wrote:
> It seems completely spurious to me - normal practice is to blow away
> the config on a distclean, not a plain clean. And seeing as the
> patch is about removing noise during the normal build, I figured
> this qualified as a bug causing noise.
> 
> I can separate it out into another patch, but I'd really prefer that
> make clean doesn't result in running configure again. Especially
> considering the build dependencies are very broken so the only way
> to guarantee a build catches all changes is to do 'make clean;
> make'.

Looking at various other packages it seems like configure output
usually survives make clean indeed.  With that I agree with the change,
but it really should be a separate patch.


Reviewed-by: Christoph Hellwig <hch@lst.de>

For this one without that change, and I'll also approve the make clean
change when you send it.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
