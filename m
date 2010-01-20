Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0KM1UW1035164 for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 16:01:30 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9F40917D398
	for <xfs@oss.sgi.com>; Wed, 20 Jan 2010 14:02:30 -0800 (PST)
Received: from mail.internode.on.net (bld-mail12.adl6.internode.on.net
	[150.101.137.97]) by cuda.sgi.com with ESMTP id
	lrBgkks0bRUwyZS5 for <xfs@oss.sgi.com>;
	Wed, 20 Jan 2010 14:02:30 -0800 (PST)
Date: Thu, 21 Jan 2010 09:02:28 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests: kill in 131 needs to be quiet
Message-ID: <20100120220228.GO14035@discord.disaster>
References: <1263967126-7603-1-git-send-email-david@fromorbit.com>
	<20100120081807.GA9968@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20100120081807.GA9968@infradead.org>
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

On Wed, Jan 20, 2010 at 03:18:07AM -0500, Christoph Hellwig wrote:
> On Wed, Jan 20, 2010 at 04:58:46PM +1100, Dave Chinner wrote:
> > If the kill fails because the processes have already terminates,
> > the output from kill (no such process) will cause the test to
> > fail. Make sure kill doesn't output anything.
> > 
> > Signed-off-by: Dave Chinner <david@fromorbit.com>
> 
> Yes, I see the same here,
> 
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Pushed.

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
