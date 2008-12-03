Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB32uPTu008724 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 20:56:25 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3CC3716104C9
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 18:56:23 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	GrqJaRGYEKAS2iIg for <xfs@oss.sgi.com>;
	Tue, 02 Dec 2008 18:56:23 -0800 (PST)
Date: Wed, 3 Dec 2008 13:56:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 08/22] reduce l_icloglock roundtrips
Message-ID: <20081203025614.GG18236@disturbed>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160650.663976000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081202160650.663976000@bombadil.infradead.org>
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

On Tue, Dec 02, 2008 at 11:04:38AM -0500, Christoph Hellwig wrote:
> All but one caller of xlog_state_want_sync drop and re-acquire
> l_icloglock around the call to it, just so that xlog_state_want_sync can
> acquire and drop it.

Not really a performance problem, though, because the one caller
that doesn't already hold the lock is the common path (i.e.
xlog_write()); the others are in the  unmount path, so lock traffic
is not there is not performance critical....

Hence I'm not sure this is really necessary.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
