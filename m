Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oB14hmlr172588 for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 22:43:48 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 87F661B820E
	for <xfs@oss.sgi.com>; Tue, 30 Nov 2010 20:45:29 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	04dt4iVdiKShqxRH for <xfs@oss.sgi.com>;
	Tue, 30 Nov 2010 20:45:29 -0800 (PST)
Date: Wed, 1 Dec 2010 15:45:27 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 08/10] xfs: remove the all_bh flag from xfs_convert_page
Message-ID: <20101201044527.GI16922@dastard>
References: <20101122130506.868076797@bombadil.infradead.org>
	<20101122130904.551028056@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20101122130904.551028056@bombadil.infradead.org>
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

On Mon, Nov 22, 2010 at 08:05:14AM -0500, Christoph Hellwig wrote:
> The all_bh flag is always set when entering the page clustering machinery
> with a regular written extent, which means the check for it is superflous.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Dave Chinner <dchinner@redhat.com>

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
