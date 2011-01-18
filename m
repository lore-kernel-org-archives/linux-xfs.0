Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0ILkam3161088 for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 15:46:36 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B57AB273F76
	for <xfs@oss.sgi.com>; Tue, 18 Jan 2011 13:48:53 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	l00w4IXpBjC90VcT for <xfs@oss.sgi.com>;
	Tue, 18 Jan 2011 13:48:53 -0800 (PST)
Date: Wed, 19 Jan 2011 08:48:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC, PATCH 0/12] xfs: rework error logging infrastructure
Message-ID: <20110118214850.GX28803@dastard>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
	<20110118130314.GC23988@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110118130314.GC23988@infradead.org>
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

On Tue, Jan 18, 2011 at 08:03:14AM -0500, Christoph Hellwig wrote:
> The series looks good to me.  One thing that feels a bit odd is
> the xfs_printk.[ch] name - the functions exported to the rest of the
> code don't contain prink anyway.  Maybe xfs_msg.[ch] or
> xfs_message.[ch]?

I was struggling for something relevant to call the file -
xfs_message.[ch] definitely seems more appropriate. I'll change
the name..

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
