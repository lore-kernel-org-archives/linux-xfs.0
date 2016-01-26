Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9C8CC7CA2
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 10:47:08 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8C9EA304032
	for <xfs@oss.sgi.com>; Tue, 26 Jan 2016 08:47:05 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id ltnVn0mRgHpHz2fD (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Jan 2016 08:47:01 -0800 (PST)
Date: Tue, 26 Jan 2016 08:47:00 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: Fix untranslatable strings
Message-ID: <20160126164700.GA31746@infradead.org>
References: <20160124155853.GA10063@stranger.qboosh.pl>
	<56A50508.4060207@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <56A50508.4060207@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs@oss.sgi.com

On Sun, Jan 24, 2016 at 11:08:24AM -0600, Eric Sandeen wrote:
> Don't substitute in "would" or "will" for %s here, it makes
> it untranslatable.  Just spell it out twice like every other
> message in the function.
> 
> Reported-by: Jakub Bogusz <qboosh@pld-linux.org>
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
