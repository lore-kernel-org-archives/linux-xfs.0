Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB3LsIEQ022065 for <xfs@oss.sgi.com>; Wed, 3 Dec 2008 15:54:18 -0600
Received: from ipmail05.adl2.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1CE0916871B3
	for <xfs@oss.sgi.com>; Wed,  3 Dec 2008 13:54:16 -0800 (PST)
Received: from ipmail05.adl2.internode.on.net (ipmail05.adl2.internode.on.net
	[203.16.214.145]) by cuda.sgi.com with ESMTP id
	8iQ99jn0TbgUsuyD for <xfs@oss.sgi.com>;
	Wed, 03 Dec 2008 13:54:16 -0800 (PST)
Date: Thu, 4 Dec 2008 08:54:14 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 15/22] replace b_fspriv with b_mount
Message-ID: <20081203215414.GZ18236@disturbed>
References: <20081202160430.775774000@bombadil.infradead.org>
	<20081202160651.749289000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20081202160651.749289000@bombadil.infradead.org>
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

On Tue, Dec 02, 2008 at 11:04:45AM -0500, Christoph Hellwig wrote:
> Replace the b_fspriv pointer and it's ugly accessors with a properly types
> xfs_mount pointer.  Also switch log reocvery over to it instead of using
> b_fspriv for the mount pointer.
> 
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Sorry Christoph, I missed this one. Looks good, though.

Reviewed-by: Dave Chinner <david@fromorbit.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
