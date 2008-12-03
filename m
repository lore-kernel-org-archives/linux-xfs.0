Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB33Daxp010022 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 21:13:36 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4C9B615BFC89
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 19:13:34 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	KcnAgBQwyu0dFVIC for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2008 19:13:34 -0800 (PST)
Date: Wed, 3 Dec 2008 14:03:48 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 16/22] use xfs_trans_ijoin in xfs_trans_iget
Message-ID: <20081203030348.GM18236@disturbed>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160651.861936000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081202160651.861936000@bombadil.infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

On Tue, Dec 02, 2008 at 11:04:46AM -0500, Christoph Hellwig wrote:
> Use xfs_trans_ijoin in xfs_trans_iget in case we need to join an inode into
> a transaction instead of opencoding it.  Based on a discussion with and an
> incomplete patch from Niv Sardi.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
