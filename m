Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ABD177F8E
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 03:06:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 503F2AC002
	for <xfs@oss.sgi.com>; Tue,  5 Nov 2013 01:06:29 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Z5eHaHk8XgGaixWI (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 Nov 2013 01:06:28 -0800 (PST)
Date: Tue, 5 Nov 2013 01:06:27 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 26/30] xfs_db: avoid libxfs buffer lookup warnings
Message-ID: <20131105090627.GB6114@infradead.org>
References: <1383107481-28937-1-git-send-email-david@fromorbit.com>
	<1383107481-28937-27-git-send-email-david@fromorbit.com>
	<20131104091245.GF23564@infradead.org>
	<20131105005248.GV6188@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20131105005248.GV6188@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Nov 05, 2013 at 11:52:48AM +1100, Dave Chinner wrote:
> > The icache_flags aren't used anywhere.  Also I'd really prefer to have
> > my patch to kill the inode cache istead of adding more changes to it.
> 
> Sure - should I prepend your series to kill the icache to this one?

It's just a single patch.  Just include it in your series.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
